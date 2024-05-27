import 'package:flutter/material.dart';

const Color KGreen = Colors.greenAccent;

const Color KBlack = Colors.black;

const Color KWhite = Colors.white;

const Color KBackground = Color.fromARGB(30, 132, 132, 132);

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

const String kname = 'name';
const String kemail = 'email';
const String kphnumber = 'phoneNumber';
const String kpassword = 'password';
const String kmessage = 'message';
const String ktoken = 'token';
const String kconversation = 'conversation';
const String kid = '_id';
const String kquestion = 'question';
const String kanswer = 'answer';
