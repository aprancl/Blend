import 'package:flutter/material.dart';

class PlatformSelection {
  
  // attribues belonging to instanted class
  final String name;
  final IconData icon;
  final List<List<int>> colors; // [ [a,r,g,b], ...]

  PlatformSelection(this.name, this.icon, this.colors);

  // STATICS 
  // character limites for making posts
  static const charLimitInstagram = 2200;
  static const charLimitTikTok = 4000;
  static const charLimitYoutube = 80;
  static const charLimitX = 280;
  static const charLimitFacebook = 63206;
  static const charLimitLinkedIn = 3000;

  // image resolution (px)
  static const ResLimitWidthInstagram = 1080;

  // Video Resolution (px)
  static const ResLimitWidthTokTok = 1080;
  static const ResLimitHeightTokTok = 1920;

  // Maximum number of media (media is photo AND video)
  static const maxMediaInstagram = 10;
  static const maxMedia = 10;



}
