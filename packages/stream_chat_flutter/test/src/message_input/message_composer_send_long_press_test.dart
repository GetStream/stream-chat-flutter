import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'message_composer_harness.dart';

void main() {
  testWidgets('offers a long press for a new message', (tester) async {
    final controller = composerController()..text = 'Hello';

    await pumpTrailing(tester, controller: controller, onSendLongPress: () {});

    expect(sendButton(tester).props.onLongPress, isNotNull);
  });

  testWidgets('hints that a long press schedules a new message', (tester) async {
    final handle = tester.ensureSemantics();
    // Cleaned up in the test, as the handle is checked before teardown runs.
    try {
      final controller = composerController()..text = 'Hello';

      await pumpTrailing(tester, controller: controller, onSendLongPress: () {});

      expect(
        tester.getSemantics(find.byType(StreamButton)),
        containsSemantics(tooltip: 'Send message', hasLongPressAction: true, onLongPressHint: 'Schedule message'),
      );
    } finally {
      handle.dispose();
    }
  });

  testWidgets("doesn't hint at scheduling while editing", (tester) async {
    final handle = tester.ensureSemantics();
    // Cleaned up in the test, as the handle is checked before teardown runs.
    try {
      final controller = composerController()
        ..editMessage(
          Message(
            id: 'message-id',
            text: 'Hello',
            createdAt: DateTime.utc(2026, 10, 29),
          ),
        );

      await pumpTrailing(tester, controller: controller, onSendLongPress: () {});

      expect(
        tester.getSemantics(find.byType(StreamButton)),
        isNot(containsSemantics(onLongPressHint: 'Schedule message')),
      );
    } finally {
      handle.dispose();
    }
  });

  testWidgets("doesn't hint at scheduling when there is nothing to send", (tester) async {
    final handle = tester.ensureSemantics();
    // Cleaned up in the test, as the handle is checked before teardown runs.
    try {
      final controller = composerController();

      await pumpTrailing(tester, controller: controller, onSendLongPress: () {});

      expect(
        tester.getSemantics(find.byType(StreamButton)),
        isNot(containsSemantics(onLongPressHint: 'Schedule message')),
      );
    } finally {
      handle.dispose();
    }
  });

  testWidgets('offers no long press while editing', (tester) async {
    final controller = composerController()
      ..editMessage(
        Message(
          id: 'message-id',
          text: 'Hello',
          createdAt: DateTime.utc(2026, 10, 29),
        ),
      );

    await pumpTrailing(tester, controller: controller, onSendLongPress: () {});

    expect(sendButton(tester).props.onPressed, isNotNull);
    expect(sendButton(tester).props.onLongPress, isNull);
  });

  testWidgets('hands the controller to onSendLongPress', (tester) async {
    useFakeRecordPlatform();
    final controller = composerController();
    StreamMessageComposerController? longPressed;

    await pumpComposer(
      tester,
      composer: StreamMessageComposer(
        messageComposerController: controller,
        enableVoiceRecording: false,
        onSendLongPress: (context, controller) => longPressed = controller,
      ),
    );
    await tester.enterText(find.byType(EditableText), 'Hello');
    await tester.pump();
    await tester.longPress(find.byKey(const ValueKey('send_key')));
    await tester.pump();

    expect(longPressed, same(controller));
  });

  testWidgets("doesn't send the message on a long press", (tester) async {
    useFakeRecordPlatform();
    final controller = composerController();

    final channel = await pumpComposer(
      tester,
      composer: StreamMessageComposer(
        messageComposerController: controller,
        enableVoiceRecording: false,
        onSendLongPress: (context, controller) {},
      ),
    );
    await tester.enterText(find.byType(EditableText), 'Hello');
    await tester.pump();
    await tester.longPress(find.byKey(const ValueKey('send_key')));
    await tester.pump();

    expect(controller.text, 'Hello');
    verifyNever(() => channel.sendMessage(any()));
  });

  testWidgets('offers no long press without onSendLongPress, even when the channel allows scheduling', (tester) async {
    useFakeRecordPlatform();
    final controller = composerController();

    await pumpComposer(
      tester,
      channel: schedulingChannel(),
      composer: StreamMessageComposer(messageComposerController: controller, enableVoiceRecording: false),
    );
    await tester.enterText(find.byType(EditableText), 'Hello');
    await tester.pump();

    expect(sendButton(tester).props.onLongPress, isNull);
  });
}
