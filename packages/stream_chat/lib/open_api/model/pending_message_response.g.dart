// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_message_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PendingMessageResponse _$PendingMessageResponseFromJson(
  Map<String, dynamic> json,
) => PendingMessageResponse(
  channel: json['channel'] == null
      ? null
      : ChannelResponse.fromJson(json['channel'] as Map<String, dynamic>),
  message: json['message'] == null
      ? null
      : MessageResponse.fromJson(json['message'] as Map<String, dynamic>),
  user: json['user'] == null
      ? null
      : UserResponse.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PendingMessageResponseToJson(
  PendingMessageResponse instance,
) => <String, dynamic>{
  'channel': instance.channel?.toJson(),
  'message': instance.message?.toJson(),
  'user': instance.user?.toJson(),
};
