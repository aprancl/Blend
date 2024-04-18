import 'package:blend/components/appBars/sequential_app_bar.dart';
import 'package:blend/components/posting/media_selection_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blend/global_provider.dart';
import 'package:blend/models/platformSelection.dart';

class PostingPlatformsPage extends StatelessWidget {
  var platforms = <PlatformSelection>[
    PlatformSelection(
      "Instagram",
      Icons.camera_alt_sharp,
      [
        [255, 252, 175, 69],
        [255, 233, 54, 192],
        [255, 193, 53, 132],
      ],
    ),
    PlatformSelection(
      "TikTok",
      Icons.music_note,
      [
        [255, 11, 11, 11],
        [255, 232, 51, 89],
        [255, 56, 110, 181],
      ],
    ),
    PlatformSelection(
      "Youtube",
      Icons.play_arrow_sharp,
      [
        [255, 234, 51, 36],
        [255, 253, 253, 253],
        [255, 234, 51, 36],
      ],
    ),
    PlatformSelection(
      "Snapchat",
      Icons.snapchat,
      [
        [255, 255, 252, 0],
        [255, 253, 253, 253],
        [255, 255, 252, 0],
      ],
    ),
    PlatformSelection(
      "X",
      Icons.cancel_presentation,
      [
        [255, 1, 1, 1],
        [255, 255, 255, 255],
        [
          255,
          1,
          1,
          1,
        ]
      ],
    ),
    PlatformSelection(
      "Facebook",
      Icons.facebook,
      [
        [255, 74, 97, 173],
        [255, 255, 255, 255],
        [255, 74, 97, 173],
      ],
    ),
    PlatformSelection(
      "LinkedIn",
      Icons.language_sharp,
      [
        [255, 66, 107, 246],
        [255, 255, 255, 255],
        [255, 66, 107, 246],
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GlobalProvider>(context);

    return Scaffold(
      appBar: SequentialAppBar(
        leftFunction: () {
          print('Going back');
          provider.goToNavPage(0);
        },
        leftIcon: Icons.close,
        rightFunction: () {
          print('Going to profile');
          provider.goToPage(4);
        },
        rightText: "Next",
      ).build(context),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 40, bottom: 0),
          // ------------ Main Content ------------
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Title(
                color: Color(0xFFFFFFFF),
                child: Text(
                  "Choose Platforms",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
              Divider(
                color: Color.fromARGB(255, 255, 255, 255),
                thickness: 3.0,
                indent: 12.0,
                endIndent: 12.0,
              ),
              SizedBox(height: 20),
              // ------------ Platform List ------------
              Column(
                children: List.generate(
                  platforms.length,
                  (index) {
                    return MediaSelectionButton(
                      platforms[index],
                      provider.selectedPlatforms,
                    );
                  },
                ),
              ),
              // adding a button group
            ],
          ),
        ),
      ),
    );
  }
}
