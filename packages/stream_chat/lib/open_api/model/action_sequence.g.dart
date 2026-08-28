// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_sequence.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionSequence _$ActionSequenceFromJson(Map<String, dynamic> json) =>
    ActionSequence(
      action: json['action'] as String,
      blur: json['blur'] as bool,
      cooldownPeriod: (json['cooldown_period'] as num).toInt(),
      threshold: (json['threshold'] as num).toInt(),
      timeWindow: (json['time_window'] as num).toInt(),
      warning: json['warning'] as bool,
      warningText: json['warning_text'] as String,
    );

Map<String, dynamic> _$ActionSequenceToJson(ActionSequence instance) =>
    <String, dynamic>{
      'action': instance.action,
      'blur': instance.blur,
      'cooldown_period': instance.cooldownPeriod,
      'threshold': instance.threshold,
      'time_window': instance.timeWindow,
      'warning': instance.warning,
      'warning_text': instance.warningText,
    };
