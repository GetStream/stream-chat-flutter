// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mute_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MuteRequest {
  List<String> get targetIds;
  int? get timeout;

  /// Create a copy of MuteRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MuteRequestCopyWith<MuteRequest> get copyWith =>
      _$MuteRequestCopyWithImpl<MuteRequest>(this as MuteRequest, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MuteRequest &&
            const DeepCollectionEquality().equals(other.targetIds, targetIds) &&
            (identical(other.timeout, timeout) || other.timeout == timeout));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(targetIds),
    timeout,
  );

  @override
  String toString() {
    return 'MuteRequest(targetIds: $targetIds, timeout: $timeout)';
  }
}

/// @nodoc
abstract mixin class $MuteRequestCopyWith<$Res> {
  factory $MuteRequestCopyWith(
    MuteRequest value,
    $Res Function(MuteRequest) _then,
  ) = _$MuteRequestCopyWithImpl;
  @useResult
  $Res call({List<String> targetIds, int? timeout});
}

/// @nodoc
class _$MuteRequestCopyWithImpl<$Res> implements $MuteRequestCopyWith<$Res> {
  _$MuteRequestCopyWithImpl(this._self, this._then);

  final MuteRequest _self;
  final $Res Function(MuteRequest) _then;

  /// Create a copy of MuteRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? targetIds = null, Object? timeout = freezed}) {
    return _then(
      MuteRequest(
        targetIds: null == targetIds
            ? _self.targetIds
            : targetIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        timeout: freezed == timeout
            ? _self.timeout
            : timeout // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}
