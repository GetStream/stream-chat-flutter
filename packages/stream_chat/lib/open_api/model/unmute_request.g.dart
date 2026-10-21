// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unmute_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnmuteRequest _$UnmuteRequestFromJson(Map<String, dynamic> json) => UnmuteRequest(
  targetIds: (json['target_ids'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$UnmuteRequestToJson(UnmuteRequest instance) => <String, dynamic>{
  'target_ids': instance.targetIds,
};
