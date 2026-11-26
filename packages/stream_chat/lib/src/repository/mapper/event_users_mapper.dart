import 'package:stream_core/stream_core.dart' show Standard;

import '../../../open_api/api.dart' as api;
import '../../core/models/channel_mute.dart';
import '../../core/models/mute.dart';
import '../../core/models/own_user.dart';
import '../../core/models/privacy_settings.dart';
import '../../core/models/push_preference.dart';
import '../../core/models/user.dart';
import 'channels_mapper.dart';
import 'devices_mapper.dart';
import 'users_mapper.dart';

/// Maps a generated [api.UserResponseCommonFields] to a [User].
extension UserResponseCommonFieldsMapper on api.UserResponseCommonFields {
  /// Converts these fields into a [User].
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

/// Maps a generated [api.UserResponsePrivacyFields] to a [User].
extension UserResponsePrivacyFieldsMapper on api.UserResponsePrivacyFields {
  /// Converts these fields into a [User].
  ///
  /// The privacy settings are not part of a [User]; read them from
  /// [privacySettings].
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
    invisible: invisible,
    teamsRole: teamsRole,
    avgResponseTime: avgResponseTime,
    custom: custom,
    deactivatedAt: deactivatedAt,
    deletedAt: deletedAt,
    blockedUserIds: blockedUserIds,
  );
}

/// Maps a generated [api.OwnUserResponse] to an [OwnUser].
extension OwnUserResponseMapper on api.OwnUserResponse {
  /// Converts this response into an [OwnUser].
  ///
  /// A mute missing the user who set it, or the user or channel it mutes, is
  /// left out.
  OwnUser toModel() => OwnUser(
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
    invisible: invisible,
    teamsRole: teamsRole,
    avgResponseTime: avgResponseTime,
    custom: custom,
    deactivatedAt: deactivatedAt,
    deletedAt: deletedAt,
    blockedUserIds: blockedUserIds,
    devices: [for (final device in devices) device.toModel()],
    mutes: [for (final mute in mutes) ?mute.toModel()],
    channelMutes: [for (final mute in channelMutes) ?mute.toModel()],
    totalUnreadCount: totalUnreadCount,
    unreadChannels: unreadChannels,
    unreadThreads: unreadThreads,
    pushPreferences: pushPreferences?.toModel(),
    privacySettings: privacySettings?.toModel(),
  );
}

/// Maps a generated [api.UserMuteResponse] to a [Mute].
extension UserMuteResponseMapper on api.UserMuteResponse {
  /// Converts this response into a [Mute], or `null` when it names no user or
  /// no target.
  Mute? toModel() {
    final user = this.user;
    final target = this.target;
    if (user == null || target == null) return null;

    return Mute(
      user: user.toModel(),
      target: target.toModel(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      expires: expires,
    );
  }
}

/// Maps a generated [api.ChannelMute] to a [ChannelMute].
extension ChannelMuteMapper on api.ChannelMute {
  /// Converts this mute into a [ChannelMute], or `null` when it names no user
  /// or no channel.
  ChannelMute? toModel() {
    final user = this.user;
    final channel = this.channel;
    if (user == null || channel == null) return null;

    return ChannelMute(
      user: user.toModel(),
      channel: channel.toModel(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      expires: expires,
    );
  }
}

/// Maps a generated [api.PushPreferencesResponse] to a [PushPreference].
extension PushPreferencesResponseMapper on api.PushPreferencesResponse {
  /// Converts these preferences into a [PushPreference].
  PushPreference toModel() => PushPreference(
    chatLevel: chatLevel?.let(ChatLevel.new),
    chatPreferences: chatPreferences?.toModel(),
    disabledUntil: disabledUntil,
    schedule: schedule?.toModel(),
  );
}

/// Maps a generated [api.PushScheduleResponse] to a [PushSchedule].
extension PushScheduleResponseMapper on api.PushScheduleResponse {
  /// Converts this schedule into a [PushSchedule].
  PushSchedule toModel() => PushSchedule(
    timezone: timezone,
    quietHours: [for (final rule in quietHours) rule.toModel()],
  );
}

/// Maps a generated [api.QuietHoursRuleResponse] to a [QuietHoursRule].
extension QuietHoursRuleResponseMapper on api.QuietHoursRuleResponse {
  /// Converts this rule into a [QuietHoursRule].
  QuietHoursRule toModel() => QuietHoursRule(
    start: start,
    end: end,
    days: [...?days?.map(QuietHoursDay.new)],
  );
}

/// Maps a generated [api.PrivacySettingsResponse] to [PrivacySettings].
extension PrivacySettingsResponseMapper on api.PrivacySettingsResponse {
  /// Converts these settings into [PrivacySettings].
  PrivacySettings toModel() => PrivacySettings(
    typingIndicators: typingIndicators?.let((it) => TypingIndicators(enabled: it.enabled)),
    readReceipts: readReceipts?.let((it) => ReadReceipts(enabled: it.enabled)),
    deliveryReceipts: deliveryReceipts?.let((it) => DeliveryReceipts(enabled: it.enabled)),
  );
}
