import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/src/message_input/audio_message_send_button/stream_audio_message_overlays.dart';
import 'package:stream_chat_flutter/src/message_input/audio_message_send_button/stream_audio_message_send_button.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class MockVoidCallback extends Mock {
  void call();
}

void main() {
  group('StreamAudioMessageButton', () {
    testWidgets('should show info bar on tap', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: StreamChatTheme(
                data: StreamChatThemeData(),
                child: StreamAudioMessageSendButton(
                  onRecordingStart: () {},
                  onRecordingEnd: () {},
                  onRecordingCanceled: () {},
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(StreamAudioMessageSendButton), findsOneWidget);

      await tester.tap(find.byType(StreamAudioMessageSendButton));
      await tester.pump();
      expect(
        find.byType(AudioMessageInfoBannerOverlay, skipOffstage: false),
        findsOneWidget,
      );
      await tester.pumpAndSettle(
        const Duration(milliseconds: 500),
      );
      expect(
        find.byType(AudioMessageInfoBannerOverlay, skipOffstage: false),
        findsNothing,
      );
    });

    testWidgets('should show lock button on long press', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: StreamChatTheme(
                data: StreamChatThemeData(
                  audioRecordingMessageTheme: AudioRecordingMessageThemeData(),
                ),
                child: StreamAudioMessageSendButton(
                  onRecordingStart: () {},
                  onRecordingEnd: () {},
                  onRecordingCanceled: () {},
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(StreamAudioMessageSendButton), findsOneWidget);

      final position =
          tester.getCenter(find.byType(StreamAudioMessageSendButton));
      await tester.startGesture(position, pointer: 1);
      await tester.pumpAndSettle(
        const Duration(seconds: 1),
      );
      expect(
        find.byType(LockButtonOverlay, skipOffstage: false),
        findsOneWidget,
      );
    });

    testWidgets('should show lock button on long press', (tester) async {
      final onRecordingStart = MockVoidCallback();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: StreamChatTheme(
                data: StreamChatThemeData(
                  audioRecordingMessageTheme: AudioRecordingMessageThemeData(),
                ),
                child: StreamAudioMessageSendButton(
                  onRecordingStart: onRecordingStart,
                  onRecordingEnd: () {},
                  onRecordingCanceled: () {},
                ),
              ),
            ),
          ),
        ),
      );

      final position =
          tester.getCenter(find.byType(StreamAudioMessageSendButton));
      await tester.startGesture(position, pointer: 1);
      await tester.pumpAndSettle(
        const Duration(milliseconds: 500),
      );
      verify(onRecordingStart.call);
    });

    testWidgets('should show call the cancel callback', (tester) async {
      final onRecordingCanceled = MockVoidCallback();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: StreamChatTheme(
                data: StreamChatThemeData(
                  audioRecordingMessageTheme: AudioRecordingMessageThemeData(),
                ),
                child: StreamAudioMessageSendButton(
                  onRecordingStart: () {},
                  onRecordingEnd: () {},
                  onRecordingCanceled: onRecordingCanceled,
                ),
              ),
            ),
          ),
        ),
      );

      final position =
          tester.getCenter(find.byType(StreamAudioMessageSendButton));
      final gesture = await tester.startGesture(position, pointer: 1);
      await tester.pumpAndSettle(
        const Duration(milliseconds: 500),
      );
      await gesture.moveTo(position + const Offset(-300, 0));
      verify(onRecordingCanceled.call);
    });
  });
}
