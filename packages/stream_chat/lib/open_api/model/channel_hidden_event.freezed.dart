// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_hidden_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChannelHiddenEvent {
  ChannelResponse get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  bool get clearHistory;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String? get team;
  String get type;
  UserResponseCommonFields? get user;

  /// Create a copy of ChannelHiddenEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelHiddenEventCopyWith<ChannelHiddenEvent> get copyWith =>
      _$ChannelHiddenEventCopyWithImpl<ChannelHiddenEvent>(
        this as ChannelHiddenEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelHiddenEvent &&
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) ||
                other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) ||
                other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.clearHistory, clearHistory) ||
                other.clearHistory == clearHistory) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    clearHistory,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    team,
    type,
    user,
  );

  @override
  String toString() {
    return 'ChannelHiddenEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, clearHistory: $clearHistory, createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, team: $team, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $ChannelHiddenEventCopyWith<$Res> {
  factory $ChannelHiddenEventCopyWith(
    ChannelHiddenEvent value,
    $Res Function(ChannelHiddenEvent) _then,
  ) = _$ChannelHiddenEventCopyWithImpl;
  @useResult
  $Res call({
    ChannelResponse channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    bool clearHistory,
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String? team,
    String type,
    UserResponseCommonFields? user,
  });
}

/// @nodoc
class _$ChannelHiddenEventCopyWithImpl<$Res>
    implements $ChannelHiddenEventCopyWith<$Res> {
  _$ChannelHiddenEventCopyWithImpl(this._self, this._then);

  final ChannelHiddenEvent _self;
  final $Res Function(ChannelHiddenEvent) _then;

  /// Create a copy of ChannelHiddenEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = null,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? clearHistory = null,
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      ChannelHiddenEvent(
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        clearHistory: null == clearHistory
            ? _self.clearHistory
            : clearHistory // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}
