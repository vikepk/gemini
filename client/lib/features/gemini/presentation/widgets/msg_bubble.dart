import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gemini/core/constants/constant.dart';
import 'package:jumping_dot/jumping_dot.dart';

class MsgBubble extends StatelessWidget {
  late final text;
  late final user;
  bool isloading;
  bool isMe;
  String? imgpath;
  MsgBubble(
      {required this.text,
      required this.user,
      required this.isMe,
      required this.isloading,
      required this.imgpath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: !(isloading && !isMe)
          ? Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                imgpath!.isNotEmpty
                    ? Image(
                        filterQuality: FilterQuality.high,
                        height: AppQuery.ScreenHeight(context) * 0.18,
                        width: AppQuery.ScreenWidth(context) * 0.55,
                        image: FileImage(
                          File(imgpath!),
                        ),
                      )
                    : SizedBox(),
                Material(
                  elevation: 5,
                  borderRadius: isMe
                      ? BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.zero,
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50))
                      : BorderRadius.only(
                          topRight: Radius.circular(50),
                          topLeft: Radius.zero,
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50)),
                  color: isMe ? KGreen : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Text(
                      text,
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ),
                ),
                Text(
                  user,
                  style: KBody1.copyWith(color: KGreen),
                )
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Material(
                      elevation: 5,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.zero,
                          topRight: Radius.circular(50),
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50)),
                      color: isMe ? KGreen : Colors.white,
                      child: JumpingDots(
                        innerPadding: 5,
                        color: Colors.grey,
                        radius: 10,
                        numberOfDots: 3,
                      ),
                    ),
                    Text(user)
                  ],
                ),
              ],
            ),
    );
  }
}
