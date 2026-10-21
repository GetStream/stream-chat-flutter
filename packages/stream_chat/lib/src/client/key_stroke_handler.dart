import 'dart:async';

import 'package:stream_core/stream_core.dart' show Failure, Result;

/// A class that manages buffering typing events and call [onStartTyping] and
/// [onStopTyping] accordingly in a timed manner.
///
/// This class is used by [Channel] to manage typing events.
class KeyStrokeHandler {
  /// Creates a new instance of [KeyStrokeHandler].
  KeyStrokeHandler({
    this.startTypingEventTimeout = 1,
    this.startTypingResendInterval = 3,
    required this.onStartTyping,
    required this.onStopTyping,
  });

  /// The number of seconds from the last [onStartTyping] callback until
  /// the [onStopTyping] callback is automatically invoked.
  final int startTypingEventTimeout;

  /// The number of seconds after the last [onStartTyping] callback before
  /// the [onStartTyping] callback is automatically invoked again.
  final int startTypingResendInterval;

  /// Called when a typing start event is due.
  ///
  /// A failure it returns cancels the scheduled stop and completes [call] with
  /// it.
  final Future<Result<void>> Function([String? parentId]) onStartTyping;

  /// Called when a typing stop event is due.
  ///
  /// A failure it returns completes the pending [call] with it.
  final Future<Result<void>> Function([String? parentId]) onStopTyping;

  Timer? _keyStrokeTimer;
  String? _currentParentId;
  DateTime? _lastTypingEvent;
  Completer<Result<void>>? _keyStrokeCompleter;

  Future<Result<void>> _startTyping(String? parentId) {
    _currentParentId = parentId;
    _lastTypingEvent = DateTime.now();
    return onStartTyping(parentId);
  }

  Future<Result<void>> _stopTyping(String? parentId) {
    _currentParentId = null;
    _lastTypingEvent = null;
    return onStopTyping(parentId);
  }

  // Completes the key stroke completer with a success if it is not yet
  // completed.
  void _completeKeyStrokeCompleterIfRequired() {
    final completer = _keyStrokeCompleter;
    if (completer != null && !completer.isCompleted) completer.complete(const Result.success(null));
  }

  // Completes the completer if available and not yet completed then creates a
  // new completer and returns it.
  Completer<Result<void>> _resetKeyStrokeCompleter() {
    _completeKeyStrokeCompleterIfRequired();
    return _keyStrokeCompleter = Completer<Result<void>>();
  }

  // Cancels the key stroke timer if it is running.
  void _cancelKeyStrokeTimer() {
    _keyStrokeTimer?.cancel();
    _keyStrokeTimer = null;
  }

  /// Cancels the handler and stops the typing event.
  void cancel() {
    // If the user is typing, stop typing.
    // This is needed to prevent the user from being stuck in typing mode.
    if (_lastTypingEvent != null) _stopTyping(_currentParentId).ignore();
    _cancelKeyStrokeTimer();
    _completeKeyStrokeCompleterIfRequired();
  }

  /// Invokes the [onStartTyping] callback and schedules a timer to invoke the
  /// [onStopTyping] callback.
  ///
  /// This is meant to be called every time the user presses a key. The method
  /// will manage requests and timer as needed.
  ///
  /// Completes with the result of the [onStopTyping] call this schedules, or
  /// with a success when a later key stroke or [cancel] takes over first.
  /// Completes early with the failure of [onStartTyping], which also cancels
  /// the scheduled stop. An error either callback throws completes this with
  /// that error.
  Future<Result<void>> call([String? parentId]) async {
    final completer = _resetKeyStrokeCompleter();

    _cancelKeyStrokeTimer();

    final keyStrokeTimer = _keyStrokeTimer = Timer(Duration(seconds: startTypingEventTimeout), () {
      _stopTyping(parentId).then(
        (result) {
          if (!completer.isCompleted) completer.complete(result);
        },
        onError: (Object error, StackTrace stackTrace) {
          if (!completer.isCompleted) completer.completeError(error, stackTrace);
        },
      );
    });

    // If the user is typing too long, it should call [onStartTyping] again.
    final now = DateTime.now();
    final lastTypingEvent = _lastTypingEvent;
    if (lastTypingEvent == null ||
        now.difference(lastTypingEvent).inMilliseconds >
            // startTypingResendInterval in milliseconds
            startTypingResendInterval * 1000) {
      // A start that fails cancels the stop it scheduled, but not one a later
      // key stroke scheduled since.
      void cancelOwnStop() {
        if (identical(_keyStrokeTimer, keyStrokeTimer)) _cancelKeyStrokeTimer();
      }

      _startTyping(parentId).then(
        (result) {
          if (result is! Failure) return;
          cancelOwnStop();
          if (!completer.isCompleted) completer.complete(result);
        },
        onError: (Object error, StackTrace stackTrace) {
          cancelOwnStop();
          if (!completer.isCompleted) completer.completeError(error, stackTrace);
        },
      );
    }

    return completer.future;
  }
}
