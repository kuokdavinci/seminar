import 'package:seminar/source/resources/features/remember.dart';
import 'package:seminar/source/resources/pages/admin_home_page.dart';
import 'package:seminar/source/resources/pages/home_page.dart';
import 'package:seminar/source/resources/pages/login_page.dart';
import "package:firebase_core/firebase_core.dart" show Firebase, FirebaseOptions;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  bool rememberMe = await RememberMeManager.getRememberMe();
  String? username = await RememberMeManager.getUsername();
  String? password = await RememberMeManager.getPassword();
  bool? isAdmin = await RememberMeManager.getIsAdmin();
  Widget initialRoute;

  if (rememberMe && username != null && password != null && isAdmin != null) {
    if (isAdmin) {
      initialRoute = const AdminHomePage();
    } else{

      initialRoute = const HomePage(initialTabIndex: 0);
    }
  } else {
    initialRoute = const LoginPage();
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final Widget initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Attendance App',
      home: initialRoute,
    );
  }
}

class DefaultFirebaseOptions {
  static FirebaseOptions? get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.fuchsia:
      // TODO: Handle this case.
      case TargetPlatform.linux:
      // TODO: Handle this case.
      case TargetPlatform.windows:
      // TODO: Handle this case.
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
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
    appId: '1:1041681179622:android:fd73e43364b8720c73ec27',
    messagingSenderId: '1041681179622',
    projectId: 'attendance-a0034',
    databaseURL: 'https://attendance-a0034-default-rtdb.firebaseio.com',
    storageBucket: 'attendance-a0034.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'xxxxxxxxxxxxxxxxxxx',
    appId: 'xxxxxxxxxxxxxxxxxxx',
    messagingSenderId: 'xxxxxxxxxxxxxxxxxxx',
    projectId: 'xxxxxxxxxxxxxxxxxxx',
    databaseURL: 'xxxxxxxxxxxxxxxxxxx',
    storageBucket: 'xxxxxxxxxxxxxxxxxxx',
    androidClientId: 'xxxxxxxxxxxxxxxxxxx',
    iosClientId: 'xxxxxxxxxxxxxxxxxxx',
    iosBundleId: 'xxxxxxxxxxxxxxxxxxx',
  );

  static FirebaseOptions? get macos => null;
}
