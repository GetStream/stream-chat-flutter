// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feeds_share_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedsShareResponse _$FeedsShareResponseFromJson(Map<String, dynamic> json) =>
    FeedsShareResponse(
      activityId: json['activity_id'] as String,
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FeedsShareResponseToJson(FeedsShareResponse instance) =>
    <String, dynamic>{
      'activity_id': instance.activityId,
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'user': instance.user.toJson(),
    };
