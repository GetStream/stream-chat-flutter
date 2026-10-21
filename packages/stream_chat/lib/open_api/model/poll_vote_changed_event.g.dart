// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_vote_changed_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PollVoteChangedEvent _$PollVoteChangedEventFromJson(
  Map<String, dynamic> json,
) => PollVoteChangedEvent(
  activityId: json['activity_id'] as String?,
  cid: json['cid'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  messageId: json['message_id'] as String?,
  poll: PollResponseData.fromJson(json['poll'] as Map<String, dynamic>),
  pollVote: PollVoteResponseData.fromJson(
    json['poll_vote'] as Map<String, dynamic>,
  ),
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$PollVoteChangedEventToJson(
  PollVoteChangedEvent instance,
) => <String, dynamic>{
  'activity_id': instance.activityId,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'message_id': instance.messageId,
  'poll': instance.poll.toJson(),
  'poll_vote': instance.pollVote.toJson(),
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
