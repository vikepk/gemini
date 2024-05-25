import 'dart:async';

import 'package:dio/dio.dart';
import 'package:gemini/features/authentication/business/entities/user_entity.dart';
import 'package:gemini/features/authentication/business/usecases/auth_usecase.dart';
import 'package:gemini/features/authentication/data/datasources/auth_datasource.dart';
import 'package:gemini/features/authentication/data/model/user_model.dart';
import 'package:gemini/features/authentication/data/repositories/auth_respository_impl.dart';
import 'package:riverpod/riverpod.dart';

class AuthController extends AsyncNotifier<String> {
  @override
  FutureOr<String> build() {
    return '';
  }

  Future<void> signIn(UserEntity user) async {
    state = const AsyncLoading();
    try {
      final repository = AuthRespositoryImpl(
        authRemoteDataSource: AuthRmoteDatasourceImpl(dio: Dio()),
      );
      final result = await Auth(respository: repository).signIn(user: user);

      state = result.fold(
        (failure) => AsyncValue.error(failure, StackTrace.current),
        (result) => AsyncValue.data(result),
      );
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }

  Future<void> signUp(UserEntity user) async {
    state = const AsyncLoading();
    try {
      final repository = AuthRespositoryImpl(
        authRemoteDataSource: AuthRmoteDatasourceImpl(dio: Dio()),
      );
      final result = await Auth(respository: repository).signUp(user: user);

      state = result.fold(
        (failure) => AsyncValue.error(failure, StackTrace.current),
        (result) => AsyncValue.data(result),
      );
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }
}

final AuthControllerProvider = AsyncNotifierProvider<AuthController, String>(
  () => AuthController(),
);

// final signInProvider =
//     FutureProvider.autoDispose.family<String, UserEntity>((ref, user) async {
//   final respository = AuthRespositoryImpl(
//       authRemoteDataSource: AuthRmoteDatasourceImpl(dio: Dio()));
//   final result = await Auth(respository: respository).signIn(user: user);

//   return result.fold((failure) => throw failure, (result) => result);
// });

// final signUpProvider =
//     FutureProvider.autoDispose.family<String, UserEntity>((ref, user) async {
//   final respository = AuthRespositoryImpl(
//       authRemoteDataSource: AuthRmoteDatasourceImpl(dio: Dio()));
//   final result = await Auth(respository: respository).signUp(user: user);

//   return result.fold((failure) => throw failure, (result) => result);
// });
