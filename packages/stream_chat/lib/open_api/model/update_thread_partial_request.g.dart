// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_thread_partial_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateThreadPartialRequest _$UpdateThreadPartialRequestFromJson(
  Map<String, dynamic> json,
) => UpdateThreadPartialRequest(
  set: json['set'] as Map<String, dynamic>?,
  unset: (json['unset'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$UpdateThreadPartialRequestToJson(
  UpdateThreadPartialRequest instance,
) => <String, dynamic>{'set': instance.set, 'unset': instance.unset};
