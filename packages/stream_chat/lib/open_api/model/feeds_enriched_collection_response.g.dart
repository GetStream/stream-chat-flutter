// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feeds_enriched_collection_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedsEnrichedCollectionResponse _$FeedsEnrichedCollectionResponseFromJson(
  Map<String, dynamic> json,
) => FeedsEnrichedCollectionResponse(
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  id: json['id'] as String,
  name: json['name'] as String,
  status: json['status'] as String,
  updatedAt: const StreamDateTimeConverter().fromJson(
    json['updated_at'] as Object,
  ),
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$FeedsEnrichedCollectionResponseToJson(
  FeedsEnrichedCollectionResponse instance,
) => <String, dynamic>{
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'id': instance.id,
  'name': instance.name,
  'status': instance.status,
  'updated_at': const StreamDateTimeConverter().toJson(instance.updatedAt),
  'user_id': instance.userId,
};
