import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/src/audio/audio_playlist_state.dart';
import 'package:stream_chat_flutter/src/misc/audio_waveform.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';
import '../utils/finders.dart';

void main() {
  group(
    'StreamVoiceRecordingAttachment',
    () {
      final fakePlaylistTrack = PlaylistTrack(
        title: 'test.m4a',
        uri: Uri.file('voice_recordings/test.m4a'),
        duration: const Duration(seconds: 30),
        waveform: List.filled(50, 0.5),
      );

      testWidgets(
        'renders basic components',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            _wrapWithStreamChatApp(
              StreamVoiceRecordingAttachment(
                track: fakePlaylistTrack,
                speed: PlaybackSpeed.regular,
              ),
            ),
          );

          // Verify key components are present
          expect(find.byType(AudioControlButton), findsOneWidget);
          expect(find.byType(StreamAudioWaveformSlider), findsOneWidget);
          expect(find.bySvgIcon(StreamSvgIcons.filetypeAudioM4a), findsOneWidget);
        },
      );

      testWidgets(
        'shows title when enabled',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            _wrapWithStreamChatApp(
              StreamVoiceRecordingAttachment(
                showTitle: true,
                track: fakePlaylistTrack,
                speed: PlaybackSpeed.regular,
              ),
            ),
          );

          // Verify key components are present
          expect(find.text('test.m4a'), findsOneWidget);
          expect(find.byType(AudioTitleText), findsOneWidget);
        },
      );

      testWidgets(
        'shows title when enabled',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            _wrapWithStreamChatApp(
              StreamVoiceRecordingAttachment(
                showTitle: true,
                track: fakePlaylistTrack,
                speed: PlaybackSpeed.regular,
              ),
            ),
          );

          // Verify key components are present
          expect(find.text('test.m4a'), findsOneWidget);
          expect(find.byType(AudioTitleText), findsOneWidget);
        },
      );

      testWidgets(
        'shows control speed button when playing',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            _wrapWithStreamChatApp(
              StreamVoiceRecordingAttachment(
                track: fakePlaylistTrack.copyWith(state: TrackState.playing),
                speed: PlaybackSpeed.regular,
              ),
            ),
          );

          expect(find.text('x1.0'), findsOneWidget);
          expect(find.byType(SpeedControlButton), findsOneWidget);
        },
      );

      testWidgets(
        'handles track play callback',
        (WidgetTester tester) async {
          for (final state in [TrackState.idle, TrackState.paused]) {
            final onTrackPlay = MockVoidCallback();

            await tester.pumpWidget(
              _wrapWithStreamChatApp(
                StreamVoiceRecordingAttachment(
                  track: fakePlaylistTrack.copyWith(state: state),
                  speed: PlaybackSpeed.regular,
                  onTrackPlay: onTrackPlay,
                ),
              ),
            );

            // Simulate play/pause button tap
            await tester.tap(find.byType(AudioControlButton));

            // Verify callbacks
            verify(onTrackPlay).called(1);
          }
        },
      );

      testWidgets(
        'handles track pause callback',
        (WidgetTester tester) async {
          final onTrackPause = MockVoidCallback();

          await tester.pumpWidget(
            _wrapWithStreamChatApp(
              StreamVoiceRecordingAttachment(
                track: fakePlaylistTrack.copyWith(state: TrackState.playing),
                speed: PlaybackSpeed.regular,
                onTrackPause: onTrackPause,
              ),
            ),
          );

          // Simulate play/pause button tap
          await tester.tap(find.byType(AudioControlButton));

          // Verify callbacks
          verify(onTrackPause).called(1);
        },
      );

      testWidgets(
        'handles track seek callback',
        (WidgetTester tester) async {
          final onTrackSeekStart = MockValueChanged<double>();
          final onTrackSeekChanged = MockValueChanged<double>();
          final onTrackSeekEnd = MockValueChanged<double>();

          await tester.pumpWidget(
            _wrapWithStreamChatApp(
              StreamVoiceRecordingAttachment(
                track: fakePlaylistTrack.copyWith(state: TrackState.playing),
                speed: PlaybackSpeed.regular,
                onTrackSeekStart: onTrackSeekStart,
                onTrackSeekChanged: onTrackSeekChanged,
                onTrackSeekEnd: onTrackSeekEnd,
              ),
            ),
          );

          final sliderFinder = find.byType(StreamAudioWaveformSlider);
          final topLeft = tester.getTopLeft(sliderFinder);
          final sliderSize = tester.getSize(sliderFinder);

          // Start gesture
          final gesture = await tester.startGesture(topLeft);
          verify(() => onTrackSeekStart(0)).called(1);

          // Move gesture to the middle of the slider
          await gesture.moveBy(Offset(sliderSize.width * 0.5, 0));
          verify(() => onTrackSeekChanged(0.5)).called(1);

          // Move gesture to the end of the slider
          await gesture.moveBy(Offset(sliderSize.width, 0));
          verify(() => onTrackSeekChanged(1)).called(1);

          // End gesture
          await gesture.up();
          verify(() => onTrackSeekEnd(1)).called(1);
        },
      );

      testWidgets(
        'handles speed change callback',
        (WidgetTester tester) async {
          for (final speed in PlaybackSpeed.values) {
            final onChangeSpeed = MockValueChanged<PlaybackSpeed>();

            await tester.pumpWidget(
              _wrapWithStreamChatApp(
                StreamVoiceRecordingAttachment(
                  track: fakePlaylistTrack.copyWith(state: TrackState.playing),
                  speed: speed,
                  onChangeSpeed: onChangeSpeed,
                ),
              ),
            );

            await tester.tap(find.byType(SpeedControlButton));
            verify(() => onChangeSpeed(speed.next)).called(1);
          }
        },
      );

      testWidgets(
        'custom trailing builder works',
        (WidgetTester tester) async {
          Widget customTrailingBuilder(
            BuildContext context,
            PlaylistTrack track,
            PlaybackSpeed speed,
            ValueChanged<PlaybackSpeed>? onChangeSpeed,
          ) {
            return const StreamSvgIcon(icon: StreamSvgIcons.closeSmall);
          }

          await tester.pumpWidget(
            _wrapWithStreamChatApp(
              StreamVoiceRecordingAttachment(
                track: fakePlaylistTrack,
                speed: PlaybackSpeed.regular,
                trailingBuilder: customTrailingBuilder,
              ),
            ),
          );

          // Verify custom trailing widget is rendered
          expect(find.bySvgIcon(StreamSvgIcons.closeSmall), findsOneWidget);
          expect(find.bySvgIcon(StreamSvgIcons.filetypeAudioM4a), findsNothing);
        },
      );

      for (final brightness in Brightness.values) {
        final theme = brightness.name;
        goldenTest(
          '[$theme] -> should look fine in idle state',
          fileName: 'stream_voice_recording_attachment_idle_$theme',
          constraints: const BoxConstraints.tightFor(width: 412, height: 200),
          builder: () => _wrapWithStreamChatApp(
            brightness: brightness,
            Padding(
              padding: const EdgeInsets.all(8),
              child: StreamVoiceRecordingAttachment(
                showTitle: true,
                track: fakePlaylistTrack,
                speed: PlaybackSpeed.regular,
              ),
            ),
          ),
        );

        goldenTest(
          '[$theme] -> should look fine in playing state',
          fileName: 'stream_voice_recording_attachment_playing_$theme',
          constraints: const BoxConstraints.tightFor(width: 412, height: 200),
          builder: () => _wrapWithStreamChatApp(
            brightness: brightness,
            Padding(
              padding: const EdgeInsets.all(8),
              child: StreamVoiceRecordingAttachment(
                showTitle: true,
                track: fakePlaylistTrack.copyWith(
                  state: TrackState.playing,
                  position: const Duration(seconds: 10),
                ),
                speed: PlaybackSpeed.regular,
              ),
            ),
          ),
        );
      }
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
      child: Builder(
        builder: (context) {
          final theme = StreamChatTheme.of(context);
          return Scaffold(
            backgroundColor: theme.colorTheme.appBg,
            body: Center(child: widget),
          );
        },
      ),
    ),
  );
}
