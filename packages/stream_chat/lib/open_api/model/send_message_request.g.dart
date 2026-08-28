// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_message_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendMessageRequest _$SendMessageRequestFromJson(Map<String, dynamic> json) =>
    SendMessageRequest(
      includeChannelContext: json['include_channel_context'] as bool?,
      includeMentionedMembers: json['include_mentioned_members'] as bool?,
      keepChannelHidden: json['keep_channel_hidden'] as bool?,
      message: MessageRequest.fromJson(json['message'] as Map<String, dynamic>),
      skipEnrichUrl: json['skip_enrich_url'] as bool?,
      skipPush: json['skip_push'] as bool?,
    );

Map<String, dynamic> _$SendMessageRequestToJson(SendMessageRequest instance) =>
    <String, dynamic>{
      'include_channel_context': instance.includeChannelContext,
      'include_mentioned_members': instance.includeMentionedMembers,
      'keep_channel_hidden': instance.keepChannelHidden,
      'message': instance.message.toJson(),
      'skip_enrich_url': instance.skipEnrichUrl,
      'skip_push': instance.skipPush,
    };
