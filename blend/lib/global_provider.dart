import 'dart:async';
import 'dart:typed_data';

import 'package:blend/main.dart';
import 'package:blend/models/blendCard.dart';
import 'package:blend/models/blendTheme.dart';
import 'package:blend/models/blendUser.dart';
import 'package:blend/models/blendWorkspace.dart';
import 'package:blend/models/platformSelection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:ffmpeg_kit_flutter/abstract_session.dart';
import 'package:ffmpeg_kit_flutter/arch_detect.dart';
import 'package:ffmpeg_kit_flutter/chapter.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_session_complete_callback.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_session.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_session_complete_callback.dart';
import 'package:ffmpeg_kit_flutter/level.dart';
import 'package:ffmpeg_kit_flutter/log.dart';
import 'package:ffmpeg_kit_flutter/log_callback.dart';
import 'package:ffmpeg_kit_flutter/log_redirection_strategy.dart';
import 'package:ffmpeg_kit_flutter/media_information.dart';
import 'package:ffmpeg_kit_flutter/media_information_json_parser.dart';
import 'package:ffmpeg_kit_flutter/media_information_session.dart';
import 'package:ffmpeg_kit_flutter/media_information_session_complete_callback.dart';
import 'package:ffmpeg_kit_flutter/packages.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:ffmpeg_kit_flutter/session.dart';
import 'package:ffmpeg_kit_flutter/session_state.dart';
import 'package:ffmpeg_kit_flutter/signal.dart';
import 'package:ffmpeg_kit_flutter/statistics.dart';
import 'package:ffmpeg_kit_flutter/statistics_callback.dart';
import 'package:ffmpeg_kit_flutter/stream_information.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gal/gal.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:path_provider/path_provider.dart';

class GlobalProvider with ChangeNotifier {
  //  ██████  ██       ██████  ██████   █████  ██
  // ██       ██      ██    ██ ██   ██ ██   ██ ██
  // ██   ███ ██      ██    ██ ██████  ███████ ██
  // ██    ██ ██      ██    ██ ██   ██ ██   ██ ██
  //  ██████  ███████  ██████  ██████  ██   ██ ███████
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  late StreamSubscription<User?> _authStateChanges;
  int currentWorkspace = 0;

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
      tertiaryContainer: Color.fromARGB(255, 0, 78, 89),
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
      inversePrimary: Color.fromARGB(255, 14, 70, 115),
      shadow: Color(0xff000000),
    ),
  );

  void setTheme(ThemeData newTheme) {
    theme = newTheme;
    notifyListeners();
  }

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
  var pauseAuthStateListener = false;
  BlendUser blendUser = BlendUser();
  BlendCard blendCard = BlendCard(
    topColor: "rgba(255, 149, 56, 1)",
    bottomColor: "rgba(114, 203, 255, 0.5)",
    background:
        "https://images.pexels.com/photos/15334615/pexels-photo-15334615.jpeg",
  );

  void _initializeAuthStateListener() {
    _authStateChanges = FirebaseAuth.instance.authStateChanges().listen(
      (User? user) async {
        if (user == null) {
          print('User is currently signed out!');
        } else {
          if (!pauseAuthStateListener) {
            print('User is signed in!');
            await getAuthUser();
            await getBlendUser();

            // check if email is verified
            // if (authUser!.emailVerified) {
            await getBlendCard(blendUser.workspaces![0].blendCard!);
            // }
            notifyListeners();
          }
        }
      },
    );
  }

  User? getAuthUser() {
    if (FirebaseAuth.instance.currentUser != null) {
      authUser = FirebaseAuth.instance.currentUser;
      notifyListeners();
      print("THE AUTH USER IS " + authUser!.uid);
      return FirebaseAuth.instance.currentUser!;
    } else {
      authUser = null;
      notifyListeners();
      return null;
    }
  }

  Future<BlendUser> getBlendUser() async {
    // DEBUG EMERGENCY SIGNOUT
    if (false) {
      signOut();
    }
    print("getAuthUserDoc");
    if (FirebaseAuth.instance.currentUser != null &&
        FirebaseAuth.instance.currentUser!.emailVerified) {
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

      if (blendUser.theme == "custom") {
        // Extract JSON from the theme string
        BlendTheme blendTheme = BlendTheme.fromJson(blendUser.customTheme!);
        // Convert the JSON to a ThemeData object
        this.theme = ThemeData.from(
          colorScheme: ColorScheme(
            brightness: blendTheme.brightness!,
            primary: blendTheme.primary!,
            onPrimary: blendTheme.onPrimary!,
            primaryContainer: blendTheme.primaryContainer!,
            onPrimaryContainer: blendTheme.onPrimaryContainer!,
            secondary: blendTheme.secondary!,
            onSecondary: blendTheme.onSecondary!,
            secondaryContainer: blendTheme.secondaryContainer!,
            onSecondaryContainer: blendTheme.onSecondaryContainer!,
            tertiary: blendTheme.tertiary!,
            onTertiary: blendTheme.onTertiary!,
            tertiaryContainer: blendTheme.tertiaryContainer!,
            onTertiaryContainer: blendTheme.onTertiaryContainer!,
            error: blendTheme.error!,
            onError: blendTheme.onError!,
            errorContainer: blendTheme.errorContainer!,
            onErrorContainer: blendTheme.onErrorContainer!,
            outline: blendTheme.outline!,
            background: blendTheme.background!,
            onBackground: blendTheme.onBackground!,
            surface: blendTheme.surface!,
            onSurface: blendTheme.onSurface!,
            surfaceVariant: blendTheme.surfaceVariant!,
            onSurfaceVariant: blendTheme.onSurfaceVariant!,
            inverseSurface: blendTheme.inverseSurface!,
            onInverseSurface: blendTheme.onInverseSurface!,
            inversePrimary: blendTheme.inversePrimary!,
            shadow: blendTheme.shadow!,
          ),
        );
      }
      notifyListeners();
      return blendUser;
    } else {
      this.blendUser = BlendUser();
      this.theme = ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFFD5DCE7),
          onPrimary: Color(0xFF009DFF),
          primaryContainer: Color(0xff0028ff),
          onPrimaryContainer: Color(0xffd0d9ff),
          secondary: Color(0xff00d3ff),
          onSecondary: Color(0xff061e1e),
          secondaryContainer: Color(0xff009fad),
          onSecondaryContainer: Color(0xffd0f5f8),
          tertiary: Color(0xff86d2e1),
          onTertiary: Color(0xff151e1e),
          tertiaryContainer: Color(0xFF004E59),
          onTertiaryContainer: Color(0xffd0e2e5),
          error: Color(0xffffb4a9),
          onError: Color(0xff680003),
          errorContainer: Color(0xff930006),
          onErrorContainer: Color(0xffffb4a9),
          outline: Color(0xff93969a),
          background: Color(0xFF0B2966),
          onBackground: Color(0xFFFFFFFF),
          surface: Color(0xFF000730),
          onSurface: Color(0xfff0f1f1),
          surfaceVariant: Color(0xff10171e),
          onSurfaceVariant: Color(0xffe2e3e4),
          inverseSurface: Color(0xfff8fbff),
          onInverseSurface: Color(0xff0e0e0f),
          inversePrimary: Color(0xFF0E4673),
          shadow: Color(0xff000000),
        ),
      );
      notifyListeners();
      return BlendUser();
    }
  }

  Future<BlendUser> getBlendUserByRef(
      DocumentReference<Map<String, dynamic>> blendUserRef) async {
    final ref = blendUserRef.withConverter(
      fromFirestore: BlendUser.fromFirestore,
      toFirestore: (BlendUser blendUser, _) => blendUser.toFirestore(),
    );
    final blendUserDocSnap = await ref.get();
    final blendUser = blendUserDocSnap.data();
    return blendUser!;
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

  Future<BlendCard> getBlendCard(
      DocumentReference<Map<String, dynamic>> blendCardRef) async {
    final ref = blendCardRef.withConverter(
      fromFirestore: BlendCard.fromFirestore,
      toFirestore: (BlendCard blendCard, _) => blendCard.toFirestore(),
    );
    final blendCardDocSnap = await ref.get();
    final blendCard = blendCardDocSnap.data();
    this.blendCard = blendCard!;
    return blendCard!;
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
    pauseAuthStateListener = true;
    try {
      // Check if username is taken
      isUsernameAvailable(username).then((value) {
        if (!value) {
          return FirebaseAuthException(
            code: "username-taken",
            message: "Username is already taken",
          );
        }
      });

      // Create auth account
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Reload authUser
      authUser = FirebaseAuth.instance.currentUser;
      await authUser!.updateDisplayName("$fname $lname");

      // Add username to database
      final usernameRecord = <String, dynamic>{
        "uid": authUser!.uid,
      };

      await db.collection("usernames").doc(username).set(usernameRecord);

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

      await getAuthUser();
      pauseAuthStateListener = false;

      // send verification email
      await authUser!.sendEmailVerification();
      return null;
    } on FirebaseAuthException catch (e) {
      pauseAuthStateListener = false;
      return e;
    }
  }

  Future<FirebaseAuthException?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        throw const NoGoogleAccountChosenException();
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // fetchSignInMethodsForEmail
      final signInMethods = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(googleUser.email);

      if (signInMethods.isEmpty) {
        signUpWithGoogle();
        return null;
      } else {
        await FirebaseAuth.instance.signInWithCredential(credential);
        getAuthUser();
        // pop until /
        navigatorKey.currentState!.popUntil(ModalRoute.withName('/'));
        return null;
      }
    } on FirebaseAuthException catch (e) {
      return e;
    }
  }

  Future<FirebaseAuthException?> signUpWithGoogle() async {
    pauseAuthStateListener = true;
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      throw const NoGoogleAccountChosenException();
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Check if user already exists
    final signInMethods = await FirebaseAuth.instance
        .fetchSignInMethodsForEmail(googleUser.email);

    if (signInMethods.isNotEmpty) {
      pauseAuthStateListener = false;
      await signInWithGoogle();
      return null;
    }

    // Once signed in, return the UserCredential
    UserCredential uc =
        await FirebaseAuth.instance.signInWithCredential(credential);

    var fname = uc.additionalUserInfo!.profile!['given_name'];
    var lname = uc.additionalUserInfo!.profile!['family_name'];
    var email = uc.additionalUserInfo!.profile!['email'];
    var username = email.split('@')[0];

    try {
      // Check if username is taken
      isUsernameAvailable(username).then((value) {
        if (!value) {
          return FirebaseAuthException(
            code: "username-taken",
            message: "Username is already taken",
          );
        }
      });

      // Create auth account

      // Reload authUser
      authUser = FirebaseAuth.instance.currentUser;
      await authUser!.updateDisplayName("$fname $lname");

      // Add username to database
      final usernameRecord = <String, dynamic>{
        "uid": authUser!.uid,
      };

      await db.collection("usernames").doc(username).set(usernameRecord);

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

      pauseAuthStateListener = false;
      await getAuthUser();
      await getBlendUser();
      await getBlendCard(blendUser.workspaces![0].blendCard!);
      navigatorKey.currentState!.popUntil(ModalRoute.withName('/'));
      return null;
    } on FirebaseAuthException catch (e) {
      pauseAuthStateListener = false;
      return e;
    }
  }

  Future<bool> isUsernameAvailable(String username) async {
    final usernameRef = db.collection("usernames").doc(username);

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
    // sign out of google
    await GoogleSignIn().signOut();
    getAuthUser();
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    // Step 1: Get the user's blendUser document
    BlendUser? user = await getBlendUser();

    // Step 2: Loop through all of the user's workspaces
    for (var workspaceRef in user.workspaceRefs!) {
      // Step 3: Get the workspace document
      BlendWorkspace workspace = await getBlendWorkspace(workspaceRef);

      // Step 3: Delete the workspace's blendCard
      await workspace.blendCard!.delete();

      // Step 4: For each workspace, loop through the users
      for (var workspaceUserIndex in workspace.users!) {
        var workspaceUserObject = workspaceUserIndex as Map<String, dynamic>;

        // Step 5: For all users, get the user's blendUser document and remove
        // this workspace from it
        if (workspaceUserObject['role'] == "owner") {
          continue;
        } else {
          BlendUser workspaceUser =
              await getBlendUserByRef(workspaceUserObject['user']);
          await workspaceUser.removeWorkspace(workspaceRef);
        }
      }

      // Step 6: Delete the workspace
      await workspaceRef.delete();
    }

    // Step 7: Delete the user's username from the usernames table
    await db.collection("usernames").doc(user.username).delete();

    // Step 8: Delete the user's blendUser document
    await db.collection("users").doc(authUser!.uid).delete();

    // Step 9: Delete the user's auth account
    await authUser!.delete();

    // Step 10: Sign out
    signOut();

    this.authUser = null;
    this.blendUser = BlendUser();
    notifyListeners();
  }

  // ██████   ██████  ███████ ████████ ██ ███    ██  ██████
  // ██   ██ ██    ██ ██         ██    ██ ████   ██ ██
  // ██████  ██    ██ ███████    ██    ██ ██ ██  ██ ██   ███
  // ██      ██    ██      ██    ██    ██ ██  ██ ██ ██    ██
  // ██       ██████  ███████    ██    ██ ██   ████  ██████
  Set<PlatformSelection> selectedPlatforms = {};
  var postCaption = "";
  var defaultImagePath = "images/lime.png";
  File? compositeVideo;
  bool hasSelectedMedia =
      false; // i know its cheesy, but having issues checking if selectedMedia is null
  String selectedMediaURN = "";
  List<File> medias =
      []; // to be used in the futer if we are able to get multiple images working
  var client = http.Client();
  SelectedImagesDetails? mediaSelection;

  updateMediaSelection(SelectedImagesDetails? mediaSelection) async {
    this.mediaSelection = mediaSelection;
    notifyListeners();
  }

  postAll() async {
    // loop through selected platforms
    for (var platform in selectedPlatforms) {
      switch (platform.name) {
        case "Instagram":
          break;
        case "TikTok":
          break;
        case "Youtube":
          publishToYoutube();
          break;
        case "LinkedIn":
          if (hasSelectedMedia) {
            publishWithImagetoLinkedin(postCaption);
          } else {
            publishToLinkedin(postCaption);
          }
          break;
        case "Facebook":
          break;
        case "Snapchat":
          break;
        case "X":
          break;
        default:
          break;
      }
    }
    selectedPlatforms.clear();
  }

//  ██      ██ ███    ██ ██   ██ ███████ ██████  ██ ███    ██
//  ██      ██ ████   ██ ██  ██  ██      ██   ██ ██ ████   ██
//  ██      ██ ██ ██  ██ █████   █████   ██   ██ ██ ██ ██  ██
//  ██      ██ ██  ██ ██ ██  ██  ██      ██   ██ ██ ██  ██ ██
//  ███████ ██ ██   ████ ██   ██ ███████ ██████  ██ ██   ████

  publishToLinkedin(String message) async {
    var headers = {
      'LinkedIn-Version': '202401',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${dotenv.env['linkedin_api_token']}',
      'Cookie':
          'lidc="b=TB55:s=T:r=T:a=T:p=T:g=4081:u=27:x=1:i=1711720982:t=1711778521:v=2:sig=AQFHk_EgohwHNH45-qiIvk5hjzAGOcNk"; bcookie="v=2&9cb71389-ecec-4803-8d0b-1fa772424053"; lidc="b=VB35:s=V:r=V:a=V:p=V:g=3852:u=1:x=1:i=1711719625:t=1711806025:v=2:sig=AQGWDQb4TuZLTDClebTViudjfQju-mSx"'
    };
    var userId = await getLinkedInUserId();
    var request =
        http.Request('POST', Uri.parse('https://api.linkedin.com/rest/posts'));
    request.body = json.encode({
      "author": "urn:li:person:${userId}",
      "commentary": message,
      "visibility": "PUBLIC",
      "distribution": {
        "feedDistribution": "MAIN_FEED",
        "targetEntities": [],
        "thirdPartyDistributionChannels": []
      },
      "lifecycleState": "PUBLISHED",
      "isReshareDisabledByAuthor": false
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  publishWithImagetoLinkedin(String message) async {
    // make the upload request
    print("===Before publishing image===");
    await uploadImageToLinkedIn();
    print("===After publishing image===");

    var userId = await getUserId();
    // make post to linkedin with the posted image
    var headers = {
      'X-Restli-Protocol-Version': '2.0.0',
      'LinkedIn-Version': '202401',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${dotenv.env['linkedin_api_token']}',
      'Cookie': 'bcookie="v=2&9cb71389-ecec-4803-8d0b-1fa772424053"'
    };

    var postContent = (true)
        ? {
            "media": {
              "altText": "testing for alt tags",
              "id": selectedMediaURN,
            }
          }
        : {
            "multiImage": {
              "images": [
                // was images
                {
                  "id": selectedMediaURN,
                  "altText": "testing for alt tags1",
                },
                {
                  "id": selectedMediaURN,
                  "altText": "testing for alt tags2",
                },
              ]
            }
          };
    var request =
        http.Request('POST', Uri.parse('https://api.linkedin.com/rest/posts'));
    request.body = json.encode({
      "author": "urn:li:person:${userId}",
      "commentary": message,
      "visibility": "PUBLIC",
      "distribution": {
        "feedDistribution": "MAIN_FEED",
        "targetEntities": [],
        "thirdPartyDistributionChannels": []
      },
      "lifecycleState": "PUBLISHED",
      "isReshareDisabledByAuthor": false,
      "content": postContent
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> uploadImageToLinkedIn() async {
    String uploadURL = "";
    String imageURN = "";

    // make the upload request
    var userId = await getLinkedInUserId();

    var headers = {
      'X-Restli-Protocol-Version': '2.0.0',
      'LinkedIn-Version': '202401',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${dotenv.env['linkedin_api_token']}',
      'Cookie':
          'lidc="b=TB55:s=T:r=T:a=T:p=T:g=4150:u=31:x=1:i=1713043350:t=1713069108:v=2:sig=AQHT5KnjKxwxMo8B1gw0UOAM6cKYTD4d"; bcookie="v=2&9cb71389-ecec-4803-8d0b-1fa772424053"'
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://api.linkedin.com/rest/images?action=initializeUpload'));
    request.body = json.encode(
      {
        "initializeUploadRequest": {
          "owner": "urn:li:person:${userId}",
        },
      },
    );
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseBody);

      print(jsonResponse);
      uploadURL = jsonResponse["value"]["uploadUrl"];
      imageURN = jsonResponse["value"]["image"];
      print(uploadURL);
      print(imageURN);
      print("===upload request successful===");
    } else {
      print(response.reasonPhrase);
    }

    // upload the literal image after making the request
    List<int> imageBytes = await medias[0].readAsBytes();

    // Prepare request headers
    Map<String, String> uploadHeaders = {
      'Authorization': 'Bearer ${dotenv.env['linkedin_api_token']}',
      'Content-Type':
          'image/png', // Adjust content type based on your image format
    };

    // LinkedIn API endpoint for image upload

    // Send POST request
    try {
      http.Response response = await http.post(
        Uri.parse(uploadURL),
        headers: uploadHeaders,
        body: imageBytes,
      );

      print("TRYING TO UPLOAD IMAGE");
      // Check response status
      if (response.statusCode == 201) {
        print('Image uploaded successfully');
        selectedMediaURN = imageURN;
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<dynamic> getLinkedInUserInfo() async {
    // var url = Uri.parse(uri);
    // var headers = {
    //   'Authorization': 'Bearer sfie328370428387=',
    //   'api_key': 'ief873fj38uf38uf83u839898989',
    // };

    String endpoint =
        'https://api.linkedin.com/v2/me?projection=(id,localizedFirstName,localizedLastName)&oauth2_access_token=${dotenv.env['linkedin_api_token']}';

    var uri = Uri.parse(endpoint);

    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      String id = jsonResponse['id'];
      return id;
    } else {
      //throw exception and catch it in UI
      print("ERROR_NO_USER_ID");
    }
  }

  Future<dynamic> getLinkedInUserId() async {
    // var url = Uri.parse(uri);
    // var headers = {
    //   'Authorization': 'Bearer sfie328370428387=',
    //   'api_key': 'ief873fj38uf38uf83u839898989',
    // };

    String endpoint =
        'https://api.linkedin.com/v2/me?projection=(id,localizedFirstName,localizedLastName)&oauth2_access_token=${dotenv.env['linkedin_api_token']}';

    var uri = Uri.parse(endpoint);

    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      String id = jsonResponse['id'];
      return id;
    } else {
      //throw exception and catch it in UI
      print("ERROR_NO_USER_ID");
    }
  }

  Future<dynamic> getUserId() async {
    // var url = Uri.parse(uri);
    // var headers = {
    //   'Authorization': 'Bearer sfie328370428387=',
    //   'api_key': 'ief873fj38uf38uf83u839898989',
    // };

    String endpoint =
        'https://api.linkedin.com/v2/me?projection=(id,localizedFirstName,localizedLastName)&oauth2_access_token=${dotenv.env['linkedin_api_token']}';

    var uri = Uri.parse(endpoint);

    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      String id = jsonResponse['id'];
      return id;
    } else {
      //throw exception and catch it in UI
      print("ERROR_NO_USER_ID");
    }
  }

//  ██    ██  ██████  ██    ██ ████████ ██    ██ ██████  ███████
//   ██  ██  ██    ██ ██    ██    ██    ██    ██ ██   ██ ██
//    ████   ██    ██ ██    ██    ██    ██    ██ ██████  █████
//     ██    ██    ██ ██    ██    ██    ██    ██ ██   ██ ██
//     ██     ██████   ██████     ██     ██████  ██████  ███████

  /// Method to obtain the YouTube API object with the necessary permissions
  Future<YouTubeApi> getYoutubeApi() async {
    // Ensure user is signed in with Google
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: <String>[
        YouTubeApi.youtubeReadonlyScope,
        YouTubeApi.youtubeUploadScope,
      ],
    );
    await googleSignIn.signIn();

    // Get permission from user to access YouTube
    var httpClient = await googleSignIn.authenticatedClient();
    if (httpClient == null) {
      print("You didn't allow to proceed with YouTube access");
    }

    return YouTubeApi(httpClient!);
  }

  Future<File> copyVideoToLocal(String assetPath, String fileName) async {
    // Get the directory for the app's local storage
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    // Path for the destination file
    String filePath = '$appDocPath/$fileName';

    // Check if the file already exists
    bool fileExists = await File(filePath).exists();

    if (!fileExists) {
      // Load video file as a ByteData (binary data)
      ByteData data = await rootBundle.load(assetPath);

      // Write the data into the file
      await File(filePath).writeAsBytes(data.buffer.asUint8List());
    }

    // Return a File object for the copied video
    return File(filePath);
  }

  publishToYoutube() async {
    var youTubeApi = await getYoutubeApi();

    // get the file from assets/vid.mp4
    SelectedByte? composite = await generateCompositeVideo();
    File f = composite!.selectedFile;

    // check if file exists

    Stream<List<int>> stream = f.openRead();
    Media m = Media(stream, (await f.length()));
    Video video = Video(
      snippet: VideoSnippet(
        title: 'Video',
        description: 'Test Upload for Blend',
        categoryId: '22',
      ),
    );

    return await youTubeApi.videos.insert(
      video,
      ['snippet', 'status'],
      uploadMedia: m,
    );
  }

  Future<SelectedByte?> generateCompositeVideo() async {
    // Get the first media file from the mediaSelection
    final firstMedia = mediaSelection!.selectedFiles[0];

    SelectedByte? compositeVideo;

    // Check if the media is an image
    if (firstMedia.isThatImage) {
      // Create a video from the image
      compositeVideo = await createVideoFromImages([firstMedia.selectedByte]);
    } else {
      compositeVideo = firstMedia;
    }

    if (compositeVideo == null) {
      print("-------------------------->>>>>>>>> SUM TIN WONG");
    }

    // Loop through the remaining media files
    for (int i = 1; i < mediaSelection!.selectedFiles.length; i++) {
      final media = mediaSelection!.selectedFiles[i];

      // Check if the media is an image
      if (media.isThatImage) {
        // Create a video from the image
        final video = await createVideoFromImages([media.selectedByte]);

        // Check if the video was successfully created
        if (video != null) {
          // Merge the video with the composite video
          compositeVideo = await mergeRecordWithIntro(
            compositeVideo!.selectedFile.path,
            video.selectedFile.path,
          );
        }
      } else {
        // Merge the video with the composite video
        compositeVideo = await mergeRecordWithIntro(
          compositeVideo!.selectedFile.path,
          media.selectedFile.path,
        );
      }
    }

    return compositeVideo;
  }

  Future<SelectedByte?> createVideoFromImages(List<Uint8List> images) async {
    // Initialize video save location
    final tempDir = await getTemporaryDirectory();
    final videoPath =
        '${tempDir.path}/output_${DateTime.now().millisecondsSinceEpoch}.mp4';

    final imagePaths = <String>[];

    // Concatenate the images into a single memory location
    for (int i = 0; i < images.length; i++) {
      final extension =
          images[i][0] == 0xFF && images[i][1] == 0xD8 ? 'jpg' : 'png';
      final imagePath = '${tempDir.path}/image$i.$extension';
      await File(imagePath).writeAsBytes(images[i]);
      imagePaths.add(imagePath);
    }

    // Determine the total number of frames for each image to last three seconds
    final totalFrames = 8 * 3; // 8 fps * 3 seconds

    // Construct a list of input image files
    final inputImageFiles = '${tempDir.path}/image%d.*';

    // Configure the ffmpeg command
    final ffmpegCommand = [
      '-framerate',
      '8',
      '-pattern_type',
      'glob',
      '-i',
      inputImageFiles,
      '-c:v',
      'libx264',
      '-pix_fmt',
      'yuv420p',
      '-r',
      '8', // Output frame rate (fps)
      '-t',
      '${totalFrames ~/ 8}', // Total duration of each image in seconds
      videoPath,
    ];

    // Execute the ffmpeg command to convert the memory location into an mp4 file
    final session = await FFmpegKit.executeWithArguments(ffmpegCommand);

    // Check if the video was successfully created
    final logs = await session.getLogs();
    for (final log in logs) {
      print(log.getMessage());
    }

    // Return the newly created file, or null if there was an error
    if (ReturnCode.isSuccess(await session.getReturnCode())) {
      await Gal.putVideo(videoPath);
      print("Composite Video Saved to Gallery");
      return SelectedByte(
        isThatImage: false,
        selectedByte: await File(videoPath).readAsBytes(),
        selectedFile: File(videoPath),
      );
    } else {
      print('Error: Video creation failed');
      return null;
    }
  }

  Future<SelectedByte?> mergeRecordWithIntro(
      String outputPath, String videoPath) async {
    print("MergeVideoLoading");
    const filter =
        " [0:v]scale=480:640,setsar=1[l];[1:v]scale=480:640,setsar=1[r];[l][r]hstack;[0][1]amix -vsync 0 ";

    await FFmpegKit.execute(
            '-y -i $videoPath -i $videoPath -filter_complex $filter $outputPath')
        .then((value) async {
      final returnCode = await value.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        Gal.putVideo(outputPath);
        print("MergeVideoSucces");
        return SelectedByte(
          isThatImage: false,
          selectedByte: await File(outputPath).readAsBytes(),
          selectedFile: File(outputPath),
        );
      } else if (ReturnCode.isCancel(returnCode)) {
        print('MergeVideoError');
        return null;
      }
    });
  }

  // @override
  void dispose() {
    _authStateChanges.cancel();
    super.dispose();
  }
}

class NoGoogleAccountChosenException implements Exception {
  const NoGoogleAccountChosenException();
}
