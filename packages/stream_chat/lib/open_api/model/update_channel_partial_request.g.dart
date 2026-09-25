// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_channel_partial_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateChannelPartialRequest _$UpdateChannelPartialRequestFromJson(
  Map<String, dynamic> json,
) => UpdateChannelPartialRequest(
  set: json['set'] as Map<String, dynamic>?,
  unset: (json['unset'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$UpdateChannelPartialRequestToJson(
  UpdateChannelPartialRequest instance,
) => <String, dynamic>{'set': instance.set, 'unset': instance.unset};
