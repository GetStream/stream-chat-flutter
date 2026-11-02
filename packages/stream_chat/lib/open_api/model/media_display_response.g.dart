// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_display_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaDisplayResponse _$MediaDisplayResponseFromJson(
  Map<String, dynamic> json,
) => MediaDisplayResponse(
  auditReveal: json['audit_reveal'] as bool,
  mode: json['mode'] as MediaDisplayResponseMode,
  revealRestricted: json['reveal_restricted'] as bool,
);

Map<String, dynamic> _$MediaDisplayResponseToJson(
  MediaDisplayResponse instance,
) => <String, dynamic>{
  'audit_reveal': instance.auditReveal,
  'mode': instance.mode,
  'reveal_restricted': instance.revealRestricted,
};
