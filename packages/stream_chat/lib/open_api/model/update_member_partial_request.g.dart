// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_member_partial_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateMemberPartialRequest _$UpdateMemberPartialRequestFromJson(
  Map<String, dynamic> json,
) => UpdateMemberPartialRequest(
  set: json['set'] as Map<String, dynamic>?,
  unset: (json['unset'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$UpdateMemberPartialRequestToJson(
  UpdateMemberPartialRequest instance,
) => <String, dynamic>{'set': instance.set, 'unset': instance.unset};
