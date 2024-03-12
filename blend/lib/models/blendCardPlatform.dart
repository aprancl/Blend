import 'package:cloud_firestore/cloud_firestore.dart';

class BlendCardPlatform {
  String? title;
  String? type;
  String? url;

  BlendCardPlatform({
    this.title,
    this.type,
    this.url,
  });

  bool equals(BlendCardPlatform platform) {
    return platform.title == title && platform.type == type && platform.url == url;
  }

  // toMap function
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'type': type,
      'url': url,
    };
  }
}
