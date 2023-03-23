import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat_flutter/src/attachment/audio/record_controller.dart';

import '../../mocks.dart';

void main() {
  group('Record Controller tests', () {
    test('Init of controller should make it listen for streams', () async {
      final mockRecorder = MockRecorder();
      final stateSubject = BehaviorSubject<RecordState>();
      final amplitudeSubject = BehaviorSubject<Amplitude>();
      const duration = Duration(milliseconds: 100);

      when(mockRecorder.onStateChanged).thenAnswer((_) => stateSubject.stream);
      when(() => mockRecorder.onAmplitudeChanged(duration))
          .thenAnswer((_) => amplitudeSubject.stream);

      stateSubject.sink.add(RecordState.pause);

      final recordController = StreamRecordController(
        audioRecorder: mockRecorder,
        onRecordStateChange: (state) {},
      )..init();

      verify(() => mockRecorder.onAmplitudeChanged(duration)).called(1);
      verify(mockRecorder.onStateChanged).called(1);
      stateSubject.close();
      amplitudeSubject.close();
    });

    test('Start recording should work', () async {
      final mockRecorder = MockRecorder();

      final recordController = StreamRecordController(
        audioRecorder: mockRecorder,
        onRecordStateChange: (state) {},
      );

      await recordController.record();

      verify(mockRecorder.start).called(1);
    });

    test('Pause recording should work', () async {
      final mockRecorder = MockRecorder();

      when(mockRecorder.pause).thenAnswer((_) => Future.value());

      final recordController = StreamRecordController(
        audioRecorder: mockRecorder,
        onRecordStateChange: (state) {},
      );

      await recordController.pauseRecording();

      verify(mockRecorder.pause).called(1);
    });

    test('Init of controller should make it listen for streams', () async {
      final mockRecorder = MockRecorder();
      final stateSubject = BehaviorSubject<RecordState>();
      final amplitudeSubject = BehaviorSubject<Amplitude>();
      const duration = Duration(milliseconds: 100);

      when(mockRecorder.onStateChanged).thenAnswer((_) => stateSubject.stream);
      when(() => mockRecorder.onAmplitudeChanged(duration))
          .thenAnswer((_) => amplitudeSubject.stream);

      stateSubject.sink.add(RecordState.pause);

      final recordController = StreamRecordController(
        audioRecorder: mockRecorder,
        onRecordStateChange: (state) {},
      )..init();

      await Future<void>.delayed(const Duration(milliseconds: 100));
      await recordController.record();

      verify(mockRecorder.resume).called(1);
      stateSubject.close();
      amplitudeSubject.close();
    });

    test('Finish method should work', () async {
      final mockRecorder = MockRecorder();
      final stateSubject = BehaviorSubject<RecordState>();
      final amplitudeSubject = BehaviorSubject<Amplitude>();
      const duration = Duration(milliseconds: 100);

      when(mockRecorder.onStateChanged).thenAnswer((_) => stateSubject.stream);
      when(() => mockRecorder.onAmplitudeChanged(duration))
          .thenAnswer((_) => amplitudeSubject.stream);
      when(mockRecorder.stop).thenAnswer((_) => Future.value('path'));

      final recordController = StreamRecordController(
        audioRecorder: mockRecorder,
        onRecordStateChange: (state) {},
      )..init();

      await Future<void>.delayed(const Duration(milliseconds: 100));

      await recordController.finishRecording();

      verify(mockRecorder.stop).called(1);

      stateSubject.close();
      amplitudeSubject.close();
    });
  });
}
