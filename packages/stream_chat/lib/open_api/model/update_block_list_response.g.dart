// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_block_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateBlockListResponse _$UpdateBlockListResponseFromJson(
  Map<String, dynamic> json,
) => UpdateBlockListResponse(
  blocklist: json['blocklist'] == null
      ? null
      : BlockListResponse.fromJson(json['blocklist'] as Map<String, dynamic>),
  duration: json['duration'] as String,
);

Map<String, dynamic> _$UpdateBlockListResponseToJson(
  UpdateBlockListResponse instance,
) => <String, dynamic>{
  'blocklist': instance.blocklist?.toJson(),
  'duration': instance.duration,
};
