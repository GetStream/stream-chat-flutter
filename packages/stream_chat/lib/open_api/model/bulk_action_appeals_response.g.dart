// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_action_appeals_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BulkActionAppealsResponse _$BulkActionAppealsResponseFromJson(
  Map<String, dynamic> json,
) => BulkActionAppealsResponse(
  duration: json['duration'] as String,
  errors: (json['errors'] as List<dynamic>).map((e) => BulkAppealError.fromJson(e as Map<String, dynamic>)).toList(),
  results: (json['results'] as List<dynamic>).map((e) => BulkAppealResult.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$BulkActionAppealsResponseToJson(
  BulkActionAppealsResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'errors': instance.errors.map((e) => e.toJson()).toList(),
  'results': instance.results.map((e) => e.toJson()).toList(),
};
