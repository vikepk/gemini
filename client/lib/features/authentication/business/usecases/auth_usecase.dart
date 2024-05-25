import 'package:dartz/dartz.dart';
import 'package:gemini/core/error/failure.dart';
import 'package:gemini/features/authentication/business/entities/user_entity.dart';
import 'package:gemini/features/authentication/business/repositories/auth_respository.dart';

class Auth {
  final AuthRespository respository;
  Auth({required this.respository});

  Future<Either<Failure, String>> signIn({required UserEntity user}) async {
    return await respository.signIn(user: user);
  }

  Future<Either<Failure, String>> signUp({required UserEntity user}) async {
    return await respository.signUp(user: user);
  }
}
