import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

void main() {
  group('with the default validator', () {
    test('cannot send an empty message', () {
      final controller = _controller();

      expect(controller.canSend, isFalse);
    });

    test('cannot send text that is only whitespace', () {
      final controller = _controller()..text = '   ';

      expect(controller.canSend, isFalse);
    });

    test('can send a message with text', () {
      final controller = _controller()..text = 'Hello';

      expect(controller.canSend, isTrue);
    });

    test('can send a message with an attachment', () {
      final controller = _controller()..addAttachment(Attachment(type: AttachmentType.image));

      expect(controller.canSend, isTrue);
    });

    test('can send a message with a poll', () {
      final poll = Poll(
        name: 'Lunch?',
        options: const [PollOption(text: 'Pizza')],
      );
      final controller = _controller()..poll = poll;

      expect(controller.canSend, isTrue);
    });

    test('cannot send a reply that only quotes another message', () {
      final quoted = Message(id: 'quoted-message-id', text: 'Original');
      final controller = _controller()..quotedMessage = quoted;

      expect(controller.canSend, isFalse);
    });
  });

  test('follows a custom validator', () {
    final controller = _controller(validator: (message) => message.text == 'ok')..text = 'ok';

    expect(controller.canSend, isTrue);
  });

  test('restorable controller value uses the given validator', () {
    final restorable = StreamRestorableMessageComposerController(validator: (_) => true);

    final controller = restorable.createDefaultValue();
    addTearDown(controller.dispose);

    expect(controller.canSend, isTrue);
  });

  test('restorable controller value keeps the given validator after restoring a draft', () {
    final restorable = StreamRestorableMessageComposerController(validator: (_) => true);

    final controller = restorable.fromPrimitives(json.encode({'message': Message().toJson()}));
    addTearDown(controller.dispose);

    expect(controller.canSend, isTrue);
  });
}

StreamMessageComposerController _controller({
  MessageValidator validator = StreamMessageComposerController.defaultValidator,
}) {
  final controller = StreamMessageComposerController(validator: validator);
  addTearDown(controller.dispose);
  return controller;
}
