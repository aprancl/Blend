// This is NOT our code - we found it on the internet and modified it to fit our needs
// Original code: https://stackoverflow.com/questions/62996469/diagonal-design-of-a-container

import 'package:flutter/material.dart';

class SkewBox extends StatelessWidget {
  final Color topColor;
  final Color bottomColor;
  final double height;
  final double width;
  final String image;
  const SkewBox({
    super.key,
    this.topColor = const Color.fromRGBO(255, 149, 56, 1),
    this.bottomColor = const Color.fromRGBO(114, 203, 255, 0.5),
    this.height = 250,
    this.width = 400,
    this.image =
        "https://images.pexels.com/photos/15334615/pexels-photo-15334615.jpeg",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Image.network(image).image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          ClipPath(
            clipper: CustomClipPath(height: height, width: width),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    topColor,
                    bottomColor,
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  final double height;
  final double width;
  CustomClipPath({this.height = 250, this.width = 400});

  var radius = 10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, height);
    path.lineTo(((width / 2) - 30), height);
    path.lineTo(((width / 2) + 30), 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
