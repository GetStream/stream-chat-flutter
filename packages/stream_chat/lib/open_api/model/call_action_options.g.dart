// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_action_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallActionOptions _$CallActionOptionsFromJson(Map<String, dynamic> json) =>
    CallActionOptions(
      duration: (json['duration'] as num?)?.toInt(),
      flagReason: json['flag_reason'] as String?,
      kickReason: json['kick_reason'] as String?,
      muteAudio: json['mute_audio'] as bool?,
      muteVideo: json['mute_video'] as bool?,
      reason: json['reason'] as String?,
      warningText: json['warning_text'] as String?,
    );

Map<String, dynamic> _$CallActionOptionsToJson(CallActionOptions instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'flag_reason': instance.flagReason,
      'kick_reason': instance.kickReason,
      'mute_audio': instance.muteAudio,
      'mute_video': instance.muteVideo,
      'reason': instance.reason,
      'warning_text': instance.warningText,
    };
