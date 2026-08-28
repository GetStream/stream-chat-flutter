// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageOptions _$MessageOptionsFromJson(Map<String, dynamic> json) => MessageOptions(
  includeThreadParticipants: json['include_thread_participants'] as bool?,
  memberCustomInclude: (json['member_custom_include'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$MessageOptionsToJson(MessageOptions instance) => <String, dynamic>{
  'include_thread_participants': instance.includeThreadParticipants,
  'member_custom_include': instance.memberCustomInclude,
};
