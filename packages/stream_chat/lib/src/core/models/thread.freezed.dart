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
  Map<String, Object?> get extraData;

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
            const DeepCollectionEquality().equals(other.threadParticipants, threadParticipants) &&
            (identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt) &&
            const DeepCollectionEquality().equals(other.latestReplies, latestReplies) &&
            const DeepCollectionEquality().equals(other.read, read) &&
            (identical(other.draft, draft) || other.draft == draft) &&
            const DeepCollectionEquality().equals(other.extraData, extraData));
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
    const DeepCollectionEquality().hash(extraData),
  ]);

  @override
  String toString() {
    return 'Thread(activeParticipantCount: $activeParticipantCount, channelCid: $channelCid, channel: $channel, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, createdByUserId: $createdByUserId, createdBy: $createdBy, title: $title, parentMessageId: $parentMessageId, parentMessage: $parentMessage, replyCount: $replyCount, participantCount: $participantCount, threadParticipants: $threadParticipants, lastMessageAt: $lastMessageAt, latestReplies: $latestReplies, read: $read, draft: $draft, extraData: $extraData)';
  }
}
