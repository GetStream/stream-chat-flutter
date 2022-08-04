// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hms_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HMSPayload _$HMSPayloadFromJson(Map<String, dynamic> json) => HMSPayload(
      roomId: json['room_id'] as String,
      roomName: json['room_name'] as String,
    );

Map<String, dynamic> _$HMSPayloadToJson(HMSPayload instance) =>
    <String, dynamic>{
      'room_id': instance.roomId,
      'room_name': instance.roomName,
    };
