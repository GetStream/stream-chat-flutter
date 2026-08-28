// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'full_user_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FullUserResponse {
  int? get avgResponseTime;
  DateTime? get banExpires;
  bool get banned;
  List<String> get blockedUserIds;
  List<ChannelMute> get channelMutes;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get deactivatedAt;
  DateTime? get deletedAt;
  List<DeviceResponse> get devices;
  String get id;
  String? get image;
  bool get invisible;
  String get language;
  DateTime? get lastActive;
  List<String>? get latestHiddenChannels;
  List<UserMuteResponse> get mutes;
  String? get name;
  bool get online;
  PrivacySettingsResponse? get privacySettings;
  DateTime? get revokeTokensIssuedBefore;
  String get role;
  bool get shadowBanned;
  List<String> get teams;
  Map<String, String>? get teamsRole;
  int get totalUnreadCount;
  int get unreadChannels;
  int get unreadCount;
  int get unreadThreads;
  DateTime get updatedAt;

  /// Create a copy of FullUserResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FullUserResponseCopyWith<FullUserResponse> get copyWith =>
      _$FullUserResponseCopyWithImpl<FullUserResponse>(
        this as FullUserResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FullUserResponse &&
            (identical(other.avgResponseTime, avgResponseTime) ||
                other.avgResponseTime == avgResponseTime) &&
            (identical(other.banExpires, banExpires) ||
                other.banExpires == banExpires) &&
            (identical(other.banned, banned) || other.banned == banned) &&
            const DeepCollectionEquality().equals(
              other.blockedUserIds,
              blockedUserIds,
            ) &&
            const DeepCollectionEquality().equals(
              other.channelMutes,
              channelMutes,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.deactivatedAt, deactivatedAt) ||
                other.deactivatedAt == deactivatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            const DeepCollectionEquality().equals(other.devices, devices) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.invisible, invisible) ||
                other.invisible == invisible) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.lastActive, lastActive) ||
                other.lastActive == lastActive) &&
            const DeepCollectionEquality().equals(
              other.latestHiddenChannels,
              latestHiddenChannels,
            ) &&
            const DeepCollectionEquality().equals(other.mutes, mutes) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.online, online) || other.online == online) &&
            (identical(other.privacySettings, privacySettings) ||
                other.privacySettings == privacySettings) &&
            (identical(
                  other.revokeTokensIssuedBefore,
                  revokeTokensIssuedBefore,
                ) ||
                other.revokeTokensIssuedBefore == revokeTokensIssuedBefore) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.shadowBanned, shadowBanned) ||
                other.shadowBanned == shadowBanned) &&
            const DeepCollectionEquality().equals(other.teams, teams) &&
            const DeepCollectionEquality().equals(other.teamsRole, teamsRole) &&
            (identical(other.totalUnreadCount, totalUnreadCount) ||
                other.totalUnreadCount == totalUnreadCount) &&
            (identical(other.unreadChannels, unreadChannels) ||
                other.unreadChannels == unreadChannels) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.unreadThreads, unreadThreads) ||
                other.unreadThreads == unreadThreads) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    avgResponseTime,
    banExpires,
    banned,
    const DeepCollectionEquality().hash(blockedUserIds),
    const DeepCollectionEquality().hash(channelMutes),
    createdAt,
    const DeepCollectionEquality().hash(custom),
    deactivatedAt,
    deletedAt,
    const DeepCollectionEquality().hash(devices),
    id,
    image,
    invisible,
    language,
    lastActive,
    const DeepCollectionEquality().hash(latestHiddenChannels),
    const DeepCollectionEquality().hash(mutes),
    name,
    online,
    privacySettings,
    revokeTokensIssuedBefore,
    role,
    shadowBanned,
    const DeepCollectionEquality().hash(teams),
    const DeepCollectionEquality().hash(teamsRole),
    totalUnreadCount,
    unreadChannels,
    unreadCount,
    unreadThreads,
    updatedAt,
  ]);

  @override
  String toString() {
    return 'FullUserResponse(avgResponseTime: $avgResponseTime, banExpires: $banExpires, banned: $banned, blockedUserIds: $blockedUserIds, channelMutes: $channelMutes, createdAt: $createdAt, custom: $custom, deactivatedAt: $deactivatedAt, deletedAt: $deletedAt, devices: $devices, id: $id, image: $image, invisible: $invisible, language: $language, lastActive: $lastActive, latestHiddenChannels: $latestHiddenChannels, mutes: $mutes, name: $name, online: $online, privacySettings: $privacySettings, revokeTokensIssuedBefore: $revokeTokensIssuedBefore, role: $role, shadowBanned: $shadowBanned, teams: $teams, teamsRole: $teamsRole, totalUnreadCount: $totalUnreadCount, unreadChannels: $unreadChannels, unreadCount: $unreadCount, unreadThreads: $unreadThreads, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $FullUserResponseCopyWith<$Res> {
  factory $FullUserResponseCopyWith(
    FullUserResponse value,
    $Res Function(FullUserResponse) _then,
  ) = _$FullUserResponseCopyWithImpl;
  @useResult
  $Res call({
    int? avgResponseTime,
    DateTime? banExpires,
    bool banned,
    List<String> blockedUserIds,
    List<ChannelMute> channelMutes,
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? deactivatedAt,
    DateTime? deletedAt,
    List<DeviceResponse> devices,
    String id,
    String? image,
    bool invisible,
    String language,
    DateTime? lastActive,
    List<String>? latestHiddenChannels,
    List<UserMuteResponse> mutes,
    String? name,
    bool online,
    PrivacySettingsResponse? privacySettings,
    DateTime? revokeTokensIssuedBefore,
    String role,
    bool shadowBanned,
    List<String> teams,
    Map<String, String>? teamsRole,
    int totalUnreadCount,
    int unreadChannels,
    int unreadCount,
    int unreadThreads,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$FullUserResponseCopyWithImpl<$Res>
    implements $FullUserResponseCopyWith<$Res> {
  _$FullUserResponseCopyWithImpl(this._self, this._then);

  final FullUserResponse _self;
  final $Res Function(FullUserResponse) _then;

  /// Create a copy of FullUserResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? avgResponseTime = freezed,
    Object? banExpires = freezed,
    Object? banned = null,
    Object? blockedUserIds = null,
    Object? channelMutes = null,
    Object? createdAt = null,
    Object? custom = null,
    Object? deactivatedAt = freezed,
    Object? deletedAt = freezed,
    Object? devices = null,
    Object? id = null,
    Object? image = freezed,
    Object? invisible = null,
    Object? language = null,
    Object? lastActive = freezed,
    Object? latestHiddenChannels = freezed,
    Object? mutes = null,
    Object? name = freezed,
    Object? online = null,
    Object? privacySettings = freezed,
    Object? revokeTokensIssuedBefore = freezed,
    Object? role = null,
    Object? shadowBanned = null,
    Object? teams = null,
    Object? teamsRole = freezed,
    Object? totalUnreadCount = null,
    Object? unreadChannels = null,
    Object? unreadCount = null,
    Object? unreadThreads = null,
    Object? updatedAt = null,
  }) {
    return _then(
      FullUserResponse(
        avgResponseTime: freezed == avgResponseTime
            ? _self.avgResponseTime
            : avgResponseTime // ignore: cast_nullable_to_non_nullable
                  as int?,
        banExpires: freezed == banExpires
            ? _self.banExpires
            : banExpires // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        banned: null == banned
            ? _self.banned
            : banned // ignore: cast_nullable_to_non_nullable
                  as bool,
        blockedUserIds: null == blockedUserIds
            ? _self.blockedUserIds
            : blockedUserIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        channelMutes: null == channelMutes
            ? _self.channelMutes
            : channelMutes // ignore: cast_nullable_to_non_nullable
                  as List<ChannelMute>,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        deactivatedAt: freezed == deactivatedAt
            ? _self.deactivatedAt
            : deactivatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        deletedAt: freezed == deletedAt
            ? _self.deletedAt
            : deletedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        devices: null == devices
            ? _self.devices
            : devices // ignore: cast_nullable_to_non_nullable
                  as List<DeviceResponse>,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        image: freezed == image
            ? _self.image
            : image // ignore: cast_nullable_to_non_nullable
                  as String?,
        invisible: null == invisible
            ? _self.invisible
            : invisible // ignore: cast_nullable_to_non_nullable
                  as bool,
        language: null == language
            ? _self.language
            : language // ignore: cast_nullable_to_non_nullable
                  as String,
        lastActive: freezed == lastActive
            ? _self.lastActive
            : lastActive // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        latestHiddenChannels: freezed == latestHiddenChannels
            ? _self.latestHiddenChannels
            : latestHiddenChannels // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        mutes: null == mutes
            ? _self.mutes
            : mutes // ignore: cast_nullable_to_non_nullable
                  as List<UserMuteResponse>,
        name: freezed == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        online: null == online
            ? _self.online
            : online // ignore: cast_nullable_to_non_nullable
                  as bool,
        privacySettings: freezed == privacySettings
            ? _self.privacySettings
            : privacySettings // ignore: cast_nullable_to_non_nullable
                  as PrivacySettingsResponse?,
        revokeTokensIssuedBefore: freezed == revokeTokensIssuedBefore
            ? _self.revokeTokensIssuedBefore
            : revokeTokensIssuedBefore // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        role: null == role
            ? _self.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        shadowBanned: null == shadowBanned
            ? _self.shadowBanned
            : shadowBanned // ignore: cast_nullable_to_non_nullable
                  as bool,
        teams: null == teams
            ? _self.teams
            : teams // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        teamsRole: freezed == teamsRole
            ? _self.teamsRole
            : teamsRole // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
        totalUnreadCount: null == totalUnreadCount
            ? _self.totalUnreadCount
            : totalUnreadCount // ignore: cast_nullable_to_non_nullable
                  as int,
        unreadChannels: null == unreadChannels
            ? _self.unreadChannels
            : unreadChannels // ignore: cast_nullable_to_non_nullable
                  as int,
        unreadCount: null == unreadCount
            ? _self.unreadCount
            : unreadCount // ignore: cast_nullable_to_non_nullable
                  as int,
        unreadThreads: null == unreadThreads
            ? _self.unreadThreads
            : unreadThreads // ignore: cast_nullable_to_non_nullable
                  as int,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}
