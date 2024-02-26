import 'package:blend/components/misc/skewbox.dart';
import 'package:flutter/material.dart';

class BlendCardPage extends StatelessWidget {
  const BlendCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Method to convert string containing CSS rgba color to Color object
    Color cssToColor(String color) {
      String hex = color.split('(')[1].split(')')[0];
      List<String> rgba = hex.split(',');
      return Color.fromRGBO(
        int.parse(rgba[0]),
        int.parse(rgba[1]),
        int.parse(rgba[2]),
        double.parse(rgba[3]),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Blend Card'),
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SkewBox(
              topColor: cssToColor("rgba(21, 21, 106, 1)"),
              bottomColor: cssToColor("rgba(160, 220, 255, 0.5)"),
              height: (MediaQuery.of(context).size.width / 16) * 9,
              width: MediaQuery.of(context).size.width,
              image: "https://i.redd.it/1a0n0xeq13u91.jpg",
            ),
          ],
        ),
      ),
    );
  }
}