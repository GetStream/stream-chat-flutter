// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enriched_activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnrichedActivity _$EnrichedActivityFromJson(Map<String, dynamic> json) =>
    EnrichedActivity(
      actor: json['actor'] == null
          ? null
          : Data.fromJson(json['actor'] as Map<String, dynamic>),
      foreignId: json['foreign_id'] as String?,
      id: json['id'] as String?,
      latestReactions: (json['latest_reactions'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map((e) => EnrichedReaction.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ),
      object: json['object'] == null
          ? null
          : Data.fromJson(json['object'] as Map<String, dynamic>),
      origin: json['origin'] == null
          ? null
          : Data.fromJson(json['origin'] as Map<String, dynamic>),
      ownReactions: (json['own_reactions'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map((e) => EnrichedReaction.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ),
      reactionCounts: (json['reaction_counts'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      score: (json['score'] as num?)?.toDouble(),
      target: json['target'] == null
          ? null
          : Data.fromJson(json['target'] as Map<String, dynamic>),
      to: (json['to'] as List<dynamic>?)?.map((e) => e as String).toList(),
      verb: json['verb'] as String?,
    );

Map<String, dynamic> _$EnrichedActivityToJson(EnrichedActivity instance) =>
    <String, dynamic>{
      'actor': instance.actor?.toJson(),
      'foreign_id': instance.foreignId,
      'id': instance.id,
      'latest_reactions': instance.latestReactions?.map(
        (k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()),
      ),
      'object': instance.object?.toJson(),
      'origin': instance.origin?.toJson(),
      'own_reactions': instance.ownReactions?.map(
        (k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()),
      ),
      'reaction_counts': instance.reactionCounts,
      'score': instance.score,
      'target': instance.target?.toJson(),
      'to': instance.to,
      'verb': instance.verb,
    };
