import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gemini/features/home/model/question.model.dart';
import 'package:gemini/utils/constant.dart';
import 'package:jumping_dot/jumping_dot.dart';

Widget HomeDrawer(
    Future<List<QuestionItem>> qns, context, String user_name, String email) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: const BoxDecoration(
            color: Colors.green,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Chats",
                  style: KTitle1,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Image.asset("assets/images/profile.png"),
                    radius: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$user_name",
                        style: KTitle2,
                      ),
                      Text(
                        "$email",
                        style: KBody1,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        FutureBuilder(
          future: qns,
          builder: (ctx, snapshot) {
            // Checking if future is resolved or not
            if (snapshot.connectionState == ConnectionState.done) {
              // If we got an error
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Oops!',
                    style: KTitle2,
                  ),
                );
              } else if (snapshot.hasData) {
                // Extracting data from snapshot object
                List<QuestionItem> qns = snapshot.data!;

                if (qns.isEmpty) {
                  return Center(
                    child: Text("Oops!", style: KBody1),
                  );
                } else {
                  return buildQn(context, qns);
                }
              } else {
                // Displaying LoadingSpinner to indicate waiting state
                return const Center(
                  child: CircularProgressIndicator(
                    color: KGreen,
                  ),
                );
              }
            }
            // If the connection state is not done, return a placeholder or loading state.
            return const Center(
              child: CircularProgressIndicator(
                color: KGreen,
              ),
            );
          },
        ),
      ],
    ),
  );
}

Widget buildQn(BuildContext context, List<QuestionItem> qns) {
  return Column(
    children: qns.map((qn) {
      return ListTile(
        title: Text(qn.question),
        onTap: () {
          Navigator.pop(context);
          // Do something with the tapped item
        },
      );
    }).toList(),
  );
}

class MsgBubble extends StatelessWidget {
  late final text;
  late final user;
  bool isMe;
  MsgBubble({required this.text, required this.user, required this.isMe}) {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
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
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                text,
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
          ),
          Text(user),
          JumpingDots(
            color: Colors.grey,
            radius: 10,
            numberOfDots: 3,
          ),
        ],
      ),
    );
  }
}
