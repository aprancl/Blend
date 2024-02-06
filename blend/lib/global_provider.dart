// Flutter
import 'package:flutter/material.dart';
// Firebase
import 'package:firebase_auth/firebase_auth.dart';
// Misc
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class GlobalProvider with ChangeNotifier {
  int page = 0;
  GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();
  PageController pageController = PageController();

  void updatePage(int index) {
    page = index;
    notifyListeners();
  }

  void goToPage(int index) {
    final CurvedNavigationBarState? navBarState =
        bottomNavigationKey.currentState;
    navBarState?.setPage(index);
  }

  var authStateChanges =
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });
}
