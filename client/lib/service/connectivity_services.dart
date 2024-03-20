import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Stream<bool> get connectionStream => _connectivity.onConnectivityChanged
      .map((result) => result != ConnectivityResult.none);
}
