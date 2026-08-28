// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_draft_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatDraftResponse {
  String get channelCid;
  DateTime get createdAt;
  ChatDraftPayloadResponse get message;
  String? get parentId;
  ChatMessageResponse? get parentMessage;
  ChatMessageResponse? get quotedMessage;

  /// Create a copy of ChatDraftResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChatDraftResponseCopyWith<ChatDraftResponse> get copyWith =>
      _$ChatDraftResponseCopyWithImpl<ChatDraftResponse>(
        this as ChatDraftResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChatDraftResponse &&
            (identical(other.channelCid, channelCid) ||
                other.channelCid == channelCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.parentMessage, parentMessage) ||
                other.parentMessage == parentMessage) &&
            (identical(other.quotedMessage, quotedMessage) ||
                other.quotedMessage == quotedMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channelCid,
    createdAt,
    message,
    parentId,
    parentMessage,
    quotedMessage,
  );

  @override
  String toString() {
    return 'ChatDraftResponse(channelCid: $channelCid, createdAt: $createdAt, message: $message, parentId: $parentId, parentMessage: $parentMessage, quotedMessage: $quotedMessage)';
  }
}

/// @nodoc
abstract mixin class $ChatDraftResponseCopyWith<$Res> {
  factory $ChatDraftResponseCopyWith(
    ChatDraftResponse value,
    $Res Function(ChatDraftResponse) _then,
  ) = _$ChatDraftResponseCopyWithImpl;
  @useResult
  $Res call({
    String channelCid,
    DateTime createdAt,
    ChatDraftPayloadResponse message,
    String? parentId,
    ChatMessageResponse? parentMessage,
    ChatMessageResponse? quotedMessage,
  });
}

/// @nodoc
class _$ChatDraftResponseCopyWithImpl<$Res>
    implements $ChatDraftResponseCopyWith<$Res> {
  _$ChatDraftResponseCopyWithImpl(this._self, this._then);

  final ChatDraftResponse _self;
  final $Res Function(ChatDraftResponse) _then;

  /// Create a copy of ChatDraftResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelCid = null,
    Object? createdAt = null,
    Object? message = null,
    Object? parentId = freezed,
    Object? parentMessage = freezed,
    Object? quotedMessage = freezed,
  }) {
    return _then(
      ChatDraftResponse(
        channelCid: null == channelCid
            ? _self.channelCid
            : channelCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        message: null == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as ChatDraftPayloadResponse,
        parentId: freezed == parentId
            ? _self.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        parentMessage: freezed == parentMessage
            ? _self.parentMessage
            : parentMessage // ignore: cast_nullable_to_non_nullable
                  as ChatMessageResponse?,
        quotedMessage: freezed == quotedMessage
            ? _self.quotedMessage
            : quotedMessage // ignore: cast_nullable_to_non_nullable
                  as ChatMessageResponse?,
      ),
    );
  }
}
