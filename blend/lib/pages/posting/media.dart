import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import './postingState.dart';

class PostingMediaPage extends StatelessWidget {
  XFile? image;

  Future pickImage() async {
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (img != null) {
        image = img;
        print('printing image: ${image!.path}');
      }
    } on Error catch (err) {
      debugPrint("Failed to find image: $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    // var appState = context.watch<PostDataState>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Hello world: Media'),
          ElevatedButton(
            child: Text('Add Media'),
            onPressed: () {
              pickImage();
            },
          ),
          if (image != null)
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Image.file(
                File(image!.path),
                height: 200.0, // Set the desired height
                width: 200.0, // Set the desired width
                fit: BoxFit.cover, // Adjust the fit as needed
              ),
            ),
        ],
      ),
    );
  }
}
