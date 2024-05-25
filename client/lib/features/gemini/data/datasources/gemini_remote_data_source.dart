import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gemini/core/constants/constant.dart';
import 'package:gemini/core/error/exception.dart';
import 'package:gemini/features/authentication/business/entities/user_entity.dart';
import 'package:gemini/features/gemini/data/models/qn_ans_model.dart';
import 'package:gemini/main.dart';

abstract class GeminiRemoteDataSource {
  Future<List<QuestionItemModel>> getQuestions({required UserEntity user});
}

class GeminiRemoteDataSourceImpl implements GeminiRemoteDataSource {
  final Dio dio;

  GeminiRemoteDataSourceImpl({required this.dio});
  final _baseUrl = dotenv.env['BASE_URL'];
  String? token = prefs.getString(ktoken);
  @override
  Future<List<QuestionItemModel>> getQuestions(
      {required UserEntity user}) async {
    var data = jsonEncode({"email": user.email});
    String url = "$_baseUrl/gemini/getallqns";
    try {
      final response = await dio.get(url,
          data: data,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": token
          }));

      if (response.statusCode == 200) {
        final List result = response.data[kconversation];
        return result.map((e) => QuestionItemModel.fromJson(e)).toList();
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      throw Exception('Failed get question \n ${e.response!.data[kmessage]}');
    }
  }
}
