import '../../../open_api/api.dart' as api;
import '../../core/models/own_user.dart';
import '../../core/models/privacy_settings.dart';
import '../../core/models/request/update_user_partial_request.dart';
import '../../core/models/response/block_users_response.dart';
import '../../core/models/response/create_guest_user_response.dart';
import '../../core/models/response/get_blocked_users_response.dart';
import '../../core/models/response/get_unread_count_response.dart';
import '../../core/models/response/unblock_users_response.dart';
import '../../core/models/response/update_users_response.dart';
import '../../core/models/unread_counts_channel.dart';
import '../../core/models/unread_counts_channel_type.dart';
import '../../core/models/unread_counts_thread.dart';
import '../../core/models/user.dart';
import '../../core/models/user_block.dart';

// TODO(openapi-migration): re-point these mappers in group 09.

/// Maps a generated [api.UserResponse] to a [User].
extension UserResponseMapper on api.UserResponse {
  /// Converts this response into a [User].
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
    custom: custom,
    deactivatedAt: deactivatedAt,
    deletedAt: deletedAt,
    blockedUserIds: blockedUserIds,
  );
}

/// Maps a generated [api.FullUserResponse] to a [User].
extension FullUserResponseMapper on api.FullUserResponse {
  /// Converts this response into a [User].
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
    banExpires: banExpires,
    teams: teams,
    language: language,
    invisible: invisible,
    teamsRole: teamsRole,
    avgResponseTime: avgResponseTime,
    custom: custom,
    deactivatedAt: deactivatedAt,
    deletedAt: deletedAt,
    shadowBanned: shadowBanned,
    blockedUserIds: blockedUserIds,
  );
}

/// Maps a [User] to the generated [api.UserRequest].
extension UserRequestMapper on User {
  /// Converts this user into an [api.UserRequest].
  ///
  /// The privacy settings of an [OwnUser] are carried over.
  api.UserRequest toRequest() => api.UserRequest(
    id: id,
    name: name,
    image: image,
    language: language,
    invisible: invisible,
    privacySettings: switch (this) {
      OwnUser(:final privacySettings?) => privacySettings.toRequest(),
      _ => null,
    },
    custom: custom,
  );
}

/// Maps [PrivacySettings] to the generated [api.PrivacySettingsResponse].
///
/// The generated client names the settings a request sends [api.PrivacySettingsResponse], too.
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

/// Maps a generated [api.WrappedUnreadCountsResponse] to a
/// [GetUnreadCountResponse].
extension WrappedUnreadCountsResponseMapper on api.WrappedUnreadCountsResponse {
  /// Converts this response into a [GetUnreadCountResponse].
  GetUnreadCountResponse toModel() => GetUnreadCountResponse(
    duration: duration,
    totalUnreadCount: totalUnreadCount,
    totalUnreadThreadsCount: totalUnreadThreadsCount,
    totalUnreadCountByTeam: totalUnreadCountByTeam,
    channels: [for (final channel in channels) channel.toModel()],
    channelType: [for (final type in channelType) type.toModel()],
    threads: [for (final thread in threads) thread.toModel()],
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

/// Maps a generated [api.UnreadCountsChannelType] to an
/// [UnreadCountsChannelType].
extension UnreadCountsChannelTypeMapper on api.UnreadCountsChannelType {
  /// Converts these counts into an [UnreadCountsChannelType].
  UnreadCountsChannelType toModel() => UnreadCountsChannelType(
    channelType: channelType,
    channelCount: channelCount,
    unreadCount: unreadCount,
  );
}

/// Maps a generated [api.BlockUsersResponse] to a [BlockUsersResponse].
extension BlockUsersResponseMapper on api.BlockUsersResponse {
  /// Converts this response into a [BlockUsersResponse].
  BlockUsersResponse toModel() => BlockUsersResponse(
    duration: duration,
    blockedByUserId: blockedByUserId,
    blockedUserId: blockedUserId,
    createdAt: createdAt,
  );
}

/// Maps a generated [api.UnblockUsersResponse] to an [UnblockUsersResponse].
extension UnblockUsersResponseMapper on api.UnblockUsersResponse {
  /// Converts this response into an [UnblockUsersResponse].
  UnblockUsersResponse toModel() => UnblockUsersResponse(duration: duration);
}

/// Maps a generated [api.GetBlockedUsersResponse] to a
/// [GetBlockedUsersResponse].
extension GetBlockedUsersResponseMapper on api.GetBlockedUsersResponse {
  /// Converts this response into a [GetBlockedUsersResponse].
  GetBlockedUsersResponse toModel() => GetBlockedUsersResponse(
    duration: duration,
    blocks: [for (final block in blocks) block.toModel()],
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

/// Maps a generated [api.UpdateUsersResponse] to an [UpdateUsersResponse].
extension UpdateUsersResponseMapper on api.UpdateUsersResponse {
  /// Converts this response into an [UpdateUsersResponse].
  UpdateUsersResponse toModel() => UpdateUsersResponse(
    duration: duration,
    users: users.map((id, user) => MapEntry(id, user.toModel())),
  );
}

/// Maps an [UpdateUserPartialRequest] to the generated [api.UpdateUserPartialRequest].
extension UpdateUserPartialRequestMapper on UpdateUserPartialRequest {
  /// Converts this update into an [api.UpdateUserPartialRequest].
  api.UpdateUserPartialRequest toRequest() => api.UpdateUserPartialRequest(id: id, set: set, unset: unset);
}
