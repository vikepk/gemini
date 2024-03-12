import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gemini/features/authentication/login.dart';
import 'package:gemini/features/home/home.dart';
import 'package:gemini/main.dart';
import 'package:gemini/utils/notifymessage.dart';

String ip = "192.168.27.56";
//set your ip both mobile and lap connected to same network

class ApiService {
  final base_url = dotenv.env['BASE_URL'];
  final dio = Dio();
  Future<void> sign_in(BuildContext context, email, password) async {
    var data = jsonEncode({"email": email, "password": password});
    String url = "$base_url/users/signin";
    try {
      Response response = await dio.post(url,
          data: data,
          options: Options(headers: {"Content-Type": "application/json"}));
      if (response.statusCode == 200) {
        print(response.data);
        NotifyUserMessage().errMessage(context, response.data['message']);
        prefs.setString("token", response.data['token']);
        //storing token in phone storage
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => Home()));
      }
      if (response.statusCode == 400) {
        print(response.data);
        NotifyUserMessage().errMessage(context, response.data['message']);
      }
      if (response.statusCode == 500) {
        print(response.data);
        NotifyUserMessage().errMessage(context, response.data['message']);
      }
    } on DioException catch (e) {
      NotifyUserMessage().errMessage(context, e.response?.data['message']);
      print("Error $e");
    }
  }

  Future<void> sign_up(BuildContext context, String name, String email,
      String password, String phoneNumber) async {
    var data = jsonEncode({
      "name": name,
      "email": email,
      "phoneNumber": phoneNumber,
      "password": password
    });
    String url = "$base_url/users/signup";
    try {
      Response response = await dio.post(url, data: data);
      if (response.statusCode == 200) {
        print(response.data);
        NotifyUserMessage().errMessage(context, response.data['message']);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
      if (response.statusCode == 400) {
        print("Client Error${response.data}");
        NotifyUserMessage().errMessage(context, response.data['message']);
      }
    } on DioException catch (e) {
      NotifyUserMessage().errMessage(context, e.response?.data['message']);
      print("Error $e");
    }
  }
}
