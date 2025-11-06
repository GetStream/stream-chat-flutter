// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrivacySettings _$PrivacySettingsFromJson(Map<String, dynamic> json) =>
    PrivacySettings(
      typingIndicators: json['typing_indicators'] == null
          ? null
          : TypingIndicators.fromJson(
              json['typing_indicators'] as Map<String, dynamic>),
      readReceipts: json['read_receipts'] == null
          ? null
          : ReadReceipts.fromJson(
              json['read_receipts'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PrivacySettingsToJson(PrivacySettings instance) =>
    <String, dynamic>{
      if (instance.typingIndicators?.toJson() case final value?)
        'typing_indicators': value,
      if (instance.readReceipts?.toJson() case final value?)
        'read_receipts': value,
    };

TypingIndicators _$TypingIndicatorsFromJson(Map<String, dynamic> json) =>
    TypingIndicators(
      enabled: json['enabled'] as bool? ?? true,
    );

Map<String, dynamic> _$TypingIndicatorsToJson(TypingIndicators instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
    };

ReadReceipts _$ReadReceiptsFromJson(Map<String, dynamic> json) => ReadReceipts(
      enabled: json['enabled'] as bool? ?? true,
    );

Map<String, dynamic> _$ReadReceiptsToJson(ReadReceipts instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
    };
