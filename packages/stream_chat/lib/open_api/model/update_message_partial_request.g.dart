// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_message_partial_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateMessagePartialRequest _$UpdateMessagePartialRequestFromJson(
  Map<String, dynamic> json,
) => UpdateMessagePartialRequest(
  set: json['set'] as Map<String, dynamic>?,
  skipEnrichUrl: json['skip_enrich_url'] as bool?,
  skipPush: json['skip_push'] as bool?,
  unset: (json['unset'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$UpdateMessagePartialRequestToJson(
  UpdateMessagePartialRequest instance,
) => <String, dynamic>{
  'set': instance.set,
  'skip_enrich_url': instance.skipEnrichUrl,
  'skip_push': instance.skipPush,
  'unset': instance.unset,
};
