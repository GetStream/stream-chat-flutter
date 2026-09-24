import '../../../open_api/api.dart' as api;
import '../../core/api/responses.dart';

/// Maps a generated [api.DurationResponse] to an [EmptyResponse].
extension DurationResponseMapper on api.DurationResponse {
  /// Converts this response into an [EmptyResponse].
  EmptyResponse toDomain() => EmptyResponse()..duration = duration;
}
