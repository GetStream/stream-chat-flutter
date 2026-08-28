// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_thread_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetThreadResponse _$GetThreadResponseFromJson(Map<String, dynamic> json) =>
    GetThreadResponse(
      duration: json['duration'] as String,
      thread: ThreadStateResponse.fromJson(
        json['thread'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$GetThreadResponseToJson(GetThreadResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'thread': instance.thread.toJson(),
    };
