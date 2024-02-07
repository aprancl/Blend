// Flutter
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

class GlobalProvider with ChangeNotifier {
  ThemeData lightTheme = FlexThemeData.light(
    colors: const FlexSchemeColor(
      primary: Color(0xff004881),
      primaryContainer: Color(0xffd0e4ff),
      secondary: Color(0xffac3306),
      secondaryContainer: Color(0xffffdbcf),
      tertiary: Color(0xff006875),
      tertiaryContainer: Color(0xff95f0ff),
      appBarColor: Color(0xffffdbcf),
      error: Color(0xffb00020),
    ),
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 20,
    appBarOpacity: 0.95,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 20,
      blendOnColors: false,
    ),
    useMaterial3ErrorColors: true,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    // To use the playground font, add GoogleFonts package and uncomment
    // fontFamily: GoogleFonts.notoSans().fontFamily,
  );

  ThemeData darkTheme = FlexThemeData.dark(
    colors: const FlexSchemeColor(
      primary: Color.fromARGB(255, 0, 132, 255),
      primaryContainer: Color.fromARGB(255, 0, 40, 255),
      secondary: Color.fromARGB(255, 0, 211, 255),
      secondaryContainer: Color.fromARGB(255, 0, 159, 173),
      tertiary: Color.fromARGB(255, 134, 210, 225),
      tertiaryContainer: Color.fromARGB(255, 0, 78, 89),
      appBarColor: Color.fromARGB(255, 0, 159, 173),
      error: Color.fromARGB(255, 207, 102, 121),
    ),
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 30,
    appBarStyle: FlexAppBarStyle.background,
    appBarOpacity: 0.90,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 30,
    ),
    useMaterial3ErrorColors: true,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    // To use the playground font, add GoogleFonts package and uncomment
    // fontFamily: GoogleFonts.notoSans().fontFamily,
  );

  ThemeData theme = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: Color.fromARGB(255, 213, 220, 231),
      onPrimary: Color.fromARGB(255, 0, 157, 255),
      primaryContainer: Color(0xff0028ff),
      onPrimaryContainer: Color(0xffd0d9ff),
      secondary: Color(0xff00d3ff),
      onSecondary: Color(0xff061e1e),
      secondaryContainer: Color(0xff009fad),
      onSecondaryContainer: Color(0xffd0f5f8),
      tertiary: Color(0xff86d2e1),
      onTertiary: Color(0xff151e1e),
      tertiaryContainer: Color(0xff004e59),
      onTertiaryContainer: Color(0xffd0e2e5),
      error: Color(0xffffb4a9),
      onError: Color(0xff680003),
      errorContainer: Color(0xff930006),
      onErrorContainer: Color(0xffffb4a9),
      outline: Color(0xff93969a),
      background: Color.fromARGB(255, 11, 41, 102),
      onBackground: Color.fromARGB(255, 255, 255, 255),
      surface: Color.fromARGB(255, 0, 7, 48),
      onSurface: Color(0xfff0f1f1),
      surfaceVariant: Color(0xff10171e),
      onSurfaceVariant: Color(0xffe2e3e4),
      inverseSurface: Color(0xfff8fbff),
      onInverseSurface: Color(0xff0e0e0f),
      inversePrimary: Color(0xff0e4673),
      shadow: Color(0xff000000),
    ),
  );

  // ****************************************************** //
  // ********************* Navigation ********************* //
  // ****************************************************** //
  int navbarIndex = 0;
  GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();
  PageController pageController = PageController();

  void updateNavbarIndex(int index) {
    navbarIndex = index;
    notifyListeners();
  }

  void goToNavPage(int index) {
    final CurvedNavigationBarState? navBarState =
        bottomNavigationKey.currentState;
    navBarState?.setPage(index);
  }

  void goToPage(int index) {
    pageController.jumpToPage(index);
  }

  void animateToPage(int index) {
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  // ****************************************************** //
  // ************************ Auth ************************ //
  // ****************************************************** //
  var existingEmail = null;
  final FirebaseAuth auth = FirebaseAuth.instance;
  var authUser = FirebaseAuth.instance.currentUser;

  var authStateChanges = FirebaseAuth.instance.authStateChanges().listen(
    (User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    },
  );

  User? getAuthUser() {
    if (FirebaseAuth.instance.currentUser != null) {
      authUser = FirebaseAuth.instance.currentUser;
      notifyListeners();
      return FirebaseAuth.instance.currentUser!;
    } else {
      authUser = null;
      notifyListeners();
      return null;
    }
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    authUser = null;
    notifyListeners();
  }
  // getAuthUser()

  // ****************************************************** //
  // ********************** Posting *********************** //
  // ****************************************************** //
  Set<String> selectedPlatforms = {};
  var postCaption = "";
  var postMediaPath = "images/lime.png";

  Future selectImage() async {
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (img != null) {
        postMediaPath = img.path;
        notifyListeners();
      }
    } on Error catch (err) {
      debugPrint("Failed to find image: $err");
    }
  }
}
