// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrivacySettings _$PrivacySettingsFromJson(Map<String, dynamic> json) => PrivacySettings(
  typingIndicators: json['typing_indicators'] == null
      ? null
      : TypingIndicators.fromJson(
          json['typing_indicators'] as Map<String, dynamic>,
        ),
  readReceipts: json['read_receipts'] == null
      ? null
      : ReadReceipts.fromJson(
          json['read_receipts'] as Map<String, dynamic>,
        ),
  deliveryReceipts: json['delivery_receipts'] == null
      ? null
      : DeliveryReceipts.fromJson(
          json['delivery_receipts'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$PrivacySettingsToJson(PrivacySettings instance) => <String, dynamic>{
  'typing_indicators': ?instance.typingIndicators?.toJson(),
  'read_receipts': ?instance.readReceipts?.toJson(),
  'delivery_receipts': ?instance.deliveryReceipts?.toJson(),
};

TypingIndicators _$TypingIndicatorsFromJson(Map<String, dynamic> json) =>
    TypingIndicators(enabled: json['enabled'] as bool? ?? true);

Map<String, dynamic> _$TypingIndicatorsToJson(TypingIndicators instance) => <String, dynamic>{
  'enabled': instance.enabled,
};

ReadReceipts _$ReadReceiptsFromJson(Map<String, dynamic> json) =>
    ReadReceipts(enabled: json['enabled'] as bool? ?? true);

Map<String, dynamic> _$ReadReceiptsToJson(ReadReceipts instance) => <String, dynamic>{'enabled': instance.enabled};

DeliveryReceipts _$DeliveryReceiptsFromJson(Map<String, dynamic> json) =>
    DeliveryReceipts(enabled: json['enabled'] as bool? ?? true);

Map<String, dynamic> _$DeliveryReceiptsToJson(DeliveryReceipts instance) => <String, dynamic>{
  'enabled': instance.enabled,
};
