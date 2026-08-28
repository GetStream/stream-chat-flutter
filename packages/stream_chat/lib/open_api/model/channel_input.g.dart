// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelInput _$ChannelInputFromJson(Map<String, dynamic> json) => ChannelInput(
  autoTranslationEnabled: json['auto_translation_enabled'] as bool?,
  autoTranslationLanguage: json['auto_translation_language'] as String?,
  configOverrides: json['config_overrides'] == null
      ? null
      : ChannelConfigOverrides.fromJson(
          json['config_overrides'] as Map<String, dynamic>,
        ),
  createdBy: json['created_by'] == null
      ? null
      : UserRequest.fromJson(json['created_by'] as Map<String, dynamic>),
  createdById: json['created_by_id'] as String?,
  custom: json['custom'] as Map<String, dynamic>?,
  disabled: json['disabled'] as bool?,
  filterTags: (json['filter_tags'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  frozen: json['frozen'] as bool?,
  invites: (json['invites'] as List<dynamic>?)
      ?.map((e) => ChannelMemberRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
  members: (json['members'] as List<dynamic>?)
      ?.map((e) => ChannelMemberRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
  team: json['team'] as String?,
  truncatedById: json['truncated_by_id'] as String?,
);

Map<String, dynamic> _$ChannelInputToJson(ChannelInput instance) =>
    <String, dynamic>{
      'auto_translation_enabled': instance.autoTranslationEnabled,
      'auto_translation_language': instance.autoTranslationLanguage,
      'config_overrides': instance.configOverrides?.toJson(),
      'created_by': instance.createdBy?.toJson(),
      'created_by_id': instance.createdById,
      'custom': instance.custom,
      'disabled': instance.disabled,
      'filter_tags': instance.filterTags,
      'frozen': instance.frozen,
      'invites': instance.invites?.map((e) => e.toJson()).toList(),
      'members': instance.members?.map((e) => e.toJson()).toList(),
      'team': instance.team,
      'truncated_by_id': instance.truncatedById,
    };
