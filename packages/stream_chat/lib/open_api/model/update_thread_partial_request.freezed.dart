// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_thread_partial_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateThreadPartialRequest {
  Map<String, Object?>? get set;
  List<String>? get unset;

  /// Create a copy of UpdateThreadPartialRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdateThreadPartialRequestCopyWith<UpdateThreadPartialRequest>
  get copyWith =>
      _$UpdateThreadPartialRequestCopyWithImpl<UpdateThreadPartialRequest>(
        this as UpdateThreadPartialRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdateThreadPartialRequest &&
            const DeepCollectionEquality().equals(other.set, set) &&
            const DeepCollectionEquality().equals(other.unset, unset));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(set),
    const DeepCollectionEquality().hash(unset),
  );

  @override
  String toString() {
    return 'UpdateThreadPartialRequest(set: $set, unset: $unset)';
  }
}

/// @nodoc
abstract mixin class $UpdateThreadPartialRequestCopyWith<$Res> {
  factory $UpdateThreadPartialRequestCopyWith(
    UpdateThreadPartialRequest value,
    $Res Function(UpdateThreadPartialRequest) _then,
  ) = _$UpdateThreadPartialRequestCopyWithImpl;
  @useResult
  $Res call({Map<String, Object?>? set, List<String>? unset});
}

/// @nodoc
class _$UpdateThreadPartialRequestCopyWithImpl<$Res>
    implements $UpdateThreadPartialRequestCopyWith<$Res> {
  _$UpdateThreadPartialRequestCopyWithImpl(this._self, this._then);

  final UpdateThreadPartialRequest _self;
  final $Res Function(UpdateThreadPartialRequest) _then;

  /// Create a copy of UpdateThreadPartialRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? set = freezed, Object? unset = freezed}) {
    return _then(
      UpdateThreadPartialRequest(
        set: freezed == set
            ? _self.set
            : set // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        unset: freezed == unset
            ? _self.unset
            : unset // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}
