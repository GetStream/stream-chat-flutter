// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Command _$CommandFromJson(Map<String, dynamic> json) => Command(
  name: json['name'] as String,
  description: json['description'] as String? ?? '',
  args: json['args'] as String? ?? '',
  set: json['set'] == null ? const CommandSet('') : Command._setFromJson(json['set']),
);

Map<String, dynamic> _$CommandToJson(Command instance) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'args': instance.args,
  'set': Command._setToJson(instance.set),
};
