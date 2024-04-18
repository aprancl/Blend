import 'package:blend/global_provider.dart';
import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer({Key? key, required this.provider}) : super(key: key);

  // final File imageFile; // Change the type from String to XFile
  final GlobalProvider provider;

  @override
  Widget build(BuildContext context) {
    if (provider.medias.isNotEmpty) {
      return Image.file(
        provider.medias[0],
      );
    } else {
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
}
