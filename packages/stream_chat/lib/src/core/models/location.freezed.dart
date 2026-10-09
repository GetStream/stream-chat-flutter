// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Location {
  String? get channelCid;
  ChannelModel? get channel;
  String? get messageId;
  Message? get message;
  String? get userId;
  double get latitude;
  double get longitude;
  String? get createdByDeviceId;
  DateTime? get endAt;
  DateTime get createdAt;
  DateTime get updatedAt;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Location &&
            (identical(other.channelCid, channelCid) || other.channelCid == channelCid) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.latitude, latitude) || other.latitude == latitude) &&
            (identical(other.longitude, longitude) || other.longitude == longitude) &&
            (identical(other.createdByDeviceId, createdByDeviceId) || other.createdByDeviceId == createdByDeviceId) &&
            (identical(other.endAt, endAt) || other.endAt == endAt) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channelCid,
    channel,
    messageId,
    message,
    userId,
    latitude,
    longitude,
    createdByDeviceId,
    endAt,
    createdAt,
    updatedAt,
  );

  @override
  String toString() {
    return 'Location(channelCid: $channelCid, channel: $channel, messageId: $messageId, message: $message, userId: $userId, latitude: $latitude, longitude: $longitude, createdByDeviceId: $createdByDeviceId, endAt: $endAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
