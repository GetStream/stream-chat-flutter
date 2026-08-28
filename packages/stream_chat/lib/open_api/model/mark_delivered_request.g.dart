// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_delivered_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkDeliveredRequest _$MarkDeliveredRequestFromJson(
  Map<String, dynamic> json,
) => MarkDeliveredRequest(
  latestDeliveredMessages: (json['latest_delivered_messages'] as List<dynamic>?)
      ?.map((e) => DeliveredMessagePayload.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MarkDeliveredRequestToJson(
  MarkDeliveredRequest instance,
) => <String, dynamic>{
  'latest_delivered_messages': instance.latestDeliveredMessages
      ?.map((e) => e.toJson())
      .toList(),
};
