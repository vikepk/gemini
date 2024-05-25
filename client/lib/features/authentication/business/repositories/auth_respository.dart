import 'package:gemini/core/error/failure.dart';
import 'package:gemini/features/authentication/business/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRespository {
  Future<Either<Failure, String>> signIn({required UserEntity user});
  Future<Either<Failure, String>> signUp({required UserEntity user});
}
