import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:gemini/core/constants/constant.dart';

class VoiceButton extends StatelessWidget {
  bool isloading;
  final callback;
  VoiceButton({required this.isloading, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(50)),
      child: AvatarGlow(
        animate: isloading,
        glowColor: KGreen,
        glowShape: BoxShape.rectangle,
        glowBorderRadius: BorderRadius.circular(25),
        duration: Duration(milliseconds: 1000),
        glowRadiusFactor: 1,
        repeat: true,
        child: IconButton(
          icon: Icon(
            isloading ? Icons.mic : Icons.mic_none,
          ),
          onPressed: callback,
        ),
      ),
    );
  }
}

class BottomButton extends StatelessWidget {
  final callback;
  IconData iconData;
  BottomButton({required this.callback, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Colors.white,
      icon: Icon(iconData),
      iconSize: 30,
      onPressed: callback,
    );
  }
}
