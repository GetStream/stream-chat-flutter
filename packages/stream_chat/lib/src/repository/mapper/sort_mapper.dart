import 'package:stream_core/stream_core.dart' show Sort;

import '../../../open_api/api.dart' as api;

/// Maps a [Sort] to the generated [api.SortParamRequest].
extension SortMapper on Sort<Object> {
  /// Converts this sort into an [api.SortParamRequest].
  api.SortParamRequest toRequest() => api.SortParamRequest(field: field.remote, direction: direction.value);
}
