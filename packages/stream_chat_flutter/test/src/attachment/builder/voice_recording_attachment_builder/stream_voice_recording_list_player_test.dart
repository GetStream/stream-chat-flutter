import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  group('StreamVoiceRecordingListPlayer', () {
    const totalDuration = Duration(seconds: 20);

    testWidgets('should show the loading widget', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: StreamChatTheme(
            data: StreamChatThemeData(
              voiceRecordingTheme: StreamVoiceRecordingThemeData.dark(),
            ),
            child: const StreamVoiceRecordingListPlayer(
              playList: [
                PlayListItem(
                  duration: totalDuration,
                  waveForm: [0.1, 0.2, 0.3],
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(StreamVoiceRecordingLoading), findsOneWidget);
    });

    testWidgets('should show the player widget', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: StreamChatTheme(
            data: StreamChatThemeData(
              voiceRecordingTheme: StreamVoiceRecordingThemeData.dark(),
            ),
            child: const StreamVoiceRecordingListPlayer(
              playList: [
                PlayListItem(
                  assetUrl: 'url',
                  duration: totalDuration,
                  waveForm: [0.1, 0.2, 0.3],
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(StreamVoiceRecordingPlayer), findsOneWidget);
    });
  });
}
