// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poll_vote.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PollVote {
  String? get id;
  String? get pollId;
  String? get optionId;
  String? get answerText;
  Map<String, String>? get answerTextI18n;
  DateTime get createdAt;
  DateTime get updatedAt;
  String? get userId;
  User? get user;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PollVote &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.pollId, pollId) || other.pollId == pollId) &&
            (identical(other.optionId, optionId) || other.optionId == optionId) &&
            (identical(other.answerText, answerText) || other.answerText == answerText) &&
            const DeepCollectionEquality().equals(other.answerTextI18n, answerTextI18n) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    pollId,
    optionId,
    answerText,
    const DeepCollectionEquality().hash(answerTextI18n),
    createdAt,
    updatedAt,
    userId,
    user,
  );

  @override
  String toString() {
    return 'PollVote(id: $id, pollId: $pollId, optionId: $optionId, answerText: $answerText, answerTextI18n: $answerTextI18n, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, user: $user)';
  }
}
