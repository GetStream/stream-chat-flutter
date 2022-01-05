import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

void main() {
  testWidgets(
    'should instantiate a new MessageInputController with empty message',
    (tester) async {
      final controller = MessageInputController()..text = 'test';

      expect(controller.text, 'test');
      expect(controller.message.text, 'test');
    },
  );
}
