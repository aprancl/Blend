import "dart:io";

import "package:blend/components/appBars/sequential_app_bar.dart";
import "package:blend/global_provider.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:provider/provider.dart";
import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker_plus/src/gallery_display.dart';
import 'package:image_picker_plus/src/utilities/enum.dart';

class PostingMediaPage extends StatefulWidget {
  @override
  State<PostingMediaPage> createState() => _PostingMediaPageState();
}

class _PostingMediaPageState extends State<PostingMediaPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GlobalProvider>(context);

    Future<void> globalizeSelection(SelectedImagesDetails details) async {
      print("------- GLOBALIZED SELECTION -------");
      await provider.updateMediaSelection(details);
      print(provider.mediaSelection!.selectedFiles[0].selectedFile.path);
    }

    return Scaffold(
      body: CustomImagePicker(
        source: ImageSource.both,
        pickerSource: PickerSource.both,
        multiSelection: true,
        galleryDisplaySettings: GalleryDisplaySettings(
          cropImage: true,
          showImagePreview: true,
          appTheme: AppTheme(
            primaryColor: provider.theme.colorScheme.background,
            focusColor: Colors.white,
          ),
          callbackFunction: (value) => globalizeSelection(value),
        ),
        leftFunction: () {
          print('Going back');
          provider.goToPage(1);
        },
        rightFunction: () {
          print('Going to profile');
          provider.goToPage(5);
        },
        clearMediaFunction: () {
          print('Clearing media');
          provider.updateMediaSelection(null);
          provider.goToPage(5);
        },
        theme: provider.theme,
      ),
    );
  }

  // EVERYTHING BELOW THIS POINT IS FOR EXAMPLE ONLY. NONE OF IT IS ACTUALLY USED.
  // Anthony, if you see this, the below content may be useful for accessing the selected media.

  ElevatedButton preview3(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        ImagePickerPlus picker = ImagePickerPlus(context);
        SelectedImagesDetails? details = await picker.pickBoth(
          source: ImageSource.both,
          multiSelection: true,
          galleryDisplaySettings: GalleryDisplaySettings(
            cropImage: true,
            showImagePreview: true,
          ),
        );
        if (details != null) await displayDetails(details);
      },
      child: const Text("Preview 3"),
    );
  }

  Future<void> displayDetails(SelectedImagesDetails details) async {
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) {
          return DisplayImages(
              selectedBytes: details.selectedFiles,
              details: details,
              aspectRatio: details.aspectRatio);
        },
      ),
    );
  }
}

class DisplayImages extends StatefulWidget {
  final List<SelectedByte> selectedBytes;
  final double aspectRatio;
  final SelectedImagesDetails details;
  const DisplayImages({
    Key? key,
    required this.details,
    required this.selectedBytes,
    required this.aspectRatio,
  }) : super(key: key);

  @override
  State<DisplayImages> createState() => _DisplayImagesState();
}

class _DisplayImagesState extends State<DisplayImages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selected images/videos')),
      body: ListView.builder(
        itemBuilder: (context, index) {
          SelectedByte selectedByte = widget.selectedBytes[index];
          if (!selectedByte.isThatImage) {
            return _DisplayVideo(selectedByte: selectedByte);
          } else {
            return SizedBox(
              width: double.infinity,
              child: Image.file(selectedByte.selectedFile),
            );
          }
        },
        itemCount: widget.selectedBytes.length,
      ),
    );
  }
}

class _DisplayVideo extends StatefulWidget {
  final SelectedByte selectedByte;
  const _DisplayVideo({Key? key, required this.selectedByte}) : super(key: key);

  @override
  State<_DisplayVideo> createState() => _DisplayVideoState();
}

class _DisplayVideoState extends State<_DisplayVideo> {
  late VideoPlayerController controller;
  late Future<void> initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    File file = widget.selectedByte.selectedFile;
    controller = VideoPlayerController.file(file);
    initializeVideoPlayerFuture = controller.initialize();
    controller.setLooping(true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (controller.value.isPlaying) {
                        controller.pause();
                      } else {
                        controller.play();
                      }
                    });
                  },
                  child: Icon(
                    controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 45,
                  ),
                ),
              )
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 1),
          );
        }
      },
    );
  }
}
