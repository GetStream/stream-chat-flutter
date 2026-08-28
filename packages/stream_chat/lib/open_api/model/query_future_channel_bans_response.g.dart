// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_future_channel_bans_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryFutureChannelBansResponse _$QueryFutureChannelBansResponseFromJson(
  Map<String, dynamic> json,
) => QueryFutureChannelBansResponse(
  bans: (json['bans'] as List<dynamic>)
      .map((e) => FutureChannelBanResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  duration: json['duration'] as String,
  total: (json['total'] as num?)?.toInt(),
);

Map<String, dynamic> _$QueryFutureChannelBansResponseToJson(
  QueryFutureChannelBansResponse instance,
) => <String, dynamic>{
  'bans': instance.bans.map((e) => e.toJson()).toList(),
  'duration': instance.duration,
  'total': instance.total,
};
