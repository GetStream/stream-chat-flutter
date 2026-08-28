// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_draft_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateDraftRequest _$CreateDraftRequestFromJson(Map<String, dynamic> json) =>
    CreateDraftRequest(
      message: MessageRequest.fromJson(json['message'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateDraftRequestToJson(CreateDraftRequest instance) =>
    <String, dynamic>{'message': instance.message.toJson()};
