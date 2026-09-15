// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_block_list_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateBlockListRequest _$UpdateBlockListRequestFromJson(
  Map<String, dynamic> json,
) => UpdateBlockListRequest(
  isConfusableFoldingEnabled: json['is_confusable_folding_enabled'] as bool?,
  isLeetCheckEnabled: json['is_leet_check_enabled'] as bool?,
  isPluralCheckEnabled: json['is_plural_check_enabled'] as bool?,
  isSubstringMatchingEnabled: json['is_substring_matching_enabled'] as bool?,
  team: json['team'] as String?,
  words: (json['words'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$UpdateBlockListRequestToJson(
  UpdateBlockListRequest instance,
) => <String, dynamic>{
  'is_confusable_folding_enabled': instance.isConfusableFoldingEnabled,
  'is_leet_check_enabled': instance.isLeetCheckEnabled,
  'is_plural_check_enabled': instance.isPluralCheckEnabled,
  'is_substring_matching_enabled': instance.isSubstringMatchingEnabled,
  'team': instance.team,
  'words': instance.words,
};
