// Import dependencies
// Flutter
import 'package:blend/pages/auth/verify.dart';
import 'package:blend/pages/navPages/analytics/analytics.dart';
import 'package:blend/pages/navPages/userProfile/user_profile.dart';
import 'package:blend/pages/navPages/workspaceProfile/workspace_profile.dart';
import 'package:blend/pages/splash.dart';
import 'package:flutter/material.dart';
import 'router/router.dart' as router;
import 'router/routing_constants.dart';
import 'package:blend/global_provider.dart';
// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
// Misc
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

// Import pages
import 'pages/home.dart';
import 'pages/auth/login.dart';
import 'pages/auth/register.dart';
import 'pages/navPages/posting/platforms.dart';
import 'pages/navPages/posting/caption.dart';
import 'pages/navPages/posting/media.dart';
import 'pages/navPages/posting/overview_post.dart';

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
    final _page = provider.navbarIndex;
    final _pageController = provider.pageController;
    final authUser = provider.authUser;

    return MaterialApp(
      title: "Blend",
      onGenerateRoute: router.generateRoute,
      initialRoute: SplashRoute,
      theme: provider.theme,
      home: (authUser == null)
          ? SplashPage()
          : (!authUser.emailVerified)
              ? VerifyPage()
              : SafeArea(
                child: Scaffold(
                    extendBody: true,
                    body: PageView(
                      controller: _pageController,
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        HomePage(), //0
                        PostingPlatformsPage(), //1
                        AnalyticsPage(), //2
                        WorkspaceProfilePage(), //3
                        PostingCaptionPage(), //4
                        PostingMediaPage(), //5
                        PostingOverviewPage(), //6
                        // UserProfilePage(), //7
                      ],
                    ),
                    bottomNavigationBar: CurvedNavigationBar(
                      key: _bottomNavigationKey,
                      index: 0,
                      animationCurve: Curves.easeInOut,
                      animationDuration: Duration(milliseconds: 300),
                      backgroundColor: Color.fromARGB(
                        210,
                        provider.theme.colorScheme.background.red,
                        provider.theme.colorScheme.background.green,
                        provider.theme.colorScheme.background.blue,
                      ),
                      buttonBackgroundColor: provider.theme.colorScheme.surface,
                      color: provider.theme.colorScheme.surface,
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
                        provider.updateNavbarIndex(index);
                        _pageController.animateToPage(index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut);
                      },
                      letIndexChange: (index) => true,
                    ),
                  ),
              ),
      
    );
  }
}


// Router class
