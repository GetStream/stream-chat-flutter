// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reaction_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReactionGroup {
  int get count;
  int get sumScores;
  DateTime get firstReactionAt;
  DateTime get lastReactionAt;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReactionGroup &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.sumScores, sumScores) || other.sumScores == sumScores) &&
            (identical(other.firstReactionAt, firstReactionAt) || other.firstReactionAt == firstReactionAt) &&
            (identical(other.lastReactionAt, lastReactionAt) || other.lastReactionAt == lastReactionAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, count, sumScores, firstReactionAt, lastReactionAt);

  @override
  String toString() {
    return 'ReactionGroup(count: $count, sumScores: $sumScores, firstReactionAt: $firstReactionAt, lastReactionAt: $lastReactionAt)';
  }
}
