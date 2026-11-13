import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_app/scheduled_messages/schedule_on_send_long_press.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(Message());
    registerFallbackValue(DateTime(2026));
  });

  testWidgets('scheduleOnSendLongPress keeps text typed meanwhile as a new message', (tester) async {
    final channel = _channel();
    final answer = Completer<ScheduleMessageResponse>();
    when(
      () => channel.scheduleMessage(any(), scheduledAt: any(named: 'scheduledAt')),
    ).thenAnswer((_) => answer.future);
    final controller = StreamMessageComposerController()..text = 'First';
    addTearDown(controller.dispose);
    final scheduledId = controller.value.id;

    await _scheduleWithPreset(tester, channel, controller);
    controller.text = 'Second';
    answer.complete(ScheduleMessageResponse()..message = Message(id: scheduledId));
    await tester.pumpAndSettle();

    expect(controller.text, 'Second');
    expect(controller.value.id, isNot(scheduledId));
  });

  testWidgets('scheduleOnSendLongPress keeps only the text typed meanwhile, not what was scheduled', (tester) async {
    final channel = _channel();
    final answer = Completer<ScheduleMessageResponse>();
    when(
      () => channel.scheduleMessage(any(), scheduledAt: any(named: 'scheduledAt')),
    ).thenAnswer((_) => answer.future);
    final uploaded = Attachment(
      type: AttachmentType.image,
      imageUrl: 'https://example.com/a.png',
      uploadState: const UploadState.success(),
    );
    final controller = StreamMessageComposerController()
      ..text = 'First'
      ..attachments = [uploaded];
    addTearDown(controller.dispose);

    await _scheduleWithPreset(tester, channel, controller);
    controller.text = 'Second';
    answer.complete(ScheduleMessageResponse()..message = Message());
    await tester.pumpAndSettle();

    expect(controller.text, 'Second');
    expect(controller.attachments, isEmpty);
  });

  testWidgets('scheduleOnSendLongPress clears the composer once its message is scheduled', (tester) async {
    final channel = _channel();
    when(
      () => channel.scheduleMessage(any(), scheduledAt: any(named: 'scheduledAt')),
    ).thenAnswer((_) async => ScheduleMessageResponse()..message = Message());
    final controller = StreamMessageComposerController()..text = 'First';
    addTearDown(controller.dispose);
    final scheduledId = controller.value.id;

    await _scheduleWithPreset(tester, channel, controller);
    await tester.pumpAndSettle();

    expect(controller.text, isEmpty);
    expect(controller.value.id, isNot(scheduledId));
  });
}

class _MockClient extends Mock implements StreamChatClient {}

class _MockClientState extends Mock implements ClientState {}

class _MockChannel extends Mock implements Channel {}

class _MockChannelState extends Mock implements ChannelClientState {}

const _cid = 'messaging:general';

// A loaded channel the current user can schedule messages in.
_MockChannel _channel() {
  final client = _MockClient();
  final clientState = _MockClientState();
  final channel = _MockChannel();
  final channelState = _MockChannelState();
  final currentUser = OwnUser(id: 'current-user');

  when(() => client.wsConnectionStatus).thenReturn(ConnectionStatus.connected);
  when(() => client.wsConnectionStatusStream).thenAnswer((_) => Stream.value(ConnectionStatus.connected));
  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(currentUser);
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(currentUser));
  when(() => clientState.scheduledMessages).thenReturn(const []);
  when(() => clientState.scheduledMessagesStream).thenAnswer((_) => Stream.value(const []));

  when(() => channel.client).thenReturn(client);
  when(() => channel.cid).thenReturn(_cid);
  when(() => channel.id).thenReturn('general');
  when(() => channel.type).thenReturn('messaging');
  when(() => channel.initialized).thenAnswer((_) async => true);
  when(() => channel.config).thenReturn(ChannelConfig());
  when(() => channel.ownCapabilities).thenReturn([
    ChannelCapability.sendMessage,
    ChannelCapability.scheduleMessage,
  ]);
  when(() => channel.ownCapabilitiesStream).thenAnswer(
    (_) => Stream.value([ChannelCapability.sendMessage, ChannelCapability.scheduleMessage]),
  );
  when(() => channel.state).thenReturn(channelState);
  when(() => channelState.channelState).thenReturn(ChannelState(channel: ChannelModel(cid: _cid)));
  when(() => channelState.members).thenReturn(const []);

  return channel;
}

// Long-presses send for [controller] in [channel], and picks the first
// preset of the schedule sheet.
Future<void> _scheduleWithPreset(
  WidgetTester tester,
  _MockChannel channel,
  StreamMessageComposerController controller,
) async {
  await tester.pumpWidget(
    MaterialApp(
      builder: (context, child) => StreamChat(
        client: channel.client,
        connectivityStream: Stream.value([ConnectivityResult.wifi]),
        child: StreamChannel.value(channel: channel, child: child!),
      ),
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => scheduleOnSendLongPress(context, controller),
            child: const Text('Schedule'),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('Schedule'));
  await tester.pumpAndSettle();

  await tester.tap(find.textContaining('Tomorrow').first);
  await tester.pump();
}
