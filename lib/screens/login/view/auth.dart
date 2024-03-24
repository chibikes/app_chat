import 'package:app_chat/screens/login/view/login_screen.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                Center(
                  child: Image.asset(
                    'assets/appchat.png',
                    scale: 1.5,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      'Welcome to AppChat',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                        'By tapping the Continue button you agree to adhere to our terms and services'),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const LoginScreen();
                      }));
                    },
                    child: Text(
                      'Agree and Continue',
                      style: TextStyle(color: Colors.white),
                    ))
              ]),
        ),
      ),
    );
  }
}
