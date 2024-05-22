import 'package:flutter/material.dart';

const Color KGreen = Colors.greenAccent;

const TextStyle KTitle1 = TextStyle(fontSize: 24, fontWeight: FontWeight.w600);

const TextStyle KTitle2 = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);

const TextStyle KBody1 = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);

class AppQuery {
  static double ScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double ScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
