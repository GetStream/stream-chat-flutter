// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChannelModel {
  String get id;
  String get type;
  String get cid;
  List<ChannelCapability>? get ownCapabilities;
  ChannelConfig get config;
  User? get createdBy;
  bool get frozen;
  DateTime? get lastMessageAt;
  DateTime get createdAt;
  DateTime get updatedAt;
  DateTime? get deletedAt;
  int get memberCount;
  List<Member>? get members;
  int get cooldown;
  bool? get disabled;
  bool? get hidden;
  bool? get muted;
  bool? get blocked;
  DateTime? get truncatedAt;
  User? get truncatedBy;
  bool? get autoTranslationEnabled;
  String? get autoTranslationLanguage;
  Map<String, Object?> get custom;
  String? get team;
  int? get messageCount;
  List<String>? get filterTags;

  /// Create a copy of ChannelModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelModelCopyWith<ChannelModel> get copyWith =>
      _$ChannelModelCopyWithImpl<ChannelModel>(this as ChannelModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            const DeepCollectionEquality().equals(other.ownCapabilities, ownCapabilities) &&
            (identical(other.config, config) || other.config == config) &&
            (identical(other.createdBy, createdBy) || other.createdBy == createdBy) &&
            (identical(other.frozen, frozen) || other.frozen == frozen) &&
            (identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt) &&
            (identical(other.memberCount, memberCount) || other.memberCount == memberCount) &&
            const DeepCollectionEquality().equals(other.members, members) &&
            (identical(other.cooldown, cooldown) || other.cooldown == cooldown) &&
            (identical(other.disabled, disabled) || other.disabled == disabled) &&
            (identical(other.hidden, hidden) || other.hidden == hidden) &&
            (identical(other.muted, muted) || other.muted == muted) &&
            (identical(other.blocked, blocked) || other.blocked == blocked) &&
            (identical(other.truncatedAt, truncatedAt) || other.truncatedAt == truncatedAt) &&
            (identical(other.truncatedBy, truncatedBy) || other.truncatedBy == truncatedBy) &&
            (identical(other.autoTranslationEnabled, autoTranslationEnabled) ||
                other.autoTranslationEnabled == autoTranslationEnabled) &&
            (identical(other.autoTranslationLanguage, autoTranslationLanguage) ||
                other.autoTranslationLanguage == autoTranslationLanguage) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.messageCount, messageCount) || other.messageCount == messageCount) &&
            const DeepCollectionEquality().equals(other.filterTags, filterTags));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    type,
    cid,
    const DeepCollectionEquality().hash(ownCapabilities),
    config,
    createdBy,
    frozen,
    lastMessageAt,
    createdAt,
    updatedAt,
    deletedAt,
    memberCount,
    const DeepCollectionEquality().hash(members),
    cooldown,
    disabled,
    hidden,
    muted,
    blocked,
    truncatedAt,
    truncatedBy,
    autoTranslationEnabled,
    autoTranslationLanguage,
    const DeepCollectionEquality().hash(custom),
    team,
    messageCount,
    const DeepCollectionEquality().hash(filterTags),
  ]);

  @override
  String toString() {
    return 'ChannelModel(id: $id, type: $type, cid: $cid, ownCapabilities: $ownCapabilities, config: $config, createdBy: $createdBy, frozen: $frozen, lastMessageAt: $lastMessageAt, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, memberCount: $memberCount, members: $members, cooldown: $cooldown, disabled: $disabled, hidden: $hidden, muted: $muted, blocked: $blocked, truncatedAt: $truncatedAt, truncatedBy: $truncatedBy, autoTranslationEnabled: $autoTranslationEnabled, autoTranslationLanguage: $autoTranslationLanguage, custom: $custom, team: $team, messageCount: $messageCount, filterTags: $filterTags)';
  }
}

/// @nodoc
abstract mixin class $ChannelModelCopyWith<$Res> {
  factory $ChannelModelCopyWith(ChannelModel value, $Res Function(ChannelModel) _then) = _$ChannelModelCopyWithImpl;
  @useResult
  $Res call({
    String? id,
    String? type,
    String? cid,
    List<ChannelCapability>? ownCapabilities,
    ChannelConfig? config,
    User? createdBy,
    bool frozen,
    DateTime? lastMessageAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    int memberCount,
    List<Member>? members,
    Map<String, Object?> custom,
    String? team,
    int cooldown,
    bool? disabled,
    bool? hidden,
    bool? muted,
    bool? blocked,
    DateTime? truncatedAt,
    int? messageCount,
    List<String>? filterTags,
    User? truncatedBy,
    bool? autoTranslationEnabled,
    String? autoTranslationLanguage,
  });
}

/// @nodoc
class _$ChannelModelCopyWithImpl<$Res> implements $ChannelModelCopyWith<$Res> {
  _$ChannelModelCopyWithImpl(this._self, this._then);

  final ChannelModel _self;
  final $Res Function(ChannelModel) _then;

  /// Create a copy of ChannelModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? type = freezed,
    Object? cid = freezed,
    Object? ownCapabilities = freezed,
    Object? config = freezed,
    Object? createdBy = freezed,
    Object? frozen = null,
    Object? lastMessageAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? memberCount = null,
    Object? members = freezed,
    Object? custom = null,
    Object? team = freezed,
    Object? cooldown = null,
    Object? disabled = freezed,
    Object? hidden = freezed,
    Object? muted = freezed,
    Object? blocked = freezed,
    Object? truncatedAt = freezed,
    Object? messageCount = freezed,
    Object? filterTags = freezed,
    Object? truncatedBy = freezed,
    Object? autoTranslationEnabled = freezed,
    Object? autoTranslationLanguage = freezed,
  }) {
    return _then(
      ChannelModel(
        id: freezed == id
            ? _self.id!
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: freezed == type
            ? _self.type!
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid!
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        ownCapabilities: freezed == ownCapabilities
            ? _self.ownCapabilities
            : ownCapabilities // ignore: cast_nullable_to_non_nullable
                  as List<ChannelCapability>?,
        config: freezed == config
            ? _self.config!
            : config // ignore: cast_nullable_to_non_nullable
                  as ChannelConfig?,
        createdBy: freezed == createdBy
            ? _self.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as User?,
        frozen: null == frozen
            ? _self.frozen
            : frozen // ignore: cast_nullable_to_non_nullable
                  as bool,
        lastMessageAt: freezed == lastMessageAt
            ? _self.lastMessageAt
            : lastMessageAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: freezed == createdAt
            ? _self.createdAt!
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _self.updatedAt!
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        deletedAt: freezed == deletedAt
            ? _self.deletedAt
            : deletedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        memberCount: null == memberCount
            ? _self.memberCount
            : memberCount // ignore: cast_nullable_to_non_nullable
                  as int,
        members: freezed == members
            ? _self.members
            : members // ignore: cast_nullable_to_non_nullable
                  as List<Member>?,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        cooldown: null == cooldown
            ? _self.cooldown
            : cooldown // ignore: cast_nullable_to_non_nullable
                  as int,
        disabled: freezed == disabled
            ? _self.disabled
            : disabled // ignore: cast_nullable_to_non_nullable
                  as bool?,
        hidden: freezed == hidden
            ? _self.hidden
            : hidden // ignore: cast_nullable_to_non_nullable
                  as bool?,
        muted: freezed == muted
            ? _self.muted
            : muted // ignore: cast_nullable_to_non_nullable
                  as bool?,
        blocked: freezed == blocked
            ? _self.blocked
            : blocked // ignore: cast_nullable_to_non_nullable
                  as bool?,
        truncatedAt: freezed == truncatedAt
            ? _self.truncatedAt
            : truncatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        messageCount: freezed == messageCount
            ? _self.messageCount
            : messageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        filterTags: freezed == filterTags
            ? _self.filterTags
            : filterTags // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        truncatedBy: freezed == truncatedBy
            ? _self.truncatedBy
            : truncatedBy // ignore: cast_nullable_to_non_nullable
                  as User?,
        autoTranslationEnabled: freezed == autoTranslationEnabled
            ? _self.autoTranslationEnabled
            : autoTranslationEnabled // ignore: cast_nullable_to_non_nullable
                  as bool?,
        autoTranslationLanguage: freezed == autoTranslationLanguage
            ? _self.autoTranslationLanguage
            : autoTranslationLanguage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
