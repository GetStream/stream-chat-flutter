// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'own_mark.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OwnMark _$OwnMarkFromJson(Map<String, dynamic> json) => OwnMark(
  type: json['type'] as MessageMarkType,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$OwnMarkToJson(OwnMark instance) => <String, dynamic>{
  'type': instance.type,
  'created_at': instance.createdAt.toIso8601String(),
};
