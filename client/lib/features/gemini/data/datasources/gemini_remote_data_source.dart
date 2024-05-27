import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gemini/core/constants/constant.dart';
import 'package:gemini/core/error/exception.dart';
import 'package:gemini/features/authentication/business/entities/user_entity.dart';
import 'package:gemini/features/gemini/business/entities/qn_ans_entity.dart';
import 'package:gemini/features/gemini/data/models/qn_ans_model.dart';
import 'package:gemini/main.dart';
import 'package:path/path.dart' as path;

abstract class GeminiRemoteDataSource {
  Future<List<QuestionItemModel>> getQuestions({required UserEntity user});
  Future<AnswerEntity> textReq(
      {required UserEntity user, required QuestionItemEntity qn});
  Future<AnswerEntity> imgReq(
      {required UserEntity user,
      required QuestionItemEntity qn,
      required String imgPath});
}

class GeminiRemoteDataSourceImpl implements GeminiRemoteDataSource {
  final Dio dio;

  GeminiRemoteDataSourceImpl({required this.dio});
  final _baseUrl = dotenv.env['BASE_URL'];
  String? token = prefs.getString(ktoken);
  @override
  Future<List<QuestionItemModel>> getQuestions(
      {required UserEntity user}) async {
    var data = jsonEncode({kemail: user.email});
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

  @override
  Future<AnswerEntity> textReq(
      {required UserEntity user, required QuestionItemEntity qn}) async {
    var data = jsonEncode({kemail: user.email, kquestion: qn.question});
    String url = "$_baseUrl/gemini/textreq";
    try {
      final response = await dio.post(url,
          data: data,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": token
          }));

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = response.data;
        return AnswerModel.fromJson(result);
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      throw Exception('Failed get question \n ${e.response!.data[kmessage]}');
    }
  }

  @override
  Future<AnswerEntity> imgReq(
      {required UserEntity user,
      required QuestionItemEntity qn,
      required String imgPath}) async {
    Map<String, String> mimeTypes = {
      '.webp': 'image/webp',
      '.heic': 'image/heic',
      '.heif': 'image/heif',
      '.jpg': 'image/jpeg',
      '.jpeg': 'image/jpeg',
      '.png': 'image/png',
    };
    String extension = path.extension(imgPath);
    String? contentTypeString = mimeTypes[extension];
    var data = FormData.fromMap({
      "email": user.email,
      "prompt": qn.question,
      "image": await MultipartFile.fromFile(imgPath,
          filename: path.basename(imgPath),
          contentType: MediaType.parse(contentTypeString!))
    });
    String url = "$_baseUrl/gemini/fileupload";
    try {
      Response response = await dio.post(url,
          data: data,
          options: Options(headers: {
            'Content-Type': 'multipart/form-data',
            "Authorization": token
          }));
      if (response.statusCode == 200) {
        print(response.data);
        AnswerModel answer = AnswerModel.fromJson(response.data);

        return answer;
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      throw Exception('Failed get question \n ${e.response!.data[kmessage]}');
    }
  }
}
