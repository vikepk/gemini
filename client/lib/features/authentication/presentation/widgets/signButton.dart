import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/constant.dart';

Widget signButton({required String text, required Function callback}) {
  return FadeInUp(
    duration: const Duration(milliseconds: 1400),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        padding: const EdgeInsets.only(top: 3, left: 3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: const Border(
              bottom: BorderSide(color: Colors.black),
              top: BorderSide(color: Colors.black),
              left: BorderSide(color: Colors.black),
              right: BorderSide(color: Colors.black),
            )),
        child: MaterialButton(
          minWidth: double.infinity,
          height: 60,
          onPressed: callback(),
          color: KGreen,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
        ),
      ),
    ),
  );
}
