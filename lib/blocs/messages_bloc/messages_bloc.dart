import 'package:app_chat/blocs/messages_bloc/messages_event.dart';
import 'package:app_chat/blocs/messages_bloc/messages_state.dart';
import 'package:bloc/bloc.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final MessagesRepository _messagesRepository;

  MessagesBloc({
    required MessagesRepository messageRepository,
  })  : _messagesRepository = messageRepository,
        super(const MessagesState()) {
    on<GetRecentMessages>((event, emit) async {
      await emit.forEach(_messagesRepository.getRecentMessages(),
          onData: (data) {
        return state.copyWith(
          recentMessages: data.map((e) => Message.fromMap(e)).toList(),
        );
      });
    });

    on<GetContacts>((event, emit) async {
      final status = await Permission.contacts.status;
      if (status.isDenied) {
        await Permission.contacts.request();
      }
      final contacts = await ContactsService.getContacts();
      var ctx = contacts.first.phones?.first.value ?? 'empty contact';
      print('contact: $contacts');
      contacts
          .removeWhere((item) => item.phones == null || item.phones!.isEmpty);
      emit(state.copyWith(contacts: contacts));
    });

    on<GetContactUserId>((event, emit) async {
      final chatId = await _messagesRepository.getContactUserId(event.phone);
      await emit.forEach(_messagesRepository.getChatMessages(chatId),
          onData: (data) {
        final messages = data.map((e) => Message.fromMap(e)).toList();
        return state.copyWith(messages: messages, chatId: chatId);
      });
    });

    on<SendMessage>((event, emit) {
      _messagesRepository.sendMessage(event.message.toMap());
    });

    on<GetUserMessages>((event, emit) async {
      await emit.forEach(_messagesRepository.getChatMessages(event.chatId),
          onData: (data) {
        return state.copyWith(
            messages: data.map((e) => Message.fromMap(e)).toList(),
            chatId: event.chatId);
      });
    });
  }

  @override
  Future<void> close() async {
    Supabase.instance.client.removeAllChannels();
    return super.close();
  }
}
