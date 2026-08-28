// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChannelResponse {
  bool? get autoTranslationEnabled;
  String? get autoTranslationLanguage;
  bool? get blocked;
  String get cid;
  ChannelConfigWithInfo? get config;
  int? get cooldown;
  DateTime get createdAt;
  UserResponse? get createdBy;
  Map<String, Object?> get custom;
  DateTime? get deletedAt;
  bool get disabled;
  List<String>? get filterTags;
  bool get frozen;
  bool? get hidden;
  DateTime? get hideMessagesBefore;
  String get id;
  DateTime? get lastMessageAt;
  int? get memberCount;
  List<ChannelMemberResponse>? get members;
  int? get messageCount;
  DateTime? get muteExpiresAt;
  bool? get muted;
  List<ChannelOwnCapability>? get ownCapabilities;
  String? get team;
  DateTime? get truncatedAt;
  UserResponse? get truncatedBy;
  String get type;
  DateTime get updatedAt;

  /// Create a copy of ChannelResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelResponseCopyWith<ChannelResponse> get copyWith =>
      _$ChannelResponseCopyWithImpl<ChannelResponse>(
        this as ChannelResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelResponse &&
            (identical(other.autoTranslationEnabled, autoTranslationEnabled) ||
                other.autoTranslationEnabled == autoTranslationEnabled) &&
            (identical(
                  other.autoTranslationLanguage,
                  autoTranslationLanguage,
                ) ||
                other.autoTranslationLanguage == autoTranslationLanguage) &&
            (identical(other.blocked, blocked) || other.blocked == blocked) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.config, config) || other.config == config) &&
            (identical(other.cooldown, cooldown) ||
                other.cooldown == cooldown) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.disabled, disabled) ||
                other.disabled == disabled) &&
            const DeepCollectionEquality().equals(
              other.filterTags,
              filterTags,
            ) &&
            (identical(other.frozen, frozen) || other.frozen == frozen) &&
            (identical(other.hidden, hidden) || other.hidden == hidden) &&
            (identical(other.hideMessagesBefore, hideMessagesBefore) ||
                other.hideMessagesBefore == hideMessagesBefore) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt) &&
            (identical(other.memberCount, memberCount) ||
                other.memberCount == memberCount) &&
            const DeepCollectionEquality().equals(other.members, members) &&
            (identical(other.messageCount, messageCount) ||
                other.messageCount == messageCount) &&
            (identical(other.muteExpiresAt, muteExpiresAt) ||
                other.muteExpiresAt == muteExpiresAt) &&
            (identical(other.muted, muted) || other.muted == muted) &&
            const DeepCollectionEquality().equals(
              other.ownCapabilities,
              ownCapabilities,
            ) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.truncatedAt, truncatedAt) ||
                other.truncatedAt == truncatedAt) &&
            (identical(other.truncatedBy, truncatedBy) ||
                other.truncatedBy == truncatedBy) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    autoTranslationEnabled,
    autoTranslationLanguage,
    blocked,
    cid,
    config,
    cooldown,
    createdAt,
    createdBy,
    const DeepCollectionEquality().hash(custom),
    deletedAt,
    disabled,
    const DeepCollectionEquality().hash(filterTags),
    frozen,
    hidden,
    hideMessagesBefore,
    id,
    lastMessageAt,
    memberCount,
    const DeepCollectionEquality().hash(members),
    messageCount,
    muteExpiresAt,
    muted,
    const DeepCollectionEquality().hash(ownCapabilities),
    team,
    truncatedAt,
    truncatedBy,
    type,
    updatedAt,
  ]);

  @override
  String toString() {
    return 'ChannelResponse(autoTranslationEnabled: $autoTranslationEnabled, autoTranslationLanguage: $autoTranslationLanguage, blocked: $blocked, cid: $cid, config: $config, cooldown: $cooldown, createdAt: $createdAt, createdBy: $createdBy, custom: $custom, deletedAt: $deletedAt, disabled: $disabled, filterTags: $filterTags, frozen: $frozen, hidden: $hidden, hideMessagesBefore: $hideMessagesBefore, id: $id, lastMessageAt: $lastMessageAt, memberCount: $memberCount, members: $members, messageCount: $messageCount, muteExpiresAt: $muteExpiresAt, muted: $muted, ownCapabilities: $ownCapabilities, team: $team, truncatedAt: $truncatedAt, truncatedBy: $truncatedBy, type: $type, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $ChannelResponseCopyWith<$Res> {
  factory $ChannelResponseCopyWith(
    ChannelResponse value,
    $Res Function(ChannelResponse) _then,
  ) = _$ChannelResponseCopyWithImpl;
  @useResult
  $Res call({
    bool? autoTranslationEnabled,
    String? autoTranslationLanguage,
    bool? blocked,
    String cid,
    ChannelConfigWithInfo? config,
    int? cooldown,
    DateTime createdAt,
    UserResponse? createdBy,
    Map<String, Object?> custom,
    DateTime? deletedAt,
    bool disabled,
    List<String>? filterTags,
    bool frozen,
    bool? hidden,
    DateTime? hideMessagesBefore,
    String id,
    DateTime? lastMessageAt,
    int? memberCount,
    List<ChannelMemberResponse>? members,
    int? messageCount,
    DateTime? muteExpiresAt,
    bool? muted,
    List<ChannelOwnCapability>? ownCapabilities,
    String? team,
    DateTime? truncatedAt,
    UserResponse? truncatedBy,
    String type,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$ChannelResponseCopyWithImpl<$Res>
    implements $ChannelResponseCopyWith<$Res> {
  _$ChannelResponseCopyWithImpl(this._self, this._then);

  final ChannelResponse _self;
  final $Res Function(ChannelResponse) _then;

  /// Create a copy of ChannelResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? autoTranslationEnabled = freezed,
    Object? autoTranslationLanguage = freezed,
    Object? blocked = freezed,
    Object? cid = null,
    Object? config = freezed,
    Object? cooldown = freezed,
    Object? createdAt = null,
    Object? createdBy = freezed,
    Object? custom = null,
    Object? deletedAt = freezed,
    Object? disabled = null,
    Object? filterTags = freezed,
    Object? frozen = null,
    Object? hidden = freezed,
    Object? hideMessagesBefore = freezed,
    Object? id = null,
    Object? lastMessageAt = freezed,
    Object? memberCount = freezed,
    Object? members = freezed,
    Object? messageCount = freezed,
    Object? muteExpiresAt = freezed,
    Object? muted = freezed,
    Object? ownCapabilities = freezed,
    Object? team = freezed,
    Object? truncatedAt = freezed,
    Object? truncatedBy = freezed,
    Object? type = null,
    Object? updatedAt = null,
  }) {
    return _then(
      ChannelResponse(
        autoTranslationEnabled: freezed == autoTranslationEnabled
            ? _self.autoTranslationEnabled
            : autoTranslationEnabled // ignore: cast_nullable_to_non_nullable
                  as bool?,
        autoTranslationLanguage: freezed == autoTranslationLanguage
            ? _self.autoTranslationLanguage
            : autoTranslationLanguage // ignore: cast_nullable_to_non_nullable
                  as String?,
        blocked: freezed == blocked
            ? _self.blocked
            : blocked // ignore: cast_nullable_to_non_nullable
                  as bool?,
        cid: null == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String,
        config: freezed == config
            ? _self.config
            : config // ignore: cast_nullable_to_non_nullable
                  as ChannelConfigWithInfo?,
        cooldown: freezed == cooldown
            ? _self.cooldown
            : cooldown // ignore: cast_nullable_to_non_nullable
                  as int?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdBy: freezed == createdBy
            ? _self.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as UserResponse?,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        deletedAt: freezed == deletedAt
            ? _self.deletedAt
            : deletedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        disabled: null == disabled
            ? _self.disabled
            : disabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        filterTags: freezed == filterTags
            ? _self.filterTags
            : filterTags // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        frozen: null == frozen
            ? _self.frozen
            : frozen // ignore: cast_nullable_to_non_nullable
                  as bool,
        hidden: freezed == hidden
            ? _self.hidden
            : hidden // ignore: cast_nullable_to_non_nullable
                  as bool?,
        hideMessagesBefore: freezed == hideMessagesBefore
            ? _self.hideMessagesBefore
            : hideMessagesBefore // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        lastMessageAt: freezed == lastMessageAt
            ? _self.lastMessageAt
            : lastMessageAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        memberCount: freezed == memberCount
            ? _self.memberCount
            : memberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        members: freezed == members
            ? _self.members
            : members // ignore: cast_nullable_to_non_nullable
                  as List<ChannelMemberResponse>?,
        messageCount: freezed == messageCount
            ? _self.messageCount
            : messageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        muteExpiresAt: freezed == muteExpiresAt
            ? _self.muteExpiresAt
            : muteExpiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        muted: freezed == muted
            ? _self.muted
            : muted // ignore: cast_nullable_to_non_nullable
                  as bool?,
        ownCapabilities: freezed == ownCapabilities
            ? _self.ownCapabilities
            : ownCapabilities // ignore: cast_nullable_to_non_nullable
                  as List<ChannelOwnCapability>?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        truncatedAt: freezed == truncatedAt
            ? _self.truncatedAt
            : truncatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        truncatedBy: freezed == truncatedBy
            ? _self.truncatedBy
            : truncatedBy // ignore: cast_nullable_to_non_nullable
                  as UserResponse?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}
