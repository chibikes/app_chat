import 'package:app_chat/blocs/messages_bloc/messages_event.dart';
import 'package:app_chat/blocs/messages_bloc/messages_state.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final MessagesRepository _messagesRepository;

  MessagesBloc({
    required MessagesRepository messageRepository,
  })  : _messagesRepository = messageRepository,
        super(const MessagesState()) {
    on<MessagesEvent>(
      (event, emit) async {
        // two events trigger in this event bucket to ensure they are run sequentially
        if (event is GetRecentMessages) {
          emit(state.copyWith(fetchState: MessageFetchState.fetching));
          _messagesRepository.ListenToDatabaseChanges(event.id);
          await emit.forEach(_messagesRepository.getRecentMessages(event.id),
              onData: (recentChats) {
            return _handleRecentMessages(event, recentChats);
          });
        } else if (event is GetContacts) {
          final state = await _handlegetContacts();
          emit(state);
        }
      },
      transformer: sequential(),
    );

    on<GetContactUserId>((event, emit) async {
      final chatId = await _messagesRepository.getContactUserId(event.phone);
      add(UpdateChatId(chatId: chatId));
    });

    on<SendMessage>((event, emit) async {
      // emit(state.copyWith(sendingState: MessagingSendingState.sending));
      try {
        await _messagesRepository.sendMessage(event.message.toMap());
        // emit(state.copyWith(sendingState: MessagingSendingState.sent));
      } catch (e) {
        // emit(state.copyWith(sendingState: MessagingSendingState.failed));
      }
    });

    on<UpdateChatId>((event, emit) {
      _messagesRepository.getChats(event.chatId);
      emit(state.copyWith(chatId: event.chatId));
    });

    on<GetUserMessages>((event, emit) async {
      await emit.forEach(_messagesRepository.getChatMessages(), onData: (data) {
        return state.copyWith(
          messages: data.map((e) => Message.fromMap(e)).toList(),
        );
      });
    });
  }

  @override
  Future<void> close() async {
    Supabase.instance.client.removeAllChannels();
    return super.close();
  }

  bool arePhonesEqual(String databaseNumber, String phoneNumber, String code) {
    int codeLenght = code.length;
    var number = databaseNumber;
    var numberTwo = phoneNumber;
    if (databaseNumber[0] != phoneNumber[0]) {
      number = databaseNumber.substring(codeLenght, databaseNumber.length);
      numberTwo = phoneNumber.substring(1, phoneNumber.length);
    }
    return number == numberTwo;
  }

  MessagesState _handleRecentMessages(
      GetRecentMessages event, List recentChats) {
    final contacts = state.contacts;
    var userId = event.id.isNotEmpty
        ? event.id
        : Supabase.instance.client.auth.currentUser?.id;
    for (int i = 0; i < recentChats.length; i++) {
      final senderId = recentChats[i]['sender_id'] as String;
      bool isSender = senderId == userId;
      String phone = isSender
          ? recentChats[i]['receiver_phone'] ?? ''
          : recentChats[i]['sender_phone'] ?? '';
      final avatarUrl = isSender
          ? recentChats[i]['receiver_avatar'] ?? ''
          : recentChats[i]['sender_avatar'] ?? '';
      final code = isSender
          ? recentChats[i]['receiver_code'] ?? ''
          : recentChats[i]['sender_code'] ?? '';
      for (int index = 0; index < contacts.length; index++) {
        if (arePhonesEqual(phone, contacts[index].phoneNumber, code)) {
          // contact is in user's phonebook
          recentChats[i].addAll({'name': contacts[index].fullName});
          contacts[index] = contacts[index].copyWith(avatarUrl: avatarUrl);
          break;
        }
      }
    }

    return state.copyWith(
        recentMessages: recentChats.map((e) => Message.fromMap(e)).toList(),
        contacts: contacts,
        fetchState: MessageFetchState.fetched);
  }

  Future<MessagesState> _handlegetContacts() async {
    final status = await Permission.contacts.status;
    if (status.isDenied) {
      await Permission.contacts.request();
    }
    final contacts = await ContactsService.getContacts();
    contacts.removeWhere((item) => item.phones == null || item.phones!.isEmpty);
    return (state.copyWith(
        contacts: contacts
            .map((e) => AppUser(
                fullName: '${e.displayName}',
                phoneNumber: e.phones?.first.value?.replaceAll(" ", "") ?? ''))
            .toList()));
  }
}
