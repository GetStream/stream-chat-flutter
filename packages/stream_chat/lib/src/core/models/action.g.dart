// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Action _$ActionFromJson(Map<String, dynamic> json) {
  return Action(
    name: json['name'] as String,
    style: json['style'] as String? ?? 'default',
    text: json['text'] as String,
    type: json['type'] as String,
    value: json['value'] as String?,
  );
}

Map<String, dynamic> _$ActionToJson(Action instance) => <String, dynamic>{
      'name': instance.name,
      'style': instance.style,
      'text': instance.text,
      'type': instance.type,
      'value': instance.value,
    };
