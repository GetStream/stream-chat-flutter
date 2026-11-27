// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_channel_bans_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryChannelBansResponse _$QueryChannelBansResponseFromJson(
  Map<String, dynamic> json,
) => QueryChannelBansResponse(
  bans: (json['bans'] as List<dynamic>).map((e) => ChannelBanResponse.fromJson(e as Map<String, dynamic>)).toList(),
  duration: json['duration'] as String,
  next: json['next'] as String?,
  prev: json['prev'] as String?,
  total: (json['total'] as num?)?.toInt(),
  totalByScope: json['total_by_scope'] == null
      ? null
      : ChannelBansScopeTotals.fromJson(
          json['total_by_scope'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$QueryChannelBansResponseToJson(
  QueryChannelBansResponse instance,
) => <String, dynamic>{
  'bans': instance.bans.map((e) => e.toJson()).toList(),
  'duration': instance.duration,
  'next': instance.next,
  'prev': instance.prev,
  'total': instance.total,
  'total_by_scope': instance.totalByScope?.toJson(),
};
