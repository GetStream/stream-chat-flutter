// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_user_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberUserRequest _$MemberUserRequestFromJson(Map<String, dynamic> json) => MemberUserRequest(
  custom: json['custom'] as Map<String, dynamic>?,
  id: json['id'] as String,
  image: json['image'] as String?,
  invisible: json['invisible'] as bool?,
  language: json['language'] as String?,
  name: json['name'] as String?,
  privacySettings: json['privacy_settings'] == null
      ? null
      : PrivacySettingsResponse.fromJson(
          json['privacy_settings'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$MemberUserRequestToJson(MemberUserRequest instance) => <String, dynamic>{
  'custom': instance.custom,
  'id': instance.id,
  'image': instance.image,
  'invisible': instance.invisible,
  'language': instance.language,
  'name': instance.name,
  'privacy_settings': instance.privacySettings?.toJson(),
};
