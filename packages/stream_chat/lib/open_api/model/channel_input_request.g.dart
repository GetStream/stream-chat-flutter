// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_input_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelInputRequest _$ChannelInputRequestFromJson(Map<String, dynamic> json) => ChannelInputRequest(
  autoTranslationEnabled: json['auto_translation_enabled'] as bool?,
  autoTranslationLanguage: json['auto_translation_language'] as String?,
  configOverrides: json['config_overrides'] == null
      ? null
      : ConfigOverridesRequest.fromJson(
          json['config_overrides'] as Map<String, dynamic>,
        ),
  createdBy: json['created_by'] == null ? null : UserRequest.fromJson(json['created_by'] as Map<String, dynamic>),
  custom: json['custom'] as Map<String, dynamic>?,
  disabled: json['disabled'] as bool?,
  frozen: json['frozen'] as bool?,
  invites: (json['invites'] as List<dynamic>?)
      ?.map((e) => ChannelMemberRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
  members: (json['members'] as List<dynamic>?)
      ?.map((e) => ChannelMemberRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
  team: json['team'] as String?,
);

Map<String, dynamic> _$ChannelInputRequestToJson(
  ChannelInputRequest instance,
) => <String, dynamic>{
  'auto_translation_enabled': instance.autoTranslationEnabled,
  'auto_translation_language': instance.autoTranslationLanguage,
  'config_overrides': instance.configOverrides?.toJson(),
  'created_by': instance.createdBy?.toJson(),
  'custom': instance.custom,
  'disabled': instance.disabled,
  'frozen': instance.frozen,
  'invites': instance.invites?.map((e) => e.toJson()).toList(),
  'members': instance.members?.map((e) => e.toJson()).toList(),
  'team': instance.team,
};
