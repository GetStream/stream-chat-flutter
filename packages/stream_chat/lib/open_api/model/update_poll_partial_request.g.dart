// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_poll_partial_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdatePollPartialRequest _$UpdatePollPartialRequestFromJson(
  Map<String, dynamic> json,
) => UpdatePollPartialRequest(
  set: json['set'] as Map<String, dynamic>?,
  unset: (json['unset'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$UpdatePollPartialRequestToJson(
  UpdatePollPartialRequest instance,
) => <String, dynamic>{'set': instance.set, 'unset': instance.unset};
