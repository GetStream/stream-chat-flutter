// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_block_list_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImportBlockListRequest _$ImportBlockListRequestFromJson(
  Map<String, dynamic> json,
) => ImportBlockListRequest(
  chunkSize: (json['chunk_size'] as num?)?.toInt(),
  items: (json['items'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$ImportBlockListRequestToJson(
  ImportBlockListRequest instance,
) => <String, dynamic>{
  'chunk_size': instance.chunkSize,
  'items': instance.items,
};
