// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rewind_channel_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RewindChannelRequest _$RewindChannelRequestFromJson(
  Map<String, dynamic> json,
) => RewindChannelRequest(
  expectedLastMessageId: json['expected_last_message_id'] as String,
  inclusive: json['inclusive'] as bool?,
  messageId: json['message_id'] as String,
);

Map<String, dynamic> _$RewindChannelRequestToJson(
  RewindChannelRequest instance,
) => <String, dynamic>{
  'expected_last_message_id': instance.expectedLastMessageId,
  'inclusive': instance.inclusive,
  'message_id': instance.messageId,
};
