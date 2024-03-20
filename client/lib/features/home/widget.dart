import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gemini/features/home/model/question.model.dart';
import 'package:gemini/utils/constant.dart';

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
              // Container(
              //   width: 150,
              //   height: 50,
              //   padding: EdgeInsets.all(10),
              //   decoration: BoxDecoration(
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.black.withOpacity(0.5),
              //           spreadRadius: 1,
              //           blurRadius: 5,
              //           offset: Offset(1, 4),
              //         ),
              //       ],
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(30)),
              //   child: const Align(
              //     alignment: Alignment.centerLeft,
              //     child: Text(
              //       'New Request ->',
              //       style: KBody1,
              //     ),
              //   ),
              // ),
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
