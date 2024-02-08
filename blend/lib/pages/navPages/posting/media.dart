import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blend/global_provider.dart';
import 'package:image_picker/image_picker.dart';

class PostingMediaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GlobalProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ImageContainer(imgPath: provider.mediaFile.path),
              ImageContainer(provider: provider),
              ElevatedButton(
                child: Text('Add Media'),
                onPressed: () {
                  provider.selectImage();
                },
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      child: Text('Back'),
                      onPressed: () {
                        print('We want to go back!');
                        provider.goToPage(1);
                      },
                    ),
                    Spacer(),
                    ElevatedButton(
                      child: Text('Next'),
                      onPressed: () {
                        print('We want to go next!');
                        provider.goToPage(4);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ImageContainer extends StatelessWidget {
  const ImageContainer({Key? key, required this.provider}) : super(key: key);

  // final File imageFile; // Change the type from String to XFile
  final GlobalProvider provider;

  @override
  Widget build(BuildContext context) {
    return provider.selectedMedia != null
        ? Image.file(
            provider.selectedMedia!,
            width: 240,
            height: 240,
            fit: BoxFit.cover,
          )
        : Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Image.asset(
              provider.defaultImagePath,
            ),
          ); // You can replace this with any fallback widget or null widget.
  }
}
