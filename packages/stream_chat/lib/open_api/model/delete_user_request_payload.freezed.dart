// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_user_request_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeleteUserRequestPayload {
  bool? get deleteConversationChannels;
  bool? get deleteFeedsContent;
  String? get entityId;
  String? get entityType;
  bool? get hardDelete;
  bool? get markMessagesDeleted;
  String? get reason;

  /// Create a copy of DeleteUserRequestPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeleteUserRequestPayloadCopyWith<DeleteUserRequestPayload> get copyWith =>
      _$DeleteUserRequestPayloadCopyWithImpl<DeleteUserRequestPayload>(
        this as DeleteUserRequestPayload,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DeleteUserRequestPayload &&
            (identical(
                  other.deleteConversationChannels,
                  deleteConversationChannels,
                ) ||
                other.deleteConversationChannels ==
                    deleteConversationChannels) &&
            (identical(other.deleteFeedsContent, deleteFeedsContent) ||
                other.deleteFeedsContent == deleteFeedsContent) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.hardDelete, hardDelete) ||
                other.hardDelete == hardDelete) &&
            (identical(other.markMessagesDeleted, markMessagesDeleted) ||
                other.markMessagesDeleted == markMessagesDeleted) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    deleteConversationChannels,
    deleteFeedsContent,
    entityId,
    entityType,
    hardDelete,
    markMessagesDeleted,
    reason,
  );

  @override
  String toString() {
    return 'DeleteUserRequestPayload(deleteConversationChannels: $deleteConversationChannels, deleteFeedsContent: $deleteFeedsContent, entityId: $entityId, entityType: $entityType, hardDelete: $hardDelete, markMessagesDeleted: $markMessagesDeleted, reason: $reason)';
  }
}

/// @nodoc
abstract mixin class $DeleteUserRequestPayloadCopyWith<$Res> {
  factory $DeleteUserRequestPayloadCopyWith(
    DeleteUserRequestPayload value,
    $Res Function(DeleteUserRequestPayload) _then,
  ) = _$DeleteUserRequestPayloadCopyWithImpl;
  @useResult
  $Res call({
    bool? deleteConversationChannels,
    bool? deleteFeedsContent,
    String? entityId,
    String? entityType,
    bool? hardDelete,
    bool? markMessagesDeleted,
    String? reason,
  });
}

/// @nodoc
class _$DeleteUserRequestPayloadCopyWithImpl<$Res>
    implements $DeleteUserRequestPayloadCopyWith<$Res> {
  _$DeleteUserRequestPayloadCopyWithImpl(this._self, this._then);

  final DeleteUserRequestPayload _self;
  final $Res Function(DeleteUserRequestPayload) _then;

  /// Create a copy of DeleteUserRequestPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deleteConversationChannels = freezed,
    Object? deleteFeedsContent = freezed,
    Object? entityId = freezed,
    Object? entityType = freezed,
    Object? hardDelete = freezed,
    Object? markMessagesDeleted = freezed,
    Object? reason = freezed,
  }) {
    return _then(
      DeleteUserRequestPayload(
        deleteConversationChannels: freezed == deleteConversationChannels
            ? _self.deleteConversationChannels
            : deleteConversationChannels // ignore: cast_nullable_to_non_nullable
                  as bool?,
        deleteFeedsContent: freezed == deleteFeedsContent
            ? _self.deleteFeedsContent
            : deleteFeedsContent // ignore: cast_nullable_to_non_nullable
                  as bool?,
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
        markMessagesDeleted: freezed == markMessagesDeleted
            ? _self.markMessagesDeleted
            : markMessagesDeleted // ignore: cast_nullable_to_non_nullable
                  as bool?,
        reason: freezed == reason
            ? _self.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
