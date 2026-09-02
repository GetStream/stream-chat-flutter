// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModerationResponse _$ModerationResponseFromJson(Map<String, dynamic> json) => ModerationResponse(
  action: json['action'] as String,
  explicit: (json['explicit'] as num).toDouble(),
  spam: (json['spam'] as num).toDouble(),
  toxic: (json['toxic'] as num).toDouble(),
);

Map<String, dynamic> _$ModerationResponseToJson(ModerationResponse instance) => <String, dynamic>{
  'action': instance.action,
  'explicit': instance.explicit,
  'spam': instance.spam,
  'toxic': instance.toxic,
};
