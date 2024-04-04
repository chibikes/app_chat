import 'messages_state.dart';

abstract class MessagesEvent {}

class GetRecentMessages extends MessagesEvent {
  final String id;

  GetRecentMessages(this.id);
}

class GetUserMessages extends MessagesEvent {
  GetUserMessages();
}

class UpdateChatId extends MessagesEvent {
  final String chatId;

  UpdateChatId({required this.chatId});
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
