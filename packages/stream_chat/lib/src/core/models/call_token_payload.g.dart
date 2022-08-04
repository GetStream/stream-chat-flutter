// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_token_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallTokenPayload _$CallTokenPayloadFromJson(Map<String, dynamic> json) =>
    CallTokenPayload(
      token: json['token'] as String,
      agoraUid: json['agora_uid'] as int?,
      agoraAppId: json['agora_app_id'] as String?,
    );

Map<String, dynamic> _$CallTokenPayloadToJson(CallTokenPayload instance) {
  final val = <String, dynamic>{
    'token': instance.token,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('agora_uid', instance.agoraUid);
  writeNotNull('agora_app_id', instance.agoraAppId);
  return val;
}
