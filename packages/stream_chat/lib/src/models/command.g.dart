// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Command _$CommandFromJson(Map<String, dynamic> json) {
  return Command(
    name: json['name'] as String,
    description: json['description'] as String,
    args: json['args'] as String,
  );
}

Map<String, dynamic> _$CommandToJson(Command instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'args': instance.args,
    };
