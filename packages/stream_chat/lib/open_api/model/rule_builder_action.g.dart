// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rule_builder_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RuleBuilderAction _$RuleBuilderActionFromJson(Map<String, dynamic> json) =>
    RuleBuilderAction(
      banOptions: json['ban_options'] == null
          ? null
          : BanOptions.fromJson(json['ban_options'] as Map<String, dynamic>),
      callOptions: json['call_options'] == null
          ? null
          : CallActionOptions.fromJson(
              json['call_options'] as Map<String, dynamic>,
            ),
      flagUserOptions: json['flag_user_options'] == null
          ? null
          : FlagUserOptions.fromJson(
              json['flag_user_options'] as Map<String, dynamic>,
            ),
      reason: json['reason'] as String?,
      skipInbox: json['skip_inbox'] as bool?,
      type: json['type'] == null
          ? null
          : RuleBuilderActionType.fromJson(json['type'] as String),
    );

Map<String, dynamic> _$RuleBuilderActionToJson(RuleBuilderAction instance) =>
    <String, dynamic>{
      'ban_options': instance.banOptions?.toJson(),
      'call_options': instance.callOptions?.toJson(),
      'flag_user_options': instance.flagUserOptions?.toJson(),
      'reason': instance.reason,
      'skip_inbox': instance.skipInbox,
      'type': instance.type?.toJson(),
    };
