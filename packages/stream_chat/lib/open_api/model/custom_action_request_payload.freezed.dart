// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_action_request_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomActionRequestPayload {
  String? get id;
  Map<String, Object?>? get options;

  /// Create a copy of CustomActionRequestPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CustomActionRequestPayloadCopyWith<CustomActionRequestPayload>
  get copyWith =>
      _$CustomActionRequestPayloadCopyWithImpl<CustomActionRequestPayload>(
        this as CustomActionRequestPayload,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CustomActionRequestPayload &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other.options, options));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    const DeepCollectionEquality().hash(options),
  );

  @override
  String toString() {
    return 'CustomActionRequestPayload(id: $id, options: $options)';
  }
}

/// @nodoc
abstract mixin class $CustomActionRequestPayloadCopyWith<$Res> {
  factory $CustomActionRequestPayloadCopyWith(
    CustomActionRequestPayload value,
    $Res Function(CustomActionRequestPayload) _then,
  ) = _$CustomActionRequestPayloadCopyWithImpl;
  @useResult
  $Res call({String? id, Map<String, Object?>? options});
}

/// @nodoc
class _$CustomActionRequestPayloadCopyWithImpl<$Res>
    implements $CustomActionRequestPayloadCopyWith<$Res> {
  _$CustomActionRequestPayloadCopyWithImpl(this._self, this._then);

  final CustomActionRequestPayload _self;
  final $Res Function(CustomActionRequestPayload) _then;

  /// Create a copy of CustomActionRequestPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = freezed, Object? options = freezed}) {
    return _then(
      CustomActionRequestPayload(
        id: freezed == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        options: freezed == options
            ? _self.options
            : options // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
      ),
    );
  }
}
