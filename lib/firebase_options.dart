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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCIwvDawKAl_gLIzWZNUXa5nw9pby2NHkA',
    appId: '1:1041681179622:web:b5b1db854308359a73ec27',
    messagingSenderId: '1041681179622',
    projectId: 'attendance-a0034',
    authDomain: 'attendance-a0034.firebaseapp.com',
    databaseURL: 'https://attendance-a0034-default-rtdb.firebaseio.com',
    storageBucket: 'attendance-a0034.appspot.com',
    measurementId: 'G-64Q6YY9XHC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCA7Th-o7gx4dltlktG2dPWsFPi7aPIGnY',
    appId: '1:1041681179622:android:9965375513af7c6d73ec27',
    messagingSenderId: '1041681179622',
    projectId: 'attendance-a0034',
    databaseURL: 'https://attendance-a0034-default-rtdb.firebaseio.com',
    storageBucket: 'attendance-a0034.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBOyOgGUArVr6lf9J6ghCsCqZIEHhRCO38',
    appId: '1:1041681179622:ios:5f6ec28bb1fbcb3d73ec27',
    messagingSenderId: '1041681179622',
    projectId: 'attendance-a0034',
    databaseURL: 'https://attendance-a0034-default-rtdb.firebaseio.com',
    storageBucket: 'attendance-a0034.appspot.com',
    iosBundleId: 'com.example.seminar',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCIwvDawKAl_gLIzWZNUXa5nw9pby2NHkA',
    appId: '1:1041681179622:web:f918891d31a0263073ec27',
    messagingSenderId: '1041681179622',
    projectId: 'attendance-a0034',
    authDomain: 'attendance-a0034.firebaseapp.com',
    databaseURL: 'https://attendance-a0034-default-rtdb.firebaseio.com',
    storageBucket: 'attendance-a0034.appspot.com',
    measurementId: 'G-LCHFCCD2CQ',
  );
}
