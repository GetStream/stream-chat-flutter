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

  /// Create a copy of ReactionGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReactionGroupCopyWith<ReactionGroup> get copyWith =>
      _$ReactionGroupCopyWithImpl<ReactionGroup>(this as ReactionGroup, _$identity);

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

/// @nodoc
abstract mixin class $ReactionGroupCopyWith<$Res> {
  factory $ReactionGroupCopyWith(ReactionGroup value, $Res Function(ReactionGroup) _then) = _$ReactionGroupCopyWithImpl;
  @useResult
  $Res call({int count, int sumScores, DateTime? firstReactionAt, DateTime? lastReactionAt});
}

/// @nodoc
class _$ReactionGroupCopyWithImpl<$Res> implements $ReactionGroupCopyWith<$Res> {
  _$ReactionGroupCopyWithImpl(this._self, this._then);

  final ReactionGroup _self;
  final $Res Function(ReactionGroup) _then;

  /// Create a copy of ReactionGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
    Object? sumScores = null,
    Object? firstReactionAt = freezed,
    Object? lastReactionAt = freezed,
  }) {
    return _then(
      ReactionGroup(
        count: null == count
            ? _self.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
        sumScores: null == sumScores
            ? _self.sumScores
            : sumScores // ignore: cast_nullable_to_non_nullable
                  as int,
        firstReactionAt: freezed == firstReactionAt
            ? _self.firstReactionAt!
            : firstReactionAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lastReactionAt: freezed == lastReactionAt
            ? _self.lastReactionAt!
            : lastReactionAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}
