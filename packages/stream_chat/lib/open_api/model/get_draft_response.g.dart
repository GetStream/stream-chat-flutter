// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_draft_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetDraftResponse _$GetDraftResponseFromJson(Map<String, dynamic> json) => GetDraftResponse(
  draft: DraftResponse.fromJson(json['draft'] as Map<String, dynamic>),
  duration: json['duration'] as String,
);

Map<String, dynamic> _$GetDraftResponseToJson(GetDraftResponse instance) => <String, dynamic>{
  'draft': instance.draft.toJson(),
  'duration': instance.duration,
};
