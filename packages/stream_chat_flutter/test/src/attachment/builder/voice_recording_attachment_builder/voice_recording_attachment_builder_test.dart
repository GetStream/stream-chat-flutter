import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../mocks.dart';

void main() {
  group('VoiceRecordingAttachmentBuilder', () {
    test('should handle voiceRecording attachment type', () {
      final builder = VoiceRecordingAttachmentBuilder();
      final message = MockMessage();
      final attachments = {
        'voiceRecording': [Attachment()],
      };

      expect(builder.canHandle(message, attachments), true);
    });

    test('should not handle other than voiceRecording attachment type', () {
      final builder = VoiceRecordingAttachmentBuilder();
      final message = MockMessage();
      final attachments = {
        'gify': [Attachment()],
      };

      expect(builder.canHandle(message, attachments), false);
    });

    testWidgets('should build StreamVoiceRecordingListPlayer', (tester) async {
      final builder = VoiceRecordingAttachmentBuilder();
      final message = MockMessage();
      final attachments = {
        'voiceRecording': [Attachment()],
      };

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: StreamChatTheme(
            data: StreamChatThemeData(
              voiceRecordingTheme: StreamVoiceRecordingThemeData.dark(),
            ),
            child: Builder(builder: (context) {
              return builder.build(context, message, attachments);
            }),
          ),
        ),
      );

      expect(find.byType(StreamVoiceRecordingListPlayer), findsOneWidget);
    });
  });
}
