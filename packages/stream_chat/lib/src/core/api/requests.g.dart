// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationParams _$PaginationParamsFromJson(Map<String, dynamic> json) => PaginationParams(
  limit: (json['limit'] as num?)?.toInt() ?? 10,
  offset: (json['offset'] as num?)?.toInt(),
  next: json['next'] as String?,
  idAround: json['id_around'] as String?,
  greaterThan: json['id_gt'] as String?,
  greaterThanOrEqual: json['id_gte'] as String?,
  lessThan: json['id_lt'] as String?,
  lessThanOrEqual: json['id_lte'] as String?,
  createdAtAfterOrEqual: json['created_at_after_or_equal'] == null
      ? null
      : DateTime.parse(json['created_at_after_or_equal'] as String),
  createdAtAfter: json['created_at_after'] == null ? null : DateTime.parse(json['created_at_after'] as String),
  createdAtBeforeOrEqual: json['created_at_before_or_equal'] == null
      ? null
      : DateTime.parse(json['created_at_before_or_equal'] as String),
  createdAtBefore: json['created_at_before'] == null ? null : DateTime.parse(json['created_at_before'] as String),
  createdAtAround: json['created_at_around'] == null ? null : DateTime.parse(json['created_at_around'] as String),
);

Map<String, dynamic> _$PaginationParamsToJson(PaginationParams instance) => <String, dynamic>{
  'limit': instance.limit,
  'offset': ?instance.offset,
  'next': ?instance.next,
  'id_around': ?instance.idAround,
  'id_gt': ?instance.greaterThan,
  'id_gte': ?instance.greaterThanOrEqual,
  'id_lt': ?instance.lessThan,
  'id_lte': ?instance.lessThanOrEqual,
  'created_at_after_or_equal': ?instance.createdAtAfterOrEqual?.toIso8601String(),
  'created_at_after': ?instance.createdAtAfter?.toIso8601String(),
  'created_at_before_or_equal': ?instance.createdAtBeforeOrEqual?.toIso8601String(),
  'created_at_before': ?instance.createdAtBefore?.toIso8601String(),
  'created_at_around': ?instance.createdAtAround?.toIso8601String(),
};

Map<String, dynamic> _$PartialUpdateUserRequestToJson(
  PartialUpdateUserRequest instance,
) => <String, dynamic>{
  'stringify': instance.stringify,
  'hash_code': instance.hashCode,
  'id': instance.id,
  'set': instance.set,
  'unset': instance.unset,
  'props': instance.props,
};

Map<String, dynamic> _$ThreadOptionsToJson(ThreadOptions instance) => <String, dynamic>{
  'stringify': instance.stringify,
  'hash_code': instance.hashCode,
  'watch': instance.watch,
  'reply_limit': instance.replyLimit,
  'participant_limit': instance.participantLimit,
  'member_limit': instance.memberLimit,
  'props': instance.props,
};

Map<String, dynamic> _$MemberUpdatePayloadToJson(
  MemberUpdatePayload instance,
) => <String, dynamic>{
  'archived': ?instance.archived,
  'pinned': ?instance.pinned,
};
