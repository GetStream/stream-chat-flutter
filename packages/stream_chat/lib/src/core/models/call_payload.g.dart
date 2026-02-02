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

AgoraPayload _$AgoraPayloadFromJson(Map<String, dynamic> json) => AgoraPayload(
      channel: json['channel'] as String,
    );

HMSPayload _$HMSPayloadFromJson(Map<String, dynamic> json) => HMSPayload(
      roomId: json['room_id'] as String,
      roomName: json['room_name'] as String,
    );
