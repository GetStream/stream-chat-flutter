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

Map<String, dynamic> _$CallPayloadToJson(CallPayload instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'provider': instance.provider,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('agora', instance.agora?.toJson());
  writeNotNull('hms', instance.hms?.toJson());
  return val;
}
