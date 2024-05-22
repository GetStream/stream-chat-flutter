import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  group('StreamVoiceRecordingLoading', () {
    testWidgets('should show a progress indicator', (tester) async {
      await tester.pumpWidget(
        StreamChatTheme(
          data: StreamChatThemeData(
            voiceRecordingTheme: StreamVoiceRecordingThemeData.dark(),
          ),
          child: const StreamVoiceRecordingLoading(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
