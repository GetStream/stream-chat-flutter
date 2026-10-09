// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Reaction {
  String? get messageId;
  String get type;
  int get score;
  String? get emojiCode;
  User? get user;
  String? get userId;
  DateTime get createdAt;
  DateTime get updatedAt;
  Map<String, Object?> get extraData;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Reaction &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.emojiCode, emojiCode) || other.emojiCode == emojiCode) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other.extraData, extraData));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    messageId,
    type,
    score,
    emojiCode,
    user,
    userId,
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(extraData),
  );

  @override
  String toString() {
    return 'Reaction(messageId: $messageId, type: $type, score: $score, emojiCode: $emojiCode, user: $user, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt, extraData: $extraData)';
  }
}
