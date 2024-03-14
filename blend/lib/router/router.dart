import 'package:blend/pages/analytics/analytics.dart';
import 'package:blend/pages/analytics/platform_analytics.dart';
import 'package:blend/pages/auth/verify.dart';
import 'package:blend/pages/posting/overview_post.dart';
import 'package:blend/pages/user/settings/user_settings.dart';
import 'package:blend/pages/user/settings/user_theme.dart';
import 'package:blend/pages/user/user_profile.dart';
import 'package:blend/pages/workspace/edit_blendCard.dart';
import 'package:blend/pages/workspace/settings/workspace_account_linking.dart';
import 'package:blend/pages/workspace/settings/workspace_settings.dart';
import 'package:blend/pages/workspace/workspace_profile.dart';
import 'package:blend/pages/splash.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import '../pages/home.dart';
import '../pages/undefined.dart';
import '../pages/auth/login.dart';
import '../pages/auth/register.dart';
import '../pages/posting/platforms.dart';
import '../pages/posting/caption.dart';
import '../pages/posting/media.dart';
import 'package:blend/global_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  var authUser = FirebaseAuth.instance.currentUser;
  print("CURRENT USER: $authUser");

  if (authUser != null) {
    if (authUser.emailVerified == false) {
      print("VERIFY YO EMAIL");
      return MaterialPageRoute(builder: (context) => VerifyPage());
    } else {
      print("Oh cool, yo email is verified! :))))))");

      // ATTENTION!! ATTENTION!! ATTENTION!! ATTENTION!! ATTENTION!! ATTENTION!! 
      // --- If you are adding a new route for LOGGED IN USERS, add it here!
      // ATTENTION!! ATTENTION!! ATTENTION!! ATTENTION!! ATTENTION!! ATTENTION!! 
      switch (settings.name) {
        // HOME
        case '/home':
          return MaterialPageRoute(builder: (context) => HomePage());

        // POSTING
        case '/posting/platforms':
          return MaterialPageRoute(
              builder: (context) => PostingPlatformsPage());
        case '/posting/caption':
          return MaterialPageRoute(builder: (context) => PostingCaptionPage());
        case '/posting/media':
          return MaterialPageRoute(builder: (context) => PostingMediaPage());
        case '/posting/overview':
          return MaterialPageRoute(builder: (context) => PostingOverviewPage());

        // WORKSPACE
        case '/workspace/profile':
          return MaterialPageRoute(
              builder: (context) => WorkspaceProfilePage());
        case '/workspace/blendcard':
          return MaterialPageRoute(
            builder: (context) => EditBlendCardPage(),
          );
        case '/workspace/settings':
          return MaterialPageRoute(
              builder: (context) => WorkspaceSettingsPage());
        case '/workspace/settings/account-linking':
          return MaterialPageRoute(
              builder: (context) => WorkspaceAccountLinkingPage());
          
        // USER
        case '/user/profile':
          return MaterialPageRoute(builder: (context) => UserProfilePage());
        case '/user/settings':
          return MaterialPageRoute(builder: (context) => UserSettingsPage());
        case '/user/settings/theme':
          return MaterialPageRoute(builder: (context) => UserThemePage());
          
        // ANALYTICS
        case '/analytics':
          return MaterialPageRoute(builder: (context) => AnalyticsPage());
        case '/analytics/platforms':
          return MaterialPageRoute(builder: (context) => PlatformAnalyticsPage());
        default:
          return MaterialPageRoute(builder: (context) => UndefinedPage());
      }
    }
  } else {
    print("imagine not being logged in. loser");
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (context) => LoginPage());
      case '/register':
        return MaterialPageRoute(builder: (context) => RegisterPage());
      default:
        return MaterialPageRoute(builder: (context) => SplashPage());
    }
  }
}
