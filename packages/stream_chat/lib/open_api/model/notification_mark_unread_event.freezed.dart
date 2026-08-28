// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_mark_unread_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationMarkUnreadEvent {
  ChannelResponse? get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  String? get firstUnreadMessageId;
  Map<String, int>? get groupedUnreadChannels;
  DateTime? get lastReadAt;
  String? get lastReadMessageId;
  DateTime? get receivedAt;
  String? get team;
  String? get threadId;
  int? get totalUnreadCount;
  String get type;
  int? get unreadChannels;
  int? get unreadCount;
  int? get unreadMessages;
  int? get unreadThreadMessages;
  int? get unreadThreads;
  UserResponseCommonFields? get user;

  /// Create a copy of NotificationMarkUnreadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationMarkUnreadEventCopyWith<NotificationMarkUnreadEvent>
  get copyWith =>
      _$NotificationMarkUnreadEventCopyWithImpl<NotificationMarkUnreadEvent>(
        this as NotificationMarkUnreadEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationMarkUnreadEvent &&
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
            (identical(other.firstUnreadMessageId, firstUnreadMessageId) ||
                other.firstUnreadMessageId == firstUnreadMessageId) &&
            const DeepCollectionEquality().equals(
              other.groupedUnreadChannels,
              groupedUnreadChannels,
            ) &&
            (identical(other.lastReadAt, lastReadAt) ||
                other.lastReadAt == lastReadAt) &&
            (identical(other.lastReadMessageId, lastReadMessageId) ||
                other.lastReadMessageId == lastReadMessageId) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.threadId, threadId) ||
                other.threadId == threadId) &&
            (identical(other.totalUnreadCount, totalUnreadCount) ||
                other.totalUnreadCount == totalUnreadCount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.unreadChannels, unreadChannels) ||
                other.unreadChannels == unreadChannels) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.unreadMessages, unreadMessages) ||
                other.unreadMessages == unreadMessages) &&
            (identical(other.unreadThreadMessages, unreadThreadMessages) ||
                other.unreadThreadMessages == unreadThreadMessages) &&
            (identical(other.unreadThreads, unreadThreads) ||
                other.unreadThreads == unreadThreads) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hashAll([
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
    firstUnreadMessageId,
    const DeepCollectionEquality().hash(groupedUnreadChannels),
    lastReadAt,
    lastReadMessageId,
    receivedAt,
    team,
    threadId,
    totalUnreadCount,
    type,
    unreadChannels,
    unreadCount,
    unreadMessages,
    unreadThreadMessages,
    unreadThreads,
    user,
  ]);

  @override
  String toString() {
    return 'NotificationMarkUnreadEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, firstUnreadMessageId: $firstUnreadMessageId, groupedUnreadChannels: $groupedUnreadChannels, lastReadAt: $lastReadAt, lastReadMessageId: $lastReadMessageId, receivedAt: $receivedAt, team: $team, threadId: $threadId, totalUnreadCount: $totalUnreadCount, type: $type, unreadChannels: $unreadChannels, unreadCount: $unreadCount, unreadMessages: $unreadMessages, unreadThreadMessages: $unreadThreadMessages, unreadThreads: $unreadThreads, user: $user)';
  }
}

/// @nodoc
abstract mixin class $NotificationMarkUnreadEventCopyWith<$Res> {
  factory $NotificationMarkUnreadEventCopyWith(
    NotificationMarkUnreadEvent value,
    $Res Function(NotificationMarkUnreadEvent) _then,
  ) = _$NotificationMarkUnreadEventCopyWithImpl;
  @useResult
  $Res call({
    ChannelResponse? channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    String? firstUnreadMessageId,
    Map<String, int>? groupedUnreadChannels,
    DateTime? lastReadAt,
    String? lastReadMessageId,
    DateTime? receivedAt,
    String? team,
    String? threadId,
    int? totalUnreadCount,
    String type,
    int? unreadChannels,
    int? unreadCount,
    int? unreadMessages,
    int? unreadThreadMessages,
    int? unreadThreads,
    UserResponseCommonFields? user,
  });
}

/// @nodoc
class _$NotificationMarkUnreadEventCopyWithImpl<$Res>
    implements $NotificationMarkUnreadEventCopyWith<$Res> {
  _$NotificationMarkUnreadEventCopyWithImpl(this._self, this._then);

  final NotificationMarkUnreadEvent _self;
  final $Res Function(NotificationMarkUnreadEvent) _then;

  /// Create a copy of NotificationMarkUnreadEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = freezed,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? firstUnreadMessageId = freezed,
    Object? groupedUnreadChannels = freezed,
    Object? lastReadAt = freezed,
    Object? lastReadMessageId = freezed,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? threadId = freezed,
    Object? totalUnreadCount = freezed,
    Object? type = null,
    Object? unreadChannels = freezed,
    Object? unreadCount = freezed,
    Object? unreadMessages = freezed,
    Object? unreadThreadMessages = freezed,
    Object? unreadThreads = freezed,
    Object? user = freezed,
  }) {
    return _then(
      NotificationMarkUnreadEvent(
        channel: freezed == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse?,
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
        firstUnreadMessageId: freezed == firstUnreadMessageId
            ? _self.firstUnreadMessageId
            : firstUnreadMessageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        groupedUnreadChannels: freezed == groupedUnreadChannels
            ? _self.groupedUnreadChannels
            : groupedUnreadChannels // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>?,
        lastReadAt: freezed == lastReadAt
            ? _self.lastReadAt
            : lastReadAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lastReadMessageId: freezed == lastReadMessageId
            ? _self.lastReadMessageId
            : lastReadMessageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        threadId: freezed == threadId
            ? _self.threadId
            : threadId // ignore: cast_nullable_to_non_nullable
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
        unreadMessages: freezed == unreadMessages
            ? _self.unreadMessages
            : unreadMessages // ignore: cast_nullable_to_non_nullable
                  as int?,
        unreadThreadMessages: freezed == unreadThreadMessages
            ? _self.unreadThreadMessages
            : unreadThreadMessages // ignore: cast_nullable_to_non_nullable
                  as int?,
        unreadThreads: freezed == unreadThreads
            ? _self.unreadThreads
            : unreadThreads // ignore: cast_nullable_to_non_nullable
                  as int?,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}
