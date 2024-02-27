import 'package:blend/models/blendCardPlatform.dart';
import 'package:blend/models/blendWorkspace.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BlendCard {
  String? background;
  String? bio;
  String? bottomColor;
  String? topColor;
  List<BlendCardPlatform>? platforms;

  BlendCard({
    this.background,
    this.bio,
    this.bottomColor,
    this.topColor,
    this.platforms,
  });

  factory BlendCard.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    var blendPlatforms = List<BlendCardPlatform>.from(
      data?['platforms']?.map(
        (platform) => BlendCardPlatform(
          title: platform['title'],
          type: platform['type'],
          url: platform['url'],
        ),
      ),
    );

    return BlendCard(
      background: data?['background'],
      bio: data?['bio'],
      bottomColor: data?['bottomColor'],
      topColor: data?['topColor'],
      platforms: blendPlatforms,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (background != null) "background": background,
      if (bio != null) "bio": bio,
      if (bottomColor != null) "bottomColor": bottomColor,
      if (topColor != null) "topColor": topColor,
      if (platforms != null) "platforms": platforms,
    };
  }
}
