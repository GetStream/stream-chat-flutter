import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';
import 'message_composer_harness.dart';

void main() {
  // Verifies [channel] was asked to send or update nothing.
  void verifyNothingSent(MockChannel channel) {
    verifyNever(() => channel.sendMessage(any(), skipEnrichUrl: any(named: 'skipEnrichUrl')));
    verifyNever(() => channel.updateMessage(any(), skipEnrichUrl: any(named: 'skipEnrichUrl')));
  }

  testWidgets('hands the controller to onSendMessage instead of sending when send is tapped', (tester) async {
    useFakeRecordPlatform();
    final controller = composerController();
    StreamMessageComposerController? sent;

    final channel = await pumpComposer(
      tester,
      composer: StreamMessageComposer(
        messageComposerController: controller,
        enableVoiceRecording: false,
        onSendMessage: (context, controller) => sent = controller,
      ),
    );
    await tester.enterText(find.byType(EditableText), 'Hello');
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('send_key')));
    await tester.pump();

    expect(sent, same(controller));
    verifyNothingSent(channel);
  });

  testWidgets('leaves the composer as it is when onSendMessage is set', (tester) async {
    useFakeRecordPlatform();
    final controller = composerController();

    await pumpComposer(
      tester,
      composer: StreamMessageComposer(
        messageComposerController: controller,
        enableVoiceRecording: false,
        onSendMessage: (_, _) {},
      ),
    );
    await tester.enterText(find.byType(EditableText), 'Hello');
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('send_key')));
    await tester.pump();

    expect(controller.text, 'Hello');
  });

  testWidgets('calls onSendMessage instead of sending on the send key', (tester) async {
    useFakeRecordPlatform();
    final controller = composerController();
    var sends = 0;

    final channel = await pumpComposer(
      tester,
      composer: StreamMessageComposer(
        messageComposerController: controller,
        enableVoiceRecording: false,
        sendMessageKeyPredicate: (_, event) => event.logicalKey == LogicalKeyboardKey.enter && event is KeyDownEvent,
        onSendMessage: (_, _) => sends += 1,
      ),
    );
    await tester.enterText(find.byType(EditableText), 'Hello');
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(sends, 1);
    verifyNothingSent(channel);
  });

  testWidgets('calls onSendMessage instead of updating when an edit is saved', (tester) async {
    useFakeRecordPlatform();
    final edited = Message(
      id: 'message-id',
      text: 'Hello',
      createdAt: DateTime.utc(2026, 10, 29),
    );
    final controller = composerController()..editMessage(edited);
    StreamMessageComposerController? saved;

    final channel = await pumpComposer(
      tester,
      composer: StreamMessageComposer(
        messageComposerController: controller,
        enableVoiceRecording: false,
        onSendMessage: (context, controller) => saved = controller,
      ),
    );
    await tester.tap(find.byKey(const ValueKey('send_key')));
    await tester.pump();

    expect(saved, same(controller));
    expect(saved?.isEditing, isTrue);
    verifyNothingSent(channel);
  });

  testWidgets("doesn't call onSendMessage while the message can't be sent", (tester) async {
    useFakeRecordPlatform();
    var sends = 0;

    await pumpComposer(
      tester,
      composer: StreamMessageComposer(
        messageComposerController: composerController(),
        enableVoiceRecording: false,
        onSendMessage: (_, _) => sends += 1,
      ),
    );
    await tester.tap(find.byKey(const ValueKey('send_key')), warnIfMissed: false);
    await tester.pump();

    expect(sends, 0);
  });

  testWidgets("doesn't call onSendMessage while slow mode is active", (tester) async {
    useFakeRecordPlatform();
    final controller = composerController();
    var sends = 0;

    await pumpComposer(
      tester,
      composer: StreamMessageComposer(
        messageComposerController: controller,
        enableVoiceRecording: false,
        onSendMessage: (_, _) => sends += 1,
      ),
    );
    await tester.enterText(find.byType(EditableText), 'Hello');
    controller.startCooldown(10);
    // Cleaned up in the test, as the timer is checked before teardown runs.
    try {
      await tester.pump();
      final composer = tester.state<DefaultStreamMessageComposerState>(find.byType(DefaultStreamMessageComposer));
      await composer.sendMessage();

      expect(sends, 0);
    } finally {
      controller.cancelCooldown();
    }
  });
}
