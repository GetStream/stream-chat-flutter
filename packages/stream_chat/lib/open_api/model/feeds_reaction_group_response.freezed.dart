// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feeds_reaction_group_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeedsReactionGroupResponse {
  int get count;
  DateTime get firstReactionAt;
  DateTime get lastReactionAt;

  /// Create a copy of FeedsReactionGroupResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FeedsReactionGroupResponseCopyWith<FeedsReactionGroupResponse>
  get copyWith =>
      _$FeedsReactionGroupResponseCopyWithImpl<FeedsReactionGroupResponse>(
        this as FeedsReactionGroupResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FeedsReactionGroupResponse &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.firstReactionAt, firstReactionAt) ||
                other.firstReactionAt == firstReactionAt) &&
            (identical(other.lastReactionAt, lastReactionAt) ||
                other.lastReactionAt == lastReactionAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, count, firstReactionAt, lastReactionAt);

  @override
  String toString() {
    return 'FeedsReactionGroupResponse(count: $count, firstReactionAt: $firstReactionAt, lastReactionAt: $lastReactionAt)';
  }
}

/// @nodoc
abstract mixin class $FeedsReactionGroupResponseCopyWith<$Res> {
  factory $FeedsReactionGroupResponseCopyWith(
    FeedsReactionGroupResponse value,
    $Res Function(FeedsReactionGroupResponse) _then,
  ) = _$FeedsReactionGroupResponseCopyWithImpl;
  @useResult
  $Res call({int count, DateTime firstReactionAt, DateTime lastReactionAt});
}

/// @nodoc
class _$FeedsReactionGroupResponseCopyWithImpl<$Res>
    implements $FeedsReactionGroupResponseCopyWith<$Res> {
  _$FeedsReactionGroupResponseCopyWithImpl(this._self, this._then);

  final FeedsReactionGroupResponse _self;
  final $Res Function(FeedsReactionGroupResponse) _then;

  /// Create a copy of FeedsReactionGroupResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
    Object? firstReactionAt = null,
    Object? lastReactionAt = null,
  }) {
    return _then(
      FeedsReactionGroupResponse(
        count: null == count
            ? _self.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
        firstReactionAt: null == firstReactionAt
            ? _self.firstReactionAt
            : firstReactionAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastReactionAt: null == lastReactionAt
            ? _self.lastReactionAt
            : lastReactionAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}
