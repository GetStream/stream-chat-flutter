import 'package:flutter/widgets.dart';

/// A feedback handler for audio recorder interactions.
///
/// Provides default feedback behavior (haptic feedback, system sounds, etc.)
/// and can be used directly, or extended to customize feedback behavior.
///
/// {@tool snippet}
/// Basic usage with default feedback:
/// ```dart
/// const AudioRecorderFeedback()
/// ```
///
/// Disable feedback:
/// ```dart
/// const AudioRecorderFeedback.disabled()
/// ```
///
/// Custom feedback (haptic or system sounds):
/// ```dart
/// class CustomFeedback extends AudioRecorderFeedback {
///   @override
///   Future<void> onRecordStart(BuildContext context) async {
///     // Haptic feedback
///     await HapticFeedback.heavyImpact();
///     // Or system sound
///     // await SystemSound.play(SystemSoundType.click);
///   }
/// }
///
/// CustomFeedback()
/// ```
/// {@end-tool}
class AudioRecorderFeedback {
  /// Creates a new [AudioRecorderFeedback] instance.
  ///
  /// The [enableFeedback] parameter controls whether feedback is enabled.
  /// Defaults to `true`.
  const AudioRecorderFeedback({this.enableFeedback = true});

  /// Creates a new [AudioRecorderFeedback] instance with feedback disabled.
  ///
  /// Use this constructor to disable feedback entirely.
  const AudioRecorderFeedback.disabled() : enableFeedback = false;

  /// Whether feedback is enabled.
  ///
  /// If `false`, no feedback will be triggered regardless of which methods are
  /// called.
  final bool enableFeedback;

  /// Provides platform-specific feedback when recording starts.
  ///
  /// This is called when the user initiates a new recording session and the
  /// recording actually begins.
  Future<void> onRecordStart(BuildContext context) async {
    if (!enableFeedback) return;
    return Feedback.forLongPress(context);
  }

  /// Provides platform-specific feedback when recording is paused.
  ///
  /// This is called when the user pauses the ongoing recording.
  Future<void> onRecordPause(BuildContext context) async {
    if (!enableFeedback) return;
    return Feedback.forTap(context);
  }

  /// Provides platform-specific feedback when recording is finished.
  ///
  /// This is called when the user finishes the recording.
  Future<void> onRecordFinish(BuildContext context) async {
    if (!enableFeedback) return;
    return Feedback.forTap(context);
  }

  /// Provides platform-specific feedback when the recording is locked.
  ///
  /// This is called when the user locks the recording to continue without
  /// holding the record button.
  Future<void> onRecordLock(BuildContext context) async {
    if (!enableFeedback) return;
    return Feedback.forLongPress(context);
  }

  /// Provides platform-specific feedback when recording is canceled.
  ///
  /// This is called when the user cancels an ongoing recording.
  Future<void> onRecordCancel(BuildContext context) async {
    if (!enableFeedback) return;
    return Feedback.forTap(context);
  }

  /// Provides platform-specific feedback when recording is canceled before
  /// starting.
  ///
  /// This can occur if the user holds the record button but releases it before
  /// the recording actually starts.
  Future<void> onRecordStartCancel(BuildContext context) async {
    if (!enableFeedback) return;
    return Feedback.forTap(context);
  }

  /// Provides platform-specific feedback when recording stops.
  ///
  /// This is called when the recording is finalized and the audio track
  /// is now ready to be used.
  Future<void> onRecordStop(BuildContext context) async {
    if (!enableFeedback) return;
    return Feedback.forTap(context);
  }
}
