// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_message_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendMessageResponse _$SendMessageResponseFromJson(Map<String, dynamic> json) =>
    SendMessageResponse(
      channelContext: json['channel_context'] == null
          ? null
          : ChannelContextResponse.fromJson(
              json['channel_context'] as Map<String, dynamic>,
            ),
      duration: json['duration'] as String,
      mentionedMembers: (json['mentioned_members'] as Map<String, dynamic>?)
          ?.map((k, e) => MapEntry(k, e as bool)),
      message: MessageResponse.fromJson(
        json['message'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$SendMessageResponseToJson(
  SendMessageResponse instance,
) => <String, dynamic>{
  'channel_context': instance.channelContext?.toJson(),
  'duration': instance.duration,
  'mentioned_members': instance.mentionedMembers,
  'message': instance.message.toJson(),
};
