// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_bans_scope_totals.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelBansScopeTotals _$ChannelBansScopeTotalsFromJson(
  Map<String, dynamic> json,
) => ChannelBansScopeTotals(
  channel: (json['channel'] as num).toInt(),
  futureChannel: (json['future_channel'] as num).toInt(),
);

Map<String, dynamic> _$ChannelBansScopeTotalsToJson(
  ChannelBansScopeTotals instance,
) => <String, dynamic>{
  'channel': instance.channel,
  'future_channel': instance.futureChannel,
};
