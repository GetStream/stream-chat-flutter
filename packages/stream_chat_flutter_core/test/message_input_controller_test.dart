import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

void main() {
  testWidgets(
    'should instantiate a new MessageInputController with default validator'
    ' and empty message',
    (tester) async {
      final controller = MessageInputController();

      expect(controller.isValid, false);
      controller.text = 'test';
      expect(controller.isValid, true);
    },
  );

  testWidgets(
    'should instantiate a new MessageInputController with default validator'
    ' and specified message',
    (tester) async {
      final message = Message(text: 'test');
      final controller = MessageInputController(
        message: message,
      );

      expect(controller.message, message);
      expect(controller.isValid, true);
    },
  );
}
