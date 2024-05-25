import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingStateNotifier extends StateNotifier<bool> {
  LoadingStateNotifier() : super(false);

  // Method to set the loading state to true
  void startLoading() {
    state = true;
  }

  // Method to set the loading state to false
  void stopLoading() {
    state = false;
  }
}

// Provider for LoadingStateNotifier
final loadingStateProvider = StateNotifierProvider<LoadingStateNotifier, bool>(
  (ref) => LoadingStateNotifier(),
);
