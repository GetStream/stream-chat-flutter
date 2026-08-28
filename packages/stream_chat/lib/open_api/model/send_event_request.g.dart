// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_event_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendEventRequest _$SendEventRequestFromJson(Map<String, dynamic> json) =>
    SendEventRequest(
      event: EventRequest.fromJson(json['event'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SendEventRequestToJson(SendEventRequest instance) =>
    <String, dynamic>{'event': instance.event.toJson()};
