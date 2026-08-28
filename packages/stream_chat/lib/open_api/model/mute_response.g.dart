// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mute_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MuteResponse _$MuteResponseFromJson(Map<String, dynamic> json) => MuteResponse(
  duration: json['duration'] as String,
  mutes: (json['mutes'] as List<dynamic>?)
      ?.map((e) => UserMuteResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  nonExistingUsers: (json['non_existing_users'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  ownUser: json['own_user'] == null
      ? null
      : OwnUserResponse.fromJson(json['own_user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MuteResponseToJson(MuteResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'mutes': instance.mutes?.map((e) => e.toJson()).toList(),
      'non_existing_users': instance.nonExistingUsers,
      'own_user': instance.ownUser?.toJson(),
    };
