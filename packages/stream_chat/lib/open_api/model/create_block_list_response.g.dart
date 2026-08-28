// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_block_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateBlockListResponse _$CreateBlockListResponseFromJson(
  Map<String, dynamic> json,
) => CreateBlockListResponse(
  blocklist: json['blocklist'] == null
      ? null
      : BlockListResponse.fromJson(json['blocklist'] as Map<String, dynamic>),
  duration: json['duration'] as String,
);

Map<String, dynamic> _$CreateBlockListResponseToJson(
  CreateBlockListResponse instance,
) => <String, dynamic>{
  'blocklist': instance.blocklist?.toJson(),
  'duration': instance.duration,
};
