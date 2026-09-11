// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_message_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateMessageRequest _$UpdateMessageRequestFromJson(
  Map<String, dynamic> json,
) => UpdateMessageRequest(
  message: MessageRequest.fromJson(json['message'] as Map<String, dynamic>),
  skipEnrichUrl: json['skip_enrich_url'] as bool?,
  skipPush: json['skip_push'] as bool?,
);

Map<String, dynamic> _$UpdateMessageRequestToJson(
  UpdateMessageRequest instance,
) => <String, dynamic>{
  'message': instance.message.toJson(),
  'skip_enrich_url': instance.skipEnrichUrl,
  'skip_push': instance.skipPush,
};
