// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_channels_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryChannelsResponse _$QueryChannelsResponseFromJson(
  Map<String, dynamic> json,
) => QueryChannelsResponse(
  channels: (json['channels'] as List<dynamic>)
      .map(
        (e) => ChannelStateResponseFields.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  duration: json['duration'] as String,
  predefinedFilter: json['predefined_filter'] == null
      ? null
      : ParsedPredefinedFilterResponse.fromJson(
          json['predefined_filter'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$QueryChannelsResponseToJson(
  QueryChannelsResponse instance,
) => <String, dynamic>{
  'channels': instance.channels.map((e) => e.toJson()).toList(),
  'duration': instance.duration,
  'predefined_filter': instance.predefinedFilter?.toJson(),
};
