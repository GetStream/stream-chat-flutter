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
      // ignore: deprecated_member_use_from_same_package
      composer: StreamMessageComposer(validator: (_) => false, enableVoiceRecording: false),
    );
    await tester.enterText(find.byType(EditableText), 'Hello');
    await tester.pump();

    expect(_sendButton(tester).props.onPressed, isNull);
  });

  testWidgets("applies the deprecated composer validator to the app's own controller", (tester) async {
    final originalRecordPlatform = RecordPlatform.instance;
    RecordPlatform.instance = FakeRecordPlatform();
    addTearDown(() => RecordPlatform.instance = originalRecordPlatform);
    final controller = _controller()..text = 'Hello';

    await _pumpComposer(
      tester,
      composer: StreamMessageComposer(
        messageComposerController: controller,
        // ignore: deprecated_member_use_from_same_package
        validator: (_) => false,
        enableVoiceRecording: false,
      ),
    );

    expect(_sendButton(tester).props.onPressed, isNull);
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
            voiceRecordingCallback: voiceRecordingCallback,
            audioRecorderState: const RecordStateIdle(),
          ),
        ),
      ),
    ),
  );
}

Future<MockChannel> _pumpComposer(WidgetTester tester, {required Widget composer}) async {
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

  await tester.pumpWidget(
    MaterialApp(
      home: StreamChat(
        client: client,
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

StreamButton _sendButton(WidgetTester tester) {
  return tester.widget<StreamButton>(find.byKey(const ValueKey('send_key')));
}
