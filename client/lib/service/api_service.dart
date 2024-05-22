import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:gemini/features/authentication/login.dart';
import 'package:gemini/features/home/home.dart';
import 'package:gemini/features/home/model/answer_model.dart';
import 'package:gemini/features/home/model/question.model.dart';
import 'package:gemini/main.dart';
import 'package:gemini/utils/notifymessage.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

class ApiService {
  final base_Url = dotenv.env['BASE_URL'];

  final dio = Dio();

  String? token = prefs.getString('token');

  Future<void> sign_in(BuildContext context, email, password) async {
    var data = jsonEncode({"email": email, "password": password});
    String url = "$base_Url/users/signin";
    try {
      Response response = await dio.post(url,
          data: data,
          options: Options(headers: {"Content-Type": "application/json"}));
      if (response.statusCode == 200) {
        print(response.data);
        NotifyUserMessage().errMessage(context, response.data['message']);
        prefs.setString("token", response.data['token']);
        //storing token in phone storage
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    Home(token: prefs.getString('token')!)));
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
      print("Error ${e.response?.data}");
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
    String url = "$base_Url/users/signup";
    try {
      Response response = await dio.post(url,
          data: data,
          options: Options(headers: {"Content-Type": "application/json"}));
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
      print("Error ${e.response?.data}");
    }
  }

  Future<List<QuestionItem>> get_Question(String email) async {
    var data = jsonEncode({"email": email});
    print(data);
    String url = "$base_Url/gemini/getallqns";
    try {
      Response response = await dio.get(url,
          data: data,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": token
          }));
      if (response.statusCode == 200) {
        print(response.data);
        List<dynamic> conversationJson = response.data['conversation'];
        List<QuestionItem> qns = conversationJson
            .map((json) => QuestionItem.fromJson(json))
            .toList();
        return qns;
      }
      if (response.statusCode == 400) {
        print("Client Error${response.data}");
        return [];
      }
      if (response.statusCode == 401) {
        print("Client Error${response.data.toString()}");
        return [];
      }
    } on DioException catch (e) {
      print("Error ${e.response?.data}");
      return [];
    }
    return [];
  }

  Future<Answer> text_Request(String email, String question) async {
    var data = jsonEncode({"email": email, "question": question});

    String url = "$base_Url/gemini/textreq";
    try {
      Response response = await dio.post(url,
          data: data,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": token
          }));
      if (response.statusCode == 200) {
        print(response.data);
        Answer answerJson = Answer.fromJson(response.data);

        return answerJson;
      }
      if (response.statusCode == 400) {
        print("Client Error${response.data}");
        return Answer();
      }
      if (response.statusCode == 401) {
        print("Client Error${response.data.toString()}");
        return Answer();
      }
    } on DioException catch (e) {
      print("Error ${e.response?.data}");
      return Answer();
    }
    return Answer();
  }

  Future<Answer> img_Request(
      String email, String question, String imgpath) async {
    Map<String, String> mimeTypes = {
      '.webp': 'image/webp',
      '.heic': 'image/heic',
      '.heif': 'image/heif',
      '.jpg': 'image/jpeg',
      '.jpeg': 'image/jpeg',
      '.png': 'image/png',
    };
    String extension = path.extension(imgpath);
    String? contentTypeString = mimeTypes[extension];
    var data = FormData.fromMap({
      "email": email,
      "prompt": question,
      "image": await MultipartFile.fromFile(imgpath,
          filename: path.basename(imgpath),
          contentType: MediaType.parse(contentTypeString!))
    });
    print(data);
    print(path.basename(imgpath));

    String url = "$base_Url/gemini/fileupload";
    try {
      Response response = await dio.post(url,
          data: data,
          options: Options(headers: {
            'Content-Type': 'multipart/form-data',
            "Authorization": token
          }));
      if (response.statusCode == 200) {
        print(response.data);
        Answer answerJson = Answer.fromJson(response.data);

        return answerJson;
      }
      if (response.statusCode == 400) {
        print("Client Error${response.data}");
        return Answer();
      }
      if (response.statusCode == 401) {
        print("Client Error${response.data.toString()}");
        return Answer();
      }
    } on DioException catch (e) {
      print("Error ${e.response?.data}");
      return Answer();
    }
    return Answer();
  }
}
