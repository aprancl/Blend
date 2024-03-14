import 'package:blend/models/blendWorkspace.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BlendUser {
  String? uid;
  String? fname;
  String? lname;
  String? email;
  String? username;
  String? pfp;
  String? theme;
  Map<String, dynamic>? customTheme;
  DocumentReference<Map<String, dynamic>>? personalWorkspaceRef;
  BlendWorkspace? personalWorkspace;
  List<DocumentReference<Map<String, dynamic>>>? workspaceRefs;
  List<BlendWorkspace>? workspaces;

  BlendUser({
    this.uid,
    this.fname,
    this.lname,
    this.email,
    this.username,
    this.pfp,
    this.theme,
    this.customTheme,
    this.personalWorkspaceRef,
    this.workspaceRefs,
  });

  factory BlendUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return BlendUser(
      uid: snapshot.id,
      fname: data?['fname'],
      lname: data?['lname'],
      email: data?['email'],
      username: data?['username'],
      pfp: data?['pfp'],
      theme: data?['theme'],
      customTheme: data?['customTheme'],
      personalWorkspaceRef: data?['personalWorkspace'],
      workspaceRefs:
          data?['workspaces'] is Iterable ? List.from(data?['workspaces']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (uid != null) "uid": uid,
      if (fname != null) "fname": fname,
      if (lname != null) "lname": lname,
      if (email != null) "email": email,
      if (username != null) "username": username,
      if (pfp != null) "pfp": pfp,
      if (theme != null) "theme": theme,
      if (customTheme != null) "customTheme": customTheme,
      if (personalWorkspaceRef != null) "personalWorkspace": personalWorkspaceRef,
      if (workspaceRefs != null) "workspaces": workspaceRefs,
    };
  }

  // method to remove a workspace from the user's list of workspaces on the firestore
  Future<void> removeWorkspace(DocumentReference<Map<String, dynamic>> workspaceRef) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final userDoc = await userRef.get();
    final user = BlendUser.fromFirestore(userDoc, null);
    final workspaces = user.workspaceRefs;
    workspaces?.remove(workspaceRef);
    await userRef.update({'workspaces': workspaces});
  }
}
