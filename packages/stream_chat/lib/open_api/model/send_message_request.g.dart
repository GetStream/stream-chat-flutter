// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_message_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendMessageRequest _$SendMessageRequestFromJson(Map<String, dynamic> json) => SendMessageRequest(
  includeChannelContext: json['include_channel_context'] as bool?,
  includeMentionedMembers: json['include_mentioned_members'] as bool?,
  keepChannelHidden: json['keep_channel_hidden'] as bool?,
  message: MessageRequest.fromJson(json['message'] as Map<String, dynamic>),
  scheduledAt: _$JsonConverterFromJson<Object, DateTime>(
    json['scheduled_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  skipEnrichUrl: json['skip_enrich_url'] as bool?,
  skipPush: json['skip_push'] as bool?,
);

Map<String, dynamic> _$SendMessageRequestToJson(SendMessageRequest instance) => <String, dynamic>{
  'include_channel_context': instance.includeChannelContext,
  'include_mentioned_members': instance.includeMentionedMembers,
  'keep_channel_hidden': instance.keepChannelHidden,
  'message': instance.message.toJson(),
  'scheduled_at': _$JsonConverterToJson<Object, DateTime>(
    instance.scheduledAt,
    const StreamDateTimeConverter().toJson,
  ),
  'skip_enrich_url': instance.skipEnrichUrl,
  'skip_push': instance.skipPush,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
