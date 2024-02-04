import 'package:flutter/material.dart';

class PostDataState extends ChangeNotifier {
  Set<String> selectedPlatforms = {}; // a list of strings, each denoting the platforms to post to
  var text = ""; // the text to go with the post
  var media = ""; // pointer to the media that they provide

  void showSelectedPlatforms() {
    print(selectedPlatforms);
    notifyListeners();

  }
  
}
