// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'thread_state_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ThreadStateResponse {
  int get activeParticipantCount;
  ChannelResponse? get channel;
  String get channelCid;
  DateTime get createdAt;
  UserResponse? get createdBy;
  String get createdByUserId;
  Map<String, Object?> get custom;
  DateTime? get deletedAt;
  DraftResponse? get draft;
  DateTime? get lastMessageAt;
  List<MessageResponse> get latestReplies;
  MessageResponse? get parentMessage;
  String get parentMessageId;
  int get participantCount;
  List<ReadStateResponse>? get read;
  int get replyCount;
  List<ThreadParticipant>? get threadParticipants;
  String get title;
  DateTime get updatedAt;

  /// Create a copy of ThreadStateResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ThreadStateResponseCopyWith<ThreadStateResponse> get copyWith =>
      _$ThreadStateResponseCopyWithImpl<ThreadStateResponse>(
        this as ThreadStateResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ThreadStateResponse &&
            (identical(other.activeParticipantCount, activeParticipantCount) ||
                other.activeParticipantCount == activeParticipantCount) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.channelCid, channelCid) ||
                other.channelCid == channelCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdByUserId, createdByUserId) ||
                other.createdByUserId == createdByUserId) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.draft, draft) || other.draft == draft) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt) &&
            const DeepCollectionEquality().equals(
              other.latestReplies,
              latestReplies,
            ) &&
            (identical(other.parentMessage, parentMessage) ||
                other.parentMessage == parentMessage) &&
            (identical(other.parentMessageId, parentMessageId) ||
                other.parentMessageId == parentMessageId) &&
            (identical(other.participantCount, participantCount) ||
                other.participantCount == participantCount) &&
            const DeepCollectionEquality().equals(other.read, read) &&
            (identical(other.replyCount, replyCount) ||
                other.replyCount == replyCount) &&
            const DeepCollectionEquality().equals(
              other.threadParticipants,
              threadParticipants,
            ) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    activeParticipantCount,
    channel,
    channelCid,
    createdAt,
    createdBy,
    createdByUserId,
    const DeepCollectionEquality().hash(custom),
    deletedAt,
    draft,
    lastMessageAt,
    const DeepCollectionEquality().hash(latestReplies),
    parentMessage,
    parentMessageId,
    participantCount,
    const DeepCollectionEquality().hash(read),
    replyCount,
    const DeepCollectionEquality().hash(threadParticipants),
    title,
    updatedAt,
  ]);

  @override
  String toString() {
    return 'ThreadStateResponse(activeParticipantCount: $activeParticipantCount, channel: $channel, channelCid: $channelCid, createdAt: $createdAt, createdBy: $createdBy, createdByUserId: $createdByUserId, custom: $custom, deletedAt: $deletedAt, draft: $draft, lastMessageAt: $lastMessageAt, latestReplies: $latestReplies, parentMessage: $parentMessage, parentMessageId: $parentMessageId, participantCount: $participantCount, read: $read, replyCount: $replyCount, threadParticipants: $threadParticipants, title: $title, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $ThreadStateResponseCopyWith<$Res> {
  factory $ThreadStateResponseCopyWith(
    ThreadStateResponse value,
    $Res Function(ThreadStateResponse) _then,
  ) = _$ThreadStateResponseCopyWithImpl;
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
    DraftResponse? draft,
    DateTime? lastMessageAt,
    List<MessageResponse> latestReplies,
    MessageResponse? parentMessage,
    String parentMessageId,
    int participantCount,
    List<ReadStateResponse>? read,
    int replyCount,
    List<ThreadParticipant>? threadParticipants,
    String title,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$ThreadStateResponseCopyWithImpl<$Res>
    implements $ThreadStateResponseCopyWith<$Res> {
  _$ThreadStateResponseCopyWithImpl(this._self, this._then);

  final ThreadStateResponse _self;
  final $Res Function(ThreadStateResponse) _then;

  /// Create a copy of ThreadStateResponse
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
    Object? draft = freezed,
    Object? lastMessageAt = freezed,
    Object? latestReplies = null,
    Object? parentMessage = freezed,
    Object? parentMessageId = null,
    Object? participantCount = null,
    Object? read = freezed,
    Object? replyCount = null,
    Object? threadParticipants = freezed,
    Object? title = null,
    Object? updatedAt = null,
  }) {
    return _then(
      ThreadStateResponse(
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
        draft: freezed == draft
            ? _self.draft
            : draft // ignore: cast_nullable_to_non_nullable
                  as DraftResponse?,
        lastMessageAt: freezed == lastMessageAt
            ? _self.lastMessageAt
            : lastMessageAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        latestReplies: null == latestReplies
            ? _self.latestReplies
            : latestReplies // ignore: cast_nullable_to_non_nullable
                  as List<MessageResponse>,
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
        read: freezed == read
            ? _self.read
            : read // ignore: cast_nullable_to_non_nullable
                  as List<ReadStateResponse>?,
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
