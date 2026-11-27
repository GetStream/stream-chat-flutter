// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_poll_option_request_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeletePollOptionRequestPayload _$DeletePollOptionRequestPayloadFromJson(
  Map<String, dynamic> json,
) => DeletePollOptionRequestPayload(
  optionId: json['option_id'] as String?,
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$DeletePollOptionRequestPayloadToJson(
  DeletePollOptionRequestPayload instance,
) => <String, dynamic>{
  'option_id': instance.optionId,
  'reason': instance.reason,
};
