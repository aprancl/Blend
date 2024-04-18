import 'package:flutter/material.dart';
import 'package:blend/models/platformSelection.dart';

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
