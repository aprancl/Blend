import 'dart:io';

import 'package:blend/global_provider.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:card_swiper/card_swiper.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer({Key? key, required this.provider}) : super(key: key);

  // final File imageFile; // Change the type from String to XFile
  final GlobalProvider provider;

  @override
  Widget build(BuildContext context) {
    if (provider.mediaSelection != null) {
      // display carousel of images/videos from provider
      return Container(
        height: 400,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return Container(
                constraints:
                    BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
                child: Center(
                  child: !provider
                          .mediaSelection!.selectedFiles[index].isThatImage
                      ? _DisplayVideo(
                          selectedByte:
                              provider.mediaSelection!.selectedFiles[index],
                        )
                      : Container(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: List.generate(
                              provider.mediaSelection!.selectedFiles.length,
                              (idx) => Image.file(
                                provider.mediaSelection!.selectedFiles[idx]
                                    .selectedFile,
                                width: MediaQuery.of(context).size.width - 50,
                              ),
                            ),
                          ),
                        ),
                ),
              );
            },
            itemCount: provider.mediaSelection!.selectedFiles.length,
            scrollDirection: Axis.horizontal,
            physics: PageScrollPhysics(),
          ),
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Image.asset(
          provider.defaultImagePath,
        ),
      ); // You can replace this with any fallback widget or null widget.
    }
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
