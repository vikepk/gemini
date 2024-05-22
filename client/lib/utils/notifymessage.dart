import 'package:flutter/material.dart';

//For small message to user
class NotifyUserMessage {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> loginSucess(
      BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    return notifyType(context, "Login Successful");
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> errMessage(
      BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    return notifyType(context, message);
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> notifyType(
      BuildContext context, String message) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Center(child: Text(message)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.grey,
        margin: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 6.0,
        duration: Duration(milliseconds: 1000)));
  }
}
