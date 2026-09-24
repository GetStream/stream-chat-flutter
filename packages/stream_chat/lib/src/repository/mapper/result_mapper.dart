import 'package:stream_core/stream_core.dart' show PatternMatching, Result;

/// Maps a [Result] to one that carries no value.
extension ResultMapper<T> on Result<T> {
  /// Converts this result into a [Result] with no value.
  ///
  /// A failure is returned as it is, with its error and stack trace.
  Result<void> ignoreResult() => map((_) {});
}
