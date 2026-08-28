// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_appeal_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAppealResponse _$GetAppealResponseFromJson(Map<String, dynamic> json) =>
    GetAppealResponse(
      duration: json['duration'] as String,
      item: json['item'] == null
          ? null
          : AppealItemResponse.fromJson(json['item'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetAppealResponseToJson(GetAppealResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'item': instance.item?.toJson(),
    };
