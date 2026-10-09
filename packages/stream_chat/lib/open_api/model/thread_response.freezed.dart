// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'thread_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ThreadResponse {
  int get activeParticipantCount;
  ChannelResponse? get channel;
  String get channelCid;
  DateTime get createdAt;
  UserResponse? get createdBy;
  String get createdByUserId;
  Map<String, Object?> get custom;
  DateTime? get deletedAt;
  DateTime? get lastMessageAt;
  MessageResponse? get parentMessage;
  String get parentMessageId;
  int get participantCount;
  int get replyCount;
  List<ThreadParticipant>? get threadParticipants;
  String get title;
  DateTime get updatedAt;

  /// Create a copy of ThreadResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ThreadResponseCopyWith<ThreadResponse> get copyWith => _$ThreadResponseCopyWithImpl<ThreadResponse>(
    this as ThreadResponse,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ThreadResponse &&
            (identical(other.activeParticipantCount, activeParticipantCount) ||
                other.activeParticipantCount == activeParticipantCount) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.channelCid, channelCid) || other.channelCid == channelCid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) || other.createdBy == createdBy) &&
            (identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt) &&
            (identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt) &&
            (identical(other.parentMessage, parentMessage) || other.parentMessage == parentMessage) &&
            (identical(other.parentMessageId, parentMessageId) || other.parentMessageId == parentMessageId) &&
            (identical(other.participantCount, participantCount) || other.participantCount == participantCount) &&
            (identical(other.replyCount, replyCount) || other.replyCount == replyCount) &&
            const DeepCollectionEquality().equals(
              other.threadParticipants,
              threadParticipants,
            ) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    activeParticipantCount,
    channel,
    channelCid,
    createdAt,
    createdBy,
    createdByUserId,
    const DeepCollectionEquality().hash(custom),
    deletedAt,
    lastMessageAt,
    parentMessage,
    parentMessageId,
    participantCount,
    replyCount,
    const DeepCollectionEquality().hash(threadParticipants),
    title,
    updatedAt,
  );

  @override
  String toString() {
    return 'ThreadResponse(activeParticipantCount: $activeParticipantCount, channel: $channel, channelCid: $channelCid, createdAt: $createdAt, createdBy: $createdBy, createdByUserId: $createdByUserId, custom: $custom, deletedAt: $deletedAt, lastMessageAt: $lastMessageAt, parentMessage: $parentMessage, parentMessageId: $parentMessageId, participantCount: $participantCount, replyCount: $replyCount, threadParticipants: $threadParticipants, title: $title, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $ThreadResponseCopyWith<$Res> {
  factory $ThreadResponseCopyWith(
    ThreadResponse value,
    $Res Function(ThreadResponse) _then,
  ) = _$ThreadResponseCopyWithImpl;
  @useResult
  $Res call({
    int activeParticipantCount,
    ChannelResponse? channel,
    String channelCid,
    DateTime createdAt,
    UserResponse? createdBy,
    String createdByUserId,
    Map<String, Object?> custom,
    DateTime? deletedAt,
    DateTime? lastMessageAt,
    MessageResponse? parentMessage,
    String parentMessageId,
    int participantCount,
    int replyCount,
    List<ThreadParticipant>? threadParticipants,
    String title,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$ThreadResponseCopyWithImpl<$Res> implements $ThreadResponseCopyWith<$Res> {
  _$ThreadResponseCopyWithImpl(this._self, this._then);

  final ThreadResponse _self;
  final $Res Function(ThreadResponse) _then;

  /// Create a copy of ThreadResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeParticipantCount = null,
    Object? channel = freezed,
    Object? channelCid = null,
    Object? createdAt = null,
    Object? createdBy = freezed,
    Object? createdByUserId = null,
    Object? custom = null,
    Object? deletedAt = freezed,
    Object? lastMessageAt = freezed,
    Object? parentMessage = freezed,
    Object? parentMessageId = null,
    Object? participantCount = null,
    Object? replyCount = null,
    Object? threadParticipants = freezed,
    Object? title = null,
    Object? updatedAt = null,
  }) {
    return _then(
      ThreadResponse(
        activeParticipantCount: null == activeParticipantCount
            ? _self.activeParticipantCount
            : activeParticipantCount // ignore: cast_nullable_to_non_nullable
                  as int,
        channel: freezed == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse?,
        channelCid: null == channelCid
            ? _self.channelCid
            : channelCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdBy: freezed == createdBy
            ? _self.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as UserResponse?,
        createdByUserId: null == createdByUserId
            ? _self.createdByUserId
            : createdByUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        deletedAt: freezed == deletedAt
            ? _self.deletedAt
            : deletedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lastMessageAt: freezed == lastMessageAt
            ? _self.lastMessageAt
            : lastMessageAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        parentMessage: freezed == parentMessage
            ? _self.parentMessage
            : parentMessage // ignore: cast_nullable_to_non_nullable
                  as MessageResponse?,
        parentMessageId: null == parentMessageId
            ? _self.parentMessageId
            : parentMessageId // ignore: cast_nullable_to_non_nullable
                  as String,
        participantCount: null == participantCount
            ? _self.participantCount
            : participantCount // ignore: cast_nullable_to_non_nullable
                  as int,
        replyCount: null == replyCount
            ? _self.replyCount
            : replyCount // ignore: cast_nullable_to_non_nullable
                  as int,
        threadParticipants: freezed == threadParticipants
            ? _self.threadParticipants
            : threadParticipants // ignore: cast_nullable_to_non_nullable
                  as List<ThreadParticipant>?,
        title: null == title
            ? _self.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}
