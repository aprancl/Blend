import 'package:blend/pages/auth/verify.dart';
import 'package:blend/pages/navPages/posting/overview_post.dart';
import 'package:blend/pages/navPages/userProfile/user_profile.dart';
import 'package:blend/pages/navPages/workspaceProfile/workspace_profile.dart';
import 'package:blend/pages/splash.dart';
import 'package:flutter/material.dart';
import 'routing_constants.dart';
import '../pages/home.dart';
import '../pages/undefined.dart';
import '../pages/auth/login.dart';
import '../pages/auth/register.dart';
import '../pages/navPages/posting/platforms.dart';
import '../pages/navPages/posting/caption.dart';
import '../pages/navPages/posting/media.dart';
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
      switch (settings.name) {
        case HomeRoute:
          return MaterialPageRoute(builder: (context) => HomePage());
        case PostingPlatformsRoute:
          return MaterialPageRoute(
              builder: (context) => PostingPlatformsPage());
        case PostingCaptionRoute:
          return MaterialPageRoute(builder: (context) => PostingCaptionPage());
        case PostingMediaRoute:
          return MaterialPageRoute(builder: (context) => PostingMediaPage());
        case PostingOverviewRoute:
          return MaterialPageRoute(builder: (context) => PostingOverviewPage());
        case WorkspaceProfileRoute:
          return MaterialPageRoute(builder: (context) => WorkspaceProfilePage());
        case UserProfileRoute:
          return MaterialPageRoute(builder: (context) => UserProfilePage());
        default:
          return MaterialPageRoute(builder: (context) => UndefinedPage());
      }
    }
  } else {
    print("imagine not being logged in. loser");
    switch (settings.name) {
      case LoginRoute:
        return MaterialPageRoute(builder: (context) => LoginPage());
      case RegisterRoute:
        return MaterialPageRoute(builder: (context) => RegisterPage());
      default:
        return MaterialPageRoute(builder: (context) => SplashPage());
    }
  }
}
