import 'package:stream_core/stream_core.dart' show Sort;

import '../../../open_api/api.dart' as api;

/// Maps a [Sort] to the generated [api.SortParamRequest].
extension SortRequestMapper<T extends Object> on Sort<T> {
  /// Converts this sort into an [api.SortParamRequest].
  api.SortParamRequest toRequest() {
    return api.SortParamRequest(
      field: field.remote,
      direction: direction.value,
    );
  }
}
