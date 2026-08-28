// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appeal_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppealResponse _$AppealResponseFromJson(Map<String, dynamic> json) =>
    AppealResponse(
      appealId: json['appeal_id'] as String,
      duration: json['duration'] as String,
    );

Map<String, dynamic> _$AppealResponseToJson(AppealResponse instance) =>
    <String, dynamic>{
      'appeal_id': instance.appealId,
      'duration': instance.duration,
    };
