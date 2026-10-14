import '../../../open_api/api.dart' as api;
import '../../core/models/delete_type.dart';
import '../../core/models/response/flag_response.dart';
import '../../core/models/response/mute_users_response.dart';
import '../../core/models/response/unmute_users_response.dart';

/// Maps a generated [api.MuteResponse] to a [MuteUsersResponse].
extension MuteResponseMapper on api.MuteResponse {
  /// Converts this response into a [MuteUsersResponse].
  MuteUsersResponse toModel() => MuteUsersResponse(
    duration: duration,
    nonExistingUsers: nonExistingUsers ?? const [],
  );
}

/// Maps a generated [api.UnmuteResponse] to an [UnmuteUsersResponse].
extension UnmuteResponseMapper on api.UnmuteResponse {
  /// Converts this response into an [UnmuteUsersResponse].
  UnmuteUsersResponse toModel() => UnmuteUsersResponse(
    duration: duration,
    nonExistingUsers: nonExistingUsers ?? const [],
  );
}

/// Maps a generated [api.FlagItemResponse] to a [FlagResponse].
extension FlagItemResponseMapper on api.FlagItemResponse {
  /// Converts this response into a [FlagResponse].
  FlagResponse toModel() => FlagResponse(
    duration: duration,
    itemId: itemId,
  );
}

/// Maps a [DeleteType] to the generated request type.
extension DeleteTypeMapper on DeleteType {
  /// Converts this treatment into an [api.BanRequestDeleteMessages].
  api.BanRequestDeleteMessages toRequest() => api.BanRequestDeleteMessages.fromJson(rawType);
}
