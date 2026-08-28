// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockListResponse _$BlockListResponseFromJson(Map<String, dynamic> json) => BlockListResponse(
  createdAt: _$JsonConverterFromJson<Object, DateTime>(
    json['created_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  id: json['id'] as String?,
  isConfusableFoldingEnabled: json['is_confusable_folding_enabled'] as bool,
  isLeetCheckEnabled: json['is_leet_check_enabled'] as bool,
  isPluralCheckEnabled: json['is_plural_check_enabled'] as bool,
  isSubstringMatchingEnabled: json['is_substring_matching_enabled'] as bool,
  name: json['name'] as String,
  ownerUserId: json['owner_user_id'] as String?,
  team: json['team'] as String?,
  type: json['type'] as String,
  updatedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['updated_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  words: (json['words'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$BlockListResponseToJson(BlockListResponse instance) => <String, dynamic>{
  'created_at': _$JsonConverterToJson<Object, DateTime>(
    instance.createdAt,
    const StreamDateTimeConverter().toJson,
  ),
  'id': instance.id,
  'is_confusable_folding_enabled': instance.isConfusableFoldingEnabled,
  'is_leet_check_enabled': instance.isLeetCheckEnabled,
  'is_plural_check_enabled': instance.isPluralCheckEnabled,
  'is_substring_matching_enabled': instance.isSubstringMatchingEnabled,
  'name': instance.name,
  'owner_user_id': instance.ownerUserId,
  'team': instance.team,
  'type': instance.type,
  'updated_at': _$JsonConverterToJson<Object, DateTime>(
    instance.updatedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'words': instance.words,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
