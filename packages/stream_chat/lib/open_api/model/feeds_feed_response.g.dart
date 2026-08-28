// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feeds_feed_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedsFeedResponse _$FeedsFeedResponseFromJson(Map<String, dynamic> json) =>
    FeedsFeedResponse(
      activityCount: (json['activity_count'] as num).toInt(),
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      createdBy: UserResponse.fromJson(
        json['created_by'] as Map<String, dynamic>,
      ),
      custom: json['custom'] as Map<String, dynamic>?,
      deletedAt: _$JsonConverterFromJson<Object, DateTime>(
        json['deleted_at'],
        const StreamDateTimeConverter().fromJson,
      ),
      description: json['description'] as String,
      feed: json['feed'] as String,
      filterTags: (json['filter_tags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      followerCount: (json['follower_count'] as num).toInt(),
      followingCount: (json['following_count'] as num).toInt(),
      groupId: json['group_id'] as String,
      id: json['id'] as String,
      location: json['location'] == null
          ? null
          : FeedsActivityLocation.fromJson(
              json['location'] as Map<String, dynamic>,
            ),
      memberCount: (json['member_count'] as num).toInt(),
      name: json['name'] as String,
      pinCount: (json['pin_count'] as num).toInt(),
      updatedAt: const StreamDateTimeConverter().fromJson(
        json['updated_at'] as Object,
      ),
      visibility: json['visibility'] as String?,
    );

Map<String, dynamic> _$FeedsFeedResponseToJson(FeedsFeedResponse instance) =>
    <String, dynamic>{
      'activity_count': instance.activityCount,
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'created_by': instance.createdBy.toJson(),
      'custom': instance.custom,
      'deleted_at': _$JsonConverterToJson<Object, DateTime>(
        instance.deletedAt,
        const StreamDateTimeConverter().toJson,
      ),
      'description': instance.description,
      'feed': instance.feed,
      'filter_tags': instance.filterTags,
      'follower_count': instance.followerCount,
      'following_count': instance.followingCount,
      'group_id': instance.groupId,
      'id': instance.id,
      'location': instance.location?.toJson(),
      'member_count': instance.memberCount,
      'name': instance.name,
      'pin_count': instance.pinCount,
      'updated_at': const StreamDateTimeConverter().toJson(instance.updatedAt),
      'visibility': instance.visibility,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
