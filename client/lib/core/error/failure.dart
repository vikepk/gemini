abstract class Failure {
  final String errMsg;
  const Failure({required this.errMsg});
}

class ServerFailure extends Failure {
  ServerFailure({required String errMsg}) : super(errMsg: errMsg);
}

class CacheFailure extends Failure {
  CacheFailure({required String errMsg}) : super(errMsg: errMsg);
}
