// Import dependencies
// Flutter
import 'package:flutter/material.dart';
import 'router/router.dart' as router;
import 'router/routing_constants.dart';
import 'global_provider.dart';
// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
// Misc
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';

// Import pages
import 'pages/home.dart';
import 'pages/undefined.dart';
import 'pages/auth/login.dart';
import 'pages/auth/register.dart';
import 'pages/posting/platforms.dart';
import 'pages/posting/caption.dart';
import 'pages/posting/media.dart';

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
      create: (context) => GlobalProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GlobalProvider>(context);
    final _bottomNavigationKey = provider.bottomNavigationKey;
    final _page = provider.page;
    final _pageController = provider.pageController;

    return MaterialApp(
      title: "Blend",
      onGenerateRoute: router.generateRoute,
      initialRoute: HomeRoute,
      home: Scaffold(
        body: PageView(
          controller: _pageController,
          children: <Widget>[
            HomePage(),
            PostingPlatformsPage(),
            LoginPage(),
            RegisterPage()
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 0,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 300),
          backgroundColor: Color.fromARGB(255, 35, 49, 117),
          buttonBackgroundColor: Color.fromARGB(255, 15, 23, 63),
          color: Color.fromARGB(255, 15, 23, 63),
          height: 65,
          items: const <Widget>[
            Icon(
              Icons.home_filled,
              size: 35,
              color: Colors.white,
            ),
            Icon(
              Icons.add_box,
              size: 35,
              color: Colors.white,
            ),
            Icon(
              Icons.insert_chart,
              size: 35,
              color: Colors.white,
            ),
            Icon(
              Icons.account_circle,
              size: 35,
              color: Colors.white,
            )
          ],
          onTap: (index) {
            provider.updatePage(index);
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut);
          },
          letIndexChange: (index) => true,
        ),
      ),
    );
  }
}


// Router class
