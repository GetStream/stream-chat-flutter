// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkGroup _$MarkGroupFromJson(Map<String, dynamic> json) => MarkGroup(
  count: (json['count'] as num?)?.toInt() ?? 0,
  latestBy:
      (json['latest_by'] as List<dynamic>?)?.map((e) => MessageMarker.fromJson(e as Map<String, dynamic>)).toList() ??
      const [],
);

Map<String, dynamic> _$MarkGroupToJson(MarkGroup instance) => <String, dynamic>{
  'count': instance.count,
  'latest_by': instance.latestBy.map((e) => e.toJson()).toList(),
};

MessageMarker _$MessageMarkerFromJson(Map<String, dynamic> json) => MessageMarker(
  userId: json['user_id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$MessageMarkerToJson(MessageMarker instance) => <String, dynamic>{
  'user_id': instance.userId,
  'created_at': instance.createdAt.toIso8601String(),
};
