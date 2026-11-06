import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../fakes.dart';
import '../mocks.dart';

void main() {
  testWidgets('disables send for an empty message when there is no microphone', (tester) async {
    final controller = _controller();

    await _pumpTrailing(tester, controller: controller);

    expect(_sendButton(tester).props.onPressed, isNull);
  });

  testWidgets('enables send for a message with text', (tester) async {
    final controller = _controller()..text = 'Hello';

    await _pumpTrailing(tester, controller: controller);

    expect(_sendButton(tester).props.onPressed, isNotNull);
  });

  testWidgets('shows send instead of the microphone for a staged poll', (tester) async {
    final controller = _controller()
      ..poll = Poll(
        name: 'Lunch?',
        options: const [PollOption(text: 'Pizza')],
      );

    await _pumpTrailing(tester, controller: controller, withMicrophone: true);

    expect(_sendButton(tester).props.onPressed, isNotNull);
  });

  testWidgets("follows the controller's validator", (tester) async {
    final controller = _controller(validator: (_) => false)..text = 'Hello';

    await _pumpTrailing(tester, controller: controller);

    expect(_sendButton(tester).props.onPressed, isNull);
  });

  testWidgets('still follows the deprecated composer validator', (tester) async {
    final originalRecordPlatform = RecordPlatform.instance;
    RecordPlatform.instance = FakeRecordPlatform();
    addTearDown(() => RecordPlatform.instance = originalRecordPlatform);

    await _pumpComposer(
      tester,
      composer: StreamMessageComposer(validator: (_) => false, enableVoiceRecording: false),
    );
    await tester.enterText(find.byType(EditableText), 'Hello');
    await tester.pump();

    expect(_sendButton(tester).props.onPressed, isNull);
  });

  testWidgets('re-enables send when the deprecated validator goes back to the default', (tester) async {
    final originalRecordPlatform = RecordPlatform.instance;
    RecordPlatform.instance = FakeRecordPlatform();
    addTearDown(() => RecordPlatform.instance = originalRecordPlatform);

    final channel = await _pumpComposer(
      tester,
      composer: StreamMessageComposer(validator: (_) => false, enableVoiceRecording: false),
    );
    await tester.enterText(find.byType(EditableText), 'Hello');
    await _pumpComposer(tester, channel: channel, composer: StreamMessageComposer(enableVoiceRecording: false));

    expect(_sendButton(tester).props.onPressed, isNotNull);
  });

  test('rejects the deprecated validator when the app passes its own controller', () {
    final controller = _controller();

    expect(
      () => StreamMessageComposer(messageComposerController: controller, validator: (_) => false),
      throwsAssertionError,
    );
  });

  testWidgets("sends what the app's own controller accepts", (tester) async {
    final originalRecordPlatform = RecordPlatform.instance;
    RecordPlatform.instance = FakeRecordPlatform();
    addTearDown(() => RecordPlatform.instance = originalRecordPlatform);
    final controller = _controller(validator: (_) => true);

    final channel = await _pumpComposer(
      tester,
      composer: StreamMessageComposer(messageComposerController: controller, enableVoiceRecording: false),
    );
    await tester.tap(find.byKey(const ValueKey('send_key')));
    await tester.pump();

    verify(() => channel.sendMessage(any())).called(1);
  });

  testWidgets('offers a long press for a new message', (tester) async {
    final controller = _controller()..text = 'Hello';

    await _pumpTrailing(tester, controller: controller, onSendLongPress: () {});

    expect(_sendButton(tester).props.onLongPress, isNotNull);
  });

  testWidgets('offers no long press while editing', (tester) async {
    final controller = _controller()
      ..editMessage(
        Message(
          id: 'message-id',
          text: 'Hello',
          createdAt: DateTime.utc(2026, 10, 29),
        ),
      );

    await _pumpTrailing(tester, controller: controller, onSendLongPress: () {});

    expect(_sendButton(tester).props.onPressed, isNotNull);
    expect(_sendButton(tester).props.onLongPress, isNull);
  });

  testWidgets('hands the controller to onSendLongPress without sending', (tester) async {
    final originalRecordPlatform = RecordPlatform.instance;
    RecordPlatform.instance = FakeRecordPlatform();
    addTearDown(() => RecordPlatform.instance = originalRecordPlatform);
    final controller = _controller();
    StreamMessageComposerController? longPressed;

    final channel = await _pumpComposer(
      tester,
      composer: StreamMessageComposer(
        messageComposerController: controller,
        enableVoiceRecording: false,
        onSendLongPress: (it) => longPressed = it,
      ),
    );
    await tester.enterText(find.byType(EditableText), 'Hello');
    await tester.pump();
    await tester.longPress(find.byKey(const ValueKey('send_key')));
    await tester.pump();

    expect(longPressed, same(controller));
    expect(controller.text, 'Hello');
    verifyNever(() => channel.sendMessage(any()));
  });
}

StreamMessageComposerController _controller({
  MessageValidator validator = StreamMessageComposerController.defaultValidator,
}) {
  final controller = StreamMessageComposerController(validator: validator);
  addTearDown(controller.dispose);
  return controller;
}

Future<void> _pumpTrailing(
  WidgetTester tester, {
  required StreamMessageComposerController controller,
  bool withMicrophone = false,
  VoidCallback? onSendLongPress,
}) {
  final voiceRecordingCallback = switch (withMicrophone) {
    true => VoiceRecordingCallback(
      onLongPressStart: () {},
      onLongPressCancel: () {},
      onLongPressEnd: (_) {},
    ),
    false => null,
  };

  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: DefaultStreamMessageComposerInputTrailing(
          props: MessageComposerComponentProps(
            controller: controller,
            onSendPressed: () {},
            onSendLongPress: onSendLongPress,
            voiceRecordingCallback: voiceRecordingCallback,
            audioRecorderState: const RecordStateIdle(),
          ),
        ),
      ),
    ),
  );
}

Future<MockChannel> _pumpComposer(WidgetTester tester, {required Widget composer, MockChannel? channel}) async {
  channel ??= _channel();

  await tester.pumpWidget(
    MaterialApp(
      home: StreamChat(
        client: channel.client,
        child: StreamChannel(
          channel: channel,
          child: Scaffold(body: composer),
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();

  return channel;
}

MockChannel _channel() {
  final client = MockClient();
  final clientState = MockClientState();
  final channel = MockChannel();
  final channelState = MockChannelState();
  final member = Member(
    userId: 'user-id',
    user: User(id: 'user-id'),
  );

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(OwnUser(id: 'user-id')));
  when(() => channel.state).thenReturn(channelState);
  when(() => channel.client).thenReturn(client);
  when(channel.getRemainingCooldown).thenReturn(0);
  when(() => channel.lastMessageAt).thenReturn(DateTime.parse('2020-06-22 12:00:00'));
  when(() => channel.extraData).thenReturn({'name': 'test'});
  when(() => channel.extraDataStream).thenAnswer((_) => Stream.value({'name': 'test'}));
  when(() => channelState.members).thenReturn([member]);
  when(() => channelState.membersStream).thenAnswer((_) => Stream.value([member]));
  when(() => channelState.messages).thenReturn([]);
  when(() => channelState.messagesStream).thenAnswer((_) => Stream.value([]));
  when(() => channelState.draft).thenReturn(null);
  when(() => channelState.draftStream).thenAnswer((_) => Stream.value(null));
  registerFallbackValue(Message());
  when(() => channel.sendMessage(any())).thenAnswer((_) async => SendMessageResponse());

  return channel;
}

StreamButton _sendButton(WidgetTester tester) {
  return tester.widget<StreamButton>(find.byKey(const ValueKey('send_key')));
}
