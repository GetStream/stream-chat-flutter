// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReactionGroup _$ReactionGroupFromJson(Map<String, dynamic> json) =>
    ReactionGroup(
      count: (json['count'] as num?)?.toInt() ?? 0,
      sumScores: (json['sum_scores'] as num?)?.toInt() ?? 0,
      firstReactionAt: json['first_reaction_at'] == null
          ? null
          : DateTime.parse(json['first_reaction_at'] as String),
      lastReactionAt: json['last_reaction_at'] == null
          ? null
          : DateTime.parse(json['last_reaction_at'] as String),
    );

Map<String, dynamic> _$ReactionGroupToJson(ReactionGroup instance) =>
    <String, dynamic>{
      'count': instance.count,
      'sum_scores': instance.sumScores,
      'first_reaction_at': instance.firstReactionAt.toIso8601String(),
      'last_reaction_at': instance.lastReactionAt.toIso8601String(),
    };
