import 'package:flutter/material.dart';
import 'package:gemini/core/constants/constant.dart';
import 'package:lottie/lottie.dart';

class Invite extends StatelessWidget {
  const Invite({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset("assets/lottie/gemini.json", height: 150),
        Text(
          'Hello! How can I help\n you today?',
          textAlign: TextAlign.center,
          style: KBody1.copyWith(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w100),
        )
      ],
    );
  }
}
