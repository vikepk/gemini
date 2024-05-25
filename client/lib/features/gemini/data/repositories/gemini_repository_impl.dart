import 'package:dartz/dartz.dart';
import 'package:gemini/core/error/exception.dart';
import 'package:gemini/features/authentication/business/entities/user_entity.dart';
import 'package:gemini/features/gemini/business/repositories/gemini_repository.dart';
import 'package:gemini/features/gemini/data/datasources/gemini_remote_data_source.dart';
import 'package:gemini/features/gemini/data/models/qn_ans_model.dart';

import '../../../../core/error/failure.dart';

class GeminiRepositoryImpl implements GeminiRepository {
  final GeminiRemoteDataSource remoteDataSource;

  GeminiRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<QuestionItemModel>>> getQuestions(
      {required UserEntity user}) async {
    try {
      final result = await remoteDataSource.getQuestions(user: user);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure(errMsg: 'This is a server exception'));
    }
  }
}
