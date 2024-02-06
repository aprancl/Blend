import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blend/global_provider.dart';


class PostingMediaPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GlobalProvider>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageContainer(imgPath: provider.postMediaPath),
          ElevatedButton(
            child: Text('Add Media'),
            onPressed: () {
              provider.selectImage();
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