import 'package:dartz/dartz.dart';
import 'package:gemini/core/error/failure.dart';
import 'package:gemini/features/authentication/business/entities/user_entity.dart';
import 'package:gemini/features/gemini/business/entities/qn_ans_entity.dart';

abstract class GeminiRepository {
  Future<Either<Failure, List<QuestionItemEntity>>> getQuestions(
      {required UserEntity user});
}
