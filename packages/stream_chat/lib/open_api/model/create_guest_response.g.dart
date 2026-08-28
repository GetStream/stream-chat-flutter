// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_guest_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateGuestResponse _$CreateGuestResponseFromJson(Map<String, dynamic> json) =>
    CreateGuestResponse(
      accessToken: json['access_token'] as String,
      duration: json['duration'] as String,
      user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateGuestResponseToJson(
  CreateGuestResponse instance,
) => <String, dynamic>{
  'access_token': instance.accessToken,
  'duration': instance.duration,
  'user': instance.user.toJson(),
};
