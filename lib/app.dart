import 'package:app_chat/blocs/authentication_blocs/authentication_bloc.dart';
import 'package:app_chat/blocs/messages_bloc/messages_bloc.dart';
import 'package:app_chat/blocs/messages_bloc/messages_event.dart';
import 'package:app_chat/blocs/settings_bloc/settings_bloc.dart';
import 'package:app_chat/blocs/settings_bloc/settings_state.dart';
import 'package:app_chat/screens/home/home.dart';
import 'package:app_chat/screens/login/view/auth.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login/cubit/login_cubit.dart';
import 'theme.dart';

class ChatApp extends StatelessWidget {
  final AuthRepository authRepository;
  final MessagesRepository messagesRepository;

  const ChatApp({
    super.key,
    required this.authRepository,
    required this.messagesRepository,
  });
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => authRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => LoginCubit(authRepository),
          ),
          BlocProvider<AuthenticationBloc>(
              lazy: false,
              create: (context) {
                return AuthenticationBloc(
                  authRepository: authRepository,
                );
              }),
          BlocProvider<SettingsBloc>(
              lazy: false,
              create: (context) {
                return SettingsBloc(const SettingsState());
              }),
          BlocProvider<MessagesBloc>(
              lazy: false,
              create: (context) {
                return MessagesBloc(
                  messageRepository: messagesRepository,
                )..add(GetContacts());
              }),
        ],
        child:
            BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
          return MaterialApp(
            theme: context.read<SettingsBloc>().state.isDarkTheme
                ? darkTheme
                : lightTheme,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('es'),
            ],
            routes: {
              '/': (context) {
                return Scaffold(
                  backgroundColor: const Color(0xff521c99),
                  body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
                      builder: (context, state) {
                    if (state is Authenticated) {
                      return const Home();
                    }
                    return const AuthScreen();
                  }, listener: (context, state) {
                    if (state is Authenticated) {
                      context.read<AuthenticationBloc>().add(UpdateUser(() => {
                            FirebaseMessaging.instance.onTokenRefresh
                                .listen((event) {
                              debugPrint('token: $event');
                              authRepository.updateFCMToken(event);
                            })
                          }));
                    }
                  }),
                );
              }
            },
          );
        }),
      ),
    );
  }
}
