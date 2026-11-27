// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feeds_reaction_group_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedsReactionGroupResponse _$FeedsReactionGroupResponseFromJson(
  Map<String, dynamic> json,
) => FeedsReactionGroupResponse(
  count: (json['count'] as num).toInt(),
  firstReactionAt: const StreamDateTimeConverter().fromJson(
    json['first_reaction_at'] as Object,
  ),
  lastReactionAt: const StreamDateTimeConverter().fromJson(
    json['last_reaction_at'] as Object,
  ),
);

Map<String, dynamic> _$FeedsReactionGroupResponseToJson(
  FeedsReactionGroupResponse instance,
) => <String, dynamic>{
  'count': instance.count,
  'first_reaction_at': const StreamDateTimeConverter().toJson(
    instance.firstReactionAt,
  ),
  'last_reaction_at': const StreamDateTimeConverter().toJson(
    instance.lastReactionAt,
  ),
};
