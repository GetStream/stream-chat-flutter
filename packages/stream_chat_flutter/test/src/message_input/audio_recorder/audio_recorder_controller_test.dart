// ignore_for_file: cascade_invocations

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:record/record.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat_flutter/src/message_input/audio_recorder/audio_recorder_controller.dart';
import 'package:stream_chat_flutter/src/message_input/audio_recorder/audio_recorder_state.dart';

import '../../fakes.dart';

class MockAudioRecorder extends Mock implements AudioRecorder {}

class MockAmplitude extends Mock implements Amplitude {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAudioRecorder mockRecorder;
  const config = RecordConfig(numChannels: 1);
  late StreamAudioRecorderController controller;
  late PublishSubject<Amplitude> amplitudeController;

  setUpAll(() {
    registerFallbackValue(Duration.zero);
  });

  setUp(() {
    PathProviderPlatform.instance = FakePathProviderPlatform();

    mockRecorder = MockAudioRecorder();
    when(() => mockRecorder.dispose()).thenAnswer((_) async {});

    amplitudeController = PublishSubject<Amplitude>();
    when(() => mockRecorder.onAmplitudeChanged(any()))
        .thenAnswer((_) => amplitudeController.stream);

    controller = StreamAudioRecorderController.raw(
      config: config,
      recorder: mockRecorder,
    );
  });

  tearDown(() {
    amplitudeController.close();
    controller.dispose();
  });

  test('initial state should be idle', () {
    expect(controller.value, isA<RecordStateIdle>());
  });

  group('startRecord', () {
    setUp(() {
      when(() => mockRecorder.start(config, path: any(named: 'path')))
          .thenAnswer((_) async {});
    });

    test(
      'starts recording when permission is granted',
      () async {
        when(() => mockRecorder.hasPermission()).thenAnswer((_) async => true);

        await controller.startRecord();

        expect(controller.value, isA<RecordStateRecordingHold>());
        verify(() => mockRecorder.start(config, path: any(named: 'path')));
      },
    );

    test('does not start recording when permission is denied', () async {
      when(() => mockRecorder.hasPermission()).thenAnswer((_) async => false);

      await controller.startRecord();

      expect(controller.value, isA<RecordStateIdle>());
      verifyNever(() => mockRecorder.start(config, path: any(named: 'path')));
    });
  });

  group('stopRecord', () {
    const pathPrefix = './test/src/message_input/audio_recorder/assets';
    const testPath = '$pathPrefix/audio.m4a';

    setUp(() async {
      when(() => mockRecorder.hasPermission()).thenAnswer((_) async => true);
      when(() => mockRecorder.stop()).thenAnswer((_) async => testPath);
      when(() => mockRecorder.start(config, path: any(named: 'path')))
          .thenAnswer((_) async {});
    });

    test('stops recording and updates state to stopped', () async {
      await controller.startRecord();
      await controller.stopRecord();

      expect(controller.value, isA<RecordStateStopped>());
      verify(() => mockRecorder.stop()).called(1);
    });

    test('includes duration and waveform in stopped state', () async {
      // Simulate some recording time and amplitude changes
      final controller = StreamAudioRecorderController.raw(
        recorder: mockRecorder,
        config: config,
        initialState: const RecordStateRecordingHold(
          duration: Duration(seconds: 5),
          waveform: [0.5, 0.6, 0.7],
        ),
      );

      await controller.startRecord();
      await controller.stopRecord();

      final stoppedState = controller.value as RecordStateStopped;
      expect(stoppedState.audioRecording.extraData['duration'], isNotNull);
      expect(stoppedState.audioRecording.extraData['waveform_data'], isNotNull);
    });
  });

  group('cancelRecord', () {
    setUp(() {
      when(() => mockRecorder.hasPermission()).thenAnswer((_) async => true);
      when(() => mockRecorder.cancel()).thenAnswer((_) async {});
      when(() => mockRecorder.start(config, path: any(named: 'path')))
          .thenAnswer((_) async {});
    });

    test('cancels recording and returns to idle state', () async {
      await controller.startRecord();
      await controller.cancelRecord();

      expect(controller.value, isA<RecordStateIdle>());
      verify(() => mockRecorder.cancel()).called(1);
    });
  });

  group('lockRecord', () {
    test('transitions from hold to locked state', () async {
      final controller = StreamAudioRecorderController.raw(
        recorder: mockRecorder,
        config: config,
        initialState: const RecordStateRecordingHold(),
      );

      controller.lockRecord();

      expect(controller.value, isA<RecordStateRecordingLocked>());
    });

    test('preserves duration and waveform when locking', () async {
      const duration = Duration(seconds: 3);
      final waveform = [0.1, 0.2, 0.3];

      final controller = StreamAudioRecorderController.raw(
        recorder: mockRecorder,
        config: config,
        initialState: RecordStateRecordingHold(
          duration: duration,
          waveform: waveform,
        ),
      );

      controller.lockRecord();

      final lockedState = controller.value as RecordStateRecordingLocked;
      expect(lockedState.duration, duration);
      expect(lockedState.waveform, waveform);
    });
  });

  group('dragRecord', () {
    test('updates drag offset in hold state', () async {
      final controller = StreamAudioRecorderController.raw(
        recorder: mockRecorder,
        config: config,
        initialState: const RecordStateRecordingHold(),
      );

      const dragOffset = Offset(10, 20);
      controller.dragRecord(dragOffset);

      final holdState = controller.value as RecordStateRecordingHold;
      expect(holdState.dragOffset, dragOffset);
    });
  });

  group('showInfo', () {
    test('shows info message in idle state', () {
      const message = 'Test Message';
      controller.showInfo(message);

      final idleState = controller.value as RecordStateIdle;
      expect(idleState.message, message);
    });

    test('clears info message after duration', () async {
      const message = 'Test Message';
      controller.showInfo(message, duration: const Duration(milliseconds: 100));

      await Future.delayed(const Duration(milliseconds: 150));

      final idleState = controller.value as RecordStateIdle;
      expect(idleState.message, isNull);
    });
  });

  group('amplitude changes', () {
    setUp(() {
      when(() => mockRecorder.hasPermission()).thenAnswer((_) async => true);
      when(() => mockRecorder.start(config, path: any(named: 'path')))
          .thenAnswer((_) async {});
    });

    test('updates waveform data when amplitude changes', () async {
      await controller.startRecord();

      final mockAmplitude = MockAmplitude();
      when(() => mockAmplitude.current).thenReturn(-30);
      amplitudeController.add(mockAmplitude);

      // Allow the stream to process
      await Future.delayed(Duration.zero);

      final recordingState = controller.value as RecordStateRecording;
      expect(recordingState.waveform, isNotEmpty);
    });
  });
}
