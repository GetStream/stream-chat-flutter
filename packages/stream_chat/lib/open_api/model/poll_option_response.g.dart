// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_option_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PollOptionResponse _$PollOptionResponseFromJson(Map<String, dynamic> json) =>
    PollOptionResponse(
      duration: json['duration'] as String,
      pollOption: PollOptionResponseData.fromJson(
        json['poll_option'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$PollOptionResponseToJson(PollOptionResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'poll_option': instance.pollOption.toJson(),
    };
