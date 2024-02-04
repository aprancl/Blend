// Import dependencies
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';

// Import pages
import 'pages/home.dart';
import 'pages/auth/login.dart';
import 'pages/auth/register.dart';
import 'pages/posting/platforms.dart';
import 'pages/posting/caption.dart';
import 'pages/posting/media.dart';
import 'pages/posting/postingState.dart';


void main() async {
  // Make sure everything is loaded
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Launch the app
  runApp(
    ChangeNotifierProvider(
      create: (context) => (PostDataState()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blend',
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/auth/login': (context) => LoginPage(),
        '/auth/register': (context) => RegisterPage(),
        '/posting/platforms': (context) => PostingPlatformsPage(),
        '/posting/caption': (context) => PostingCaptionPage(),
        '/posting/media': (context) => PostingMediaPage(),
      },
    );
  }
}

// class MyAppState extends ChangeNotifier {
//   var current = WordPair.random();

//   // Method to get a new word pair
//   void getNext() {
//     current = WordPair.random();
//     notifyListeners();
//   }

//   var favorites = <WordPair>[];

//   void toggleFavorite() {
//     if (favorites.contains(current)) {
//       favorites.remove(current);
//     } else {
//       favorites.add(current);
//     }
//     notifyListeners();
//   }

//   var authStateChanges =
//       FirebaseAuth.instance.authStateChanges().listen((User? user) {
//     if (user == null) {
//       print('User is currently signed out!');
//     } else {
//       print('User is signed in!');
//     }
//   });
// }
