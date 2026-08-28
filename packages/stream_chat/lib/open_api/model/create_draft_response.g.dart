// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_draft_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateDraftResponse _$CreateDraftResponseFromJson(Map<String, dynamic> json) =>
    CreateDraftResponse(
      draft: DraftResponse.fromJson(json['draft'] as Map<String, dynamic>),
      duration: json['duration'] as String,
    );

Map<String, dynamic> _$CreateDraftResponseToJson(
  CreateDraftResponse instance,
) => <String, dynamic>{
  'draft': instance.draft.toJson(),
  'duration': instance.duration,
};
