// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrivacySettings _$PrivacySettingsFromJson(Map<String, dynamic> json) =>
    PrivacySettings(
      json['typing_indicators'] == null
          ? null
          : TypingIndicatorPrivacySettings.fromJson(
              json['typing_indicators'] as Map<String, dynamic>),
      json['read_receipts'] == null
          ? null
          : ReadReceiptsPrivacySettings.fromJson(
              json['read_receipts'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PrivacySettingsToJson(PrivacySettings instance) =>
    <String, dynamic>{
      'typing_indicators': instance.typingIndicators?.toJson(),
      'read_receipts': instance.readReceipts?.toJson(),
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
