import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

final _currentUser = OwnUser(id: 'me', name: 'Luke Skywalker');
final _otherUser = User(id: 'han', name: 'Han Solo');

final _voiceRecording = Attachment(
  type: AttachmentType.voiceRecording,
  title: 'voice.m4a',
  file: AttachmentFile(size: 10000, path: 'voice_recordings/voice.m4a'),
  extraData: {
    'duration': 300,
    'waveform_data': List.filled(50, 0.5),
  },
);

void main() {
  setUpAll(() => registerFallbackValue(Message()));

  testWidgets("playing another user's voice recording marks it played", (tester) async {
    final channel = _channel();
    final message = _voiceMessage(user: _otherUser);
    await tester.pumpWidget(_wrap(channel, _playlist(message)));
    await tester.pump();

    _play(tester);

    verify(() => channel.sendMessageMark(message, MessageMarkType.played)).called(1);
  });

  testWidgets('playing a voice recording again marks it played once', (tester) async {
    final channel = _channel();
    final message = _voiceMessage(user: _otherUser);
    await tester.pumpWidget(_wrap(channel, _playlist(message)));
    await tester.pump();

    _play(tester);
    await tester.pump();
    _play(tester);

    verify(() => channel.sendMessageMark(message, MessageMarkType.played)).called(1);
  });

  testWidgets("playing the current user's own voice recording marks nothing", (tester) async {
    final channel = _channel();
    await tester.pumpWidget(_wrap(channel, _playlist(_voiceMessage(user: _currentUser))));
    await tester.pump();

    _play(tester);

    verifyNever(() => channel.sendMessageMark(any(), any()));
  });

  testWidgets('playing a voice recording already marked played marks nothing', (tester) async {
    final channel = _channel();
    final ownMark = OwnMark(type: MessageMarkType.played, createdAt: DateTime(2026));
    final message = _voiceMessage(user: _otherUser).copyWith(ownMarks: [ownMark]);
    await tester.pumpWidget(_wrap(channel, _playlist(message)));
    await tester.pump();

    _play(tester);

    verifyNever(() => channel.sendMessageMark(any(), any()));
  });

  testWidgets('playing a voice recording without the capability marks nothing', (tester) async {
    final channel = _channel(canMark: false);
    await tester.pumpWidget(_wrap(channel, _playlist(_voiceMessage(user: _otherUser))));
    await tester.pump();

    _play(tester);

    verifyNever(() => channel.sendMessageMark(any(), any()));
  });
}

// Calls the play callback the default track widget is given, without starting
// real playback.
void _play(WidgetTester tester) {
  final track = tester.widget<StreamVoiceRecordingAttachment>(find.byType(StreamVoiceRecordingAttachment));
  track.props.onTrackPlay?.call();
}

StreamVoiceRecordingAttachmentPlaylist _playlist(Message message) {
  return StreamVoiceRecordingAttachmentPlaylist(
    message: message,
    voiceRecordings: message.attachments,
  );
}

Message _voiceMessage({required User user}) {
  return Message(
    id: 'voice-note',
    createdAt: DateTime(2026, 11, 20, 9),
    user: user,
    state: MessageState.sent,
    attachments: [_voiceRecording],
  );
}

MockChannel _channel({bool canMark = true}) {
  final client = MockClient();
  final clientState = MockClientState();
  final channel = MockChannel(
    ownCapabilities: [
      ChannelCapability.sendMessage,
      if (canMark) ChannelCapability.sendMessageMark,
    ],
  );

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(_currentUser);
  when(() => channel.client).thenReturn(client);
  when(() => channel.sendMessageMark(any(), any())).thenAnswer(
    (_) async => SendMessageMarkResponse(),
  );
  return channel;
}

Widget _wrap(MockChannel channel, Widget body) {
  return MaterialApp(
    theme: ThemeData(extensions: [StreamTheme.light()]),
    home: StreamChatTheme(
      data: StreamChatThemeData(),
      child: StreamChannel(
        channel: channel,
        child: Scaffold(body: body),
      ),
    ),
  );
}
