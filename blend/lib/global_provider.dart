// Flutter
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:image_picker/image_picker.dart';

class GlobalProvider with ChangeNotifier {
  // ****************************************************** //
  // ********************* Navigation ********************* //
  // ****************************************************** //
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

  // ****************************************************** //
  // ************************ Auth ************************ //
  // ****************************************************** //
  var authStateChanges = FirebaseAuth.instance.authStateChanges().listen(
    (User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    },
  );

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
