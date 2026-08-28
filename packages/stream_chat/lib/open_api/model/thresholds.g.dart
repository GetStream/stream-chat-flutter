// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thresholds.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Thresholds _$ThresholdsFromJson(Map<String, dynamic> json) => Thresholds(
  explicit: json['explicit'] == null
      ? null
      : LabelThresholds.fromJson(json['explicit'] as Map<String, dynamic>),
  spam: json['spam'] == null
      ? null
      : LabelThresholds.fromJson(json['spam'] as Map<String, dynamic>),
  toxic: json['toxic'] == null
      ? null
      : LabelThresholds.fromJson(json['toxic'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ThresholdsToJson(Thresholds instance) =>
    <String, dynamic>{
      'explicit': instance.explicit?.toJson(),
      'spam': instance.spam?.toJson(),
      'toxic': instance.toxic?.toJson(),
    };
