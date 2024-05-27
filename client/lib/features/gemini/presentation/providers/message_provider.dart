import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemini/features/gemini/presentation/widgets/msg_bubble.dart';

class MessageProvider extends StateNotifier<List<MsgBubble>> {
  MessageProvider(this.ref) : super([]);

  final Ref ref;
  @override
  List<MsgBubble> build() {
    return const [];
  }

  void addMessage(MsgBubble message) {
    state.add(message);
  }

  void deleteMessage() {
    if (state.isNotEmpty) {
      state.removeLast();
    }
  }
}

final MessageNotifierProvider =
    StateNotifierProvider<MessageProvider, List<MsgBubble>>((ref) {
  return MessageProvider(ref);
});
