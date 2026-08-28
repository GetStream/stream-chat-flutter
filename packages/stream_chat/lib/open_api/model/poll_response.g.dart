// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PollResponse _$PollResponseFromJson(Map<String, dynamic> json) => PollResponse(
  duration: json['duration'] as String,
  poll: PollResponseData.fromJson(json['poll'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PollResponseToJson(PollResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'poll': instance.poll.toJson(),
    };
