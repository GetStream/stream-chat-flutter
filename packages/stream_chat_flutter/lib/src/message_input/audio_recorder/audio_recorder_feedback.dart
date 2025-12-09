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

// A callback function for providing feedback during audio recorder interaction.
typedef _FeedbackCallback = Future<void> Function(BuildContext context);

/// A wrapper around [AudioRecorderFeedback] that allows providing custom
/// callbacks for each feedback event without extending the class.
///
/// This is useful when you want to customize feedback behavior using callbacks
/// rather than extending [AudioRecorderFeedback] and overriding methods.
///
/// {@tool snippet}
/// Basic usage with custom callbacks:
/// ```dart
/// AudioRecorderFeedbackWrapper(
///   onStart: (context) async {
///     await HapticFeedback.heavyImpact();
///   },
///   onFinish: (context) async {
///     await HapticFeedback.mediumImpact();
///   },
/// )
/// ```
///
/// Disable feedback:
/// ```dart
/// AudioRecorderFeedbackWrapper(
///   enableFeedback: false,
/// )
/// ```
/// {@end-tool}
class AudioRecorderFeedbackWrapper extends AudioRecorderFeedback {
  /// Creates a new [AudioRecorderFeedbackWrapper] instance.
  ///
  /// The [enableFeedback] parameter controls whether feedback is enabled.
  /// Defaults to `true`.
  ///
  /// All callback parameters are optional. If a callback is not provided, the
  /// default behavior from [AudioRecorderFeedback] will be used.
  ///
  /// - [onStart]: Called when recording starts.
  /// - [onPause]: Called when recording is paused.
  /// - [onFinish]: Called when recording is finished.
  /// - [onLock]: Called when recording is locked.
  /// - [onCancel]: Called when recording is canceled.
  /// - [onStartCancel]: Called when recording start is canceled.
  /// - [onStop]: Called when recording stops.
  const AudioRecorderFeedbackWrapper({
    super.enableFeedback = true,
    _FeedbackCallback? onStart,
    _FeedbackCallback? onPause,
    _FeedbackCallback? onFinish,
    _FeedbackCallback? onLock,
    _FeedbackCallback? onCancel,
    _FeedbackCallback? onStartCancel,
    _FeedbackCallback? onStop,
  })  : _onStop = onStop,
        _onStartCancel = onStartCancel,
        _onCancel = onCancel,
        _onLock = onLock,
        _onFinish = onFinish,
        _onPause = onPause,
        _onStart = onStart;

  // Callback for when recording starts.
  final _FeedbackCallback? _onStart;
  // Callback for when recording is paused.
  final _FeedbackCallback? _onPause;
  // Callback for when recording is finished.
  final _FeedbackCallback? _onFinish;
  // Callback for when recording is locked.
  final _FeedbackCallback? _onLock;
  // Callback for when recording is canceled.
  final _FeedbackCallback? _onCancel;
  // Callback for when recording start is canceled.
  final _FeedbackCallback? _onStartCancel;
  // Callback for when recording stops.
  final _FeedbackCallback? _onStop;

  @override
  Future<void> onRecordStart(BuildContext context) async {
    if (_onStart case final callback?) {
      if (!enableFeedback) return;
      return callback.call(context);
    }

    return super.onRecordStart(context);
  }

  @override
  Future<void> onRecordPause(BuildContext context) async {
    if (_onPause case final callback?) {
      if (!enableFeedback) return;
      return callback.call(context);
    }

    return super.onRecordPause(context);
  }

  @override
  Future<void> onRecordFinish(BuildContext context) async {
    if (_onFinish case final callback?) {
      if (!enableFeedback) return;
      return callback.call(context);
    }

    return super.onRecordFinish(context);
  }

  @override
  Future<void> onRecordLock(BuildContext context) async {
    if (_onLock case final callback?) {
      if (!enableFeedback) return;
      return callback.call(context);
    }

    return super.onRecordLock(context);
  }

  @override
  Future<void> onRecordCancel(BuildContext context) async {
    if (_onCancel case final callback?) {
      if (!enableFeedback) return;
      return callback.call(context);
    }

    return super.onRecordCancel(context);
  }

  @override
  Future<void> onRecordStartCancel(BuildContext context) async {
    if (_onStartCancel case final callback?) {
      if (!enableFeedback) return;
      return callback.call(context);
    }

    return super.onRecordStartCancel(context);
  }

  @override
  Future<void> onRecordStop(BuildContext context) async {
    if (_onStop case final callback?) {
      if (!enableFeedback) return;
      return callback.call(context);
    }

    return super.onRecordStop(context);
  }
}
