import 'package:record/record.dart';

/// Docs
class RecordTimeTracker {
  final _stopwatch = Stopwatch();
  var _lastDuration = Duration.zero;

  /// Docs
  void start() {
    _stopwatch.start();
  }

  /// Docs
  void pause() {
    _stopwatch.stop();
    _lastDuration = _stopwatch.elapsed;
  }

  /// Docs
  void stop() {
    _stopwatch.stop();
    _lastDuration = _stopwatch.elapsed;
    _stopwatch.reset();
  }

  /// Docs
  Duration tracked() {
    return _lastDuration;
  }

  /// Docs
  Duration elapsed() {
    return _stopwatch.elapsed;
  }

  /// Docs
  void recordState(RecordState recordState) {
    switch (recordState) {
      case RecordState.record:
        start();
        break;
      case RecordState.pause:
        pause();
        break;
      case RecordState.stop:
        stop();
        break;
    }
  }
}
