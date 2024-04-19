import 'dart:io';

import 'package:blend/components/appBars/sequential_app_bar.dart';
import 'package:blend/components/posting/image_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:provider/provider.dart';
import 'package:blend/global_provider.dart';
import 'package:expandable_widgets/expandable_widgets.dart';

import 'package:video_player/video_player.dart';

class PostingOverviewPage extends StatefulWidget {
  @override
  State<PostingOverviewPage> createState() => _PostingOverviewPageState();
}

class _PostingOverviewPageState extends State<PostingOverviewPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GlobalProvider>(context);
    TextEditingController captionController = TextEditingController();

    return Scaffold(
      // ------------ AppBar ------------
      appBar: SequentialAppBar(
        leftFunction: () {
          print('Going back');
          provider.goToPage(4);
        },
        leftIcon: Icons.arrow_back,
        rightFunction: () async {
          provider.postCaption = captionController.text;

          print('Posting Content...');

          provider.postAll();

          print("Content Posted!");
          provider.hasSelectedMedia = false;
          provider.goToPage(1);
        },
        rightText: "Post",
      ).build(context),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ImageContainer(provider: provider),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Center(
                    // ------------ Main Content ------------
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ------------ Image Display ------------
                        // ElevatedButton(onPressed: () {
                        //   displayDetails(provider.mediaSelection!);
                        // }, child: Text("Display Images")),
                        // DisplayImages(details: provider.mediaSelection!, selectedBytes: provider.mediaSelection!.selectedFiles, aspectRatio: provider.mediaSelection!.aspectRatio),
                        // ------------ Caption ------------
                        TextField(
                          controller: captionController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                            labelText: "Add your caption here",
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(fontSize: 15.0),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // ------------ Platform Fields ------------
                        Center(
                          child: Text("Platform-Specfic Fields"),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Expandable(
                            backgroundColor: Color.fromARGB(255, 227, 15, 0),
                            firstChild: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text("YouTube"),
                            ),
                            secondChild: Text("world"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Expandable(
                            backgroundColor: Color.fromARGB(255, 21, 86, 225),
                            firstChild: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text("LinkedIn"),
                            ),
                            secondChild: Text("world"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
