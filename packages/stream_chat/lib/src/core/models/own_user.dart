import 'package:json_annotation/json_annotation.dart';

import '../../../stream_chat.dart';
import '../util/serializer.dart';
import 'converters/v1_json_converters.dart';

part 'own_user.g.dart';

/// The class that defines the own user model.
///
/// This object can be found in [Event].
@JsonSerializable(includeIfNull: false)
class OwnUser extends User {
  /// Constructor used for json serialization.
  OwnUser({
    this.devices = const [],
    this.mutes = const [],
    this.totalUnreadCount = 0,
    this.unreadChannels = 0,
    this.channelMutes = const [],
    this.unreadThreads = 0,
    super.blockedUserIds,
    this.pushPreferences,
    this.privacySettings,
    required super.id,
    super.role,
    super.name,
    super.image,
    super.createdAt,
    super.updatedAt,
    super.lastActive,
    super.online,
    super.custom,
    super.banned,
    super.banExpires,
    super.teams,
    super.language,
    super.invisible,
    super.teamsRole,
    super.avgResponseTime,
    super.deactivatedAt,
    super.deletedAt,
    super.shadowBanned,
  });

  /// Create a new instance from json.
  factory OwnUser.fromJson(Map<String, dynamic> json) => _$OwnUserFromJson(
    Serializer.moveToExtraDataFromRoot(json, topLevelFields),
  );

  /// Creates an [OwnUser] from [user].
  ///
  /// If [user] is already an [OwnUser], it is returned unchanged; otherwise the
  /// fields only an own user has are left at their defaults.
  factory OwnUser.fromUser(User user) => switch (user) {
    final OwnUser ownUser => ownUser,
    _ => OwnUser(
      id: user.id,
      role: user.role,
      name: user.name,
      image: user.image,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      lastActive: user.lastActive,
      online: user.online,
      custom: user.custom,
      banned: user.banned,
      banExpires: user.banExpires,
      teams: user.teams,
      language: user.language,
      invisible: user.invisible,
      teamsRole: user.teamsRole,
      avgResponseTime: user.avgResponseTime,
      deactivatedAt: user.deactivatedAt,
      deletedAt: user.deletedAt,
      shadowBanned: user.shadowBanned,
      blockedUserIds: user.blockedUserIds,
    ),
  };

  /// Creates a copy of [OwnUser] with specified attributes overridden.
  @override
  OwnUser copyWith({
    String? id,
    String? role,
    String? name,
    String? image,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastActive,
    bool? online,
    Map<String, Object?>? custom,
    bool? banned,
    DateTime? banExpires,
    List<String>? teams,
    List<ChannelMute>? channelMutes,
    List<Device>? devices,
    List<Mute>? mutes,
    List<String>? blockedUserIds,
    int? totalUnreadCount,
    int? unreadChannels,
    int? unreadThreads,
    String? language,
    bool? invisible,
    Map<String, String>? teamsRole,
    int? avgResponseTime,
    PushPreference? pushPreferences,
    PrivacySettings? privacySettings,
    DateTime? deactivatedAt,
    DateTime? deletedAt,
    bool? shadowBanned,
  }) => OwnUser(
    id: id ?? this.id,
    role: role ?? this.role,
    name: name ?? this.name,
    image: image ?? this.image,
    banned: banned ?? this.banned,
    banExpires: banExpires ?? this.banExpires,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lastActive: lastActive ?? this.lastActive,
    online: online ?? this.online,
    custom: custom ?? this.custom,
    teams: teams ?? this.teams,
    channelMutes: channelMutes ?? this.channelMutes,
    devices: devices ?? this.devices,
    mutes: mutes ?? this.mutes,
    totalUnreadCount: totalUnreadCount ?? this.totalUnreadCount,
    unreadChannels: unreadChannels ?? this.unreadChannels,
    unreadThreads: unreadThreads ?? this.unreadThreads,
    blockedUserIds: blockedUserIds ?? this.blockedUserIds,
    language: language ?? this.language,
    invisible: invisible ?? this.invisible,
    teamsRole: teamsRole ?? this.teamsRole,
    avgResponseTime: avgResponseTime ?? this.avgResponseTime,
    pushPreferences: pushPreferences ?? this.pushPreferences,
    privacySettings: privacySettings ?? this.privacySettings,
    deactivatedAt: deactivatedAt ?? this.deactivatedAt,
    deletedAt: deletedAt ?? this.deletedAt,
    shadowBanned: shadowBanned ?? this.shadowBanned,
  );

  /// Returns a new [OwnUser] that is a combination of this ownUser
  /// and the given [other] ownUser.
  OwnUser merge(OwnUser? other) {
    if (other == null) return this;
    return OwnUser(
      id: other.id,
      role: other.role ?? role,
      name: other.name ?? name,
      image: other.image ?? image,
      banned: other.banned,
      banExpires: banExpires,
      channelMutes: other.channelMutes,
      createdAt: other.createdAt ?? createdAt,
      devices: other.devices,
      custom: other.custom,
      lastActive: other.lastActive ?? lastActive,
      mutes: other.mutes,
      online: other.online,
      teams: other.teams,
      totalUnreadCount: other.totalUnreadCount,
      unreadChannels: other.unreadChannels,
      unreadThreads: other.unreadThreads,
      blockedUserIds: other.blockedUserIds,
      updatedAt: other.updatedAt ?? updatedAt,
      language: other.language ?? language,
      invisible: other.invisible ?? invisible,
      teamsRole: other.teamsRole ?? teamsRole,
      avgResponseTime: other.avgResponseTime ?? avgResponseTime,
      pushPreferences: other.pushPreferences ?? pushPreferences,
      privacySettings: other.privacySettings ?? privacySettings,
      deactivatedAt: other.deactivatedAt,
      deletedAt: other.deletedAt,
      shadowBanned: other.shadowBanned,
    );
  }

  /// The devices registered for this user to receive push notifications.
  @DeviceV1JsonConverter()
  final List<Device> devices;

  /// List of users muted by the user.
  final List<Mute> mutes;

  /// List of channels muted by the user.
  final List<ChannelMute> channelMutes;

  /// Total unread messages by the user.
  final int totalUnreadCount;

  /// Total unread channels by the user.
  final int unreadChannels;

  /// Total unread threads by the user.
  final int unreadThreads;

  /// Push preferences for the user if set.
  final PushPreference? pushPreferences;

  /// Privacy settings for the user if set.
  final PrivacySettings? privacySettings;

  /// Serializes this user to JSON.
  ///
  /// Writes the entries of [custom] at the root, leaving out any named like one
  /// of [topLevelFields].
  @override
  Map<String, dynamic> toJson() {
    return Serializer.moveFromExtraDataToRoot(_$OwnUserToJson(this), topLevelFields: topLevelFields);
  }

  /// The JSON keys [OwnUser.fromJson] reads into named fields, or leaves out.
  ///
  /// Every other key is kept in [custom].
  static const topLevelFields = [
    'devices',
    'mutes',
    'channel_mutes',
    'total_unread_count',
    'unread_channels',
    'unread_threads',
    'push_preferences',
    'privacy_settings',
    ...User.topLevelFields,
  ];
}

/// Extension methods for [OwnUser] related to privacy settings.
extension PrivacySettingsExtension on OwnUser {
  /// Whether typing indicators are enabled for the user.
  bool get isTypingIndicatorsEnabled {
    final typingIndicators = privacySettings?.typingIndicators;
    if (typingIndicators == null) return true;

    return typingIndicators.enabled;
  }

  /// Whether read receipts are enabled for the user.
  bool get isReadReceiptsEnabled {
    final readIndicators = privacySettings?.readReceipts;
    if (readIndicators == null) return true;

    return readIndicators.enabled;
  }

  /// Whether delivery receipts are enabled for the user.
  bool get isDeliveryReceiptsEnabled {
    final deliveryIndicators = privacySettings?.deliveryReceipts;
    if (deliveryIndicators == null) return true;

    return deliveryIndicators.enabled;
  }
}
