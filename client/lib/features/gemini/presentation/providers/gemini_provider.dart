import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemini/features/authentication/business/entities/user_entity.dart';
import 'package:gemini/features/gemini/business/entities/qn_ans_entity.dart';
import 'package:gemini/features/gemini/business/usecases/gemini_usecase.dart';
import 'package:gemini/features/gemini/data/datasources/gemini_remote_data_source.dart';
import 'package:gemini/features/gemini/data/repositories/gemini_repository_impl.dart';

class GeminiQnController extends AsyncNotifier<List<QuestionItemEntity>> {
  @override
  FutureOr<List<QuestionItemEntity>> build() {
    return [];
  }

  Future<void> getQuestions({required UserEntity user}) async {
    state = const AsyncLoading();
    try {
      final respository = GeminiRepositoryImpl(
          remoteDataSource: GeminiRemoteDataSourceImpl(dio: Dio()));
      final result =
          await Gemini(geminiRepository: respository).getQuestions(user: user);
      state = result.fold(
        (failure) => AsyncValue.error(failure, StackTrace.current),
        (result) => AsyncValue.data(result),
      );
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }
}

final GeminiQnControllerProvider =
    AsyncNotifierProvider<GeminiQnController, List<QuestionItemEntity>>(
        GeminiQnController.new);

class GeminiAnsController extends AsyncNotifier<AnswerEntity> {
  @override
  AnswerEntity build() {
    return AnswerEntity(answer: '');
  }

  Future<void> textReq(
      {required UserEntity user, required QuestionItemEntity qn}) async {
    state = const AsyncLoading();
    try {
      final respository = GeminiRepositoryImpl(
          remoteDataSource: GeminiRemoteDataSourceImpl(dio: Dio()));
      final result = await Gemini(geminiRepository: respository)
          .textReq(user: user, qn: qn);
      state = result.fold(
        (failure) => AsyncValue.error(failure, StackTrace.current),
        (result) => AsyncValue.data(result),
      );
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }
}

final GeminiAnsControllerProvider =
    AsyncNotifierProvider<GeminiAnsController, AnswerEntity>(
        GeminiAnsController.new);

class GeminiImgController extends AsyncNotifier<AnswerEntity> {
  @override
  AnswerEntity build() {
    return AnswerEntity(answer: '');
  }

  Future<void> imgReq(
      {required UserEntity user,
      required QuestionItemEntity qn,
      required String imgPath}) async {
    state = const AsyncLoading();
    try {
      final respository = GeminiRepositoryImpl(
          remoteDataSource: GeminiRemoteDataSourceImpl(dio: Dio()));
      final result = await Gemini(geminiRepository: respository)
          .imgReq(user: user, qn: qn, imgPath: imgPath);
      state = result.fold(
        (failure) => AsyncValue.error(failure, StackTrace.current),
        (result) => AsyncValue.data(result),
      );
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }
}

final GeminiImgControllerProvider =
    AsyncNotifierProvider<GeminiImgController, AnswerEntity>(
        GeminiImgController.new);

final geminiQuestionsProvider = FutureProvider.autoDispose
    .family<List<QuestionItemEntity>, UserEntity>((ref, user) async {
  final respository = GeminiRepositoryImpl(
      remoteDataSource: GeminiRemoteDataSourceImpl(dio: Dio()));
  final result =
      await Gemini(geminiRepository: respository).getQuestions(user: user);

  return result.fold((failure) => throw failure, (result) {
    return result;
  });
});
