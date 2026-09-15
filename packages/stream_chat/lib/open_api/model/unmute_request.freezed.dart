// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unmute_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UnmuteRequest {
  List<String> get targetIds;

  /// Create a copy of UnmuteRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UnmuteRequestCopyWith<UnmuteRequest> get copyWith => _$UnmuteRequestCopyWithImpl<UnmuteRequest>(
    this as UnmuteRequest,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UnmuteRequest &&
            const DeepCollectionEquality().equals(other.targetIds, targetIds));
  }

  @override
  int get hashCode => Object.hash(runtimeType, const DeepCollectionEquality().hash(targetIds));

  @override
  String toString() {
    return 'UnmuteRequest(targetIds: $targetIds)';
  }
}

/// @nodoc
abstract mixin class $UnmuteRequestCopyWith<$Res> {
  factory $UnmuteRequestCopyWith(
    UnmuteRequest value,
    $Res Function(UnmuteRequest) _then,
  ) = _$UnmuteRequestCopyWithImpl;
  @useResult
  $Res call({List<String> targetIds});
}

/// @nodoc
class _$UnmuteRequestCopyWithImpl<$Res> implements $UnmuteRequestCopyWith<$Res> {
  _$UnmuteRequestCopyWithImpl(this._self, this._then);

  final UnmuteRequest _self;
  final $Res Function(UnmuteRequest) _then;

  /// Create a copy of UnmuteRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? targetIds = null}) {
    return _then(
      UnmuteRequest(
        targetIds: null == targetIds
            ? _self.targetIds
            : targetIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}
