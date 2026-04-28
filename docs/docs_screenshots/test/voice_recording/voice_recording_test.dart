import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_recording_locked.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_recording_ongoing.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../src/fakes.dart';
import '../src/golden_theme.dart';
import '../src/mocks.dart';

class _MockAudioRecorder extends Mock implements AudioRecorder {}

StreamAudioRecorderController _makeRecorderController(AudioRecorderState initialState) {
  final mockRecorder = _MockAudioRecorder();
  when(() => mockRecorder.onAmplitudeChanged(any())).thenAnswer((_) => const Stream.empty());
  when(mockRecorder.dispose).thenAnswer((_) async {});
  return StreamAudioRecorderController.raw(
    config: const RecordConfig(numChannels: 1),
    recorder: mockRecorder,
    initialState: initialState,
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
              StreamMessageComposer(enableVoiceRecording: true),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildVoiceRecorderScaffold({
  required MockClient client,
  required Widget child,
}) {
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
          child: Center(child: child),
        ),
      ),
    ),
  );
}

/// Scaffold that shows a message bubble + the voice widget + an input bar,
/// giving context to how voice recording looks in a real conversation.
Widget _buildVoiceRecordingContextScaffold({
  required MockClient client,
  required MockChannel channel,
  required Widget voiceWidget,
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
              Expanded(
                child: ListView(
                  reverse: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: voiceWidget,
                    ),
                    StreamMessageWidget(
                      message: Message(
                        id: 'ctx-msg',
                        text: 'Hey, listen to this!',
                        user: User(id: 'user-2', name: 'Bob'),
                        createdAt: DateTime(2024, 6, 1, 10, 0),
                      ),
                    ),
                  ],
                ),
              ),
              StreamMessageComposer(enableVoiceRecording: true),
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

  setUpAll(() {
    registerFallbackValue(Duration.zero);
  });

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
    constraints: const BoxConstraints.tightFor(width: 375, height: 56),
    builder: () {
      final client = MockClient();

      final holdState = RecordStateRecordingHold(
        duration: const Duration(seconds: 5),
        waveform: List.generate(20, (i) => (i % 5) / 5.0),
      );

      return _buildVoiceRecorderScaffold(
        client: client,
        child: StreamMessageComposerRecordingOngoing(
          audioRecorderController: _makeRecorderController(holdState),
        ),
      );
    },
  );

  goldenTest(
    'voice recording locked recording state',
    fileName: 'voice_recording_locked_recording',
    constraints: const BoxConstraints.tightFor(width: 375, height: 120),
    builder: () {
      final client = MockClient();

      final lockedState = RecordStateRecordingLocked(
        duration: const Duration(seconds: 12),
        waveform: List.generate(20, (i) => (i % 5) / 5.0),
      );

      return _buildVoiceRecorderScaffold(
        client: client,
        child: MessageComposerRecordingLocked(
          audioRecorderController: _makeRecorderController(lockedState),
          feedback: const AudioRecorderFeedback(),
          messageComposerController: StreamMessageComposerController(),
          sendMessageCallback: null,
          state: lockedState,
        ),
      );
    },
  );

  goldenTest(
    'voice recording finished state',
    fileName: 'voice_recording_finished',
    constraints: const BoxConstraints.tightFor(width: 375, height: 120),
    builder: () {
      final client = MockClient();

      final stoppedState = RecordStateStopped(
        audioRecording: Attachment(
          type: 'voiceRecording',
          assetUrl: 'https://example.com/recording.m4a',
          uploadState: const UploadState.success(),
          extraData: const {
            'duration': 15.0,
            'waveform_data': <double>[0.1, 0.5, 0.9, 0.4, 0.2],
          },
        ),
      );

      return _buildVoiceRecorderScaffold(
        client: client,
        child: MessageComposerRecordingStopped(
          audioRecorderController: _makeRecorderController(stoppedState),
          feedback: const AudioRecorderFeedback(),
          messageComposerController: StreamMessageComposerController(),
          sendMessageCallback: null,
          recordingState: stoppedState,
        ),
      );
    },
  );

  goldenTest(
    'voice recording attachment idle',
    fileName: 'voice_recording_attachment',
    constraints: const BoxConstraints.tightFor(width: 375, height: 400),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      _setupChannel(client, clientState, channel, channelState);

      final voiceMessage = Message(
        id: 'voice-msg',
        user: User(id: 'user-2', name: 'Bob'),
        attachments: [
          Attachment(
            type: 'voiceRecording',
            assetUrl: 'https://example.com/recording.m4a',
            uploadState: const UploadState.success(),
            extraData: const {
              'duration': 15.0,
              'waveform_data': <double>[
                0.1,
                0.3,
                0.5,
                0.7,
                0.9,
                0.7,
                0.5,
                0.3,
                0.1,
                0.2,
                0.4,
                0.6,
                0.8,
                0.6,
                0.4,
                0.2,
                0.5,
                0.8,
                0.6,
                0.3,
                0.1,
                0.4,
                0.7,
                0.9,
                0.6,
                0.3,
                0.1,
                0.4,
                0.7,
                0.5,
                0.2,
                0.6,
                0.8,
                0.4,
                0.2,
              ],
            },
          ),
        ],
        createdAt: DateTime(2024, 6, 1, 10, 0),
      );

      return _buildVoiceRecordingContextScaffold(
        client: client,
        channel: channel,
        voiceWidget: StreamMessageWidget(message: voiceMessage),
      );
    },
  );

  goldenTest(
    'voice recording attachment playing',
    fileName: 'voice_recording_attachment_playing',
    constraints: const BoxConstraints.tightFor(width: 375, height: 400),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      _setupChannel(client, clientState, channel, channelState);

      final voiceMessage = Message(
        id: 'voice-msg-playing',
        user: User(id: 'user-2', name: 'Bob'),
        attachments: [
          Attachment(
            type: 'voiceRecording',
            assetUrl: 'https://example.com/recording.m4a',
            uploadState: const UploadState.success(),
            extraData: const {
              'duration': 15.0,
              'waveform_data': <double>[
                0.1,
                0.3,
                0.5,
                0.7,
                0.9,
                0.7,
                0.5,
                0.3,
                0.1,
                0.2,
                0.4,
                0.6,
                0.8,
                0.6,
                0.4,
                0.2,
                0.5,
                0.8,
                0.6,
                0.3,
                0.1,
                0.4,
                0.7,
                0.9,
                0.6,
                0.3,
                0.1,
                0.4,
                0.7,
                0.5,
                0.2,
                0.6,
                0.8,
                0.4,
                0.2,
              ],
            },
          ),
        ],
        createdAt: DateTime(2024, 6, 1, 10, 0),
      );

      return _buildVoiceRecordingContextScaffold(
        client: client,
        channel: channel,
        voiceWidget: StreamMessageWidget(message: voiceMessage),
      );
    },
  );
}
