import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/src/misc/audio_waveform.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  group('StreamAudioWaveformSlider', () {
    // Prepare random waveform data
    final waveformData = generateStaticWaveform(length: 30);

    testWidgets('Handles seek interactions', (WidgetTester tester) async {
      final onChangeStart = MockValueChanged<double>();
      final onChanged = MockValueChanged<double>();
      final onChangeEnd = MockValueChanged<double>();

      await tester.pumpWidget(
        _wrapWithMaterialApp(
          ConstrainedBox(
            constraints: const BoxConstraints.tightFor(width: 300, height: 50),
            child: StreamAudioWaveformSlider(
              limit: 35,
              waveform: waveformData,
              onChangeStart: onChangeStart,
              onChanged: onChanged,
              onChangeEnd: onChangeEnd,
            ),
          ),
        ),
      );

      final topLeft = tester.getTopLeft(find.byType(StreamAudioWaveformSlider));

      // Start gesture
      final gesture = await tester.startGesture(topLeft);
      verify(() => onChangeStart(0)).called(1);

      // Move gesture to the middle of the slider
      await gesture.moveBy(const Offset(150, 0));
      verify(() => onChanged(0.5)).called(1);

      // Move gesture to the end of the slider
      await gesture.moveBy(const Offset(300, 0));
      verify(() => onChanged(1)).called(1);

      // End gesture
      await gesture.up();
      verify(() => onChangeEnd(1)).called(1);
    });

    for (final brightness in Brightness.values) {
      final theme = brightness.name;

      goldenTest(
        '[$theme] -> should look fine',
        fileName: 'stream_audio_waveform_slider_$theme',
        constraints: const BoxConstraints.tightFor(width: 300, height: 50),
        builder: () => _wrapWithMaterialApp(
          brightness: brightness,
          Padding(
            padding: const EdgeInsets.all(8),
            child: StreamAudioWaveformSlider(
              limit: 30,
              waveform: waveformData,
              onChanged: (double value) {},
            ),
          ),
        ),
      );

      goldenTest(
        '[$theme] -> should paint waveform bars inverted',
        fileName: 'stream_audio_waveform_slider_inverted_$theme',
        constraints: const BoxConstraints.tightFor(width: 300, height: 50),
        builder: () => _wrapWithMaterialApp(
          brightness: brightness,
          Padding(
            padding: const EdgeInsets.all(8),
            child: StreamAudioWaveformSlider(
              limit: 30,
              inverse: false,
              waveform: waveformData,
              onChanged: (double value) {},
            ),
          ),
        ),
      );

      goldenTest(
        '[$theme] -> should look fine with progress',
        fileName: 'stream_audio_waveform_slider_progress_$theme',
        constraints: const BoxConstraints.tightFor(width: 300, height: 50),
        builder: () => _wrapWithMaterialApp(
          brightness: brightness,
          Padding(
            padding: const EdgeInsets.all(8),
            child: StreamAudioWaveformSlider(
              limit: 30,
              progress: 0.5,
              waveform: waveformData,
              onChanged: (double value) {},
            ),
          ),
        ),
      );

      goldenTest(
        '[$theme] -> should look fine with custom properties',
        fileName: 'stream_audio_waveform_slider_custom_$theme',
        constraints: const BoxConstraints.tightFor(width: 300, height: 50),
        builder: () => _wrapWithMaterialApp(
          brightness: brightness,
          Padding(
            padding: const EdgeInsets.all(8),
            child: StreamAudioWaveformSlider(
              limit: 30,
              color: Colors.blue,
              progress: 0.5,
              progressColor: Colors.green,
              waveform: waveformData,
              onChanged: (double value) {},
            ),
          ),
        ),
      );

      goldenTest(
        '[$theme] -> should build empty waveform if no data',
        fileName: 'stream_audio_waveform_slider_empty_$theme',
        constraints: const BoxConstraints.tightFor(width: 300, height: 50),
        builder: () => _wrapWithMaterialApp(
          brightness: brightness,
          Padding(
            padding: const EdgeInsets.all(8),
            child: StreamAudioWaveformSlider(
              limit: 30,
              waveform: const [],
              onChanged: (double value) {},
            ),
          ),
        ),
      );

      goldenTest(
        '[$theme] -> should build empty waveform if less data',
        fileName: 'stream_audio_waveform_slider_less_data_$theme',
        constraints: const BoxConstraints.tightFor(width: 300, height: 50),
        builder: () => _wrapWithMaterialApp(
          brightness: brightness,
          Padding(
            padding: const EdgeInsets.all(8),
            child: StreamAudioWaveformSlider(
              limit: 50,
              waveform: waveformData,
              onChanged: (double value) {},
            ),
          ),
        ),
      );
    }
  });
}

List<double> generateStaticWaveform({
  int length = 35,
}) {
  // A predefined pattern that mimics audio signal variations
  final basePattern = [
    0.2,
    0.4,
    0.6,
    0.3,
    0.5,
    0.7,
    0.1,
    0.8,
    0.2,
    0.6,
    0.4,
    0.9,
    0.3,
    0.7,
    0.5,
    0.2,
    0.8,
    0.1,
    0.6,
    0.4,
    0.7,
    0.3,
    0.5,
    0.2,
    0.8,
    0.1,
    0.6,
    0.4,
    0.7,
    0.3,
    0.5,
    0.2,
    0.8,
    0.1,
    0.6,
  ];

  // Ensure the returned list matches the requested length
  return basePattern.take(length).toList();
}

Widget _wrapWithMaterialApp(
  Widget widget, {
  Brightness? brightness,
}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
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
