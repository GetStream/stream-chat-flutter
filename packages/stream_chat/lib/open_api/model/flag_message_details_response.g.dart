// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flag_message_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlagMessageDetailsResponse _$FlagMessageDetailsResponseFromJson(
  Map<String, dynamic> json,
) => FlagMessageDetailsResponse(
  pinChanged: json['pin_changed'] as bool?,
  shouldEnrich: json['should_enrich'] as bool?,
  skipPush: json['skip_push'] as bool?,
  updatedById: json['updated_by_id'] as String?,
);

Map<String, dynamic> _$FlagMessageDetailsResponseToJson(
  FlagMessageDetailsResponse instance,
) => <String, dynamic>{
  'pin_changed': instance.pinChanged,
  'should_enrich': instance.shouldEnrich,
  'skip_push': instance.skipPush,
  'updated_by_id': instance.updatedById,
};
