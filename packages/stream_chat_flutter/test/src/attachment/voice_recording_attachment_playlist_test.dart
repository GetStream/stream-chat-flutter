import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  group('StreamVoiceRecordingAttachmentPlaylist', () {
    final fakeAudioRecording1 = Attachment(
      type: AttachmentType.voiceRecording,
      title: 'test1.m4a',
      file: AttachmentFile(
        size: 10000,
        path: 'voice_recordings/test1.m4a',
      ),
      extraData: {
        'duration': 300,
        'waveform_data': List.filled(50, 0.5),
      },
    );

    final fakeAudioRecording2 = Attachment(
      type: AttachmentType.voiceRecording,
      title: 'test2.m4a',
      file: AttachmentFile(
        size: 30000,
        path: 'voice_recordings/test2.m4a',
      ),
      extraData: {
        'duration': 900,
        'waveform_data': List.filled(50, 0.5),
      },
    );

    testWidgets(
      'renders playlist with correct number of attachments',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamVoiceRecordingAttachmentPlaylist(
              message: MockMessage(),
              voiceRecordings: [fakeAudioRecording1, fakeAudioRecording2],
            ),
          ),
        );

        expect(find.byType(StreamVoiceRecordingAttachment), findsNWidgets(2));
      },
    );

    testWidgets(
      'uses custom shape when provided',
      (WidgetTester tester) async {
        final customShape = RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        );

        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamVoiceRecordingAttachmentPlaylist(
              message: MockMessage(),
              voiceRecordings: [fakeAudioRecording1],
              shape: customShape,
            ),
          ),
        );

        expect(find.byType(StreamVoiceRecordingAttachment), findsOneWidget);

        final attachment = tester.widget<StreamVoiceRecordingAttachment>(
          find.byType(StreamVoiceRecordingAttachment),
        );

        expect(attachment.shape, customShape);
      },
    );

    testWidgets(
      'updates playlist when recordings change',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamVoiceRecordingAttachmentPlaylist(
              message: MockMessage(),
              voiceRecordings: [fakeAudioRecording1],
            ),
          ),
        );

        expect(find.byType(StreamVoiceRecordingAttachment), findsOneWidget);

        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamVoiceRecordingAttachmentPlaylist(
              message: MockMessage(),
              // Add a new recording
              voiceRecordings: [fakeAudioRecording1, fakeAudioRecording2],
            ),
          ),
        );

        expect(find.byType(StreamVoiceRecordingAttachment), findsNWidgets(2));

        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamVoiceRecordingAttachmentPlaylist(
              message: MockMessage(),
              // Add a new recording
              voiceRecordings: [fakeAudioRecording1],
            ),
          ),
        );

        expect(find.byType(StreamVoiceRecordingAttachment), findsNWidgets(1));
      },
    );

    testWidgets(
      'respects provided constraints',
      (WidgetTester tester) async {
        const constraints = BoxConstraints(
          minWidth: 100,
          maxWidth: 300,
          minHeight: 50,
          maxHeight: 200,
        );

        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamVoiceRecordingAttachmentPlaylist(
              message: MockMessage(),
              voiceRecordings: [fakeAudioRecording1],
              constraints: constraints,
            ),
          ),
        );

        expect(find.byType(StreamVoiceRecordingAttachment), findsOneWidget);

        final attachment = tester.widget<StreamVoiceRecordingAttachment>(
          find.byType(StreamVoiceRecordingAttachment),
        );

        expect(attachment.constraints, constraints);
      },
    );

    testWidgets(
      'respects provided padding',
      (WidgetTester tester) async {
        const padding = EdgeInsets.all(16);

        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamVoiceRecordingAttachmentPlaylist(
              message: MockMessage(),
              voiceRecordings: [fakeAudioRecording1],
              padding: padding,
            ),
          ),
        );

        expect(find.byType(StreamVoiceRecordingAttachment), findsOneWidget);

        final playlist = tester.widget<ListView>(
          find.ancestor(
            of: find.byType(StreamVoiceRecordingAttachment),
            matching: find.byType(ListView),
          ),
        );

        expect(playlist.padding, padding);
      },
    );

    testWidgets(
      'allows custom item',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamVoiceRecordingAttachmentPlaylist(
              message: MockMessage(),
              voiceRecordings: [fakeAudioRecording1],
              itemBuilder: (context, index) {
                return const Text('Custom Item');
              },
            ),
          ),
        );

        expect(find.byType(Text), findsOneWidget);
        expect(find.text('Custom Item'), findsOneWidget);
      },
    );

    testWidgets(
      'allows custom separator',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamVoiceRecordingAttachmentPlaylist(
              message: MockMessage(),
              voiceRecordings: [fakeAudioRecording1, fakeAudioRecording2],
              separatorBuilder: (context, index) => const Divider(
                color: Colors.red,
              ),
            ),
          ),
        );

        expect(find.byType(Divider), findsNWidgets(1));
      },
    );

    testWidgets(
      'handles empty voice recordings',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamVoiceRecordingAttachmentPlaylist(
              message: MockMessage(),
              voiceRecordings: const [],
            ),
          ),
        );

        expect(find.byType(StreamVoiceRecordingAttachment), findsNothing);
      },
    );
    for (final brightness in Brightness.values) {
      final theme = brightness.name;
      goldenTest(
        '[$theme] -> should look fine',
        fileName: 'stream_voice_recording_attachment_playlist_$theme',
        constraints: const BoxConstraints.tightFor(width: 412, height: 400),
        builder: () => _wrapWithStreamChatApp(
          brightness: brightness,
          StreamVoiceRecordingAttachmentPlaylist(
            message: MockMessage(),
            voiceRecordings: [fakeAudioRecording1, fakeAudioRecording2],
            padding: const EdgeInsets.all(16),
            separatorBuilder: (context, index) => const SizedBox(height: 8),
          ),
        ),
      );
    }
  });
}

Widget _wrapWithStreamChatApp(
  Widget widget, {
  Brightness? brightness,
}) {
  return MaterialApp(
    home: StreamChatTheme(
      data: StreamChatThemeData(brightness: brightness),
      child: Builder(builder: (context) {
        final theme = StreamChatTheme.of(context);
        return Scaffold(
          backgroundColor: theme.colorTheme.appBg,
          body: widget,
        );
      }),
    ),
  );
}
