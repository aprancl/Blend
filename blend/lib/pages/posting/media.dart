import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import './postingState.dart';
import 'package:provider/provider.dart';


class PostingMediaPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    var appState = context.watch<PostDataState>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageContainer(imgPath: appState.mediaPath),
          ElevatedButton(
            child: Text('Add Media'),
            onPressed: () {
              appState.pickImage();
            },
          ),
        ],
      ),
    );
  }
}
class ImageContainer extends StatelessWidget {
  const ImageContainer({super.key, required this.imgPath});

  final String imgPath;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imgPath,
      width: 240,
      height: 240,
      fit: BoxFit.cover,
    );
  }
}