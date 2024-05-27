import 'package:dartz/dartz.dart';
import 'package:gemini/core/error/failure.dart';
import 'package:gemini/features/authentication/business/entities/user_entity.dart';
import 'package:gemini/features/gemini/business/entities/qn_ans_entity.dart';

abstract class GeminiRepository {
  Future<Either<Failure, List<QuestionItemEntity>>> getQuestions(
      {required UserEntity user});
  Future<Either<Failure, AnswerEntity>> textReq(
      {required UserEntity user, required QuestionItemEntity qn});
  Future<Either<Failure, AnswerEntity>> imgReq(
      {required UserEntity user,
      required QuestionItemEntity qn,
      required String imgPath});
}
