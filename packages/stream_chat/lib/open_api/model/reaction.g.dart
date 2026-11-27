// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reaction _$ReactionFromJson(Map<String, dynamic> json) => Reaction(
  activityId: json['activity_id'] as String,
  childrenCounts: json['children_counts'] as Map<String, dynamic>?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  data: json['data'] as Map<String, dynamic>?,
  deletedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['deleted_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  id: json['id'] as String?,
  kind: json['kind'] as String,
  latestChildren: (json['latest_children'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(
      k,
      (e as List<dynamic>).map((e) => Reaction.fromJson(e as Map<String, dynamic>)).toList(),
    ),
  ),
  moderation: json['moderation'] as Map<String, dynamic>?,
  ownChildren: (json['own_children'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(
      k,
      (e as List<dynamic>).map((e) => Reaction.fromJson(e as Map<String, dynamic>)).toList(),
    ),
  ),
  parent: json['parent'] as String?,
  score: (json['score'] as num?)?.toDouble(),
  targetFeeds: (json['target_feeds'] as List<dynamic>?)?.map((e) => e as String).toList(),
  targetFeedsExtraData: json['target_feeds_extra_data'] as Map<String, dynamic>?,
  updatedAt: const StreamDateTimeConverter().fromJson(
    json['updated_at'] as Object,
  ),
  user: json['user'] == null ? null : User.fromJson(json['user'] as Map<String, dynamic>),
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$ReactionToJson(Reaction instance) => <String, dynamic>{
  'activity_id': instance.activityId,
  'children_counts': instance.childrenCounts,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'data': instance.data,
  'deleted_at': _$JsonConverterToJson<Object, DateTime>(
    instance.deletedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'id': instance.id,
  'kind': instance.kind,
  'latest_children': instance.latestChildren?.map(
    (k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()),
  ),
  'moderation': instance.moderation,
  'own_children': instance.ownChildren?.map(
    (k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()),
  ),
  'parent': instance.parent,
  'score': instance.score,
  'target_feeds': instance.targetFeeds,
  'target_feeds_extra_data': instance.targetFeedsExtraData,
  'updated_at': const StreamDateTimeConverter().toJson(instance.updatedAt),
  'user': instance.user?.toJson(),
  'user_id': instance.userId,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
