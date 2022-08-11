// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallPayload _$CallPayloadFromJson(Map<String, dynamic> json) => CallPayload(
      id: json['id'] as String,
      provider: json['provider'] as String,
      agora: json['agora'] == null
          ? null
          : AgoraPayload.fromJson(json['agora'] as Map<String, dynamic>),
      hms: json['hms'] == null
          ? null
          : HMSPayload.fromJson(json['hms'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CallPayloadToJson(CallPayload instance) =>
    <String, dynamic>{
      'id': instance.id,
      'provider': instance.provider,
      'agora': instance.agora?.toJson(),
      'hms': instance.hms?.toJson(),
    };
