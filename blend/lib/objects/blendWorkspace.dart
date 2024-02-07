import 'package:cloud_firestore/cloud_firestore.dart';

class BlendWorkspace {
  final String? name;
  final String? pfp;
  final Object? instagram;
  final Object? tiktok;
  final Object? youtube;
  final Object? snapchat;
  final Object? x;
  final Object? facebook;
  final Object? linkedin;
  final List<Object>? users;

  BlendWorkspace({
    this.name,
    this.pfp,
    this.instagram,
    this.tiktok,
    this.youtube,
    this.snapchat,
    this.x,
    this.facebook,
    this.linkedin,
    this.users,
  });

  factory BlendWorkspace.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return BlendWorkspace(
      name: data?['name'],
      pfp: data?['pfp'],
      instagram: data?['instagram'],
      tiktok: data?['tiktok'],
      youtube: data?['youtube'],
      snapchat: data?['snapchat'],
      x: data?['x'],
      facebook: data?['facebook'],
      linkedin: data?['linkedin'],
      users: data?['users'] is Iterable ? List.from(data?['users']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (pfp != null) "pfp": pfp,
      if (instagram != null) "instagram": instagram,
      if (tiktok != null) "tiktok": tiktok,
      if (youtube != null) "youtube": youtube,
      if (snapchat != null) "snapchat": snapchat,
      if (x != null) "x": x,
      if (facebook != null) "facebook": facebook,
      if (linkedin != null) "linkedin": linkedin,
      if (users != null) "users": users,
    };
  }
}
