import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart' as audio_recorder;

/// A callback called when the user starts recording an audio message.
typedef OnRecordingStart = void Function();

/// A callback called when the user ends recording an audio message.
typedef OnRecordingEnd = void Function();

/// A callback called when the user cancels recording an audio message.
typedef OnRecordingCanceled = void Function();

/// A callback called when the user locks the recording.
typedef OnRecordingLocked = void Function();

/// The controller for the recording
abstract class StreamRecordingController extends ChangeNotifier {
  /// Creates a new StreamRecordingController
  StreamRecordingController({
    this.onRecordingStart,
    this.onRecordingEnd,
    this.onRecordingCanceled,
    this.onRecordingLocked,
  });

  /// The callback called when the user long presses the button.
  final OnRecordingStart? onRecordingStart;

  /// The callback called when the user stops pressing the button.
  final OnRecordingEnd? onRecordingEnd;

  /// The callback called when the user locks the recording.
  final OnRecordingLocked? onRecordingLocked;

  /// The callback called when the user cancels the recording.
  final OnRecordingCanceled? onRecordingCanceled;

  /// Cancels the recording
  Future<void> cancel();

  /// Stops the recording
  Future<void> stop();

  /// Starts the recording
  Future<void> record();

  /// Updates the recording
  Future<void> lock();

  /// Whether the recording is currently active
  bool get isRecording;

  /// Whether the recording is currently locked
  bool get isLocked;

  /// The duration of the recording
  Duration get duration;
}

/// The controller for the recording
class StreamDefaultRecordingController extends StreamRecordingController {
  /// Creates a new StreamRecordingController
  StreamDefaultRecordingController({
    super.onRecordingStart,
    super.onRecordingEnd,
    super.onRecordingCanceled,
    super.onRecordingLocked,
    audio_recorder.AudioRecorder? audioRecorder,
    this.recordConfig = const StreamRecordConfig(),
  }) : _audioRecorder = audioRecorder ?? audio_recorder.AudioRecorder();

  /// The configuration for the recording
  final StreamRecordConfig recordConfig;

  @override
  bool get isRecording => _isRecording;
  bool _isRecording = false;

  @override
  bool get isLocked => _isLocked;
  bool _isLocked = false;

  @override
  Duration get duration => _duration;
  Duration _duration = Duration.zero;

  String? _path;
  Timer? _timer;

  final audio_recorder.AudioRecorder _audioRecorder;

  @override
  Future<void> cancel() async {
    if (_isRecording) {
      await stop();
    }
    _isLocked = false;
    _duration = Duration.zero;
    _path = null;
    onRecordingCanceled?.call();
    notifyListeners();
  }

  @override
  Future<void> record() async {
    try {
      if (!(await _audioRecorder.hasPermission())) {}

      _path = await _setPath();
      await _audioRecorder.start(
        const audio_recorder.RecordConfig(),
        path: _path!,
      );

      _startTimer();

      _isRecording = await _audioRecorder.isRecording();

      onRecordingStart?.call();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> lock() async {
    onRecordingLocked?.call();

    _isLocked = true;

    notifyListeners();
  }

  @override
  Future<void> stop() async {
    if (await _audioRecorder.isRecording()) {
      _path = await _audioRecorder.stop();
    }

    onRecordingEnd?.call();

    _isRecording = false;
    _timer?.cancel();
    _duration = Duration.zero;

    notifyListeners();
  }

  Future<String> _setPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(
      dir.path,
      'audio_${DateTime.now().millisecondsSinceEpoch}.${recordConfig.encoder.fileExtension}',
    );
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _duration = _duration + const Duration(seconds: 1);
      notifyListeners();
    });
  }
}

/// Recoding configuration
class StreamRecordConfig {
  /// Creates a new StreamRecordConfig
  const StreamRecordConfig({
    this.encoder = StreamAudioEncoder.aacLc,
    this.bitRate = 128000,
    this.sampleRate = 44100,
    this.numChannels = 2,
    this.device,
    this.autoGain = false,
    this.echoCancel = false,
    this.noiseSuppress = false,
  });

  /// The audio encoder to be used for recording.
  final StreamAudioEncoder encoder;

  /// The audio encoding bit rate in bits per second.
  final int bitRate;

  /// The sample rate for audio in samples per second.
  final int sampleRate;

  /// The numbers of channels for the recording.
  final int numChannels;

  /// The device to be used for recording.
  /// If null, default device will be selected.
  final StreamInputDevice? device;

  /// The recorder will try to auto adjust recording volume in a limited range.
  final bool autoGain;

  /// The recorder will try to reduce echo.
  final bool echoCancel;

  /// The recorder will try to negates the input noise.
  final bool noiseSuppress;

  /// Converts the config to a map
  Map<String, dynamic> toMap() {
    return {
      'encoder': encoder.name,
      'bitRate': bitRate,
      'sampleRate': sampleRate,
      'numChannels': numChannels,
      'device': device?.toMap(),
      'autoGain': autoGain,
      'echoCancel': echoCancel,
      'noiseSuppress': noiseSuppress,
    };
  }
}

/// Audio encoder to be used for recording.
enum StreamAudioEncoder {
  /// MPEG-4 AAC Low complexity
  /// Will output to MPEG_4 format container.
  ///
  /// Suggested file extension: `m4a`
  aacLc,

  /// MPEG-4 AAC Enhanced Low Delay
  /// Will output to MPEG_4 format container.
  ///
  /// Suggested file extension: `m4a`
  aacEld,

  /// MPEG-4 High Efficiency AAC (Version 2 if available)
  /// Will output to MPEG_4 format container.
  ///
  /// Suggested file extension: `m4a`
  aacHe,

  /// The AMR (Adaptive Multi-Rate) narrow band speech.
  /// sampling rate should be set to 8kHz.
  /// Will output to 3GP format container on Android.
  ///
  /// Suggested file extension: `3gp`
  amrNb,

  /// The AMR (Adaptive Multi-Rate) wide band speech.
  /// sampling rate should be set to 16kHz.
  /// Will output to 3GP format container on Android.
  ///
  /// Suggested file extension: `3gp`
  amrWb,

  /// Will output to MPEG_4 format container.
  ///
  /// SDK 29 on Android
  ///
  /// SDK 11 on iOs
  ///
  /// Suggested file extension: `opus`
  opus,

  /// Free Lossless Audio Codec
  ///
  /// /// Suggested file extension: `flac`
  flac,

  /// Waveform Audio (pcm16bit with headers)
  ///
  /// Suggested file extension: `wav`
  wav,

  /// Linear PCM 16 bit per sample
  ///
  /// Suggested file extension: `pcm`
  pcm16bits;

  /// The suggested file extension for the encoder
  String get fileExtension => {
        StreamAudioEncoder.aacLc: 'm4a',
        StreamAudioEncoder.aacEld: 'm4a',
        StreamAudioEncoder.aacHe: 'm4a',
        StreamAudioEncoder.amrNb: '3gp',
        StreamAudioEncoder.amrWb: '3gp',
        StreamAudioEncoder.opus: 'opus',
        StreamAudioEncoder.flac: 'flac',
        StreamAudioEncoder.wav: 'wav',
        StreamAudioEncoder.pcm16bits: 'pcm',
      }[this]!;
}

/// Input device for recording
class StreamInputDevice {
  /// Creates a new InputDevice
  const StreamInputDevice({
    required this.id,
    required this.label,
  });

  /// The ID used to select the device on the platform.
  final String id;

  /// The label text representation.
  final String label;

  /// Converts the device to a map
  factory StreamInputDevice.fromMap(Map map) => StreamInputDevice(
        id: map['id'],
        label: map['label'],
      );

  /// Converts the device to a map
  Map<String, dynamic> toMap() => {
        'id': id,
        'label': label,
      };

  @override
  String toString() {
    return '''
      id: $id
      label: $label
      ''';
  }
}
