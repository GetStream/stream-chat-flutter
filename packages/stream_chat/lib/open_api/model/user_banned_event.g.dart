// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_banned_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserBannedEvent _$UserBannedEventFromJson(Map<String, dynamic> json) =>
    UserBannedEvent(
      channelCustom: json['channel_custom'] as Map<String, dynamic>?,
      channelId: json['channel_id'] as String?,
      channelMemberCount: (json['channel_member_count'] as num?)?.toInt(),
      channelMessageCount: (json['channel_message_count'] as num?)?.toInt(),
      channelType: json['channel_type'] as String?,
      cid: json['cid'] as String?,
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      createdBy: json['created_by'] == null
          ? null
          : UserResponseCommonFields.fromJson(
              json['created_by'] as Map<String, dynamic>,
            ),
      custom: json['custom'] as Map<String, dynamic>,
      expiration: _$JsonConverterFromJson<Object, DateTime>(
        json['expiration'],
        const StreamDateTimeConverter().fromJson,
      ),
      reason: json['reason'] as String?,
      receivedAt: _$JsonConverterFromJson<Object, DateTime>(
        json['received_at'],
        const StreamDateTimeConverter().fromJson,
      ),
      reviewQueueItemId: json['review_queue_item_id'] as String?,
      shadow: json['shadow'] as bool?,
      team: json['team'] as String?,
      totalBans: (json['total_bans'] as num?)?.toInt(),
      type: json['type'] as String,
      user: UserResponseCommonFields.fromJson(
        json['user'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$UserBannedEventToJson(UserBannedEvent instance) =>
    <String, dynamic>{
      'channel_custom': instance.channelCustom,
      'channel_id': instance.channelId,
      'channel_member_count': instance.channelMemberCount,
      'channel_message_count': instance.channelMessageCount,
      'channel_type': instance.channelType,
      'cid': instance.cid,
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'created_by': instance.createdBy?.toJson(),
      'custom': instance.custom,
      'expiration': _$JsonConverterToJson<Object, DateTime>(
        instance.expiration,
        const StreamDateTimeConverter().toJson,
      ),
      'reason': instance.reason,
      'received_at': _$JsonConverterToJson<Object, DateTime>(
        instance.receivedAt,
        const StreamDateTimeConverter().toJson,
      ),
      'review_queue_item_id': instance.reviewQueueItemId,
      'shadow': instance.shadow,
      'team': instance.team,
      'total_bans': instance.totalBans,
      'type': instance.type,
      'user': instance.user.toJson(),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
