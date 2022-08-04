// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_call_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCallPayload _$CreateCallPayloadFromJson(Map<String, dynamic> json) =>
    CreateCallPayload(
      call: CallPayload.fromJson(json['call'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateCallPayloadToJson(CreateCallPayload instance) =>
    <String, dynamic>{
      'call': instance.call.toJson(),
    };
