// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mark_read_response_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MarkReadResponseEvent {
  ChannelResponse? get channel;
  String get channelId;
  DateTime? get channelLastMessageAt;
  String get channelType;
  String get cid;
  DateTime get createdAt;
  String? get lastReadMessageId;
  String? get team;
  ThreadResponse? get thread;
  String get type;
  UserResponseCommonFields? get user;

  /// Create a copy of MarkReadResponseEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MarkReadResponseEventCopyWith<MarkReadResponseEvent> get copyWith =>
      _$MarkReadResponseEventCopyWithImpl<MarkReadResponseEvent>(
        this as MarkReadResponseEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MarkReadResponseEvent &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelLastMessageAt, channelLastMessageAt) ||
                other.channelLastMessageAt == channelLastMessageAt) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.lastReadMessageId, lastReadMessageId) || other.lastReadMessageId == lastReadMessageId) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.thread, thread) || other.thread == thread) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    channelId,
    channelLastMessageAt,
    channelType,
    cid,
    createdAt,
    lastReadMessageId,
    team,
    thread,
    type,
    user,
  );

  @override
  String toString() {
    return 'MarkReadResponseEvent(channel: $channel, channelId: $channelId, channelLastMessageAt: $channelLastMessageAt, channelType: $channelType, cid: $cid, createdAt: $createdAt, lastReadMessageId: $lastReadMessageId, team: $team, thread: $thread, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $MarkReadResponseEventCopyWith<$Res> {
  factory $MarkReadResponseEventCopyWith(
    MarkReadResponseEvent value,
    $Res Function(MarkReadResponseEvent) _then,
  ) = _$MarkReadResponseEventCopyWithImpl;
  @useResult
  $Res call({
    ChannelResponse? channel,
    String channelId,
    DateTime? channelLastMessageAt,
    String channelType,
    String cid,
    DateTime createdAt,
    String? lastReadMessageId,
    String? team,
    ThreadResponse? thread,
    String type,
    UserResponseCommonFields? user,
  });
}

/// @nodoc
class _$MarkReadResponseEventCopyWithImpl<$Res> implements $MarkReadResponseEventCopyWith<$Res> {
  _$MarkReadResponseEventCopyWithImpl(this._self, this._then);

  final MarkReadResponseEvent _self;
  final $Res Function(MarkReadResponseEvent) _then;

  /// Create a copy of MarkReadResponseEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = freezed,
    Object? channelId = null,
    Object? channelLastMessageAt = freezed,
    Object? channelType = null,
    Object? cid = null,
    Object? createdAt = null,
    Object? lastReadMessageId = freezed,
    Object? team = freezed,
    Object? thread = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      MarkReadResponseEvent(
        channel: freezed == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse?,
        channelId: null == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String,
        channelLastMessageAt: freezed == channelLastMessageAt
            ? _self.channelLastMessageAt
            : channelLastMessageAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        channelType: null == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String,
        cid: null == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastReadMessageId: freezed == lastReadMessageId
            ? _self.lastReadMessageId
            : lastReadMessageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        thread: freezed == thread
            ? _self.thread
            : thread // ignore: cast_nullable_to_non_nullable
                  as ThreadResponse?,
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
