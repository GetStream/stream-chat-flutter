import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/src/message_input/stream_chat_message_input.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../src/fakes.dart';
import '../src/golden_theme.dart';
import '../src/mocks.dart';
import '../src/sample_users.dart';

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
  StreamMessageComposerController? messageComposerController,
}) {
  return StreamChat(
    client: client,
    connectivityStream: Stream.value([ConnectivityResult.mobile]),
    child: StreamChannel(
      showLoading: false,
      channel: channel,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(child: Container()),
            StreamMessageComposer(
              enableVoiceRecording: true,
              messageComposerController: messageComposerController,
            ),
          ],
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
  StreamChatThemeData? streamChatThemeData,
}) {
  return StreamChat(
    client: client,
    streamChatThemeData: streamChatThemeData,
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
                  StreamMessageItem(
                    message: Message(
                      id: 'ctx-msg',
                      text: 'Hey, listen to this!',
                      user: noahSmith,
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
  );
}

/// Scaffold that shows a full message input bar (with attachment button and
/// placeholder) using [StreamChatMessageInput] so we can inject a custom
/// [audioRecorderController] to control the recording state.
///
/// The outer [Material] + bottom padding mirrors what [StreamMessageComposer]
/// wraps around [StreamChatMessageInput] internally.
Widget _buildVoiceRecordingComposerScaffold({
  required MockClient client,
  required MockChannel channel,
  required StreamAudioRecorderController audioRecorderController,
}) {
  return StreamChat(
    client: client,
    connectivityStream: Stream.value([ConnectivityResult.mobile]),
    child: StreamChannel(
      showLoading: false,
      channel: channel,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(child: Container()),
            Builder(
              builder: (context) {
                return Material(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.streamColorScheme.backgroundElevation1,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: context.streamSpacing.md),
                      child: StreamChatMessageInput(
                        onSendPressed: () {},
                        onAttachmentButtonPressed: () {},
                        placeholder: 'Send a message',
                        audioRecorderController: audioRecorderController,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
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

  docsGoldenTest(
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

  docsGoldenTest(
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

  docsGoldenTest(
    'voice recording hold recording state',
    fileName: 'voice_recording_hold_recording',
    constraints: const BoxConstraints.tightFor(width: 375, height: 200),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      _setupChannel(client, clientState, channel, channelState);

      final holdState = RecordStateRecordingHold(
        duration: const Duration(seconds: 5),
        waveform: List.generate(20, (i) => (i % 5) / 5.0),
      );

      return _buildVoiceRecordingComposerScaffold(
        client: client,
        channel: channel,
        audioRecorderController: _makeRecorderController(holdState),
      );
    },
  );

  docsGoldenTest(
    'voice recording locked recording state',
    fileName: 'voice_recording_locked_recording',
    constraints: const BoxConstraints.tightFor(width: 375, height: 200),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      _setupChannel(client, clientState, channel, channelState);

      final lockedState = RecordStateRecordingLocked(
        duration: const Duration(seconds: 12),
        waveform: List.generate(20, (i) => (i % 5) / 5.0),
      );

      return _buildVoiceRecordingComposerScaffold(
        client: client,
        channel: channel,
        audioRecorderController: _makeRecorderController(lockedState),
      );
    },
  );

  docsGoldenTest(
    'voice recording stopped state',
    fileName: 'voice_recording_stopped',
    constraints: const BoxConstraints.tightFor(width: 375, height: 150),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      _setupChannel(client, clientState, channel, channelState);

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

      return _buildVoiceRecordingComposerScaffold(
        client: client,
        channel: channel,
        audioRecorderController: _makeRecorderController(stoppedState),
      );
    },
  );

  docsGoldenTest(
    'voice recording finished state',
    fileName: 'voice_recording_finished',
    constraints: const BoxConstraints.tightFor(width: 375, height: 200),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      _setupChannel(client, clientState, channel, channelState);

      final messageComposerController = StreamMessageComposerController()
        ..addAttachment(
          Attachment(
            type: 'voiceRecording',
            assetUrl: 'https://example.com/recording.m4a',
            uploadState: const UploadState.success(),
            extraData: const {
              'duration': 15.0,
              'waveform_data': <double>[0.1, 0.5, 0.9, 0.4, 0.2],
            },
          ),
        );

      return _buildVoiceRecordingMessageInputScaffold(
        client: client,
        channel: channel,
        messageComposerController: messageComposerController,
      );
    },
  );

  docsGoldenTest(
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
        user: noahSmith,
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
        voiceWidget: StreamMessageItem(message: voiceMessage),
      );
    },
  );

  docsGoldenTest(
    'voice recording idle tooltip',
    fileName: 'voice_recording_idle_tooltip',
    constraints: const BoxConstraints.tightFor(width: 375, height: 150),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      _setupChannel(client, clientState, channel, channelState);

      final audioRecorderController = _makeRecorderController(
        const RecordStateIdle(message: 'Hold to record, release to send.'),
      );

      return _buildVoiceRecordingComposerScaffold(
        client: client,
        channel: channel,
        audioRecorderController: audioRecorderController,
      );
    },
  );

  docsGoldenTest(
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
        user: noahSmith,
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
        voiceWidget: StreamMessageItem(message: voiceMessage),
      );
    },
  );

  docsGoldenTest(
    'voice recording attachment custom theme',
    fileName: 'voice_recording_attachment_custom',
    constraints: const BoxConstraints.tightFor(width: 375, height: 400),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      _setupChannel(client, clientState, channel, channelState);

      const roboto = TextStyle(fontFamily: 'Roboto');
      final customTheme = StreamChatThemeData().copyWith(
        voiceRecordingAttachmentTheme: StreamVoiceRecordingAttachmentThemeData(
          titleTextStyle: roboto.copyWith(color: Colors.black54),
          durationTextStyle: roboto.copyWith(color: Colors.black54),
          activeDurationTextStyle: roboto.copyWith(color: Colors.black),
          controlButtonStyle: StreamButtonThemeStyle.from(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          speedToggleStyle: StreamPlaybackSpeedToggleStyle.from(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          waveformStyle: const StreamAudioWaveformThemeData(
            color: Colors.black54,
            progressColor: Colors.black,
          ),
        ),
      );

      final voiceMessage = Message(
        id: 'voice-msg-custom',
        user: noahSmith,
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
        voiceWidget: StreamMessageItem(message: voiceMessage),
        streamChatThemeData: customTheme,
      );
    },
  );
}
