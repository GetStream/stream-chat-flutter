// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'thread.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Thread {
  int? get activeParticipantCount;
  String get channelCid;
  ChannelModel? get channel;
  DateTime get createdAt;
  DateTime get updatedAt;
  DateTime? get deletedAt;
  String get createdByUserId;
  User? get createdBy;
  String? get title;
  String get parentMessageId;
  Message? get parentMessage;
  int get replyCount;
  int get participantCount;
  List<ThreadParticipant> get threadParticipants;
  DateTime? get lastMessageAt;
  List<Message> get latestReplies;
  List<Read>? get read;
  Draft? get draft;
  Map<String, Object?> get custom;

  /// Create a copy of Thread
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ThreadCopyWith<Thread> get copyWith => _$ThreadCopyWithImpl<Thread>(this as Thread, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Thread &&
            (identical(other.activeParticipantCount, activeParticipantCount) ||
                other.activeParticipantCount == activeParticipantCount) &&
            (identical(other.channelCid, channelCid) || other.channelCid == channelCid) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt) &&
            (identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId) &&
            (identical(other.createdBy, createdBy) || other.createdBy == createdBy) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.parentMessageId, parentMessageId) || other.parentMessageId == parentMessageId) &&
            (identical(other.parentMessage, parentMessage) || other.parentMessage == parentMessage) &&
            (identical(other.replyCount, replyCount) || other.replyCount == replyCount) &&
            (identical(other.participantCount, participantCount) || other.participantCount == participantCount) &&
            const DeepCollectionEquality().equals(
              other.threadParticipants,
              threadParticipants,
            ) &&
            (identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt) &&
            const DeepCollectionEquality().equals(
              other.latestReplies,
              latestReplies,
            ) &&
            const DeepCollectionEquality().equals(other.read, read) &&
            (identical(other.draft, draft) || other.draft == draft) &&
            const DeepCollectionEquality().equals(other.custom, custom));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    activeParticipantCount,
    channelCid,
    channel,
    createdAt,
    updatedAt,
    deletedAt,
    createdByUserId,
    createdBy,
    title,
    parentMessageId,
    parentMessage,
    replyCount,
    participantCount,
    const DeepCollectionEquality().hash(threadParticipants),
    lastMessageAt,
    const DeepCollectionEquality().hash(latestReplies),
    const DeepCollectionEquality().hash(read),
    draft,
    const DeepCollectionEquality().hash(custom),
  ]);

  @override
  String toString() {
    return 'Thread(activeParticipantCount: $activeParticipantCount, channelCid: $channelCid, channel: $channel, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, createdByUserId: $createdByUserId, createdBy: $createdBy, title: $title, parentMessageId: $parentMessageId, parentMessage: $parentMessage, replyCount: $replyCount, participantCount: $participantCount, threadParticipants: $threadParticipants, lastMessageAt: $lastMessageAt, latestReplies: $latestReplies, read: $read, draft: $draft, custom: $custom)';
  }
}

/// @nodoc
abstract mixin class $ThreadCopyWith<$Res> {
  factory $ThreadCopyWith(Thread value, $Res Function(Thread) _then) = _$ThreadCopyWithImpl;
  @useResult
  $Res call({
    int? activeParticipantCount,
    ChannelModel? channel,
    String channelCid,
    String parentMessageId,
    Message? parentMessage,
    String createdByUserId,
    User? createdBy,
    int replyCount,
    int participantCount,
    List<ThreadParticipant> threadParticipants,
    DateTime? lastMessageAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? title,
    List<Message> latestReplies,
    List<Read>? read,
    Draft? draft,
    Map<String, Object?> custom,
  });
}

/// @nodoc
class _$ThreadCopyWithImpl<$Res> implements $ThreadCopyWith<$Res> {
  _$ThreadCopyWithImpl(this._self, this._then);

  final Thread _self;
  final $Res Function(Thread) _then;

  /// Create a copy of Thread
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeParticipantCount = freezed,
    Object? channel = freezed,
    Object? channelCid = null,
    Object? parentMessageId = null,
    Object? parentMessage = freezed,
    Object? createdByUserId = null,
    Object? createdBy = freezed,
    Object? replyCount = null,
    Object? participantCount = null,
    Object? threadParticipants = null,
    Object? lastMessageAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? title = freezed,
    Object? latestReplies = null,
    Object? read = freezed,
    Object? draft = freezed,
    Object? custom = null,
  }) {
    return _then(
      Thread(
        activeParticipantCount: freezed == activeParticipantCount
            ? _self.activeParticipantCount
            : activeParticipantCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channel: freezed == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelModel?,
        channelCid: null == channelCid
            ? _self.channelCid
            : channelCid // ignore: cast_nullable_to_non_nullable
                  as String,
        parentMessageId: null == parentMessageId
            ? _self.parentMessageId
            : parentMessageId // ignore: cast_nullable_to_non_nullable
                  as String,
        parentMessage: freezed == parentMessage
            ? _self.parentMessage
            : parentMessage // ignore: cast_nullable_to_non_nullable
                  as Message?,
        createdByUserId: null == createdByUserId
            ? _self.createdByUserId
            : createdByUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdBy: freezed == createdBy
            ? _self.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as User?,
        replyCount: null == replyCount
            ? _self.replyCount
            : replyCount // ignore: cast_nullable_to_non_nullable
                  as int,
        participantCount: null == participantCount
            ? _self.participantCount
            : participantCount // ignore: cast_nullable_to_non_nullable
                  as int,
        threadParticipants: null == threadParticipants
            ? _self.threadParticipants
            : threadParticipants // ignore: cast_nullable_to_non_nullable
                  as List<ThreadParticipant>,
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
        title: freezed == title
            ? _self.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        latestReplies: null == latestReplies
            ? _self.latestReplies
            : latestReplies // ignore: cast_nullable_to_non_nullable
                  as List<Message>,
        read: freezed == read
            ? _self.read
            : read // ignore: cast_nullable_to_non_nullable
                  as List<Read>?,
        draft: freezed == draft
            ? _self.draft
            : draft // ignore: cast_nullable_to_non_nullable
                  as Draft?,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
      ),
    );
  }
}
