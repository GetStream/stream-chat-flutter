// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_activity_request_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeleteActivityRequestPayload {
  String? get entityId;
  String? get entityType;
  bool? get hardDelete;
  String? get reason;

  /// Create a copy of DeleteActivityRequestPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeleteActivityRequestPayloadCopyWith<DeleteActivityRequestPayload>
  get copyWith =>
      _$DeleteActivityRequestPayloadCopyWithImpl<DeleteActivityRequestPayload>(
        this as DeleteActivityRequestPayload,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DeleteActivityRequestPayload &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.hardDelete, hardDelete) ||
                other.hardDelete == hardDelete) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, entityId, entityType, hardDelete, reason);

  @override
  String toString() {
    return 'DeleteActivityRequestPayload(entityId: $entityId, entityType: $entityType, hardDelete: $hardDelete, reason: $reason)';
  }
}

/// @nodoc
abstract mixin class $DeleteActivityRequestPayloadCopyWith<$Res> {
  factory $DeleteActivityRequestPayloadCopyWith(
    DeleteActivityRequestPayload value,
    $Res Function(DeleteActivityRequestPayload) _then,
  ) = _$DeleteActivityRequestPayloadCopyWithImpl;
  @useResult
  $Res call({
    String? entityId,
    String? entityType,
    bool? hardDelete,
    String? reason,
  });
}

/// @nodoc
class _$DeleteActivityRequestPayloadCopyWithImpl<$Res>
    implements $DeleteActivityRequestPayloadCopyWith<$Res> {
  _$DeleteActivityRequestPayloadCopyWithImpl(this._self, this._then);

  final DeleteActivityRequestPayload _self;
  final $Res Function(DeleteActivityRequestPayload) _then;

  /// Create a copy of DeleteActivityRequestPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entityId = freezed,
    Object? entityType = freezed,
    Object? hardDelete = freezed,
    Object? reason = freezed,
  }) {
    return _then(
      DeleteActivityRequestPayload(
        entityId: freezed == entityId
            ? _self.entityId
            : entityId // ignore: cast_nullable_to_non_nullable
                  as String?,
        entityType: freezed == entityType
            ? _self.entityType
            : entityType // ignore: cast_nullable_to_non_nullable
                  as String?,
        hardDelete: freezed == hardDelete
            ? _self.hardDelete
            : hardDelete // ignore: cast_nullable_to_non_nullable
                  as bool?,
        reason: freezed == reason
            ? _self.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
