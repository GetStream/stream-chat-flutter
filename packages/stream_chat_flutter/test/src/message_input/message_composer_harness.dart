import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../fakes.dart';
import '../mocks.dart';

/// Replaces the recording platform with a fake for the rest of the test.
void useFakeRecordPlatform() {
  final originalRecordPlatform = RecordPlatform.instance;
  RecordPlatform.instance = FakeRecordPlatform();
  addTearDown(() => RecordPlatform.instance = originalRecordPlatform);
}

/// A composer controller checked by [validator], disposed after the test.
StreamMessageComposerController composerController({
  MessageValidator validator = StreamMessageComposerController.defaultValidator,
}) {
  final controller = StreamMessageComposerController(validator: validator);
  addTearDown(controller.dispose);
  return controller;
}

/// Shows the composer's trailing send button for [controller], with a
/// microphone when [withMicrophone] is true.
Future<void> pumpTrailing(
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

/// Shows [composer] in [channel], or a [composerChannel], and returns the
/// channel.
Future<MockChannel> pumpComposer(WidgetTester tester, {required Widget composer, MockChannel? channel}) async {
  channel ??= composerChannel();

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

/// A loaded channel the current user has [capabilities] in.
MockChannel composerChannel({
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

/// A channel that allows scheduling messages.
MockChannel schedulingChannel() {
  final channel = composerChannel(
    capabilities: const [
      ChannelCapability.sendMessage,
      ChannelCapability.uploadFile,
      ChannelCapability.scheduleMessage,
    ],
  );

  final clientState = channel.client.state as MockClientState;
  final channelState = channel.state! as MockChannelState;

  when(() => channel.config).thenReturn(ChannelConfig());
  when(() => clientState.scheduledMessages).thenReturn([]);
  when(() => channelState.channelState).thenReturn(const ChannelState());

  return channel;
}

/// The composer's send button.
StreamButton sendButton(WidgetTester tester) {
  return tester.widget<StreamButton>(find.byKey(const ValueKey('send_key')));
}
