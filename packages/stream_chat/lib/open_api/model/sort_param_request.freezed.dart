// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sort_param_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SortParamRequest {
  int? get direction;
  String? get field;
  String? get type;

  /// Create a copy of SortParamRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SortParamRequestCopyWith<SortParamRequest> get copyWith =>
      _$SortParamRequestCopyWithImpl<SortParamRequest>(
        this as SortParamRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SortParamRequest &&
            (identical(other.direction, direction) ||
                other.direction == direction) &&
            (identical(other.field, field) || other.field == field) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(runtimeType, direction, field, type);

  @override
  String toString() {
    return 'SortParamRequest(direction: $direction, field: $field, type: $type)';
  }
}

/// @nodoc
abstract mixin class $SortParamRequestCopyWith<$Res> {
  factory $SortParamRequestCopyWith(
    SortParamRequest value,
    $Res Function(SortParamRequest) _then,
  ) = _$SortParamRequestCopyWithImpl;
  @useResult
  $Res call({int? direction, String? field, String? type});
}

/// @nodoc
class _$SortParamRequestCopyWithImpl<$Res>
    implements $SortParamRequestCopyWith<$Res> {
  _$SortParamRequestCopyWithImpl(this._self, this._then);

  final SortParamRequest _self;
  final $Res Function(SortParamRequest) _then;

  /// Create a copy of SortParamRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? direction = freezed,
    Object? field = freezed,
    Object? type = freezed,
  }) {
    return _then(
      SortParamRequest(
        direction: freezed == direction
            ? _self.direction
            : direction // ignore: cast_nullable_to_non_nullable
                  as int?,
        field: freezed == field
            ? _self.field
            : field // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: freezed == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
