import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blend/global_provider.dart';
import 'package:image_picker/image_picker.dart';

class PostingMediaPage extends StatefulWidget {
  @override
  State<PostingMediaPage> createState() => _PostingMediaPageState();
}

class _PostingMediaPageState extends State<PostingMediaPage> {
  List<File> galleryImages = [];
  late GlobalProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<GlobalProvider>(context, listen: false);
    loadGalleryImages();
  }

  Future<void> loadGalleryImages() async {
    List<XFile>? images = await ImagePicker().pickMultiImage(
      maxWidth: 500,
      maxHeight: 500,
      imageQuality: 80,
    );

    if (images != null) {
      setState(() {
        galleryImages = images.map((image) => File(image.path)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Your existing widgets
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
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.only(top: 10, bottom: 30),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: galleryImages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: FileImage(galleryImages[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// class PostingMediaPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<GlobalProvider>(context);

//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ImageContainer(provider: provider),
//               ElevatedButton(
//                 child: Text('Add Media'),
//                 onPressed: () {
//                   provider.selectImage();
//                 },
//               ),
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: 15.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     ElevatedButton(
//                       child: Text('Back'),
//                       onPressed: () {
//                         print('We want to go back!');
//                         provider.goToPage(1);
//                       },
//                     ),
//                     Spacer(),
//                     ElevatedButton(
//                       child: Text('Next'),
//                       onPressed: () {
//                         print('We want to go next!');
//                         provider.goToPage(4);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(

//                 child: GridView.builder(
//                   padding: EdgeInsets.only(top: 10, bottom: 30, left: 10, right: 10),
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3,
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 10,
//                   ),
//                   itemCount: 12,
//                   itemBuilder: (BuildContext context, int index) {
//                     return Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         image: DecorationImage(
//                           image: AssetImage("images/lime.png"),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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
