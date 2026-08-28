// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_channel_truncated_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationChannelTruncatedEvent {
  ChannelResponse get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  Map<String, int>? get groupedUnreadChannels;
  MessageResponse? get message;
  String? get messageId;
  DateTime? get receivedAt;
  String? get team;
  int? get totalUnreadCount;
  String get type;
  int? get unreadChannels;
  int? get unreadCount;

  /// Create a copy of NotificationChannelTruncatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationChannelTruncatedEventCopyWith<NotificationChannelTruncatedEvent>
  get copyWith =>
      _$NotificationChannelTruncatedEventCopyWithImpl<
        NotificationChannelTruncatedEvent
      >(this as NotificationChannelTruncatedEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationChannelTruncatedEvent &&
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
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            const DeepCollectionEquality().equals(
              other.groupedUnreadChannels,
              groupedUnreadChannels,
            ) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.totalUnreadCount, totalUnreadCount) ||
                other.totalUnreadCount == totalUnreadCount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.unreadChannels, unreadChannels) ||
                other.unreadChannels == unreadChannels) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount));
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
    createdAt,
    const DeepCollectionEquality().hash(custom),
    const DeepCollectionEquality().hash(groupedUnreadChannels),
    message,
    messageId,
    receivedAt,
    team,
    totalUnreadCount,
    type,
    unreadChannels,
    unreadCount,
  );

  @override
  String toString() {
    return 'NotificationChannelTruncatedEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, groupedUnreadChannels: $groupedUnreadChannels, message: $message, messageId: $messageId, receivedAt: $receivedAt, team: $team, totalUnreadCount: $totalUnreadCount, type: $type, unreadChannels: $unreadChannels, unreadCount: $unreadCount)';
  }
}

/// @nodoc
abstract mixin class $NotificationChannelTruncatedEventCopyWith<$Res> {
  factory $NotificationChannelTruncatedEventCopyWith(
    NotificationChannelTruncatedEvent value,
    $Res Function(NotificationChannelTruncatedEvent) _then,
  ) = _$NotificationChannelTruncatedEventCopyWithImpl;
  @useResult
  $Res call({
    ChannelResponse channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    Map<String, int>? groupedUnreadChannels,
    MessageResponse? message,
    String? messageId,
    DateTime? receivedAt,
    String? team,
    int? totalUnreadCount,
    String type,
    int? unreadChannels,
    int? unreadCount,
  });
}

/// @nodoc
class _$NotificationChannelTruncatedEventCopyWithImpl<$Res>
    implements $NotificationChannelTruncatedEventCopyWith<$Res> {
  _$NotificationChannelTruncatedEventCopyWithImpl(this._self, this._then);

  final NotificationChannelTruncatedEvent _self;
  final $Res Function(NotificationChannelTruncatedEvent) _then;

  /// Create a copy of NotificationChannelTruncatedEvent
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
    Object? createdAt = null,
    Object? custom = null,
    Object? groupedUnreadChannels = freezed,
    Object? message = freezed,
    Object? messageId = freezed,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? totalUnreadCount = freezed,
    Object? type = null,
    Object? unreadChannels = freezed,
    Object? unreadCount = freezed,
  }) {
    return _then(
      NotificationChannelTruncatedEvent(
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
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        groupedUnreadChannels: freezed == groupedUnreadChannels
            ? _self.groupedUnreadChannels
            : groupedUnreadChannels // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>?,
        message: freezed == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageResponse?,
        messageId: freezed == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalUnreadCount: freezed == totalUnreadCount
            ? _self.totalUnreadCount
            : totalUnreadCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        unreadChannels: freezed == unreadChannels
            ? _self.unreadChannels
            : unreadChannels // ignore: cast_nullable_to_non_nullable
                  as int?,
        unreadCount: freezed == unreadCount
            ? _self.unreadCount
            : unreadCount // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}
