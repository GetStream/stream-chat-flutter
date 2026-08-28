// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_user_partial_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateUserPartialRequest {
  String get id;
  Map<String, Object?>? get set;
  List<String>? get unset;

  /// Create a copy of UpdateUserPartialRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdateUserPartialRequestCopyWith<UpdateUserPartialRequest> get copyWith =>
      _$UpdateUserPartialRequestCopyWithImpl<UpdateUserPartialRequest>(
        this as UpdateUserPartialRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdateUserPartialRequest &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other.set, set) &&
            const DeepCollectionEquality().equals(other.unset, unset));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    const DeepCollectionEquality().hash(set),
    const DeepCollectionEquality().hash(unset),
  );

  @override
  String toString() {
    return 'UpdateUserPartialRequest(id: $id, set: $set, unset: $unset)';
  }
}

/// @nodoc
abstract mixin class $UpdateUserPartialRequestCopyWith<$Res> {
  factory $UpdateUserPartialRequestCopyWith(
    UpdateUserPartialRequest value,
    $Res Function(UpdateUserPartialRequest) _then,
  ) = _$UpdateUserPartialRequestCopyWithImpl;
  @useResult
  $Res call({String id, Map<String, Object?>? set, List<String>? unset});
}

/// @nodoc
class _$UpdateUserPartialRequestCopyWithImpl<$Res>
    implements $UpdateUserPartialRequestCopyWith<$Res> {
  _$UpdateUserPartialRequestCopyWithImpl(this._self, this._then);

  final UpdateUserPartialRequest _self;
  final $Res Function(UpdateUserPartialRequest) _then;

  /// Create a copy of UpdateUserPartialRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? set = freezed,
    Object? unset = freezed,
  }) {
    return _then(
      UpdateUserPartialRequest(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
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
