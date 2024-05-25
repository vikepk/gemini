import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:gemini/features/gemini/business/entities/qn_ans_entity.dart';

import 'package:gemini/main.dart';
import 'package:gemini/utils/notifymessage.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

import '../features/authentication/presentation/pages/login.dart';
import '../features/gemini/presentation/pages/home.dart';

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
        // print(response.data);
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

  Future<List<QuestionItemEntity>> get_Question(String email) async {
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
        // print(response.data);
        List<dynamic> conversationJson = response.data['conversation'];
        // List<QuestionItemEntity> qns = conversationJson
        //     .map((json) => QuestionItemEntity.fromJson(json))
        //     .toList();
        // return qns;
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

  Future<AnswerEntity> text_Request(String email, String question) async {
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
        // AnswerEntity AnswerEntityJson = AnswerEntity.fromJson(response.data);

        // return AnswerEntityJson;
      }
      if (response.statusCode == 400) {
        print("Client Error${response.data}");
        return AnswerEntity();
      }
      if (response.statusCode == 401) {
        print("Client Error${response.data.toString()}");
        return AnswerEntity();
      }
    } on DioException catch (e) {
      print("Error ${e.response?.data}");
      return AnswerEntity();
    }
    return AnswerEntity();
  }

  Future<AnswerEntity> img_Request(
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
        // AnswerEntity AnswerJson = AnswerEntity.fromJson(response.data);

        // return AnswerJson;
      }
      if (response.statusCode == 400) {
        print("Client Error${response.data}");
        return AnswerEntity();
      }
      if (response.statusCode == 401) {
        print("Client Error${response.data.toString()}");
        return AnswerEntity();
      }
    } on DioException catch (e) {
      print("Error ${e.response?.data}");
      return AnswerEntity();
    }
    return AnswerEntity();
  }
}
