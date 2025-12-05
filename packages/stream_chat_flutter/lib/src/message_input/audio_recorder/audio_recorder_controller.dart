import 'dart:async';
import 'dart:ui';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/src/audio/audio_sampling.dart' as sampling;
import 'package:stream_chat_flutter/src/message_input/audio_recorder/audio_recorder_state.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@template streamAudioRecorderController}
/// A controller for recording audio tracks. It provides methods to start,
/// stop, cancel and finish the recording session.
///
/// This controller uses the [AudioRecorder] to record audio tracks. It listens
/// to the recorder state changes and updates the [AudioRecorderState]
/// accordingly.
/// {@endtemplate}
class StreamAudioRecorderController extends ValueNotifier<AudioRecorderState> {
  /// {@macro streamAudioRecorderController}
  factory StreamAudioRecorderController({
    RecordConfig? config,
    Duration amplitudeInterval = const Duration(milliseconds: 100),
  }) {
    return StreamAudioRecorderController.raw(
      recorder: AudioRecorder(),
      amplitudeInterval: amplitudeInterval,
      config: switch (config) {
        final config? => config,
        _ => const RecordConfig(
            numChannels: 1,
            encoder: kIsWeb ? AudioEncoder.wav : AudioEncoder.aacLc,
          ),
      },
    );
  }

  /// {@macro streamAudioRecorderController}
  @visibleForTesting
  StreamAudioRecorderController.raw({
    required this.config,
    required AudioRecorder recorder,
    AudioRecorderState initialState = const RecordStateIdle(),
    Duration amplitudeInterval = const Duration(milliseconds: 100),
  })  : _recorder = recorder,
        super(initialState) {
    // Listen to the recorder amplitude changes
    _recorderAmplitudeSubscription = _recorder
        .onAmplitudeChanged(amplitudeInterval) //
        .listen(_onRecorderAmplitudeChanged);
  }

  /// The configuration for the recording session.
  final RecordConfig config;
  final AudioRecorder _recorder;

  /// Starts a new recording session.
  Future<void> startRecord() async {
    // Only start the recorder if it is currently idle.
    if (value case RecordStateIdle()) {
      // Return if the recorder does not have permission to record audio.
      final hasPermission = await _recorder.hasPermission();
      if (!hasPermission) return;

      // Start the recording session.
      final tempPath = await _getOutputFilePath(config.encoder);
      await _recorder.start(config, path: tempPath);
      _startDurationTimer();

      // Update the state to recording hold.
      value = const RecordStateRecordingHold();
    }
  }

  /// Stops the current recording session and returns the recorded audio track.
  ///
  /// Optionally, provide a [name] for the recorded audio attachment.
  ///
  /// Note: [name] only works on web platform.
  Future<void> stopRecord({String? name}) async {
    // Only stop the recorder if it is currently recording.
    if (value case final RecordStateRecording state) {
      final path = await _recorder.stop();

      // Stop the duration timer.
      _durationTimer?.cancel();
      _durationTimer = null;

      if (path == null) throw Exception('Failed to stop the recorder');
      final fileName = name ?? 'audio.${config.encoder.extension}';
      final attachment = await state.toAttachment(path: path, name: fileName);

      // Update the state to stopped.
      value = RecordStateStopped(audioRecording: attachment);
    }
  }

  /// Similar to [stopRecord] but does not update any state. Returns the
  /// recorded audio track as an attachment.
  ///
  /// Optionally, you can provide a [name] for the attachment.
  ///
  /// Note: [name] only works on web platform.
  Future<Attachment?> finishRecord({String? name}) async {
    // Return the audio recording directly if it is already stopped.
    if (value case RecordStateStopped(audioRecording: final recording)) {
      return recording;
    }

    // Finish the recorder if it is currently recording.
    if (value case final RecordStateRecording state) {
      final path = await _recorder.stop();

      // Stop the duration timer.
      _durationTimer?.cancel();
      _durationTimer = null;

      if (path == null) throw Exception('Failed to stop the recorder');
      final fileName = name ?? 'audio.${config.encoder.extension}';
      final attachment = await state.toAttachment(path: path, name: fileName);

      return attachment;
    }

    return null;
  }

  /// Cancels the current recording session and discards the recorded track.
  ///
  /// Pass [discardTrack] as `false` to keep the recorded track, This is useful
  /// when you want to cancel the recording session without losing the recorded
  /// track.
  Future<void> cancelRecord({bool discardTrack = true}) async {
    // Only cancel the recorder if it is currently recording or stopped.
    if (value case RecordStateRecording() || RecordStateStopped()) {
      if (discardTrack) await _recorder.cancel();

      // Update the state to idle.
      value = const RecordStateIdle();
    }
  }

  /// Updates the current recording session in the locked state, no longer
  /// requiring the user to hold the button.
  void lockRecord() {
    // Only lock the recorder if it is currently recording in the hold state.
    if (value case final RecordStateRecordingHold state) {
      // Update the state to recording locked.
      value = RecordStateRecordingLocked(
        duration: state.duration,
        waveform: state.waveform,
      );
    }
  }

  /// Updates the drag offset of the recording session.
  void dragRecord(Offset dragOffset) {
    // Only update the offset if it is currently recording in the hold state.
    if (value case final RecordStateRecordingHold state) {
      // Update the drag offset.
      value = state.copyWith(dragOffset: dragOffset);
    }
  }

  Timer? _infoTimer;

  /// Shows an info message to the user for the given [duration].
  ///
  /// This is useful for showing messages like "Hold to record" or "Recording".
  void showInfo(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    // Only show the info message if the recorder is currently idle.
    if (value case final RecordStateIdle state) {
      // Do not show the same message if it is already being shown.
      if (state.message == message) return;

      // Cancel the previous info timer.
      _infoTimer?.cancel();
      _infoTimer = null;

      // Update the state to show the info message.
      value = RecordStateIdle(message: message);

      // Start a timer to hide the info message after the given duration.
      _infoTimer = Timer(duration, () {
        // Only hide the info message if it is still being shown.
        if (value case RecordStateIdle()) value = const RecordStateIdle();
      });
    }
  }

  Future<String> _getOutputFilePath(AudioEncoder encoder) async {
    // Ignored on web platform.
    if (CurrentPlatform.isWeb) return '';

    // Generate a temporary path for the audio recording.
    final tempDir = await getTemporaryDirectory();
    final currentTimestamp = DateTime.now().millisecondsSinceEpoch;
    return '${tempDir.path}/audio_$currentTimestamp.${encoder.extension}';
  }

  StreamSubscription<Amplitude>? _recorderAmplitudeSubscription;
  void _onRecorderAmplitudeChanged(Amplitude amplitude) {
    // Only update the waveform if the recorder is currently recording.
    if (value case final RecordStateRecording state) {
      final normalizedAmplitude = amplitude.current.normalize(-60, 0);
      final updatedWaveForm = [...state.waveform, normalizedAmplitude];
      value = state.copyWith(waveform: updatedWaveForm);
    }
  }

  Timer? _durationTimer;
  void _startDurationTimer() {
    _durationTimer ??= Timer.periodic(const Duration(seconds: 1), (_) {
      if (value case final RecordStateRecording state) {
        final updatedDuration = state.duration + const Duration(seconds: 1);
        value = state.copyWith(duration: updatedDuration);
      }
    });
  }

  @override
  void dispose() {
    _durationTimer?.cancel();
    _durationTimer = null;
    _recorderAmplitudeSubscription?.cancel();
    _recorder.dispose();
    super.dispose();
  }
}

extension on RecordStateRecording {
  /// Converts the current recording state to an attachment.
  ///
  /// Optionally, provide a [name] for the attachment.
  ///
  /// Note: [name] only works on web platform.
  Future<Attachment> toAttachment({
    required String path,
    String? name,
  }) async {
    final attachmentFile = await XFile(path, name: name).toAttachmentFile;

    final attachment = Attachment(
      file: attachmentFile,
      type: AttachmentType.voiceRecording,
      extraData: {
        'duration': duration.inMilliseconds / 1000,
        'waveform_data': sampling.resampleWaveformData(waveform, 100),
      },
    );

    return attachment;
  }
}

extension on double {
  /// Normalizes the value between the given [lowerBound] and [upperBound].
  double normalize(double lowerBound, double upperBound) {
    if (this < lowerBound) return 0;
    if (this >= upperBound) return 1;

    final delta = upperBound - lowerBound;
    return ((this - lowerBound) / delta).abs();
  }
}

extension on AudioEncoder {
  /// Returns the file extension for the audio encoder.
  String get extension {
    return switch (this) {
      AudioEncoder.opus => 'opus',
      AudioEncoder.flac => 'flac',
      AudioEncoder.wav => 'wav',
      AudioEncoder.pcm16bits => 'pcm',
      AudioEncoder.amrNb || AudioEncoder.amrWb => '3gp',
      AudioEncoder.aacLc || AudioEncoder.aacEld || AudioEncoder.aacHe => 'm4a',
    };
  }
}
