// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_block_list_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateBlockListRequest _$CreateBlockListRequestFromJson(
  Map<String, dynamic> json,
) => CreateBlockListRequest(
  isConfusableFoldingEnabled: json['is_confusable_folding_enabled'] as bool?,
  isLeetCheckEnabled: json['is_leet_check_enabled'] as bool?,
  isPluralCheckEnabled: json['is_plural_check_enabled'] as bool?,
  isSubstringMatchingEnabled: json['is_substring_matching_enabled'] as bool?,
  name: json['name'] as String,
  team: json['team'] as String?,
  type: json['type'] == null
      ? null
      : CreateBlockListRequestType.fromJson(json['type'] as String),
  words: (json['words'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$CreateBlockListRequestToJson(
  CreateBlockListRequest instance,
) => <String, dynamic>{
  'is_confusable_folding_enabled': instance.isConfusableFoldingEnabled,
  'is_leet_check_enabled': instance.isLeetCheckEnabled,
  'is_plural_check_enabled': instance.isPluralCheckEnabled,
  'is_substring_matching_enabled': instance.isSubstringMatchingEnabled,
  'name': instance.name,
  'team': instance.team,
  'type': instance.type?.toJson(),
  'words': instance.words,
};
