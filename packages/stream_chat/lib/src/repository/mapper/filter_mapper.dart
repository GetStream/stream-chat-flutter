import 'package:stream_core/stream_core.dart' show Filter;

/// Maps a [Filter] to the filter of a generated request.
extension FilterRequestMapper<T extends Object> on Filter<T> {
  /// Converts this filter into the map a generated request takes.
  Map<String, Object?> toRequest() => toJson();
}
