import 'package:app_chat/app.dart';
import 'package:app_chat/consts.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:app_chat/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: '',
    anonKey: '',
  );

  runApp(
    ChatApp(
      authRepository: AuthRepository(),
      messagesRepository: MessagesRepository(),
    ),
  );
}
