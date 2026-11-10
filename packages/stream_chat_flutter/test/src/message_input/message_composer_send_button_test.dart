import 'dart:async';

import 'package:clock/clock.dart';
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

  testWidgets('hands the controller to onSendLongPress', (tester) async {
    _useFakeRecordPlatform();
    final controller = _controller();
    StreamMessageComposerController? longPressed;

    await _pumpComposer(
      tester,
      composer: StreamMessageComposer(
        messageComposerController: controller,
        enableVoiceRecording: false,
        onSendLongPress: (context, details) => longPressed = details.controller,
      ),
    );
    await tester.enterText(find.byType(EditableText), 'Hello');
    await tester.pump();
    await tester.longPress(find.byKey(const ValueKey('send_key')));
    await tester.pump();

    expect(longPressed, same(controller));
  });

  testWidgets("doesn't send the message on a long press", (tester) async {
    _useFakeRecordPlatform();
    final controller = _controller();

    final channel = await _pumpComposer(
      tester,
      composer: StreamMessageComposer(
        messageComposerController: controller,
        enableVoiceRecording: false,
        onSendLongPress: (context, details) {},
      ),
    );
    await tester.enterText(find.byType(EditableText), 'Hello');
    await tester.pump();
    await tester.longPress(find.byKey(const ValueKey('send_key')));
    await tester.pump();

    expect(controller.text, 'Hello');
    verifyNever(() => channel.sendMessage(any()));
  });

  testWidgets('shows the schedule sheet on a long press when the channel allows scheduling', (tester) async {
    _useFakeRecordPlatform();
    final controller = _controller();
    await _pumpComposer(
      tester,
      channel: _schedulingChannel(),
      composer: StreamMessageComposer(messageComposerController: controller, enableVoiceRecording: false),
    );
    await tester.enterText(find.byType(EditableText), 'Hello');
    await tester.pump();

    await tester.longPress(find.byKey(const ValueKey('send_key')));
    await tester.pumpAndSettle();

    expect(find.byType(StreamScheduleMessageSheet), findsOneWidget);
  });

  testWidgets('offers no long press when the channel does not allow scheduling', (tester) async {
    _useFakeRecordPlatform();
    final controller = _controller();
    await _pumpComposer(
      tester,
      composer: StreamMessageComposer(messageComposerController: controller, enableVoiceRecording: false),
    );

    await tester.enterText(find.byType(EditableText), 'Hello');
    await tester.pump();

    expect(_sendButton(tester).props.onLongPress, isNull);
  });

  testWidgets('offers no long press to schedule while editing', (tester) async {
    _useFakeRecordPlatform();
    final controller = _controller()
      ..editMessage(
        Message(
          id: 'message-id',
          text: 'Hello',
          createdAt: DateTime.utc(2026, 10, 29),
        ),
      );

    await _pumpComposer(
      tester,
      channel: _schedulingChannel(),
      composer: StreamMessageComposer(messageComposerController: controller, enableVoiceRecording: false),
    );

    expect(_sendButton(tester).props.onLongPress, isNull);
  });

  testWidgets('calls onSendLongPress instead of showing the schedule sheet', (tester) async {
    _useFakeRecordPlatform();
    final controller = _controller();
    var longPresses = 0;
    await _pumpComposer(
      tester,
      channel: _schedulingChannel(),
      composer: StreamMessageComposer(
        messageComposerController: controller,
        enableVoiceRecording: false,
        onSendLongPress: (context, details) => longPresses++,
      ),
    );
    await tester.enterText(find.byType(EditableText), 'Hello');
    await tester.pump();

    await tester.longPress(find.byKey(const ValueKey('send_key')));
    await tester.pumpAndSettle();

    expect(longPresses, 1);
    expect(find.byType(StreamScheduleMessageSheet), findsNothing);
  });

  testWidgets('schedules the message for a preset time', (tester) async {
    _useFakeRecordPlatform();
    final controller = _controller();
    final channel = _schedulingChannel();

    await withClock(Clock.fixed(DateTime(2026, 10, 21, 10)), () async {
      await _pumpComposer(
        tester,
        channel: channel,
        composer: StreamMessageComposer(messageComposerController: controller, enableVoiceRecording: false),
      );
      await tester.enterText(find.byType(EditableText), 'Hello');
      await tester.pump();
      await tester.longPress(find.byKey(const ValueKey('send_key')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Tomorrow at 9:00\u202fAM'));
      await tester.pumpAndSettle();
    });

    final scheduled = verify(
      () => channel.scheduleMessage(
        captureAny(),
        scheduledAt: DateTime(2026, 10, 22, 9),
        skipEnrichUrl: any(named: 'skipEnrichUrl'),
      ),
    ).captured;
    expect((scheduled.single as Message).text, 'Hello');
  });

  testWidgets('clears the composer once the message is scheduled', (tester) async {
    _useFakeRecordPlatform();
    final controller = _controller();

    await withClock(Clock.fixed(DateTime(2026, 10, 21, 10)), () async {
      await _pumpComposer(
        tester,
        channel: _schedulingChannel(),
        composer: StreamMessageComposer(messageComposerController: controller, enableVoiceRecording: false),
      );
      await tester.enterText(find.byType(EditableText), 'Hello');
      await tester.pump();
      await tester.longPress(find.byKey(const ValueKey('send_key')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Tomorrow at 9:00\u202fAM'));
      await tester.pumpAndSettle();
    });

    expect(controller.text, isEmpty);
  });

  testWidgets('offers no long press to schedule while an attachment uploads', (tester) async {
    _useFakeRecordPlatform();
    final controller = _controller()
      ..text = 'Hello'
      ..addAttachment(
        Attachment(
          type: AttachmentType.image,
          file: AttachmentFile(size: 10, path: 'photo.png'),
        ),
      );

    await _pumpComposer(
      tester,
      channel: _schedulingChannel(),
      composer: StreamMessageComposer(messageComposerController: controller, enableVoiceRecording: false),
    );

    expect(_sendButton(tester).props.onLongPress, isNull);
  });

  testWidgets("doesn't send while the message is being scheduled", (tester) async {
    _useFakeRecordPlatform();
    final controller = _controller();
    final channel = _schedulingChannel();
    final scheduling = Completer<ScheduleMessageResponse>();
    when(
      () => channel.scheduleMessage(
        any(),
        scheduledAt: any(named: 'scheduledAt'),
        skipEnrichUrl: any(named: 'skipEnrichUrl'),
      ),
    ).thenAnswer((_) => scheduling.future);

    await withClock(Clock.fixed(DateTime(2026, 10, 21, 10)), () async {
      await _pumpComposer(
        tester,
        channel: channel,
        composer: StreamMessageComposer(messageComposerController: controller, enableVoiceRecording: false),
      );
      await tester.enterText(find.byType(EditableText), 'Hello');
      await tester.pump();
      await tester.longPress(find.byKey(const ValueKey('send_key')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tomorrow at 9:00\u202fAM'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('send_key')));
      await tester.pump();
    });

    verifyNever(() => channel.sendMessage(any()));
  });

  testWidgets('schedules the message as preMessageSending changes it', (tester) async {
    _useFakeRecordPlatform();
    final controller = _controller();
    final channel = _schedulingChannel();

    await withClock(Clock.fixed(DateTime(2026, 10, 21, 10)), () async {
      await _pumpComposer(
        tester,
        channel: channel,
        composer: StreamMessageComposer(
          messageComposerController: controller,
          enableVoiceRecording: false,
          preMessageSending: (message) => message.copyWith(text: 'Edited'),
        ),
      );
      await tester.enterText(find.byType(EditableText), 'Hello');
      await tester.pump();
      await tester.longPress(find.byKey(const ValueKey('send_key')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Tomorrow at 9:00\u202fAM'));
      await tester.pumpAndSettle();
    });

    final scheduled = verify(
      () => channel.scheduleMessage(
        captureAny(),
        scheduledAt: any(named: 'scheduledAt'),
        skipEnrichUrl: any(named: 'skipEnrichUrl'),
      ),
    ).captured;
    expect((scheduled.single as Message).text, 'Edited');
  });

  testWidgets('schedules without a link preview the user dismissed', (tester) async {
    _useFakeRecordPlatform();
    final controller = _controller();
    final channel = _schedulingChannel();

    await withClock(Clock.fixed(DateTime(2026, 10, 21, 10)), () async {
      await _pumpComposer(
        tester,
        channel: channel,
        composer: StreamMessageComposer(messageComposerController: controller, enableVoiceRecording: false),
      );
      await tester.enterText(find.byType(EditableText), 'Hello');
      await tester.pump();
      controller.clearOGAttachment(dismissed: true);
      await tester.longPress(find.byKey(const ValueKey('send_key')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Tomorrow at 9:00\u202fAM'));
      await tester.pumpAndSettle();
    });

    verify(
      () => channel.scheduleMessage(
        any(),
        scheduledAt: any(named: 'scheduledAt'),
        skipEnrichUrl: true,
      ),
    ).called(1);
  });
}

// Replaces the recording platform with a fake for the rest of the test.
void _useFakeRecordPlatform() {
  final originalRecordPlatform = RecordPlatform.instance;
  RecordPlatform.instance = FakeRecordPlatform();
  addTearDown(() => RecordPlatform.instance = originalRecordPlatform);
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

MockChannel _channel({
  List<ChannelCapability> capabilities = const [
    ChannelCapability.sendMessage,
    ChannelCapability.uploadFile,
  ],
}) {
  final client = MockClient();
  final clientState = MockClientState();
  final channel = MockChannel(ownCapabilities: capabilities);
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

// A channel that allows scheduling messages, and accepts the ones scheduled.
MockChannel _schedulingChannel() {
  final channel = _channel(
    capabilities: const [
      ChannelCapability.sendMessage,
      ChannelCapability.uploadFile,
      ChannelCapability.scheduleMessage,
    ],
  );

  final clientState = channel.client.state as MockClientState;
  final channelState = channel.state! as MockChannelState;

  registerFallbackValue(DateTime(2026));
  when(() => channel.config).thenReturn(ChannelConfig());
  when(() => clientState.scheduledMessages).thenReturn([]);
  when(() => channelState.channelState).thenReturn(const ChannelState());
  when(
    () => channel.scheduleMessage(
      any(),
      scheduledAt: any(named: 'scheduledAt'),
      skipEnrichUrl: any(named: 'skipEnrichUrl'),
    ),
  ).thenAnswer((_) async => ScheduleMessageResponse());

  return channel;
}

StreamButton _sendButton(WidgetTester tester) {
  return tester.widget<StreamButton>(find.byKey(const ValueKey('send_key')));
}
