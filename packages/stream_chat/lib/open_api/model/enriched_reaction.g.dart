// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enriched_reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnrichedReaction _$EnrichedReactionFromJson(Map<String, dynamic> json) =>
    EnrichedReaction(
      activityId: json['activity_id'] as String,
      childrenCounts: (json['children_counts'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      data: json['data'] as Map<String, dynamic>?,
      id: json['id'] as String?,
      kind: json['kind'] as String,
      latestChildren: (json['latest_children'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map((e) => EnrichedReaction.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ),
      ownChildren: (json['own_children'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map((e) => EnrichedReaction.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ),
      parent: json['parent'] as String?,
      targetFeeds: (json['target_feeds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      user: json['user'] == null
          ? null
          : Data.fromJson(json['user'] as Map<String, dynamic>),
      userId: json['user_id'] as String,
    );

Map<String, dynamic> _$EnrichedReactionToJson(EnrichedReaction instance) =>
    <String, dynamic>{
      'activity_id': instance.activityId,
      'children_counts': instance.childrenCounts,
      'data': instance.data,
      'id': instance.id,
      'kind': instance.kind,
      'latest_children': instance.latestChildren?.map(
        (k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()),
      ),
      'own_children': instance.ownChildren?.map(
        (k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()),
      ),
      'parent': instance.parent,
      'target_feeds': instance.targetFeeds,
      'user': instance.user?.toJson(),
      'user_id': instance.userId,
    };
