// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SortOption<T> _$SortOptionFromJson<T>(Map<String, dynamic> json) =>
    SortOption<T>(
      json['field'] as String,
      direction: (json['direction'] as num?)?.toInt() ?? SortOption.DESC,
    );

Map<String, dynamic> _$SortOptionToJson<T>(SortOption<T> instance) =>
    <String, dynamic>{
      'field': instance.field,
      'direction': instance.direction,
    };

PaginationParams _$PaginationParamsFromJson(Map<String, dynamic> json) =>
    PaginationParams(
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
      createdAtAfter: json['created_at_after'] == null
          ? null
          : DateTime.parse(json['created_at_after'] as String),
      createdAtBeforeOrEqual: json['created_at_before_or_equal'] == null
          ? null
          : DateTime.parse(json['created_at_before_or_equal'] as String),
      createdAtBefore: json['created_at_before'] == null
          ? null
          : DateTime.parse(json['created_at_before'] as String),
      createdAtAround: json['created_at_around'] == null
          ? null
          : DateTime.parse(json['created_at_around'] as String),
    );

Map<String, dynamic> _$PaginationParamsToJson(PaginationParams instance) =>
    <String, dynamic>{
      'limit': instance.limit,
      if (instance.offset case final value?) 'offset': value,
      if (instance.next case final value?) 'next': value,
      if (instance.idAround case final value?) 'id_around': value,
      if (instance.greaterThan case final value?) 'id_gt': value,
      if (instance.greaterThanOrEqual case final value?) 'id_gte': value,
      if (instance.lessThan case final value?) 'id_lt': value,
      if (instance.lessThanOrEqual case final value?) 'id_lte': value,
      if (instance.createdAtAfterOrEqual?.toIso8601String() case final value?)
        'created_at_after_or_equal': value,
      if (instance.createdAtAfter?.toIso8601String() case final value?)
        'created_at_after': value,
      if (instance.createdAtBeforeOrEqual?.toIso8601String() case final value?)
        'created_at_before_or_equal': value,
      if (instance.createdAtBefore?.toIso8601String() case final value?)
        'created_at_before': value,
      if (instance.createdAtAround?.toIso8601String() case final value?)
        'created_at_around': value,
    };

Map<String, dynamic> _$PartialUpdateUserRequestToJson(
        PartialUpdateUserRequest instance) =>
    <String, dynamic>{
      'stringify': instance.stringify,
      'hash_code': instance.hashCode,
      'id': instance.id,
      'set': instance.set,
      'unset': instance.unset,
      'props': instance.props,
    };

Map<String, dynamic> _$ThreadOptionsToJson(ThreadOptions instance) =>
    <String, dynamic>{
      'stringify': instance.stringify,
      'hash_code': instance.hashCode,
      'watch': instance.watch,
      'reply_limit': instance.replyLimit,
      'participant_limit': instance.participantLimit,
      'member_limit': instance.memberLimit,
      'props': instance.props,
    };
