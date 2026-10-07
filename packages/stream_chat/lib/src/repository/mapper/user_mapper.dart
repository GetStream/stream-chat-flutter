import '../../../open_api/api.dart' as api;
import '../../core/models/own_user.dart';
import '../../core/models/privacy_settings.dart';
import '../../core/models/response/block_user_response.dart';
import '../../core/models/response/create_guest_user_response.dart';
import '../../core/models/response/get_blocked_users_response.dart';
import '../../core/models/response/get_unread_count_response.dart';
import '../../core/models/response/unblock_user_response.dart';
import '../../core/models/unread_counts_channel.dart';
import '../../core/models/unread_counts_channel_type.dart';
import '../../core/models/unread_counts_thread.dart';
import '../../core/models/user.dart';
import '../../core/models/user_block.dart';
import '../../core/util/extension.dart';

// TODO(openapi-migration): re-point these mappers in group 09.

/// Maps a generated [api.UserResponse] to a [User].
extension UserResponseMapper on api.UserResponse {
  // Custom keys named like one of the user's own fields, including the ones [User] does not model.
  static const _shadowedCustomKeys = {
    ...OwnUser.topLevelFields,
    'deleted_at',
    'deactivated_at',
    'revoke_tokens_issued_before',
  };

  /// Converts this response into a [User].
  ///
  /// Custom data named like one of the user's own fields is left out of [User.extraData].
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

/// Maps a [User] to the generated [api.UserRequest].
extension UserRequestMapper on User {
  /// Converts this user into an [api.UserRequest].
  ///
  /// A user without a name or image converts to a request without one, rather than one named after [id]. The
  /// privacy settings of an [OwnUser] are carried over.
  ///
  /// Custom data named like one of the user's own fields is left out.
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
      ..remove('image')
      ..removeWhere((key, _) => UserResponseMapper._shadowedCustomKeys.contains(key)),
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

/// Maps a generated [api.CreateGuestResponse] to a [CreateGuestUserResponse].
extension CreateGuestResponseMapper on api.CreateGuestResponse {
  /// Converts this response into a [CreateGuestUserResponse].
  CreateGuestUserResponse toModel() => CreateGuestUserResponse(
    duration: duration,
    accessToken: accessToken,
    user: user.toModel(),
  );
}

/// Maps a generated [api.WrappedUnreadCountsResponse] to a [GetUnreadCountResponse].
extension WrappedUnreadCountsResponseMapper on api.WrappedUnreadCountsResponse {
  /// Converts this response into a [GetUnreadCountResponse].
  GetUnreadCountResponse toModel() => GetUnreadCountResponse(
    duration: duration,
    totalUnreadCount: totalUnreadCount,
    totalUnreadThreadsCount: totalUnreadThreadsCount,
    totalUnreadCountByTeam: totalUnreadCountByTeam,
    channels: channels.map((channel) => channel.toModel()).toList(),
    channelType: channelType.map((type) => type.toModel()).toList(),
    threads: threads.map((thread) => thread.toModel()).toList(),
  );
}

/// Maps a generated [api.UnreadCountsChannel] to an [UnreadCountsChannel].
extension UnreadCountsChannelMapper on api.UnreadCountsChannel {
  /// Converts these counts into an [UnreadCountsChannel].
  UnreadCountsChannel toModel() => UnreadCountsChannel(
    channelId: channelId,
    unreadCount: unreadCount,
    lastRead: lastRead,
  );
}

/// Maps a generated [api.UnreadCountsThread] to an [UnreadCountsThread].
extension UnreadCountsThreadMapper on api.UnreadCountsThread {
  /// Converts these counts into an [UnreadCountsThread].
  UnreadCountsThread toModel() => UnreadCountsThread(
    unreadCount: unreadCount,
    lastRead: lastRead,
    lastReadMessageId: lastReadMessageId,
    parentMessageId: parentMessageId,
  );
}

/// Maps a generated [api.UnreadCountsChannelType] to an [UnreadCountsChannelType].
extension UnreadCountsChannelTypeMapper on api.UnreadCountsChannelType {
  /// Converts these counts into an [UnreadCountsChannelType].
  UnreadCountsChannelType toModel() => UnreadCountsChannelType(
    channelType: channelType,
    channelCount: channelCount,
    unreadCount: unreadCount,
  );
}

/// Maps a generated [api.BlockUsersResponse] to a [BlockUserResponse].
extension BlockUsersResponseMapper on api.BlockUsersResponse {
  /// Converts this response into a [BlockUserResponse].
  BlockUserResponse toModel() => BlockUserResponse(
    duration: duration,
    blockedByUserId: blockedByUserId,
    blockedUserId: blockedUserId,
    createdAt: createdAt,
  );
}

/// Maps a generated [api.UnblockUsersResponse] to an [UnblockUserResponse].
extension UnblockUsersResponseMapper on api.UnblockUsersResponse {
  /// Converts this response into an [UnblockUserResponse].
  UnblockUserResponse toModel() => UnblockUserResponse(duration: duration);
}

/// Maps a generated [api.GetBlockedUsersResponse] to a [GetBlockedUsersResponse].
extension GetBlockedUsersResponseMapper on api.GetBlockedUsersResponse {
  /// Converts this response into a [GetBlockedUsersResponse].
  GetBlockedUsersResponse toModel() => GetBlockedUsersResponse(
    duration: duration,
    blocks: blocks.map((block) => block.toModel()).toList(),
  );
}

/// Maps a generated [api.BlockedUserResponse] to a [UserBlock].
extension BlockedUserResponseMapper on api.BlockedUserResponse {
  /// Converts this block into a [UserBlock].
  UserBlock toModel() => UserBlock(
    user: user.toModel(),
    blockedUser: blockedUser.toModel(),
    userId: userId,
    blockedUserId: blockedUserId,
    createdAt: createdAt,
  );
}
