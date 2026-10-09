// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'thread_participant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ThreadParticipant {
  String get channelCid;
  DateTime get createdAt;
  DateTime get lastReadAt;
  DateTime? get lastThreadMessageAt;
  DateTime? get leftThreadAt;
  String? get threadId;
  String? get userId;
  User? get user;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ThreadParticipant &&
            (identical(other.channelCid, channelCid) || other.channelCid == channelCid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.lastReadAt, lastReadAt) || other.lastReadAt == lastReadAt) &&
            (identical(other.lastThreadMessageAt, lastThreadMessageAt) ||
                other.lastThreadMessageAt == lastThreadMessageAt) &&
            (identical(other.leftThreadAt, leftThreadAt) || other.leftThreadAt == leftThreadAt) &&
            (identical(other.threadId, threadId) || other.threadId == threadId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channelCid,
    createdAt,
    lastReadAt,
    lastThreadMessageAt,
    leftThreadAt,
    threadId,
    userId,
    user,
  );

  @override
  String toString() {
    return 'ThreadParticipant(channelCid: $channelCid, createdAt: $createdAt, lastReadAt: $lastReadAt, lastThreadMessageAt: $lastThreadMessageAt, leftThreadAt: $leftThreadAt, threadId: $threadId, userId: $userId, user: $user)';
  }
}
