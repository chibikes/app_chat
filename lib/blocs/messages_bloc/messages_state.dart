import 'package:equatable/equatable.dart';
import 'package:contacts_service/contacts_service.dart';

class MessagesState extends Equatable {
  final List<Message> recentMessages;
  final List<Message> messages;
  final List<Contact> contacts;
  final String chatId;
  final String date;

  const MessagesState(
      {this.recentMessages = const [],
      this.messages = const [],
      this.contacts = const [],
      this.date = '',
      this.chatId = ''});

  MessagesState copyWith({
    List<Message>? recentMessages,
    List<Message>? messages,
    List<Contact>? contacts,
    String? chatId,
    String? date,
  }) {
    return MessagesState(
      recentMessages: recentMessages ?? this.recentMessages,
      messages: messages ?? this.messages,
      contacts: contacts ?? this.contacts,
      chatId: chatId ?? this.chatId,
      date: date ?? this.date,
    );
  }

  @override
  List<Object?> get props => [recentMessages, messages, contacts, chatId, date];
}

class Message {
  final String timeStamp;
  final String content;
  final String senderId;
  final String receiverId;
  final String date;

  Message({
    required this.timeStamp,
    required this.content,
    required this.senderId,
    required this.receiverId,
    required this.date,
  });

  static Message fromMap(Map<String, dynamic> map) {
    return Message(
      timeStamp: map['created_at'],
      content: map['content'],
      senderId: map['sender_id'],
      receiverId: map['receiver_id'],
      date: getDateFromTimeStamp(map['created_at']),
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
    var date = DateTime.tryParse(timeStamp) ?? DateTime.now();
    // final daysAgo = DateTime.now().subtract(Duration(days: date.day));
    // if ( < 1) {}
    return '${date.day}/${date.month}/${date.year}';
  }
}
