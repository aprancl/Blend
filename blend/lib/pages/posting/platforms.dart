import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './postingState.dart';

class PostingPlatformsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<PostDataState>();
    // var cur_platforms = appState.platforms;

    return Center(
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
                color: Colors.white,
              ),
            ),
          ),
          Divider(
            color: Colors.white,
            thickness: 3.0,
            indent: 12.0,
            endIndent: 12.0,
          ),
          MediaSelectionButton(
            Icons.camera_alt_sharp,
            "Instagram",
            appState.selectedPlatforms
          ),
          MediaSelectionButton(
            Icons.music_note,
            "TikTok",
            appState.selectedPlatforms
          ),
          MediaSelectionButton(
            Icons.play_arrow_sharp,
            "Youtube",
            appState.selectedPlatforms
          ),
          MediaSelectionButton(
            Icons.snapchat_outlined,
            "Snapchat",
            appState.selectedPlatforms
          ),
          MediaSelectionButton(
            Icons.cancel_presentation_sharp,
            "X",
            appState.selectedPlatforms
          ),
          MediaSelectionButton(
            Icons.facebook,
            "Facebook",
            appState.selectedPlatforms
          ),
          MediaSelectionButton(
            Icons.language_sharp,
            "LinkedIn",
            appState.selectedPlatforms
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
                    appState.showSelectedPlatforms();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MediaSelectionButton extends StatelessWidget {
  final IconData buttonIcon;
  final String label;
  final Set<String> selectedPlatforms;

  MediaSelectionButton(this.buttonIcon, this.label, this.selectedPlatforms);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        selectedPlatforms.add(label);
        print(selectedPlatforms);
      },
      child: Column(
        children: <Widget>[
          Container(
            margin:
                EdgeInsets.only(bottom: 10.0), // Adjust the margin as needed
            padding: EdgeInsets.only(left: 20.0, right: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF3366FF),
                  const Color(0xFF00CCFF),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: ListTile(
              contentPadding:
                  EdgeInsets.all(0), // Remove default ListTile padding
              leading: Icon(buttonIcon),
              title: Text(label),
            ),
          ),
        ],
      ),
    );
  }
}
