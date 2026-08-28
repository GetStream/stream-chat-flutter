// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flag_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FlagRequest {
  Map<String, Object?>? get custom;
  String? get entityCreatorId;
  String get entityId;
  String get entityType;
  ModerationPayload? get moderationPayload;
  String? get reason;

  /// Create a copy of FlagRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FlagRequestCopyWith<FlagRequest> get copyWith =>
      _$FlagRequestCopyWithImpl<FlagRequest>(this as FlagRequest, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FlagRequest &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.entityCreatorId, entityCreatorId) ||
                other.entityCreatorId == entityCreatorId) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.moderationPayload, moderationPayload) ||
                other.moderationPayload == moderationPayload) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(custom),
    entityCreatorId,
    entityId,
    entityType,
    moderationPayload,
    reason,
  );

  @override
  String toString() {
    return 'FlagRequest(custom: $custom, entityCreatorId: $entityCreatorId, entityId: $entityId, entityType: $entityType, moderationPayload: $moderationPayload, reason: $reason)';
  }
}

/// @nodoc
abstract mixin class $FlagRequestCopyWith<$Res> {
  factory $FlagRequestCopyWith(
    FlagRequest value,
    $Res Function(FlagRequest) _then,
  ) = _$FlagRequestCopyWithImpl;
  @useResult
  $Res call({
    Map<String, Object?>? custom,
    String? entityCreatorId,
    String entityId,
    String entityType,
    ModerationPayload? moderationPayload,
    String? reason,
  });
}

/// @nodoc
class _$FlagRequestCopyWithImpl<$Res> implements $FlagRequestCopyWith<$Res> {
  _$FlagRequestCopyWithImpl(this._self, this._then);

  final FlagRequest _self;
  final $Res Function(FlagRequest) _then;

  /// Create a copy of FlagRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? custom = freezed,
    Object? entityCreatorId = freezed,
    Object? entityId = null,
    Object? entityType = null,
    Object? moderationPayload = freezed,
    Object? reason = freezed,
  }) {
    return _then(
      FlagRequest(
        custom: freezed == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        entityCreatorId: freezed == entityCreatorId
            ? _self.entityCreatorId
            : entityCreatorId // ignore: cast_nullable_to_non_nullable
                  as String?,
        entityId: null == entityId
            ? _self.entityId
            : entityId // ignore: cast_nullable_to_non_nullable
                  as String,
        entityType: null == entityType
            ? _self.entityType
            : entityType // ignore: cast_nullable_to_non_nullable
                  as String,
        moderationPayload: freezed == moderationPayload
            ? _self.moderationPayload
            : moderationPayload // ignore: cast_nullable_to_non_nullable
                  as ModerationPayload?,
        reason: freezed == reason
            ? _self.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
