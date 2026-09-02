// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_partial_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateUserPartialRequest _$UpdateUserPartialRequestFromJson(
  Map<String, dynamic> json,
) => UpdateUserPartialRequest(
  id: json['id'] as String,
  set: json['set'] as Map<String, dynamic>?,
  unset: (json['unset'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$UpdateUserPartialRequestToJson(
  UpdateUserPartialRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'set': instance.set,
  'unset': instance.unset,
};
