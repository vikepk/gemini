import 'package:flutter/material.dart';

Widget makeInput(
    {label,
    obscureText = false,
    TextEditingController? value,
    required String val_Msg}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      TextFormField(
        controller: value,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: val_Msg,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
              )),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter ' + val_Msg;
          }
          return null;
        },
      ),
      SizedBox(
        height: 30,
      ),
    ],
  );
}
