// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reaction_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReactionRequest {
  DateTime? get createdAt;
  Map<String, Object?>? get custom;
  int? get score;
  String get type;
  DateTime? get updatedAt;

  /// Create a copy of ReactionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReactionRequestCopyWith<ReactionRequest> get copyWith => _$ReactionRequestCopyWithImpl<ReactionRequest>(
    this as ReactionRequest,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReactionRequest &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    score,
    type,
    updatedAt,
  );

  @override
  String toString() {
    return 'ReactionRequest(createdAt: $createdAt, custom: $custom, score: $score, type: $type, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $ReactionRequestCopyWith<$Res> {
  factory $ReactionRequestCopyWith(
    ReactionRequest value,
    $Res Function(ReactionRequest) _then,
  ) = _$ReactionRequestCopyWithImpl;
  @useResult
  $Res call({
    DateTime? createdAt,
    Map<String, Object?>? custom,
    int? score,
    String type,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$ReactionRequestCopyWithImpl<$Res> implements $ReactionRequestCopyWith<$Res> {
  _$ReactionRequestCopyWithImpl(this._self, this._then);

  final ReactionRequest _self;
  final $Res Function(ReactionRequest) _then;

  /// Create a copy of ReactionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = freezed,
    Object? custom = freezed,
    Object? score = freezed,
    Object? type = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      ReactionRequest(
        createdAt: freezed == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        custom: freezed == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        score: freezed == score
            ? _self.score
            : score // ignore: cast_nullable_to_non_nullable
                  as int?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: freezed == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}
