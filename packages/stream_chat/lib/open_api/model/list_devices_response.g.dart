// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_devices_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListDevicesResponse _$ListDevicesResponseFromJson(Map<String, dynamic> json) => ListDevicesResponse(
  devices: (json['devices'] as List<dynamic>).map((e) => DeviceResponse.fromJson(e as Map<String, dynamic>)).toList(),
  duration: json['duration'] as String,
);

Map<String, dynamic> _$ListDevicesResponseToJson(
  ListDevicesResponse instance,
) => <String, dynamic>{
  'devices': instance.devices.map((e) => e.toJson()).toList(),
  'duration': instance.duration,
};
