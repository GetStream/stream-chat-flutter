import 'dart:async';

/// A class that manages buffering typing events and call [onTypingStarted] and
/// [onTypingStopped] accordingly in a timed manner.
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

  /// Called when a `typingStart` event needs to be send.
  final Future<void> Function([String? parentId]) onStartTyping;

  /// Called when a `typingStop` event needs to be send.
  final Future<void> Function([String? parentId]) onStopTyping;

  Timer? _keyStrokeTimer;
  String? _currentParentId;
  DateTime? _lastTypingEvent;
  Completer<void>? _keyStrokeCompleter;

  Future<void> _startTyping(String? parentId) {
    _currentParentId = parentId;
    _lastTypingEvent = DateTime.now();
    return onStartTyping(parentId);
  }

  Future<void> _stopTyping(String? parentId) {
    _currentParentId = null;
    _lastTypingEvent = null;
    return onStopTyping(parentId);
  }

  // Completes the key stroke completer if it is not yet completed.
  void _completeKeyStrokeCompleterIfRequired() {
    final completer = _keyStrokeCompleter;
    if (completer != null && !completer.isCompleted) completer.complete();
  }

  // Completes the completer if available and not yet completed then creates a
  // new completer and returns it.
  Completer<void> _resetKeyStrokeCompleter() {
    _completeKeyStrokeCompleterIfRequired();
    return _keyStrokeCompleter = Completer<void>();
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
    if (_lastTypingEvent != null) {
      // We don't need to handle the error here
      // ignore: no-empty-block
      _stopTyping(_currentParentId).catchError((_) {});
    }
    _cancelKeyStrokeTimer();
    _completeKeyStrokeCompleterIfRequired();
  }

  /// Invokes the [onStartTyping] callback and schedules a timer to invoke the
  /// [onStopTyping] callback.
  ///
  /// This is meant to be called every time the user presses a key. The method
  /// will manage requests and timer as needed.
  Future<void> call([String? parentId]) async {
    final completer = _resetKeyStrokeCompleter();

    _cancelKeyStrokeTimer();

    _keyStrokeTimer = Timer(Duration(seconds: startTypingEventTimeout), () {
      _stopTyping(parentId).then((_) {
        if (completer.isCompleted) return;
        completer.complete();
      }).onError((error, stackTrace) {
        if (completer.isCompleted) return;
        completer.completeError(error!, stackTrace);
      });
    });

    // If the user is typing too long, it should call [onStartTyping] again.
    final now = DateTime.now();
    final lastTypingEvent = _lastTypingEvent;
    if (lastTypingEvent == null ||
        now.difference(lastTypingEvent).inMilliseconds >
            // startTypingResendInterval in milliseconds
            startTypingResendInterval * 1000) {
      _startTyping(parentId).onError((error, stackTrace) {
        _cancelKeyStrokeTimer();
        if (completer.isCompleted) return;
        completer.completeError(error!, stackTrace);
      });
    }

    return completer.future;
  }
}
