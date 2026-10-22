// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_reminder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessageReminder {
  String get channelCid;
  ChannelModel? get channel;
  String get messageId;
  Message? get message;
  String get userId;
  User? get user;
  DateTime? get remindAt;
  DateTime get createdAt;
  DateTime get updatedAt;

  /// Create a copy of MessageReminder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MessageReminderCopyWith<MessageReminder> get copyWith =>
      _$MessageReminderCopyWithImpl<MessageReminder>(this as MessageReminder, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MessageReminder &&
            (identical(other.channelCid, channelCid) || other.channelCid == channelCid) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.remindAt, remindAt) || other.remindAt == remindAt) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, channelCid, channel, messageId, message, userId, user, remindAt, createdAt, updatedAt);

  @override
  String toString() {
    return 'MessageReminder(channelCid: $channelCid, channel: $channel, messageId: $messageId, message: $message, userId: $userId, user: $user, remindAt: $remindAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $MessageReminderCopyWith<$Res> {
  factory $MessageReminderCopyWith(MessageReminder value, $Res Function(MessageReminder) _then) =
      _$MessageReminderCopyWithImpl;
  @useResult
  $Res call({
    String channelCid,
    ChannelModel? channel,
    String messageId,
    Message? message,
    String userId,
    User? user,
    DateTime? remindAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$MessageReminderCopyWithImpl<$Res> implements $MessageReminderCopyWith<$Res> {
  _$MessageReminderCopyWithImpl(this._self, this._then);

  final MessageReminder _self;
  final $Res Function(MessageReminder) _then;

  /// Create a copy of MessageReminder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelCid = null,
    Object? channel = freezed,
    Object? messageId = null,
    Object? message = freezed,
    Object? userId = null,
    Object? user = freezed,
    Object? remindAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      MessageReminder(
        channelCid: null == channelCid
            ? _self.channelCid
            : channelCid // ignore: cast_nullable_to_non_nullable
                  as String,
        channel: freezed == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelModel?,
        messageId: null == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String,
        message: freezed == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as Message?,
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User?,
        remindAt: freezed == remindAt
            ? _self.remindAt
            : remindAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: freezed == createdAt
            ? _self.createdAt!
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _self.updatedAt!
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}
