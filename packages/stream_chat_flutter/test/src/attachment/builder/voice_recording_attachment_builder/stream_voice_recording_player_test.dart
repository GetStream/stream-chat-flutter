import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class MockAudioPlayer extends Mock implements AudioPlayer {
  @override
  Future<void> dispose() async {}
}

void main() {
  group('StreamVoiceRecordingPlayer', () {
    const totalDuration = Duration(seconds: 20);

    testWidgets('should show the total duration', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: StreamChatTheme(
            data: StreamChatThemeData(
              voiceRecordingTheme: StreamVoiceRecordingThemeData.dark(),
            ),
            child: StreamVoiceRecordingPlayer(
              player: AudioPlayer(),
              duration: totalDuration,
            ),
          ),
        ),
      );

      expect(find.text(totalDuration.toMinutesAndSeconds()), findsOneWidget);
    });

    testWidgets('should show the current duration', (tester) async {
      const aSecondLater = Duration(seconds: 1);
      final durationStream = StreamController<Duration>.broadcast();
      final audioPlayer = MockAudioPlayer();
      when(() => audioPlayer.positionStream)
          .thenAnswer((_) => durationStream.stream);
      when(() => audioPlayer.playing).thenReturn(true);
      when(() => audioPlayer.playingStream)
          .thenAnswer((_) => Stream.value(true));
      when(() => audioPlayer.currentIndex).thenReturn(0);
      when(() => audioPlayer.currentIndexStream)
          .thenAnswer((_) => Stream.value(0));
      when(() => audioPlayer.playerStateStream).thenAnswer(
          (_) => Stream.value(PlayerState(true, ProcessingState.completed)));

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: StreamChatTheme(
            data: StreamChatThemeData(
              voiceRecordingTheme: StreamVoiceRecordingThemeData.dark(),
            ),
            child: StreamVoiceRecordingPlayer(
              player: audioPlayer,
              duration: totalDuration,
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));
      durationStream.add(aSecondLater);
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text(aSecondLater.toMinutesAndSeconds()), findsOneWidget);
      durationStream.close();
    });

    testWidgets('should show the file size if passed', (tester) async {
      const fileSize = 1024;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: StreamChatTheme(
            data: StreamChatThemeData(
              voiceRecordingTheme: StreamVoiceRecordingThemeData.dark(),
            ),
            child: StreamVoiceRecordingPlayer(
              player: AudioPlayer(),
              duration: totalDuration,
              fileSize: fileSize,
            ),
          ),
        ),
      );

      expect(find.text(fileSize.toHumanReadableSize()), findsOneWidget);
    });

    testWidgets('should show the default speed value', (tester) async {
      final audioPlayer = MockAudioPlayer();

      when(() => audioPlayer.positionStream)
          .thenAnswer((_) => Stream.value(const Duration(milliseconds: 100)));
      when(() => audioPlayer.playingStream)
          .thenAnswer((_) => Stream.value(true));
      when(() => audioPlayer.playing).thenReturn(true);
      when(() => audioPlayer.currentIndex).thenReturn(0);
      when(() => audioPlayer.currentIndexStream)
          .thenAnswer((_) => Stream.value(0));
      when(() => audioPlayer.speedStream).thenAnswer(
        (_) => Stream.value(1),
      );
      when(() => audioPlayer.playerStateStream).thenAnswer(
          (_) => Stream.value(PlayerState(true, ProcessingState.completed)));

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: StreamChatTheme(
            data: StreamChatThemeData(
              voiceRecordingTheme: StreamVoiceRecordingThemeData.dark(),
            ),
            child: StreamVoiceRecordingPlayer(
              player: audioPlayer,
              duration: totalDuration,
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('1.0x'), findsOneWidget);
    });
  });
}
