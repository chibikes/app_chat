import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum MessageFetchState { fetching, fetched, initial }

enum MessagingSendingState { sent, failed, delivered, init }

class MessagesState extends Equatable {
  final List<Message> recentMessages;
  final List<Message> messages;
  final List<AppUser> contacts;
  final String chatId;
  final String date;
  final MessageFetchState fetchState;
  final MessagingSendingState sendingState;

  const MessagesState(
      {this.recentMessages = const [],
      this.messages = const [],
      this.contacts = const [],
      this.date = '',
      this.chatId = '',
      this.sendingState = MessagingSendingState.init,
      this.fetchState = MessageFetchState.initial});

  MessagesState copyWith({
    List<Message>? recentMessages,
    List<Message>? messages,
    List<AppUser>? contacts,
    String? chatId,
    String? date,
    MessageFetchState? fetchState,
    MessagingSendingState? sendingState,
  }) {
    return MessagesState(
      recentMessages: recentMessages ?? this.recentMessages,
      messages: messages ?? this.messages,
      contacts: contacts ?? this.contacts,
      chatId: chatId ?? this.chatId,
      date: date ?? this.date,
      fetchState: fetchState ?? this.fetchState,
      sendingState: sendingState ?? this.sendingState,
    );
  }

  @override
  List<Object?> get props => [
        recentMessages,
        messages,
        contacts,
        chatId,
        date,
        fetchState,
        sendingState
      ];
}

class Message {
  final String timeStamp;
  final String content;
  final String senderId;
  final String receiverId;
  final String date;
  final AppUser chatUser;

  Message({
    required this.timeStamp,
    required this.content,
    required this.senderId,
    required this.receiverId,
    required this.date,
    this.chatUser = const AppUser(),
  });

  static Message fromMap(Map<String, dynamic> map) {
    var userId = Supabase.instance.client.auth.currentUser?.id;
    var senderId = map['sender_id'] as String;
    bool isSender = senderId == userId;

    return Message(
      timeStamp: map['created_at'],
      content: map['content'],
      senderId: map['sender_id'],
      receiverId: map['receiver_id'],
      date: getDateFromTimeStamp(map['created_at']),
      chatUser: userId == null
          ? const AppUser()
          : AppUser(
              userId: isSender ? map['receiver_id'] : map['sender_id'],
              fullName: map['name'] ?? '',
              phoneNumber: isSender
                  ? map['receiver_phone'] ?? ''
                  : map['sender_phone'] ?? '',
              avatarUrl: isSender
                  ? map['receiver_avatar'] ?? ''
                  : map['sender_avatar'] ?? '',
            ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'sender_id': senderId,
      'receiver_id': receiverId,
    };
  }

  static getDateFromTimeStamp(String timeStamp) {
    var date = DateTime.tryParse(timeStamp)?.toLocal() ?? DateTime.now();
    // final daysAgo = DateTime.now().subtract(Duration(days: date.day));
    // if ( < 1) {}
    return '${date.day}/${date.month}/${date.year}';
  }
}
