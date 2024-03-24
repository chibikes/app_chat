import 'messages_state.dart';

abstract class MessagesEvent {}

class GetRecentMessages extends MessagesEvent {
  GetRecentMessages();
}

class GetUserMessages extends MessagesEvent {
  final String chatId;

  GetUserMessages({required this.chatId});
}

class SendMessage extends MessagesEvent {
  final Message message;

  SendMessage({required this.message});
}

class GetContacts extends MessagesEvent {
  GetContacts();
}

class GetContactUserId extends MessagesEvent {
  final String phone;

  GetContactUserId({required this.phone});
}
