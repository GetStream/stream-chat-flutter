// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_messages_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduledMessagesFilter _$ScheduledMessagesFilterFromJson(
  Map<String, dynamic> json,
) => ScheduledMessagesFilter(
  cid: json['cid'] as String?,
  status: (json['status'] as List<dynamic>?)?.map((e) => e as ScheduledMessageQueryStatus).toList(),
);

Map<String, dynamic> _$ScheduledMessagesFilterToJson(
  ScheduledMessagesFilter instance,
) => <String, dynamic>{'cid': instance.cid, 'status': instance.status};
