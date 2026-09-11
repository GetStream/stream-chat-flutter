// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_user_messages_request_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeleteUserMessagesRequestPayload {
  String? get channelCid;
  DeleteUserMessagesRequestPayloadDeleteMessages get deleteMessages;
  bool? get deleteReactions;
  String? get entityId;
  String? get entityType;
  String? get reason;

  /// Create a copy of DeleteUserMessagesRequestPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeleteUserMessagesRequestPayloadCopyWith<DeleteUserMessagesRequestPayload> get copyWith =>
      _$DeleteUserMessagesRequestPayloadCopyWithImpl<DeleteUserMessagesRequestPayload>(
        this as DeleteUserMessagesRequestPayload,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DeleteUserMessagesRequestPayload &&
            (identical(other.channelCid, channelCid) || other.channelCid == channelCid) &&
            (identical(other.deleteMessages, deleteMessages) || other.deleteMessages == deleteMessages) &&
            (identical(other.deleteReactions, deleteReactions) || other.deleteReactions == deleteReactions) &&
            (identical(other.entityId, entityId) || other.entityId == entityId) &&
            (identical(other.entityType, entityType) || other.entityType == entityType) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channelCid,
    deleteMessages,
    deleteReactions,
    entityId,
    entityType,
    reason,
  );

  @override
  String toString() {
    return 'DeleteUserMessagesRequestPayload(channelCid: $channelCid, deleteMessages: $deleteMessages, deleteReactions: $deleteReactions, entityId: $entityId, entityType: $entityType, reason: $reason)';
  }
}

/// @nodoc
abstract mixin class $DeleteUserMessagesRequestPayloadCopyWith<$Res> {
  factory $DeleteUserMessagesRequestPayloadCopyWith(
    DeleteUserMessagesRequestPayload value,
    $Res Function(DeleteUserMessagesRequestPayload) _then,
  ) = _$DeleteUserMessagesRequestPayloadCopyWithImpl;
  @useResult
  $Res call({
    String? channelCid,
    DeleteUserMessagesRequestPayloadDeleteMessages deleteMessages,
    bool? deleteReactions,
    String? entityId,
    String? entityType,
    String? reason,
  });
}

/// @nodoc
class _$DeleteUserMessagesRequestPayloadCopyWithImpl<$Res> implements $DeleteUserMessagesRequestPayloadCopyWith<$Res> {
  _$DeleteUserMessagesRequestPayloadCopyWithImpl(this._self, this._then);

  final DeleteUserMessagesRequestPayload _self;
  final $Res Function(DeleteUserMessagesRequestPayload) _then;

  /// Create a copy of DeleteUserMessagesRequestPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelCid = freezed,
    Object? deleteMessages = null,
    Object? deleteReactions = freezed,
    Object? entityId = freezed,
    Object? entityType = freezed,
    Object? reason = freezed,
  }) {
    return _then(
      DeleteUserMessagesRequestPayload(
        channelCid: freezed == channelCid
            ? _self.channelCid
            : channelCid // ignore: cast_nullable_to_non_nullable
                  as String?,
        deleteMessages: null == deleteMessages
            ? _self.deleteMessages
            : deleteMessages // ignore: cast_nullable_to_non_nullable
                  as DeleteUserMessagesRequestPayloadDeleteMessages,
        deleteReactions: freezed == deleteReactions
            ? _self.deleteReactions
            : deleteReactions // ignore: cast_nullable_to_non_nullable
                  as bool?,
        entityId: freezed == entityId
            ? _self.entityId
            : entityId // ignore: cast_nullable_to_non_nullable
                  as String?,
        entityType: freezed == entityType
            ? _self.entityType
            : entityType // ignore: cast_nullable_to_non_nullable
                  as String?,
        reason: freezed == reason
            ? _self.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
