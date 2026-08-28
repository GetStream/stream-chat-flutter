// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_reminder_response_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatReminderResponseData {
  String get channelCid;
  DateTime get createdAt;
  ChatMessageResponse? get message;
  String get messageId;
  DateTime? get remindAt;
  DateTime get updatedAt;
  UserResponse? get user;
  String get userId;

  /// Create a copy of ChatReminderResponseData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChatReminderResponseDataCopyWith<ChatReminderResponseData> get copyWith =>
      _$ChatReminderResponseDataCopyWithImpl<ChatReminderResponseData>(
        this as ChatReminderResponseData,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChatReminderResponseData &&
            (identical(other.channelCid, channelCid) ||
                other.channelCid == channelCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.remindAt, remindAt) ||
                other.remindAt == remindAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channelCid,
    createdAt,
    message,
    messageId,
    remindAt,
    updatedAt,
    user,
    userId,
  );

  @override
  String toString() {
    return 'ChatReminderResponseData(channelCid: $channelCid, createdAt: $createdAt, message: $message, messageId: $messageId, remindAt: $remindAt, updatedAt: $updatedAt, user: $user, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $ChatReminderResponseDataCopyWith<$Res> {
  factory $ChatReminderResponseDataCopyWith(
    ChatReminderResponseData value,
    $Res Function(ChatReminderResponseData) _then,
  ) = _$ChatReminderResponseDataCopyWithImpl;
  @useResult
  $Res call({
    String channelCid,
    DateTime createdAt,
    ChatMessageResponse? message,
    String messageId,
    DateTime? remindAt,
    DateTime updatedAt,
    UserResponse? user,
    String userId,
  });
}

/// @nodoc
class _$ChatReminderResponseDataCopyWithImpl<$Res>
    implements $ChatReminderResponseDataCopyWith<$Res> {
  _$ChatReminderResponseDataCopyWithImpl(this._self, this._then);

  final ChatReminderResponseData _self;
  final $Res Function(ChatReminderResponseData) _then;

  /// Create a copy of ChatReminderResponseData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelCid = null,
    Object? createdAt = null,
    Object? message = freezed,
    Object? messageId = null,
    Object? remindAt = freezed,
    Object? updatedAt = null,
    Object? user = freezed,
    Object? userId = null,
  }) {
    return _then(
      ChatReminderResponseData(
        channelCid: null == channelCid
            ? _self.channelCid
            : channelCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        message: freezed == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as ChatMessageResponse?,
        messageId: null == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String,
        remindAt: freezed == remindAt
            ? _self.remindAt
            : remindAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponse?,
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
