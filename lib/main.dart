import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xlearn/providers/katasifat_provider.dart';
import 'package:xlearn/providers/user_provider.dart';
import 'package:xlearn/screen/auth/login_screen.dart';
import 'package:xlearn/screen/auth/register_screen.dart';
import 'package:xlearn/screen/nav/main_screen.dart';
import 'package:xlearn/screen/splash_screen.dart';
import 'package:xlearn/providers/kosakata_provider.dart';
import 'package:xlearn/providers/quiz_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => KosakataProvider()),
        ChangeNotifierProvider(create: (_) => KataSifatProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()), // Tambahkan ini
      ],
      child: MaterialApp(
        title: 'Xlearn',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/dashboard': (context) => MainScreen(),
          // Tambahkan routes lainnya jika diperlukan
        },
      ),
    );
  }
}

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
      return ios;
    } else {
      return android;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCn0-8EkzqIwn2RTwavyxpN07r-ylcUo1o',
    appId: '1:440216501318:android:2cfd7b61fcbbd026b6de47',
    messagingSenderId: '440216501318',
    projectId: 'xlearn-e09bf',
    storageBucket: 'xlearn-e09bf.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDciDM1hmpYIR6VZYyU1cMnI2CJc8NNqso',
    appId: '1:21954989690:ios:fcf101e079cf4b8aa5f5c3',
    messagingSenderId: 'YOUR_IOS_MESSAGING_SENDER_ID',
    projectId: 'ppob-cd34c',
    storageBucket: 'ppob-cd34c.appspot.com',
    iosClientId: 'YOUR_IOS_CLIENT_ID',
    iosBundleId: 'YOUR_IOS_BUNDLE_ID',
  );
}
