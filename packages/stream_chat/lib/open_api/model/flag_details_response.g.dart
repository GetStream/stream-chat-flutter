// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flag_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlagDetailsResponse _$FlagDetailsResponseFromJson(Map<String, dynamic> json) =>
    FlagDetailsResponse(
      automod: json['automod'] == null
          ? null
          : AutomodDetailsResponse.fromJson(
              json['automod'] as Map<String, dynamic>,
            ),
      extra: json['extra'] as Map<String, dynamic>?,
      originalText: json['original_text'] as String,
    );

Map<String, dynamic> _$FlagDetailsResponseToJson(
  FlagDetailsResponse instance,
) => <String, dynamic>{
  'automod': instance.automod?.toJson(),
  'extra': instance.extra,
  'original_text': instance.originalText,
};
