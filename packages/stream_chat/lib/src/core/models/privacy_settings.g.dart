// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrivacySettings _$PrivacySettingsFromJson(Map<String, dynamic> json) =>
    PrivacySettings(
      typingIndicators: json['typing_indicators'] == null
          ? null
          : TypingIndicatorPrivacySettings.fromJson(
              json['typing_indicators'] as Map<String, dynamic>),
      readReceipts: json['read_receipts'] == null
          ? null
          : ReadReceiptsPrivacySettings.fromJson(
              json['read_receipts'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PrivacySettingsToJson(PrivacySettings instance) =>
    <String, dynamic>{
      if (instance.typingIndicators?.toJson() case final value?)
        'typing_indicators': value,
      if (instance.readReceipts?.toJson() case final value?)
        'read_receipts': value,
    };

TypingIndicatorPrivacySettings _$TypingIndicatorPrivacySettingsFromJson(
        Map<String, dynamic> json) =>
    TypingIndicatorPrivacySettings(
      enabled: json['enabled'] as bool? ?? true,
    );

Map<String, dynamic> _$TypingIndicatorPrivacySettingsToJson(
        TypingIndicatorPrivacySettings instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
    };

ReadReceiptsPrivacySettings _$ReadReceiptsPrivacySettingsFromJson(
        Map<String, dynamic> json) =>
    ReadReceiptsPrivacySettings(
      enabled: json['enabled'] as bool? ?? true,
    );

Map<String, dynamic> _$ReadReceiptsPrivacySettingsToJson(
        ReadReceiptsPrivacySettings instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
    };
