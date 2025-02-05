import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  group(
    'VoiceRecordingAttachmentPlaylistBuilder',
    () {
      const builder = VoiceRecordingAttachmentPlaylistBuilder();

      test('canHandle returns true when voice recordings exist', () {
        final attachments = {
          AttachmentType.voiceRecording: [Attachment(), Attachment()],
        };

        expect(builder.canHandle(Message(), attachments), isTrue);
      });

      test('canHandle returns false when no voice recordings exist', () {
        final attachments = <String, List<Attachment>>{};

        expect(builder.canHandle(Message(), attachments), isFalse);
      });

      test('canHandle returns false for other attachment types', () {
        final attachments = {
          AttachmentType.image: [Attachment()],
          AttachmentType.giphy: [Attachment()],
          AttachmentType.video: [Attachment()],
        };

        expect(builder.canHandle(Message(), attachments), isFalse);
      });

      test('canHandle returns false when voice recording list is empty', () {
        final attachments = {AttachmentType.voiceRecording: <Attachment>[]};

        expect(builder.canHandle(Message(), attachments), isFalse);
      });

      testWidgets(
        'build returns correct widget',
        (WidgetTester tester) async {
          final attachments = {
            AttachmentType.voiceRecording: [Attachment(), Attachment()],
          };

          await tester.pumpWidget(
            _wrapWithStreamChatApp(
              Builder(
                builder: (context) => builder.build(
                  context,
                  Message(),
                  attachments,
                ),
              ),
            ),
          );

          expect(
            find.byType(StreamVoiceRecordingAttachmentPlaylist),
            findsOneWidget,
          );
        },
      );
    },
  );
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
          body: Center(child: widget),
        );
      }),
    ),
  );
}
