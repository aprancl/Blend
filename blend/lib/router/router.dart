import 'package:flutter/material.dart';
import 'routing_constants.dart';
import '../pages/home.dart';
import '../pages/undefined.dart';
import '../pages/auth/login.dart';
import '../pages/auth/register.dart';
import '../pages/navPages/posting/platforms.dart';
import '../pages/navPages/posting/caption.dart';
import '../pages/navPages/posting/media.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeRoute:
      return MaterialPageRoute(builder: (context) => HomePage());
    case LoginRoute:
      return MaterialPageRoute(builder: (context) => LoginPage());
    case RegisterRoute:
      return MaterialPageRoute(builder: (context) => RegisterPage());
    case PostingPlatformsRoute:
      return MaterialPageRoute(builder: (context) => PostingPlatformsPage());
    case PostingCaptionRoute:
      return MaterialPageRoute(builder: (context) => PostingCaptionPage());
    case PostingMediaRoute:
      return MaterialPageRoute(builder: (context) => PostingMediaPage());
    default:
      return MaterialPageRoute(builder: (context) => UndefinedPage());
  }
}
