import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/src/audio/audio_playlist_state.dart';
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
    await tester.pumpWidget(_wrap(channel, _item(message)));
    await tester.pump();

    await _setTrackState(tester, TrackState.playing);

    verify(() => channel.sendMessageMark(message, MessageMarkType.played)).called(1);
  });

  testWidgets('a voice recording that is still loading marks nothing', (tester) async {
    final channel = _channel();
    await tester.pumpWidget(_wrap(channel, _item(_voiceMessage(user: _otherUser))));
    await tester.pump();

    await _setTrackState(tester, TrackState.loading);

    verifyNever(() => channel.sendMessageMark(any(), any()));
  });

  testWidgets('playing a voice recording again marks it played once', (tester) async {
    final channel = _channel();
    final message = _voiceMessage(user: _otherUser);
    await tester.pumpWidget(_wrap(channel, _item(message)));
    await tester.pump();

    await _setTrackState(tester, TrackState.playing);
    await _setTrackState(tester, TrackState.paused);
    await _setTrackState(tester, TrackState.playing);

    verify(() => channel.sendMessageMark(message, MessageMarkType.played)).called(1);
  });

  testWidgets('playing a voice recording again after a failed mark retries it', (tester) async {
    final channel = _channel(markFails: true);
    final message = _voiceMessage(user: _otherUser);
    await tester.pumpWidget(_wrap(channel, _item(message)));
    await tester.pump();

    await _setTrackState(tester, TrackState.playing);
    await _setTrackState(tester, TrackState.paused);
    await _setTrackState(tester, TrackState.playing);

    verify(() => channel.sendMessageMark(message, MessageMarkType.played)).called(2);
  });

  testWidgets('a failed mark is not retried while the recording keeps playing', (tester) async {
    final channel = _channel(markFails: true);
    final message = _voiceMessage(user: _otherUser);
    await tester.pumpWidget(_wrap(channel, _item(message)));
    await tester.pump();

    await _setTrackState(tester, TrackState.playing);
    await _setTrackPosition(tester, const Duration(seconds: 1));

    verify(() => channel.sendMessageMark(message, MessageMarkType.played)).called(1);
  });

  testWidgets('playing one voice recording in two players marks it played once', (tester) async {
    final channel = _channel();
    final message = _voiceMessage(user: _otherUser);
    final body = Column(children: [_item(message), _item(message)]);
    await tester.pumpWidget(_wrap(channel, body));
    await tester.pump();

    await _setTrackState(tester, TrackState.playing, player: 0);
    await _setTrackState(tester, TrackState.playing, player: 1);

    verify(() => channel.sendMessageMark(message, MessageMarkType.played)).called(1);
  });

  testWidgets('a playlist shown outside a message marks nothing', (tester) async {
    final channel = _channel();
    final message = _voiceMessage(user: _otherUser);
    final playlist = StreamVoiceRecordingAttachmentPlaylist(
      message: message,
      voiceRecordings: message.attachments,
    );
    await tester.pumpWidget(_wrap(channel, playlist));
    await tester.pump();

    await _setTrackState(tester, TrackState.playing);

    verifyNever(() => channel.sendMessageMark(any(), any()));
  });

  testWidgets('a playlist reports the recording that started playing', (tester) async {
    final channel = _channel();
    final message = _voiceMessage(user: _otherUser);
    final started = <AttachmentPlaybackStartedDetails>[];
    final playlist = StreamVoiceRecordingAttachmentPlaylist(
      message: message,
      voiceRecordings: message.attachments,
      onPlaybackStarted: started.add,
    );
    await tester.pumpWidget(_wrap(channel, playlist));
    await tester.pump();

    await _setTrackState(tester, TrackState.playing);

    expect(started.single.attachment, message.attachments.single);
  });

  testWidgets('a playlist skips a recording it cannot play when reporting', (tester) async {
    final channel = _channel();
    final unplayable = Attachment(type: AttachmentType.voiceRecording, title: 'missing.m4a');
    final message = _voiceMessage(user: _otherUser).copyWith(
      attachments: [unplayable, _voiceRecording],
    );
    final started = <AttachmentPlaybackStartedDetails>[];
    final playlist = StreamVoiceRecordingAttachmentPlaylist(
      message: message,
      voiceRecordings: message.attachments,
      onPlaybackStarted: started.add,
    );
    await tester.pumpWidget(_wrap(channel, playlist));
    await tester.pump();

    await _setTrackState(tester, TrackState.playing);

    expect(started.single.attachment, _voiceRecording);
  });

  testWidgets('a playlist reports each recording it switches to', (tester) async {
    final channel = _channel();
    final second = _voiceRecording.copyWith(id: 'second', title: 'second.m4a');
    final message = _voiceMessage(user: _otherUser).copyWith(
      attachments: [_voiceRecording, second],
    );
    final started = <AttachmentPlaybackStartedDetails>[];
    final playlist = StreamVoiceRecordingAttachmentPlaylist(
      message: message,
      voiceRecordings: message.attachments,
      onPlaybackStarted: started.add,
    );
    await tester.pumpWidget(_wrap(channel, playlist));
    await tester.pump();

    final controller = _playlistController(tester);
    final [first, other] = controller.value.tracks;
    controller.value = controller.value.copyWith(
      currentIndex: 0,
      tracks: [
        first.copyWith(state: TrackState.playing),
        other,
      ],
    );
    await tester.pump();
    controller.value = controller.value.copyWith(
      currentIndex: 1,
      tracks: [
        first.copyWith(state: TrackState.paused),
        other.copyWith(state: TrackState.playing),
      ],
    );
    await tester.pump();

    expect(started.map((it) => it.attachment), [_voiceRecording, second]);
  });

  testWidgets("playing the current user's own voice recording marks nothing", (tester) async {
    final channel = _channel();
    await tester.pumpWidget(_wrap(channel, _item(_voiceMessage(user: _currentUser))));
    await tester.pump();

    await _setTrackState(tester, TrackState.playing);

    verifyNever(() => channel.sendMessageMark(any(), any()));
  });

  testWidgets('playing a draft voice recording marks nothing', (tester) async {
    final channel = _channel();
    final draft = Message(attachments: [_voiceRecording]);
    await tester.pumpWidget(_wrap(channel, _item(draft)));
    await tester.pump();

    await _setTrackState(tester, TrackState.playing);

    verifyNever(() => channel.sendMessageMark(any(), any()));
  });

  testWidgets('playing a voice recording already marked played marks nothing', (tester) async {
    final channel = _channel();
    final ownMark = OwnMark(type: MessageMarkType.played, createdAt: DateTime(2026));
    final message = _voiceMessage(user: _otherUser).copyWith(ownMarks: [ownMark]);
    await tester.pumpWidget(_wrap(channel, _item(message)));
    await tester.pump();

    await _setTrackState(tester, TrackState.playing);

    verifyNever(() => channel.sendMessageMark(any(), any()));
  });

  testWidgets('playing a voice recording without the capability marks nothing', (tester) async {
    final channel = _channel(canMark: false);
    await tester.pumpWidget(_wrap(channel, _item(_voiceMessage(user: _otherUser))));
    await tester.pump();

    await _setTrackState(tester, TrackState.playing);

    verifyNever(() => channel.sendMessageMark(any(), any()));
  });
}

// The controller of the [player]th playlist, as the audio player drives it.
ValueNotifier<AudioPlaylistState> _playlistController(
  WidgetTester tester, {
  int player = 0,
}) {
  final finder = find.byType(ValueListenableBuilder<AudioPlaylistState>);
  final builder = tester.widget<ValueListenableBuilder<AudioPlaylistState>>(
    finder.at(player),
  );
  return builder.valueListenable as ValueNotifier<AudioPlaylistState>;
}

// Moves the first track to [trackState], as the audio player reports while it
// loads, plays and pauses.
Future<void> _setTrackState(
  WidgetTester tester,
  TrackState trackState, {
  int player = 0,
}) async {
  final controller = _playlistController(tester, player: player);
  final state = controller.value;
  final track = state.tracks.first.copyWith(state: trackState);
  controller.value = state.copyWith(
    currentIndex: 0,
    tracks: [track, ...state.tracks.skip(1)],
  );
  await tester.pump();
}

// Advances the first track's position, as the audio player reports while it
// plays.
Future<void> _setTrackPosition(WidgetTester tester, Duration position) async {
  final controller = _playlistController(tester);
  final state = controller.value;
  final track = state.tracks.first.copyWith(position: position);
  controller.value = state.copyWith(tracks: [track, ...state.tracks.skip(1)]);
  await tester.pump();
}

Widget _item(Message message) => StreamMessageItem(message: message);

Message _voiceMessage({required User user}) {
  return Message(
    id: 'voice-note',
    createdAt: DateTime(2026, 11, 20, 9),
    user: user,
    state: MessageState.sent,
    attachments: [_voiceRecording],
  );
}

MockChannel _channel({bool canMark = true, bool markFails = false}) {
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
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(_currentUser));
  when(() => client.logger).thenReturn(Logger.detached('test'));
  when(() => channel.client).thenReturn(client);
  final channelState = MockChannelState();
  when(() => channel.state).thenReturn(channelState);
  when(() => channel.memberCount).thenReturn(5);
  when(() => channelState.readStream).thenAnswer((_) => Stream.value(const []));
  when(() => channelState.channelState).thenReturn(
    ChannelState(
      channel: ChannelModel(
        cid: 'messaging:test',
        config: ChannelConfig(markTypes: const [MessageMarkType.played]),
      ),
    ),
  );
  when(() => channel.sendMessageMark(any(), any())).thenAnswer((_) async {
    if (markFails) throw const StreamChatError('offline');
    return SendMessageMarkResponse();
  });
  return channel;
}

Widget _wrap(MockChannel channel, Widget body) {
  return MaterialApp(
    home: StreamChat(
      client: channel.client,
      connectivityStream: Stream.value(const [ConnectivityResult.mobile]),
      child: StreamChannel(
        channel: channel,
        child: Scaffold(
          body: StreamMessageLayout(
            data: const StreamMessageLayoutData(alignment: StreamMessageAlignment.start),
            child: SingleChildScrollView(child: body),
          ),
        ),
      ),
    ),
  );
}
