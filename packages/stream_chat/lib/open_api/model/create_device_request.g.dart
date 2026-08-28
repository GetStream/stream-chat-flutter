// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_device_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateDeviceRequest _$CreateDeviceRequestFromJson(Map<String, dynamic> json) =>
    CreateDeviceRequest(
      hardwareId: json['hardware_id'] as String?,
      id: json['id'] as String,
      pushProvider: CreateDeviceRequestPushProvider.fromJson(
        json['push_provider'] as String,
      ),
      pushProviderName: json['push_provider_name'] as String?,
      voipToken: json['voip_token'] as bool?,
    );

Map<String, dynamic> _$CreateDeviceRequestToJson(
  CreateDeviceRequest instance,
) => <String, dynamic>{
  'hardware_id': instance.hardwareId,
  'id': instance.id,
  'push_provider': instance.pushProvider.toJson(),
  'push_provider_name': instance.pushProviderName,
  'voip_token': instance.voipToken,
};
