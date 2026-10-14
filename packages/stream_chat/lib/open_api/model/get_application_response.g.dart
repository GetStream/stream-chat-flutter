// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_application_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetApplicationResponse _$GetApplicationResponseFromJson(
  Map<String, dynamic> json,
) => GetApplicationResponse(
  app: AppResponseFields.fromJson(json['app'] as Map<String, dynamic>),
  duration: json['duration'] as String,
);

Map<String, dynamic> _$GetApplicationResponseToJson(
  GetApplicationResponse instance,
) => <String, dynamic>{
  'app': instance.app.toJson(),
  'duration': instance.duration,
};
