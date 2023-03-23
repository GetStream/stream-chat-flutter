import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:record/record.dart';
import 'package:rxdart/subjects.dart';
import 'package:stream_chat_flutter/src/attachment/audio/wave_bars_normalizer.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template recordController}
/// Controller of audio record
/// {@endtemplate}
class StreamRecordController {
  /// {@macro WaveBarsNormalizer}
  StreamRecordController({required this.audioRecorder});

  /// Actual Recorder class
  final Record audioRecorder;

  final _stopwatch = Stopwatch();
  final _amplitudeController = BehaviorSubject<Amplitude>();
  final _recordStateController = BehaviorSubject<RecordState>();
  StreamSink<Amplitude>? _amplitudeSink;
  StreamSink<RecordState>? _recordStateSink;

  StreamSubscription<RecordState>? _recordStateSubscription;

  WaveBarsNormalizer? _waveBarsNormalizer;
  RecordState _recordingState = RecordState.stop;

  /// Stream that provides the current record state.
  Stream<RecordState> get recordState => _recordStateController.stream;

  /// A Stream that provides the amplitude variation of the record.
  Stream<Amplitude> get amplitudeStream => _amplitudeController.stream;

  /// Docs
  void init() {
    _amplitudeSink = _amplitudeController.sink;
    _amplitudeSink?.addStream(
      audioRecorder.onAmplitudeChanged(
        const Duration(milliseconds: 100),
      ),
    );

    _recordStateSink = _recordStateController.sink;
    _recordStateSink?.addStream(audioRecorder.onStateChanged());

    _recordStateSubscription = recordState.listen((state) {
      _recordingState = state;
    });

    _waveBarsNormalizer = WaveBarsNormalizer(barsStream: amplitudeStream);
  }

  /// Starts recording
  Future<void> record() async {
    try {
      if (await audioRecorder.hasPermission()) {
        if (_recordingState == RecordState.stop) {
          HapticFeedback.heavyImpact();
          await audioRecorder.start();
          _stopwatch
            ..reset()
            ..start();

          _waveBarsNormalizer?.start();
        } else if (_recordingState == RecordState.pause) {
          await audioRecorder.resume();
          _stopwatch.start();
        }
      }
    } catch (e) {
      print(e);
    }
  }

  /// Pause recording. Recording can be resume by calling record().
  Future<void> pauseRecording() async {
    _stopwatch.stop();
    await audioRecorder.pause();
  }

  /// Cancel recording. Once cancelled, the recording can't be resumed.
  Future<void> cancelRecording() async {
    _waveBarsNormalizer?.reset();
    await audioRecorder.stop();
  }

  /// Finishes recording and returns the audio file as an attachment.
  Future<Attachment?> finishRecording() async {
    final recordDuration = _stopwatch.elapsed;
    final path = await audioRecorder.stop();

    if (path != null) {
      final uri = Uri.parse(path);
      final file = File(uri.path);

      final waveList = _waveBarsNormalizer?.normalizedBars(40);
      _waveBarsNormalizer?.reset();

      try {
        final fileSize = await file.length();
        return Attachment(
          type: 'audio_recording',
          file: AttachmentFile(
            size: fileSize,
            path: uri.path,
          ),
          extraData: {
            'duration': recordDuration.inMilliseconds,
            'waveList': waveList,
          },
        );
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }

  /// Disposes the controller.
  void dispose() {
    audioRecorder.dispose().then((value) {
      _amplitudeSink?.close();
      _amplitudeController.close();
      _recordStateController.close();
    });

    _recordStateSubscription?.cancel();
  }
}
