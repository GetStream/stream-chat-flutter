// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appeal_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppealRequest {
  String get appealReason;
  List<String>? get attachments;
  String get entityId;
  String get entityType;
  String? get reviewQueueItemId;

  /// Create a copy of AppealRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppealRequestCopyWith<AppealRequest> get copyWith =>
      _$AppealRequestCopyWithImpl<AppealRequest>(
        this as AppealRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppealRequest &&
            (identical(other.appealReason, appealReason) ||
                other.appealReason == appealReason) &&
            const DeepCollectionEquality().equals(
              other.attachments,
              attachments,
            ) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.reviewQueueItemId, reviewQueueItemId) ||
                other.reviewQueueItemId == reviewQueueItemId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    appealReason,
    const DeepCollectionEquality().hash(attachments),
    entityId,
    entityType,
    reviewQueueItemId,
  );

  @override
  String toString() {
    return 'AppealRequest(appealReason: $appealReason, attachments: $attachments, entityId: $entityId, entityType: $entityType, reviewQueueItemId: $reviewQueueItemId)';
  }
}

/// @nodoc
abstract mixin class $AppealRequestCopyWith<$Res> {
  factory $AppealRequestCopyWith(
    AppealRequest value,
    $Res Function(AppealRequest) _then,
  ) = _$AppealRequestCopyWithImpl;
  @useResult
  $Res call({
    String appealReason,
    List<String>? attachments,
    String entityId,
    String entityType,
    String? reviewQueueItemId,
  });
}

/// @nodoc
class _$AppealRequestCopyWithImpl<$Res>
    implements $AppealRequestCopyWith<$Res> {
  _$AppealRequestCopyWithImpl(this._self, this._then);

  final AppealRequest _self;
  final $Res Function(AppealRequest) _then;

  /// Create a copy of AppealRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appealReason = null,
    Object? attachments = freezed,
    Object? entityId = null,
    Object? entityType = null,
    Object? reviewQueueItemId = freezed,
  }) {
    return _then(
      AppealRequest(
        appealReason: null == appealReason
            ? _self.appealReason
            : appealReason // ignore: cast_nullable_to_non_nullable
                  as String,
        attachments: freezed == attachments
            ? _self.attachments
            : attachments // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        entityId: null == entityId
            ? _self.entityId
            : entityId // ignore: cast_nullable_to_non_nullable
                  as String,
        entityType: null == entityType
            ? _self.entityType
            : entityType // ignore: cast_nullable_to_non_nullable
                  as String,
        reviewQueueItemId: freezed == reviewQueueItemId
            ? _self.reviewQueueItemId
            : reviewQueueItemId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
