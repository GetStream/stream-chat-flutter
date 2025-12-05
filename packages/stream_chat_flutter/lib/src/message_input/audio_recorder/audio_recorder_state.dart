import 'dart:ui';

import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// The state of the audio recorder.
sealed class AudioRecorderState {
  const AudioRecorderState._();
}

/// {@template recordStateIdle}
/// The audio recorder is currently idle and not recording any audio track.
///
/// Optionally, provide a [message] to display when the recorder is idle.
///
/// For example, when the user has not long pressed the record button long
/// enough to start recording.
/// {@endtemplate}
final class RecordStateIdle extends AudioRecorderState {
  /// {@macro recordStateIdle}
  const RecordStateIdle({this.message}) : super._();

  /// The optional message to display when the recorder is idle.
  final String? message;
}

/// {@template recordStateRecording}
/// The audio recorder is currently recording an audio track.
/// {@endtemplate}
sealed class RecordStateRecording extends AudioRecorderState {
  /// {@macro recordStateRecording}
  const RecordStateRecording({
    this.duration = Duration.zero,
    this.waveform = const [],
  }) : super._();

  /// The current duration of the audio track being recorded.
  ///
  /// Defaults to [Duration.zero].
  final Duration duration;

  /// The waveform of the audio track being recorded.
  ///
  /// Defaults to an empty list.
  final List<double> waveform;

  /// Creates a copy of this [RecordStateRecording] but with the given fields
  /// replaced by the new values.
  RecordStateRecording copyWith({
    Duration? duration,
    List<double>? waveform,
  }) {
    return switch (this) {
      RecordStateRecordingHold() => RecordStateRecordingHold(
          duration: duration ?? this.duration,
          waveform: waveform ?? this.waveform,
        ),
      RecordStateRecordingLocked() => RecordStateRecordingLocked(
          duration: duration ?? this.duration,
          waveform: waveform ?? this.waveform,
        ),
    };
  }
}

/// {@template recordStateRecordingHold}
/// The audio recorder is currently recording an audio track in a hold state.
/// {@endtemplate}
final class RecordStateRecordingHold extends RecordStateRecording {
  /// {@macro recordStateRecordingHold}
  const RecordStateRecordingHold({
    super.duration = Duration.zero,
    super.waveform = const [],
    this.dragOffset = Offset.zero,
  });

  /// The drag offset of the recorder if it is being dragged.
  ///
  /// Defaults to [Offset.zero].
  final Offset dragOffset;

  /// Creates a copy of this [RecordStateRecordingHold] but with the given
  /// fields replaced by the new values.
  @override
  RecordStateRecordingHold copyWith({
    String? path,
    Duration? duration,
    List<double>? waveform,
    Offset? dragOffset,
  }) {
    return RecordStateRecordingHold(
      duration: duration ?? this.duration,
      waveform: waveform ?? this.waveform,
      dragOffset: dragOffset ?? this.dragOffset,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordStateRecordingHold &&
          runtimeType == other.runtimeType &&
          duration == other.duration &&
          waveform == other.waveform &&
          dragOffset == other.dragOffset;

  @override
  int get hashCode => Object.hash(duration, waveform, dragOffset);
}

/// {@template recordStateRecordingLocked}
/// The audio recorder is currently recording an audio track in a locked state.
/// {@endtemplate}
final class RecordStateRecordingLocked extends RecordStateRecording {
  /// {@macro recordStateRecordingLocked}
  const RecordStateRecordingLocked({
    super.duration = Duration.zero,
    super.waveform = const [],
  });
}

/// {@template recordStateStopped}
/// The audio recorder has stopped recording and has a recorded audio track.
/// {@endtemplate}
final class RecordStateStopped extends AudioRecorderState {
  /// {@macro recordStateStopped}
  const RecordStateStopped({
    required this.audioRecording,
  }) : super._();

  /// The audio recording that was recorded.
  final Attachment audioRecording;
}
