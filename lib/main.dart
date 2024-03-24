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
    url: 'https://uaeddetfadjtcwjwotas.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhZWRkZXRmYWRqdGN3andvdGFzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDA3NDM1MTUsImV4cCI6MjAxNjMxOTUxNX0.YylIvPrh-59xordtXe4Pw0kt_DQ7sVFO3We7XEpdxY4',
  );

  runApp(
    ChatApp(
      authRepository: AuthRepository(),
      messagesRepository: MessagesRepository(),
    ),
  );
}
