import 'package:blend/models/blendWorkspace.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BlendUser {
  String? id;
  String? fname;
  String? lname;
  String? email;
  String? username;
  String? pfp;
  String? theme;
  Object? customTheme;
  DocumentReference<Map<String, dynamic>>? personalWorkspaceRef;
  BlendWorkspace? personalWorkspace;
  List<DocumentReference<Map<String, dynamic>>>? workspaceRefs;
  List<BlendWorkspace>? workspaces;

  BlendUser({
    this.id,
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
      id: data?['id'],
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
      if (id != null) "id": id,
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
}
