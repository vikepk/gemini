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
}
