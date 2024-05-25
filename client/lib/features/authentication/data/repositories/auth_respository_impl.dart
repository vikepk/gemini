import 'package:dartz/dartz.dart';
import 'package:gemini/core/error/exception.dart';
import 'package:gemini/core/error/failure.dart';
import 'package:gemini/features/authentication/business/entities/user_entity.dart';
import 'package:gemini/features/authentication/business/repositories/auth_respository.dart';
import 'package:gemini/features/authentication/data/datasources/auth_datasource.dart';
import 'package:gemini/features/authentication/data/model/user_model.dart';

class AuthRespositoryImpl extends AuthRespository {
  final AuthRmoteDatasourceImpl authRemoteDataSource;

  AuthRespositoryImpl({required this.authRemoteDataSource});

  @override
  Future<Either<Failure, String>> signIn({required UserEntity user}) async {
    try {
      final result = await authRemoteDataSource.signIn(user: user);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure(errMsg: 'This is Server Exception'));
    }
  }

  @override
  Future<Either<Failure, String>> signUp({required UserEntity user}) async {
    try {
      final result = await authRemoteDataSource.signUp(user: user);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure(errMsg: 'This is Server Exception'));
    }
  }
}
