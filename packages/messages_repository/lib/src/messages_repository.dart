import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

class MessagesRepository {
  final _recentMessagesResponse =
      StreamController<List<Map<String, dynamic>>>();
  final _chatResponse = StreamController<List<Map<String, dynamic>>>();
  List<Map<String, dynamic>> msgs = [];
  final _messagesTable = 'messages';
  RealtimeChannel? _channel;

  String _chatId = '';

  MessagesRepository();

  Stream<List<Map<String, dynamic>>> getRecentMessages(String userId) {
    Supabase.instance.client
        .rpc('get_msgs', params: {'user_id': '$userId'}).then((value) {
      var li = value as List<dynamic>;
      var messages = li.map((e) => e as Map<String, dynamic>).toList();
      _recentMessagesResponse.add(messages);
    }).catchError((error) {
      print('Error getting recent messages $error');
    });

    return _recentMessagesResponse.stream;
  }

  Stream<List<Map<String, dynamic>>> getChatMessages() {
    return _chatResponse.stream;
  }

  void getChats(String chatId) {
    final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
    _chatId = chatId;
    Supabase.instance.client.rpc('get_users_msgs',
        params: {'user_one_id': userId, 'user_two_id': _chatId}).then((value) {
      final li = value as List<dynamic>;
      final messages = li.map((e) => e as Map<String, dynamic>).toList();
      _chatResponse.add(messages);
    }).catchError((err) {
      print('Error getting conversation is $err');
    });
  }

  RealtimeChannel? getChannel() {
    return _channel;
  }

  void ListenToDatabaseChanges(String userId) {
    _channel ??= Supabase.instance.client
        .channel(_messagesTable)
        .onPostgresChanges(
            schema: 'public',
            table: _messagesTable,
            event: PostgresChangeEvent.insert,
            callback: (payload) {
              if (payload.newRecord['sender_id'] != userId &&
                  payload.newRecord['receiver_id'] != userId) {
                return;
              }
              // fetch recent messages
              Supabase.instance.client.rpc('get_msgs',
                  params: {'user_id': '$userId'}).then((value) {
                var li = value as List<dynamic>;
                var messages =
                    li.map((e) => e as Map<String, dynamic>).toList();
                _recentMessagesResponse.add(messages);
              }).catchError((error) {
                print('Error is $error');
              });

              // get messages for recent conversation
              if (_chatId.isNotEmpty) {
                Supabase.instance.client.rpc('get_users_msgs', params: {
                  'user_one_id': userId,
                  'user_two_id': _chatId
                }).then((value) {
                  final li = value as List<dynamic>;
                  final messages =
                      li.map((e) => e as Map<String, dynamic>).toList();
                  _chatResponse.add(messages);
                }).catchError((err) {
                  print('Error getting conversation is $err');
                });
              }
            })
        .subscribe();
  }

  Future<void> sendMessage(Map<String, dynamic> message) async {
    try {
      await Supabase.instance.client.from(_messagesTable).insert(message);
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  Future<String> getContactUserId(String phone) async {
    try {
      var search = phone.replaceAll(" ", "");

      if (phone[0] != '+') {
        search = phone.substring(1);
      }
      var userIds = await Supabase.instance.client
          .from('users')
          .select('user_id')
          .ilike('phone_number', '%$search%')
          .limit(1);

      return userIds.first['user_id'] as String;
    } catch (e) {
      print('Error getting user id $e');
      return '';
    }
  }
}
