import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/src/audio/audio_playlist_state.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../src/fakes.dart';
import '../src/golden_theme.dart';
import '../src/mocks.dart';

Widget _buildRecorderButtonScaffold({
  required MockClient client,
  required MockChannel channel,
  required AudioRecorderState recordState,
}) {
  return MaterialApp(
    theme: docsScreenshotsTheme(),
    debugShowCheckedModeBanner: false,
    home: StreamChat(
      client: client,
      streamChatThemeData: docsStreamChatThemeData(),
      connectivityStream: Stream.value([ConnectivityResult.mobile]),
      child: StreamChannel(
        showLoading: false,
        channel: channel,
        child: Scaffold(
          body: Center(
            child: StreamAudioRecorderButton(recordState: recordState),
          ),
        ),
      ),
    ),
  );
}

Widget _buildVoiceRecordingMessageInputScaffold({
  required MockClient client,
  required MockChannel channel,
}) {
  return MaterialApp(
    theme: docsScreenshotsTheme(),
    debugShowCheckedModeBanner: false,
    home: StreamChat(
      client: client,
      streamChatThemeData: docsStreamChatThemeData(),
      connectivityStream: Stream.value([ConnectivityResult.mobile]),
      child: StreamChannel(
        showLoading: false,
        channel: channel,
        child: Scaffold(
          body: Column(
            children: [
              Expanded(child: Container()),
              const StreamMessageInput(enableVoiceRecording: true),
            ],
          ),
        ),
      ),
    ),
  );
}

void _setupChannel(MockClient client, MockClientState clientState, MockChannel channel, MockChannelState channelState) {
  setupMockChannel(
    client: client,
    clientState: clientState,
    channel: channel,
    channelState: channelState,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final originalRecordPlatform = RecordPlatform.instance;
  setUp(() => RecordPlatform.instance = FakeRecordPlatform());
  tearDown(() => RecordPlatform.instance = originalRecordPlatform);

  goldenTest(
    'voice recording idle state',
    fileName: 'voice_recording_idle',
    constraints: const BoxConstraints.tightFor(width: 375, height: 100),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      _setupChannel(client, clientState, channel, channelState);

      return _buildVoiceRecordingMessageInputScaffold(
        client: client,
        channel: channel,
      );
    },
  );

  goldenTest(
    'voice recording idle with tooltip',
    fileName: 'voice_recording_idle_tooltip',
    constraints: const BoxConstraints.tightFor(width: 375, height: 80),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      _setupChannel(client, clientState, channel, channelState);

      return _buildRecorderButtonScaffold(
        client: client,
        channel: channel,
        recordState: const RecordStateIdle(message: 'Hold to record'),
      );
    },
  );

  goldenTest(
    'voice recording enabled (mic button visible)',
    fileName: 'voice_recording_enabled',
    constraints: const BoxConstraints.tightFor(width: 375, height: 100),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      _setupChannel(client, clientState, channel, channelState);

      return _buildVoiceRecordingMessageInputScaffold(
        client: client,
        channel: channel,
      );
    },
  );

  goldenTest(
    'voice recording hold recording state',
    fileName: 'voice_recording_hold_recording',
    constraints: const BoxConstraints.tightFor(width: 375, height: 80),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      _setupChannel(client, clientState, channel, channelState);

      return _buildRecorderButtonScaffold(
        client: client,
        channel: channel,
        recordState: RecordStateRecordingHold(
          duration: const Duration(seconds: 5),
          waveform: List.generate(20, (i) => (i % 5) / 5.0),
        ),
      );
    },
  );

  goldenTest(
    'voice recording locked recording state',
    fileName: 'voice_recording_locked_recording',
    constraints: const BoxConstraints.tightFor(width: 375, height: 80),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      _setupChannel(client, clientState, channel, channelState);

      return _buildRecorderButtonScaffold(
        client: client,
        channel: channel,
        recordState: RecordStateRecordingLocked(
          duration: const Duration(seconds: 12),
          waveform: List.generate(20, (i) => (i % 5) / 5.0),
        ),
      );
    },
  );

  goldenTest(
    'voice recording finished state',
    fileName: 'voice_recording_finished',
    constraints: const BoxConstraints.tightFor(width: 375, height: 80),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      _setupChannel(client, clientState, channel, channelState);

      return _buildRecorderButtonScaffold(
        client: client,
        channel: channel,
        recordState: RecordStateStopped(
          audioRecording: Attachment(
            type: 'voiceRecording',
            assetUrl: 'https://example.com/recording.m4a',
            extraData: const {
              'duration': 15.0,
              'waveform_data': <double>[0.1, 0.5, 0.9, 0.4, 0.2],
            },
          ),
        ),
      );
    },
  );

  goldenTest(
    'voice recording stopped state',
    fileName: 'voice_recording_stopped',
    constraints: const BoxConstraints.tightFor(width: 375, height: 80),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      _setupChannel(client, clientState, channel, channelState);

      return _buildRecorderButtonScaffold(
        client: client,
        channel: channel,
        recordState: const RecordStateIdle(),
      );
    },
  );

  goldenTest(
    'voice recording attachment idle',
    fileName: 'voice_recording_attachment',
    constraints: const BoxConstraints.tightFor(width: 375, height: 80),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      when(() => client.state).thenReturn(clientState);

      final track = PlaylistTrack(
        uri: Uri.parse('https://example.com/recording.m4a'),
        title: 'Voice message',
        duration: const Duration(seconds: 15),
        waveform: List.generate(35, (i) => (i % 7) / 7.0),
        state: TrackState.idle,
      );

      return MaterialApp(
        theme: docsScreenshotsTheme(),
        debugShowCheckedModeBanner: false,
        home: StreamChat(
          client: client,
          streamChatThemeData: docsStreamChatThemeData(),
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(8),
              child: StreamVoiceRecordingAttachment(
                track: track,
                speed: StreamPlaybackSpeed.x1,
              ),
            ),
          ),
        ),
      );
    },
  );

  goldenTest(
    'voice recording attachment playing',
    fileName: 'voice_recording_attachment_playing',
    constraints: const BoxConstraints.tightFor(width: 375, height: 80),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      when(() => client.state).thenReturn(clientState);

      final track = PlaylistTrack(
        uri: Uri.parse('https://example.com/recording.m4a'),
        title: 'Voice message',
        duration: const Duration(seconds: 15),
        position: const Duration(seconds: 7),
        waveform: List.generate(35, (i) => (i % 7) / 7.0),
        state: TrackState.playing,
      );

      return MaterialApp(
        theme: docsScreenshotsTheme(),
        debugShowCheckedModeBanner: false,
        home: StreamChat(
          client: client,
          streamChatThemeData: docsStreamChatThemeData(),
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(8),
              child: StreamVoiceRecordingAttachment(
                track: track,
                speed: StreamPlaybackSpeed.x1,
              ),
            ),
          ),
        ),
      );
    },
  );
}
