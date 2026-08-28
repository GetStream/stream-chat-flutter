// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_read_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkReadResponse _$MarkReadResponseFromJson(Map<String, dynamic> json) =>
    MarkReadResponse(
      duration: json['duration'] as String,
      event: json['event'] == null
          ? null
          : MarkReadResponseEvent.fromJson(
              json['event'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$MarkReadResponseToJson(MarkReadResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'event': instance.event?.toJson(),
    };
