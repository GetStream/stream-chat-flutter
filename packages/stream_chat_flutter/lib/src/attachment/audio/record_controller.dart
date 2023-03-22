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
class RecordController {
  /// {@macro WaveBarsNormalizer}
  RecordController({
    required this.audioRecorder,
    required this.onRecordStateChange,
  });

  /// Actual Recorder class
  final Record audioRecorder;

  /// Function called when record state changes.
  final void Function(RecordState) onRecordStateChange;

  /// A Stream that provides the amplitude variation of the record.
  Stream<Amplitude> get amplitudeStream => _amplitudeController.stream;

  final _stopwatch = Stopwatch();
  final _amplitudeController = BehaviorSubject<Amplitude>();
  StreamSink<Amplitude>? _amplitudeSink;

  StreamSubscription<RecordState>? _recordStateSubscription;
  Stream<RecordState>? _recordStateStream;

  late WaveBarsNormalizer? _waveBarsNormalizer;
  RecordState _recordingState = RecordState.stop;

  /// Stream that provides the current record state.
  Stream<RecordState>? get recordState => _recordStateStream;

  /// Docs
  void init() {
    _recordStateStream = audioRecorder.onStateChanged();
    _recordStateSubscription = _recordStateStream?.listen((state) {
      _recordingState = state;
      onRecordStateChange(state);
    });

    _amplitudeSink = _amplitudeController.sink;
    _amplitudeSink?.addStream(audioRecorder.onAmplitudeChanged(
      const Duration(milliseconds: 100),
    ));

    _waveBarsNormalizer = WaveBarsNormalizer(
      barsStream: _amplitudeController.stream,
    );
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
  Future<void> pauseRecording() {
    _stopwatch.stop();
    return audioRecorder.pause();
  }

  /// Cancel recording. Once cancelled, the recording can't be resumed.
  Future<void> cancelRecording() {
    _waveBarsNormalizer?.reset();
    return audioRecorder.stop();
  }

  /// Finishes recording and returns the audio file as an attachment.
  Future<Attachment?> finishRecording() async {
    final recordDuration = _stopwatch.elapsed;
    final path = await audioRecorder.stop();

    if (path != null) {
      final uri = Uri.parse(path);
      final file = File(uri.path);

      final waveList = _waveBarsNormalizer?.normalizedBars(30);
      _waveBarsNormalizer?.reset();

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
    } else {
      return null;
    }
  }

  /// Disposes the controller.
  void dispose() {
    audioRecorder.dispose().then((value) {
      _amplitudeSink?.close();
      _amplitudeController.close();
    });

    _recordStateSubscription?.cancel();
  }
}
