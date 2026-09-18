// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_thread_partial_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateThreadPartialResponse _$UpdateThreadPartialResponseFromJson(
  Map<String, dynamic> json,
) => UpdateThreadPartialResponse(
  duration: json['duration'] as String,
  thread: ThreadResponse.fromJson(json['thread'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UpdateThreadPartialResponseToJson(
  UpdateThreadPartialResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'thread': instance.thread.toJson(),
};
