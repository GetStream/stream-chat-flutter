// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivered_message_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeliveredMessagePayload {
  String? get cid;
  String? get id;

  /// Create a copy of DeliveredMessagePayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeliveredMessagePayloadCopyWith<DeliveredMessagePayload> get copyWith =>
      _$DeliveredMessagePayloadCopyWithImpl<DeliveredMessagePayload>(
        this as DeliveredMessagePayload,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DeliveredMessagePayload &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(runtimeType, cid, id);

  @override
  String toString() {
    return 'DeliveredMessagePayload(cid: $cid, id: $id)';
  }
}

/// @nodoc
abstract mixin class $DeliveredMessagePayloadCopyWith<$Res> {
  factory $DeliveredMessagePayloadCopyWith(
    DeliveredMessagePayload value,
    $Res Function(DeliveredMessagePayload) _then,
  ) = _$DeliveredMessagePayloadCopyWithImpl;
  @useResult
  $Res call({String? cid, String? id});
}

/// @nodoc
class _$DeliveredMessagePayloadCopyWithImpl<$Res> implements $DeliveredMessagePayloadCopyWith<$Res> {
  _$DeliveredMessagePayloadCopyWithImpl(this._self, this._then);

  final DeliveredMessagePayload _self;
  final $Res Function(DeliveredMessagePayload) _then;

  /// Create a copy of DeliveredMessagePayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? cid = freezed, Object? id = freezed}) {
    return _then(
      DeliveredMessagePayload(
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        id: freezed == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
