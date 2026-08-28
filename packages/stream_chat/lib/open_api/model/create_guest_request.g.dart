// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_guest_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateGuestRequest _$CreateGuestRequestFromJson(Map<String, dynamic> json) =>
    CreateGuestRequest(
      user: UserRequest.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateGuestRequestToJson(CreateGuestRequest instance) =>
    <String, dynamic>{'user': instance.user.toJson()};
