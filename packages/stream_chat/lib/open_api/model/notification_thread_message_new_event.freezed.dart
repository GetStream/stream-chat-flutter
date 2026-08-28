// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_thread_message_new_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationThreadMessageNewEvent {
  ChannelResponse get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  MessageResponse get message;
  String get messageId;
  String? get parentAuthor;
  DateTime? get receivedAt;
  String? get team;
  String get threadId;
  List<UserResponseCommonFields>? get threadParticipants;
  String get type;
  int? get unreadThreadMessages;
  int? get unreadThreads;
  int get watcherCount;

  /// Create a copy of NotificationThreadMessageNewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationThreadMessageNewEventCopyWith<NotificationThreadMessageNewEvent>
  get copyWith =>
      _$NotificationThreadMessageNewEventCopyWithImpl<
        NotificationThreadMessageNewEvent
      >(this as NotificationThreadMessageNewEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationThreadMessageNewEvent &&
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
            (identical(other.message, message) || other.message == message) &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.parentAuthor, parentAuthor) ||
                other.parentAuthor == parentAuthor) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.threadId, threadId) ||
                other.threadId == threadId) &&
            const DeepCollectionEquality().equals(
              other.threadParticipants,
              threadParticipants,
            ) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.unreadThreadMessages, unreadThreadMessages) ||
                other.unreadThreadMessages == unreadThreadMessages) &&
            (identical(other.unreadThreads, unreadThreads) ||
                other.unreadThreads == unreadThreads) &&
            (identical(other.watcherCount, watcherCount) ||
                other.watcherCount == watcherCount));
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
    message,
    messageId,
    parentAuthor,
    receivedAt,
    team,
    threadId,
    const DeepCollectionEquality().hash(threadParticipants),
    type,
    unreadThreadMessages,
    unreadThreads,
    watcherCount,
  ]);

  @override
  String toString() {
    return 'NotificationThreadMessageNewEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, message: $message, messageId: $messageId, parentAuthor: $parentAuthor, receivedAt: $receivedAt, team: $team, threadId: $threadId, threadParticipants: $threadParticipants, type: $type, unreadThreadMessages: $unreadThreadMessages, unreadThreads: $unreadThreads, watcherCount: $watcherCount)';
  }
}

/// @nodoc
abstract mixin class $NotificationThreadMessageNewEventCopyWith<$Res> {
  factory $NotificationThreadMessageNewEventCopyWith(
    NotificationThreadMessageNewEvent value,
    $Res Function(NotificationThreadMessageNewEvent) _then,
  ) = _$NotificationThreadMessageNewEventCopyWithImpl;
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
    MessageResponse message,
    String messageId,
    String? parentAuthor,
    DateTime? receivedAt,
    String? team,
    String threadId,
    List<UserResponseCommonFields>? threadParticipants,
    String type,
    int? unreadThreadMessages,
    int? unreadThreads,
    int watcherCount,
  });
}

/// @nodoc
class _$NotificationThreadMessageNewEventCopyWithImpl<$Res>
    implements $NotificationThreadMessageNewEventCopyWith<$Res> {
  _$NotificationThreadMessageNewEventCopyWithImpl(this._self, this._then);

  final NotificationThreadMessageNewEvent _self;
  final $Res Function(NotificationThreadMessageNewEvent) _then;

  /// Create a copy of NotificationThreadMessageNewEvent
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
    Object? message = null,
    Object? messageId = null,
    Object? parentAuthor = freezed,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? threadId = null,
    Object? threadParticipants = freezed,
    Object? type = null,
    Object? unreadThreadMessages = freezed,
    Object? unreadThreads = freezed,
    Object? watcherCount = null,
  }) {
    return _then(
      NotificationThreadMessageNewEvent(
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
        message: null == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageResponse,
        messageId: null == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String,
        parentAuthor: freezed == parentAuthor
            ? _self.parentAuthor
            : parentAuthor // ignore: cast_nullable_to_non_nullable
                  as String?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        threadId: null == threadId
            ? _self.threadId
            : threadId // ignore: cast_nullable_to_non_nullable
                  as String,
        threadParticipants: freezed == threadParticipants
            ? _self.threadParticipants
            : threadParticipants // ignore: cast_nullable_to_non_nullable
                  as List<UserResponseCommonFields>?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        unreadThreadMessages: freezed == unreadThreadMessages
            ? _self.unreadThreadMessages
            : unreadThreadMessages // ignore: cast_nullable_to_non_nullable
                  as int?,
        unreadThreads: freezed == unreadThreads
            ? _self.unreadThreads
            : unreadThreads // ignore: cast_nullable_to_non_nullable
                  as int?,
        watcherCount: null == watcherCount
            ? _self.watcherCount
            : watcherCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
