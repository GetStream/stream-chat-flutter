// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_block_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListBlockListResponse _$ListBlockListResponseFromJson(
  Map<String, dynamic> json,
) => ListBlockListResponse(
  blocklists: (json['blocklists'] as List<dynamic>)
      .map((e) => BlockListResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  duration: json['duration'] as String,
  nextCursor: json['next_cursor'] as String?,
);

Map<String, dynamic> _$ListBlockListResponseToJson(
  ListBlockListResponse instance,
) => <String, dynamic>{
  'blocklists': instance.blocklists.map((e) => e.toJson()).toList(),
  'duration': instance.duration,
  'next_cursor': instance.nextCursor,
};
