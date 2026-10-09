// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_channels_read_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkChannelsReadRequest _$MarkChannelsReadRequestFromJson(
  Map<String, dynamic> json,
) => MarkChannelsReadRequest(
  readByChannel: (json['read_by_channel'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
);

Map<String, dynamic> _$MarkChannelsReadRequestToJson(
  MarkChannelsReadRequest instance,
) => <String, dynamic>{'read_by_channel': instance.readByChannel};
