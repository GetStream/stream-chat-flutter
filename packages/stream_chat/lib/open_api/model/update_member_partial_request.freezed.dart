// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_member_partial_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateMemberPartialRequest {
  Map<String, Object?>? get set;
  List<String>? get unset;

  /// Create a copy of UpdateMemberPartialRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdateMemberPartialRequestCopyWith<UpdateMemberPartialRequest>
  get copyWith =>
      _$UpdateMemberPartialRequestCopyWithImpl<UpdateMemberPartialRequest>(
        this as UpdateMemberPartialRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdateMemberPartialRequest &&
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
    return 'UpdateMemberPartialRequest(set: $set, unset: $unset)';
  }
}

/// @nodoc
abstract mixin class $UpdateMemberPartialRequestCopyWith<$Res> {
  factory $UpdateMemberPartialRequestCopyWith(
    UpdateMemberPartialRequest value,
    $Res Function(UpdateMemberPartialRequest) _then,
  ) = _$UpdateMemberPartialRequestCopyWithImpl;
  @useResult
  $Res call({Map<String, Object?>? set, List<String>? unset});
}

/// @nodoc
class _$UpdateMemberPartialRequestCopyWithImpl<$Res>
    implements $UpdateMemberPartialRequestCopyWith<$Res> {
  _$UpdateMemberPartialRequestCopyWithImpl(this._self, this._then);

  final UpdateMemberPartialRequest _self;
  final $Res Function(UpdateMemberPartialRequest) _then;

  /// Create a copy of UpdateMemberPartialRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? set = freezed, Object? unset = freezed}) {
    return _then(
      UpdateMemberPartialRequest(
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
