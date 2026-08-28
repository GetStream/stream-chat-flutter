// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sort_param_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SortParamRequest _$SortParamRequestFromJson(Map<String, dynamic> json) =>
    SortParamRequest(
      direction: (json['direction'] as num?)?.toInt(),
      field: json['field'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$SortParamRequestToJson(SortParamRequest instance) =>
    <String, dynamic>{
      'direction': instance.direction,
      'field': instance.field,
      'type': instance.type,
    };
