import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'message_composer_harness.dart';

void main() {
  testWidgets('disables send for an empty message when there is no microphone', (tester) async {
    final controller = composerController();

    await pumpTrailing(tester, controller: controller);

    expect(sendButton(tester).props.onPressed, isNull);
  });

  testWidgets('enables send for a message with text', (tester) async {
    final controller = composerController()..text = 'Hello';

    await pumpTrailing(tester, controller: controller);

    expect(sendButton(tester).props.onPressed, isNotNull);
  });

  testWidgets('shows send instead of the microphone for a staged poll', (tester) async {
    final controller = composerController()
      ..poll = Poll(
        name: 'Lunch?',
        options: const [PollOption(text: 'Pizza')],
      );

    await pumpTrailing(tester, controller: controller, withMicrophone: true);

    expect(sendButton(tester).props.onPressed, isNotNull);
  });

  testWidgets("follows the controller's validator", (tester) async {
    final controller = composerController(validator: (_) => false)..text = 'Hello';

    await pumpTrailing(tester, controller: controller);

    expect(sendButton(tester).props.onPressed, isNull);
  });

  testWidgets('still follows the deprecated composer validator', (tester) async {
    useFakeRecordPlatform();

    await pumpComposer(
      tester,
      composer: StreamMessageComposer(validator: (_) => false, enableVoiceRecording: false),
    );
    await tester.enterText(find.byType(EditableText), 'Hello');
    await tester.pump();

    expect(sendButton(tester).props.onPressed, isNull);
  });

  testWidgets('re-enables send when the deprecated validator goes back to the default', (tester) async {
    useFakeRecordPlatform();

    final channel = await pumpComposer(
      tester,
      composer: StreamMessageComposer(validator: (_) => false, enableVoiceRecording: false),
    );
    await tester.enterText(find.byType(EditableText), 'Hello');
    await pumpComposer(tester, channel: channel, composer: StreamMessageComposer(enableVoiceRecording: false));

    expect(sendButton(tester).props.onPressed, isNotNull);
  });

  test('rejects the deprecated validator when the app passes its own controller', () {
    final controller = composerController();

    expect(
      () => StreamMessageComposer(messageComposerController: controller, validator: (_) => false),
      throwsAssertionError,
    );
  });

  testWidgets("sends what the app's own controller accepts", (tester) async {
    useFakeRecordPlatform();
    final controller = composerController(validator: (_) => true);

    final channel = await pumpComposer(
      tester,
      composer: StreamMessageComposer(messageComposerController: controller, enableVoiceRecording: false),
    );
    await tester.tap(find.byKey(const ValueKey('send_key')));
    await tester.pump();

    verify(() => channel.sendMessage(any())).called(1);
  });
}
