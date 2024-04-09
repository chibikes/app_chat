import 'package:app_chat/app.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:app_chat/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await requestNotificationPermission();

  await dotenv.load(fileName: ".env");

  final url = dotenv.env['URL'] ?? '';
  final anonKey = dotenv.env['ANON_KEY'] ?? '';

  await Supabase.initialize(
    url: url,
    anonKey: anonKey,
    realtimeClientOptions: const RealtimeClientOptions(eventsPerSecond: 2),
  );

  runApp(
    ChatApp(
      authRepository: AuthRepository(),
      messagesRepository: MessagesRepository(),
    ),
  );
}

Future<void> requestNotificationPermission() async {
  var notifPermission = await FirebaseMessaging.instance.requestPermission();
  if (notifPermission.authorizationStatus == AuthorizationStatus.authorized) {}
}
