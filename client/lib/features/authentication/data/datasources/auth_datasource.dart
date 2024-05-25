import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gemini/core/constants/constant.dart';
import 'package:gemini/core/error/exception.dart';
import 'package:gemini/features/authentication/business/entities/user_entity.dart';
import 'package:gemini/features/authentication/data/model/user_model.dart';
import 'package:gemini/main.dart';

abstract class AuthRemoteDataSource {
  Future<String> signIn({required UserEntity user});
  Future<String> signUp({required UserEntity user});
}

class AuthRmoteDatasourceImpl extends AuthRemoteDataSource {
  final Dio dio;
  AuthRmoteDatasourceImpl({required this.dio});
  final _baseUrl = dotenv.env['BASE_URL'];
  @override
  Future<String> signIn({required UserEntity user}) async {
    var data = jsonEncode({"email": user.email, "password": user.password});
    String url = "$_baseUrl/users/signin";
    try {
      Response response = await dio.post(url,
          data: data,
          options: Options(headers: {"Content-Type": "application/json"}));
      if (response.statusCode == 200) {
        final Map result = response.data;
        await prefs.setString(ktoken, result[ktoken]);
        return result[kmessage];
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      throw Exception('Failed to Login \n ${e.response!.data[kmessage]}');
    }
  }

  @override
  Future<String> signUp({required UserEntity user}) async {
    var data = jsonEncode({
      "name": user.name,
      "email": user.email,
      "phoneNumber": user.phonenumber,
      "password": user.password
    });
    String url = "$_baseUrl/users/signup";
    try {
      Response response = await dio.post(url,
          data: data,
          options: Options(headers: {"Content-Type": "application/json"}));
      if (response.statusCode == 200) {
        final Map result = response.data;

        return result[kmessage];
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      throw Exception('Failed to Sign Up \n ${e.response!.data[kmessage]}');
    }
  }
}
