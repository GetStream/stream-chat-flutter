import 'dart:async';

/// Extension on [StreamController] to safely add events and errors.
extension StreamControllerX<T> on StreamController<T> {
  /// Safely adds the event to the controller,
  /// Returns early if the controller is closed.
  void safeAdd(T event) {
    if (isClosed) return;
    add(event);
  }

  /// Safely adds the error to the controller,
  /// Returns early if the controller is closed.
  void safeAddError(Object error, [StackTrace? stackTrace]) {
    if (isClosed) return;
    addError(error, stackTrace);
  }
}
