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

  testWidgets('playing a voice recording in a message marks it played', (tester) async {
    final channel = _channel();
    final message = _voiceMessage();
    await tester.pumpWidget(_wrap(channel, _item(message)));
    await tester.pump();

    await _setTrackState(tester, TrackState.playing);

    verify(() => channel.markMessagePlayed(message)).called(1);
  });

  testWidgets('a voice recording whose mark fails raises no error', (tester) async {
    final channel = _channel();
    when(
      () => channel.markMessagePlayed(any()),
    ).thenAnswer((_) async => throw StreamChatNetworkError(ChatErrorCode.internalSystemError));
    final message = _voiceMessage();
    await tester.pumpWidget(_wrap(channel, _item(message)));
    await tester.pump();

    await _setTrackState(tester, TrackState.playing);
    await tester.pump();

    verify(() => channel.markMessagePlayed(message)).called(1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a voice recording that is still loading marks nothing', (tester) async {
    final channel = _channel();
    await tester.pumpWidget(_wrap(channel, _item(_voiceMessage())));
    await tester.pump();

    await _setTrackState(tester, TrackState.loading);

    verifyNever(() => channel.markMessagePlayed(any()));
  });

  testWidgets('a voice recording that keeps playing is marked once', (tester) async {
    final channel = _channel();
    final message = _voiceMessage();
    await tester.pumpWidget(_wrap(channel, _item(message)));
    await tester.pump();

    await _setTrackState(tester, TrackState.playing);
    await _setTrackPosition(tester, const Duration(seconds: 1));

    verify(() => channel.markMessagePlayed(message)).called(1);
  });

  testWidgets('a playlist shown outside a message marks nothing', (tester) async {
    final channel = _channel();
    final message = _voiceMessage();
    final playlist = StreamVoiceRecordingAttachmentPlaylist(
      message: message,
      voiceRecordings: message.attachments,
    );
    await tester.pumpWidget(_wrap(channel, playlist));
    await tester.pump();

    await _setTrackState(tester, TrackState.playing);

    verifyNever(() => channel.markMessagePlayed(any()));
  });

  testWidgets('a playlist reports the recording that started playing', (tester) async {
    final message = _voiceMessage();
    final started = <AttachmentPlaybackStartedDetails>[];
    final playlist = StreamVoiceRecordingAttachmentPlaylist(
      message: message,
      voiceRecordings: message.attachments,
      onPlaybackStarted: started.add,
    );
    await tester.pumpWidget(_wrap(_channel(), playlist));
    await tester.pump();

    await _setTrackState(tester, TrackState.playing);

    expect(started.single.message, message);
    expect(started.single.attachment, message.attachments.single);
  });

  testWidgets('a playlist skips a recording it cannot play when reporting', (tester) async {
    final unplayable = Attachment(type: AttachmentType.voiceRecording, title: 'missing.m4a');
    final message = _voiceMessage().copyWith(
      attachments: [unplayable, _voiceRecording],
    );
    final started = <AttachmentPlaybackStartedDetails>[];
    final playlist = StreamVoiceRecordingAttachmentPlaylist(
      message: message,
      voiceRecordings: message.attachments,
      onPlaybackStarted: started.add,
    );
    await tester.pumpWidget(_wrap(_channel(), playlist));
    await tester.pump();

    await _setTrackState(tester, TrackState.playing);

    expect(started.single.attachment, _voiceRecording);
  });

  testWidgets('a playlist reports each recording it switches to', (tester) async {
    final second = _voiceRecording.copyWith(id: 'second', title: 'second.m4a');
    final message = _voiceMessage().copyWith(
      attachments: [_voiceRecording, second],
    );
    final started = <AttachmentPlaybackStartedDetails>[];
    final playlist = StreamVoiceRecordingAttachmentPlaylist(
      message: message,
      voiceRecordings: message.attachments,
      onPlaybackStarted: started.add,
    );
    await tester.pumpWidget(_wrap(_channel(), playlist));
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
}

// The controller of the playlist, as the audio player drives it.
ValueNotifier<AudioPlaylistState> _playlistController(WidgetTester tester) {
  final finder = find.byType(ValueListenableBuilder<AudioPlaylistState>);
  final builder = tester.widget<ValueListenableBuilder<AudioPlaylistState>>(finder);
  return builder.valueListenable as ValueNotifier<AudioPlaylistState>;
}

// Moves the first track to [trackState], as the audio player reports while it
// loads, plays and pauses.
Future<void> _setTrackState(WidgetTester tester, TrackState trackState) async {
  final controller = _playlistController(tester);
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

Message _voiceMessage() {
  return Message(
    id: 'voice-note',
    createdAt: DateTime(2026, 11, 20, 9),
    user: _otherUser,
    state: MessageState.sent,
    attachments: [_voiceRecording],
  );
}

MockChannel _channel() {
  final client = MockClient();
  final clientState = MockClientState();
  final channel = MockChannel();

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(_currentUser);
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(_currentUser));
  when(() => channel.client).thenReturn(client);
  final channelState = MockChannelState();
  when(() => channel.state).thenReturn(channelState);
  when(() => channel.memberCount).thenReturn(5);
  when(() => channelState.readStream).thenAnswer((_) => Stream.value(const []));
  when(() => channel.markMessagePlayed(any())).thenAnswer((_) async => SendMessageMarkResponse());
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
