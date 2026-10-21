// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_reaction_group_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatReactionGroupResponse _$ChatReactionGroupResponseFromJson(
  Map<String, dynamic> json,
) => ChatReactionGroupResponse(
  count: (json['count'] as num).toInt(),
  firstReactionAt: const StreamDateTimeConverter().fromJson(
    json['first_reaction_at'] as Object,
  ),
  lastReactionAt: const StreamDateTimeConverter().fromJson(
    json['last_reaction_at'] as Object,
  ),
  latestReactionsBy: (json['latest_reactions_by'] as List<dynamic>)
      .map(
        (e) => ChatReactionGroupUserResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  sumScores: (json['sum_scores'] as num).toInt(),
);

Map<String, dynamic> _$ChatReactionGroupResponseToJson(
  ChatReactionGroupResponse instance,
) => <String, dynamic>{
  'count': instance.count,
  'first_reaction_at': const StreamDateTimeConverter().toJson(
    instance.firstReactionAt,
  ),
  'last_reaction_at': const StreamDateTimeConverter().toJson(
    instance.lastReactionAt,
  ),
  'latest_reactions_by': instance.latestReactionsBy.map((e) => e.toJson()).toList(),
  'sum_scores': instance.sumScores,
};
