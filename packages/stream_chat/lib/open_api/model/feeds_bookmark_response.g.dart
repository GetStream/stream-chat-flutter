// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feeds_bookmark_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedsBookmarkResponse _$FeedsBookmarkResponseFromJson(
  Map<String, dynamic> json,
) => FeedsBookmarkResponse(
  activityId: json['activity_id'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>?,
  objectId: json['object_id'] as String,
  objectType: json['object_type'] as String,
  updatedAt: const StreamDateTimeConverter().fromJson(
    json['updated_at'] as Object,
  ),
  user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FeedsBookmarkResponseToJson(
  FeedsBookmarkResponse instance,
) => <String, dynamic>{
  'activity_id': instance.activityId,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'object_id': instance.objectId,
  'object_type': instance.objectType,
  'updated_at': const StreamDateTimeConverter().toJson(instance.updatedAt),
  'user': instance.user.toJson(),
};
