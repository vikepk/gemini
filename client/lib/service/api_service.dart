import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gemini/features/authentication/login.dart';
import 'package:gemini/main.dart';
import 'package:gemini/utils/notifymessage.dart';

String ip = "192.168.140.56";
//set your ip both mobile and lap connected to same network

class ApiService {
  Future<void> sign_in(String email, String password) async {
    var data = jsonEncode({"email": email, "password": password});
    String url = "http://$ip:3000/api/v1/users/signin";
    try {
      Response response = await Dio().post(url, data: data);
      if (response.statusCode == 200) {
        print(response.data);
        prefs.setString("token", response.data['token']);
        //storing token in phone storage
      } else if (response.statusCode == 400) {
        print(response.data);
      } else if (response.statusCode == 500) {
        print(response.data);
      } else {
        throw Error();
      }
    } catch (e) {
      print("Error $e");
    }
  }

  Future<void> sign_up(context, String name, String email, String password,
      String phoneNumber) async {
    var data = jsonEncode({
      "name": name,
      "email": email,
      "phoneNumber": phoneNumber,
      "password": password
    });
    String url = "http://$ip:3000/api/v1/users/signup";
    try {
      Response response = await Dio().post(url, data: data);
      if (response.statusCode == 200) {
        print(response.data);
        NotifyUserMessage().errMessage(context, response.data);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } else if (response.statusCode == 404) {
        print("Client Error${response.data}");
        NotifyUserMessage().errMessage(context, response.data);
      } else if (response.statusCode == 500) {
        print(response.data);
      } else {
        throw Error();
      }
    } catch (e) {
      print("Error $e");
    }
  }
}
