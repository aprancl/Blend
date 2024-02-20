// Flutter
import 'dart:async';

import 'package:blend/models/blendUser.dart';
import 'package:blend/models/blendWorkspace.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'dart:io';

class GlobalProvider with ChangeNotifier {
//  ██████  ██       ██████  ██████   █████  ██
// ██       ██      ██    ██ ██   ██ ██   ██ ██
// ██   ███ ██      ██    ██ ██████  ███████ ██
// ██    ██ ██      ██    ██ ██   ██ ██   ██ ██
//  ██████  ███████  ██████  ██████  ██   ██ ███████
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  late StreamSubscription<User?> _authStateChanges;

  GlobalProvider() {
    _initializeAuthStateListener();
  }

//  ████████ ██   ██ ███████ ███    ███ ███████
//     ██    ██   ██ ██      ████  ████ ██
//     ██    ███████ █████   ██ ████ ██ █████
//     ██    ██   ██ ██      ██  ██  ██ ██
//     ██    ██   ██ ███████ ██      ██ ███████
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

// ███    ██  █████  ██    ██ ██  ██████   █████  ████████ ██  ██████  ███    ██
// ████   ██ ██   ██ ██    ██ ██ ██       ██   ██    ██    ██ ██    ██ ████   ██
// ██ ██  ██ ███████ ██    ██ ██ ██   ███ ███████    ██    ██ ██    ██ ██ ██  ██
// ██  ██ ██ ██   ██  ██  ██  ██ ██    ██ ██   ██    ██    ██ ██    ██ ██  ██ ██
// ██   ████ ██   ██   ████   ██  ██████  ██   ██    ██    ██  ██████  ██   ████
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

//  █████  ██    ██ ████████ ██   ██ ███████ ███    ██ ████████ ██  ██████  █████  ████████ ██  ██████  ███    ██
// ██   ██ ██    ██    ██    ██   ██ ██      ████   ██    ██    ██ ██      ██   ██    ██    ██ ██    ██ ████   ██
// ███████ ██    ██    ██    ███████ █████   ██ ██  ██    ██    ██ ██      ███████    ██    ██ ██    ██ ██ ██  ██
// ██   ██ ██    ██    ██    ██   ██ ██      ██  ██ ██    ██    ██ ██      ██   ██    ██    ██ ██    ██ ██  ██ ██
// ██   ██  ██████     ██    ██   ██ ███████ ██   ████    ██    ██  ██████ ██   ██    ██    ██  ██████  ██   ████
  var existingEmail = null;
  var authUser = FirebaseAuth.instance.currentUser;
  BlendUser blendUser = BlendUser();

  void _initializeAuthStateListener() {
    _authStateChanges = FirebaseAuth.instance.authStateChanges().listen(
      (User? user) async {
        if (user == null) {
          print('User is currently signed out!');
        } else {
          print('User is signed in!');
          await getAuthUser();
          await getBlendUser();
        }
      },
    );
  }

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

  Future<BlendUser> getBlendUser() async {
    print("getAuthUserDoc");
    if (FirebaseAuth.instance.currentUser != null) {
      final ref = db.collection("users").doc(authUser!.uid).withConverter(
            fromFirestore: BlendUser.fromFirestore,
            toFirestore: (BlendUser blendUser, _) => blendUser.toFirestore(),
          );
      final docSnap = await ref.get();
      final blendUser = docSnap.data();

      var blendWorkspaces = <BlendWorkspace>[];

      // print("WORKSPACE REFS: ${blendUser}")
      for (var workspace in blendUser!.workspaceRefs!) {
        blendWorkspaces.add(await getBlendWorkspace(workspace));
      }

      blendUser.workspaces = blendWorkspaces;
      blendUser.personalWorkspace =
          await getBlendWorkspace(blendUser.personalWorkspaceRef!);

      this.blendUser = blendUser!;
      notifyListeners();
      return blendUser;
    } else {
      this.blendUser = BlendUser();
      notifyListeners();
      return BlendUser();
    }
  }

  Future<BlendWorkspace> getBlendWorkspace(
      DocumentReference<Map<String, dynamic>> workspaceRef) async {
    final ref = workspaceRef.withConverter(
      fromFirestore: BlendWorkspace.fromFirestore,
      toFirestore: (BlendWorkspace blendWorkspace, _) =>
          blendWorkspace.toFirestore(),
    );
    final workspaceDocSnap = await ref.get();
    final blendWorkspace = workspaceDocSnap.data();
    return blendWorkspace!;
  }

  Future<FirebaseAuthException?> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      getAuthUser();
      return null;
    } on FirebaseAuthException catch (e) {
      return e;
    }
  }

  Future<FirebaseAuthException?> signUp(
    String fname,
    String lname,
    String email,
    String username,
    String password,
  ) async {
    try {
      // Check if username is taken
      final usernameRef = db.collection("users").doc(username);
      final usernameDoc = await usernameRef.get();
      if (usernameDoc.exists) {
        return FirebaseAuthException(
          code: "username-taken",
          message: "Username is already taken",
        );
      }

      // Create auth account
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Reload authUser
      authUser = FirebaseAuth.instance.currentUser;
      await authUser!.updateDisplayName("$fname $lname");

      // Create personal blendCard
      final blendCard = <String, dynamic>{
        "bio": "",
        "platforms": [],
        "background":
            "https://images.pexels.com/photos/15334615/pexels-photo-15334615.jpeg",
        "topColor": "rgba(255, 149, 56, 1)",
        "bottomColor": "rgba(114, 203, 255, 0.5)",
      };

      var blendCardDocRef = await db.collection("blendCards").add(blendCard);

      // Create personal workspace
      final workspace = <String, dynamic>{
        "name": "$username's Workspace",
        "followers": 0,
        "following": 0,
        "pfp":
            "https://ui-avatars.com/api/?background=0D8ABC&color=fff&name=$fname+$lname",
        "users": [
          {"user": db.doc('users/${authUser!.uid}'), "role": "owner"}
        ],
        "blendCard": db.doc('blendCards/${blendCardDocRef.id}'),
        "instagram": {},
        "tiktok": {},
        "youtube": {},
        "snapchat": {},
        "x": {},
        "facebook": {},
        "linkedin": {},
      };

      var workspaceDocRef = await db.collection("workspaces").add(workspace);

      final user = <String, dynamic>{
        "fname": fname,
        "lname": lname,
        "email": email,
        "username": username,
        "pfp":
            "https://ui-avatars.com/api/?background=0D8ABC&color=fff&name=$fname+$lname",
        "theme": "default",
        "customTheme": {},
        "personalWorkspace": db.doc('workspaces/${workspaceDocRef.id}'),
        "workspaces": [db.doc('workspaces/${workspaceDocRef.id}')],
      };

      await db
          .collection("users")
          .doc(authUser!.uid)
          .set(user)
          .catchError((e) => print("CREATING USER ERROR: " + e));

      getAuthUser();

      // send verification email
      await authUser!.sendEmailVerification();
      return null;
    } on FirebaseAuthException catch (e) {
      return e;
    }
  }

  Future<bool> isUsernameAvailable(String username) async {
    final usernameRef = db.collection("users").doc(username);

    await usernameRef.get().then((doc) {
      if (doc.exists) {
        return false;
      } else {
        return true;
      }
    });

    return false;
  }

  void forgotPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    getAuthUser();
    notifyListeners();
  }
  // getAuthUser()

// ██████   ██████  ███████ ████████ ██ ███    ██  ██████
// ██   ██ ██    ██ ██         ██    ██ ████   ██ ██
// ██████  ██    ██ ███████    ██    ██ ██ ██  ██ ██   ███
// ██      ██    ██      ██    ██    ██ ██  ██ ██ ██    ██
// ██       ██████  ███████    ██    ██ ██   ████  ██████
  Set<String> selectedPlatforms = {};
  var postCaption = "";
  var defaultImagePath = "images/lime.png";
  File? selectedMedia;

  Future selectImage() async {
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (img != null) {
        selectedMedia = File(img!.path);
        notifyListeners();
      }
    } on Error catch (err) {
      debugPrint("Failed to find image: $err");
    }
  }

  @override
  void dispose() {
    _authStateChanges.cancel();
    super.dispose();
  }
}
