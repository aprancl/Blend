import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class PostDataState extends ChangeNotifier {
  Set<String> selectedPlatforms = {}; // a list of strings, each denoting the platforms to post to
  var text = ""; // the text to go with the post
  var mediaPath = "images/lime.png"; // pointer to the media that they provide


  Future pickImage() async {
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (img != null) {
        mediaPath = img.path;
        notifyListeners();
      }
    } on Error catch (err) {
      debugPrint("Failed to find image: $err");
    }
  }
}
