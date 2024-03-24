// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAM49IUfE3b53xURO04mARb08191ZB7nEM',
    appId: '1:819020990693:android:d8962a45a106bb32872c0c',
    messagingSenderId: '819020990693',
    projectId: 'app-chat-8328a',
    storageBucket: 'app-chat-8328a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCBTlv2A7rw5fmROZUhjs1eJvky7jZr4-s',
    appId: '1:819020990693:ios:90368248954a8d79872c0c',
    messagingSenderId: '819020990693',
    projectId: 'app-chat-8328a',
    storageBucket: 'app-chat-8328a.appspot.com',
    androidClientId: '819020990693-kuiv4076bjrm831eraunkcbt2pu2auvv.apps.googleusercontent.com',
    iosClientId: '819020990693-f524ve0bggq3q9ddqd55l2onvd53agi8.apps.googleusercontent.com',
    iosBundleId: 'com.example.appChat',
  );
}
