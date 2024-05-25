import 'package:flutter/material.dart';

Widget imageUpload(String text, onPress, IconData icon) {
  return GestureDetector(
    onTap: onPress,
    child: Column(
      children: [
        Icon(
          icon,
          size: 35,
        ),
        Text(text)
      ],
    ),
  );
}
