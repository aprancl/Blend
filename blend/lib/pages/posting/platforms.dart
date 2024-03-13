import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blend/global_provider.dart';
import 'package:blend/models/platformSelection.dart';

class PostingPlatformsPage extends StatelessWidget {
  var platforms = <PlatformSelection>[
    PlatformSelection("Instagram", Icons.camera_alt_sharp),
    PlatformSelection("TikTok", Icons.music_note),
    PlatformSelection("Youtube", Icons.play_arrow_sharp),
    PlatformSelection("Snapchat", Icons.snapchat),
    PlatformSelection("X", Icons.cancel_presentation),
    PlatformSelection("Facebook", Icons.facebook),
    PlatformSelection("LinkedIn", Icons.language_sharp),
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
                      provider.goToPage(5);
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
        print(List.generate(widget.selectedPlatforms.length, (index) => widget.selectedPlatforms.elementAt(index).name));
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
                      : const Color(0xFF3366FF),
                  _isTapped
                      ? const Color(0xFF00D7FF)
                      : const Color(0xFF00CCFF),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: Icon(widget.platform.icon),
              title: Text(
                widget.platform.name,
                style: TextStyle(
                  color: _isTapped ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
