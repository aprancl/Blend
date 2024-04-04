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
        [255, 1, 1, 1, ]
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

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            Container(
              margin: EdgeInsets.only(right: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Spacer(),
                  ElevatedButton(
                    child: Text('Next'),
                    onPressed: () {
                      print('We want to go next!');
                      provider.goToPage(7);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MediaSelectionButton extends StatefulWidget {
  final PlatformSelection platform;
  final Set<PlatformSelection> selectedPlatforms;

  MediaSelectionButton(this.platform, this.selectedPlatforms);

  @override
  _MediaSelectionButtonState createState() => _MediaSelectionButtonState();
}

class _MediaSelectionButtonState extends State<MediaSelectionButton> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isTapped = !_isTapped;
        });
        if (_isTapped) {
          widget.selectedPlatforms.add(widget.platform);
        } else {
          widget.selectedPlatforms.remove(widget.platform);
        }
        print(List.generate(widget.selectedPlatforms.length,
            (index) => widget.selectedPlatforms.elementAt(index).name));
      },
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            padding: EdgeInsets.only(left: 20.0, right: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              gradient: LinearGradient(
                colors: [
                  _isTapped
                      ? const Color(0xFF0055FF)
                      : Color.fromARGB(
                          widget.platform.colors[0][0],
                          widget.platform.colors[0][1],
                          widget.platform.colors[0][2],
                          widget.platform.colors[0][3],
                        ),
                  _isTapped
                      ? Color.fromARGB(255, 0, 217, 255)
                      : Color.fromARGB(
                          widget.platform.colors[1][0],
                          widget.platform.colors[1][1],
                          widget.platform.colors[1][2],
                          widget.platform.colors[1][3],
                        ),
                  _isTapped
                      ? Color.fromARGB(255, 0, 217, 255)
                      : Color.fromARGB(
                          widget.platform.colors[2][0],
                          widget.platform.colors[2][1],
                          widget.platform.colors[2][2],
                          widget.platform.colors[2][3],
                        ),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.5, 0.8, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: Icon(widget.platform.icon),
              title: Text(
                widget.platform.name,
                style: TextStyle(
                  color: _isTapped ? Colors.white : Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
