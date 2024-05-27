import 'package:dartz/dartz.dart';
import 'package:gemini/features/authentication/business/entities/user_entity.dart';
import 'package:gemini/features/gemini/business/entities/qn_ans_entity.dart';
import 'package:gemini/features/gemini/business/repositories/gemini_repository.dart';
import 'package:gemini/features/gemini/data/models/qn_ans_model.dart';
import '../../../../core/error/failure.dart';

class Gemini {
  final GeminiRepository geminiRepository;

  Gemini({required this.geminiRepository});

  Future<Either<Failure, List<QuestionItemEntity>>> getQuestions({
    required UserEntity user,
  }) async {
    return await geminiRepository.getQuestions(user: user);
  }

  Future<Either<Failure, AnswerEntity>> textReq(
      {required UserEntity user, required QuestionItemEntity qn}) async {
    return await geminiRepository.textReq(user: user, qn: qn);
  }

  Future<Either<Failure, AnswerEntity>> imgReq(
      {required UserEntity user,
      required QuestionItemEntity qn,
      required String imgPath}) async {
    return await geminiRepository.imgReq(user: user, qn: qn, imgPath: imgPath);
  }
}
