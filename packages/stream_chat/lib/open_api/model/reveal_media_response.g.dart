// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reveal_media_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RevealMediaResponse _$RevealMediaResponseFromJson(Map<String, dynamic> json) => RevealMediaResponse(
  duration: json['duration'] as String,
  mediaDisplay: MediaDisplayResponse.fromJson(
    json['media_display'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$RevealMediaResponseToJson(
  RevealMediaResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'media_display': instance.mediaDisplay.toJson(),
};
