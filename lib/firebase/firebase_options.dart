// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyATX9vcuuqEZfBkZhuCYN8gdiL6QdZeFA8',
    appId: '1:4318674495:web:ce8191575d0f0f3389828a',
    messagingSenderId: '4318674495',
    projectId: 'eashtonsfishies',
    authDomain: 'eashtonsfishies.firebaseapp.com',
    storageBucket: 'eashtonsfishies.firebasestorage.app',
    measurementId: 'G-LT6DCSKS8J',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDPy9v8bkfemnm5tEePbOqSo_R_CUvYwJ8',
    appId: '1:4318674495:android:5da8624cee0c170489828a',
    messagingSenderId: '4318674495',
    projectId: 'eashtonsfishies',
    storageBucket: 'eashtonsfishies.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAHEwJxAcqX4oJuU3Pm9JyDlbCEqEaXndc',
    appId: '1:4318674495:ios:f1d53f04754d929089828a',
    messagingSenderId: '4318674495',
    projectId: 'eashtonsfishies',
    storageBucket: 'eashtonsfishies.firebasestorage.app',
    iosBundleId: 'com.example.eashtonsfishies',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAHEwJxAcqX4oJuU3Pm9JyDlbCEqEaXndc',
    appId: '1:4318674495:ios:f1d53f04754d929089828a',
    messagingSenderId: '4318674495',
    projectId: 'eashtonsfishies',
    storageBucket: 'eashtonsfishies.firebasestorage.app',
    iosBundleId: 'com.example.eashtonsfishies',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyATX9vcuuqEZfBkZhuCYN8gdiL6QdZeFA8',
    appId: '1:4318674495:web:6e5cdabe17ab48a989828a',
    messagingSenderId: '4318674495',
    projectId: 'eashtonsfishies',
    authDomain: 'eashtonsfishies.firebaseapp.com',
    storageBucket: 'eashtonsfishies.firebasestorage.app',
    measurementId: 'G-V8Q5CGHE6X',
  );
}

// Import the functions you need from the SDKs you need
