// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminder_response_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReminderResponseData {
  ChannelResponse? get channel;
  String get channelCid;
  DateTime get createdAt;
  MessageResponse? get message;
  String get messageId;
  DateTime? get remindAt;
  DateTime get updatedAt;
  UserResponse? get user;
  String get userId;

  /// Create a copy of ReminderResponseData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReminderResponseDataCopyWith<ReminderResponseData> get copyWith =>
      _$ReminderResponseDataCopyWithImpl<ReminderResponseData>(
        this as ReminderResponseData,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReminderResponseData &&
            (identical(other.channel, channel) || other.channel == channel) &&
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
    channel,
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
    return 'ReminderResponseData(channel: $channel, channelCid: $channelCid, createdAt: $createdAt, message: $message, messageId: $messageId, remindAt: $remindAt, updatedAt: $updatedAt, user: $user, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $ReminderResponseDataCopyWith<$Res> {
  factory $ReminderResponseDataCopyWith(
    ReminderResponseData value,
    $Res Function(ReminderResponseData) _then,
  ) = _$ReminderResponseDataCopyWithImpl;
  @useResult
  $Res call({
    ChannelResponse? channel,
    String channelCid,
    DateTime createdAt,
    MessageResponse? message,
    String messageId,
    DateTime? remindAt,
    DateTime updatedAt,
    UserResponse? user,
    String userId,
  });
}

/// @nodoc
class _$ReminderResponseDataCopyWithImpl<$Res>
    implements $ReminderResponseDataCopyWith<$Res> {
  _$ReminderResponseDataCopyWithImpl(this._self, this._then);

  final ReminderResponseData _self;
  final $Res Function(ReminderResponseData) _then;

  /// Create a copy of ReminderResponseData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = freezed,
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
      ReminderResponseData(
        channel: freezed == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse?,
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
                  as MessageResponse?,
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
