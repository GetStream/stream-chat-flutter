// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unmute_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnmuteResponse _$UnmuteResponseFromJson(Map<String, dynamic> json) =>
    UnmuteResponse(
      duration: json['duration'] as String,
      nonExistingUsers: (json['non_existing_users'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UnmuteResponseToJson(UnmuteResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'non_existing_users': instance.nonExistingUsers,
    };
