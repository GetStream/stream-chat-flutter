import '../../../open_api/api.dart' as api;
import '../../core/models/own_user.dart';
import '../../core/models/privacy_settings.dart';
import '../../core/models/response/connect_guest_user_response.dart';
import '../../core/models/user.dart';
import '../../core/util/extension.dart';

// The user and privacy settings mappers in this file build today's `User` class, which has not been restructured
// for the generated client yet and still reads and writes JSON.
// TODO(openapi-migration): Update these mappers when `User` is restructured.

/// Maps a generated [api.UserResponse] to a [User].
extension UserResponseMapper on api.UserResponse {
  /// Converts this response into a [User].
  ///
  /// [custom] becomes [User.extraData], without the keys named after a field of the user's own, so a custom field
  /// never stands in for one of them.
  User toModel() => User(
    id: id,
    role: role,
    name: name,
    image: image,
    createdAt: createdAt,
    updatedAt: updatedAt,
    lastActive: lastActive,
    online: online,
    banned: banned,
    teams: teams,
    language: language,
    teamsRole: teamsRole,
    avgResponseTime: avgResponseTime,
    extraData: {...custom}..removeWhere((key, _) => _shadowedCustomKeys.contains(key)),
  );
}

// Custom keys a user's own fields hide: every field of an [OwnUser], and three the socket connect refuses to take
// back from its user details.
const _shadowedCustomKeys = {...OwnUser.topLevelFields, 'deleted_at', 'deactivated_at', 'revoke_tokens_issued_before'};

/// Maps a [User] to the generated [api.UserRequest].
extension UserRequestMapper on User {
  /// Converts this user into an [api.UserRequest].
  ///
  /// The `name` and `image` keys of [extraData] become their own fields and the rest becomes
  /// [api.UserRequest.custom]. The name is read from [extraData] rather than [name], which falls back to [id].
  ///
  /// The privacy settings of an [OwnUser] are carried over as well.
  api.UserRequest toRequest() => api.UserRequest(
    id: id,
    name: extraData['name'].safeCast<String>(),
    image: extraData['image'].safeCast<String>(),
    language: language,
    invisible: invisible,
    privacySettings: switch (this) {
      OwnUser(:final privacySettings?) => privacySettings.toRequest(),
      _ => null,
    },
    custom: {...extraData}
      ..remove('name')
      ..remove('image'),
  );
}

/// Maps [PrivacySettings] to the generated [api.PrivacySettingsResponse].
extension PrivacySettingsRequestMapper on PrivacySettings {
  /// Converts these settings into an [api.PrivacySettingsResponse].
  api.PrivacySettingsResponse toRequest() => api.PrivacySettingsResponse(
    typingIndicators: switch (typingIndicators) {
      final it? => api.TypingIndicatorsResponse(enabled: it.enabled),
      null => null,
    },
    readReceipts: switch (readReceipts) {
      final it? => api.ReadReceiptsResponse(enabled: it.enabled),
      null => null,
    },
    deliveryReceipts: switch (deliveryReceipts) {
      final it? => api.DeliveryReceiptsResponse(enabled: it.enabled),
      null => null,
    },
  );
}

/// Maps a generated [api.CreateGuestResponse] to a [ConnectGuestUserResponse].
extension CreateGuestResponseMapper on api.CreateGuestResponse {
  /// Converts this response into a [ConnectGuestUserResponse].
  ConnectGuestUserResponse toModel() => ConnectGuestUserResponse(
    duration: duration,
    accessToken: accessToken,
    user: user.toModel(),
  );
}
