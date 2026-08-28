// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_warning.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchWarning _$SearchWarningFromJson(Map<String, dynamic> json) =>
    SearchWarning(
      channelSearchCids: (json['channel_search_cids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      channelSearchCount: (json['channel_search_count'] as num?)?.toInt(),
      warningCode: (json['warning_code'] as num).toInt(),
      warningDescription: json['warning_description'] as String,
    );

Map<String, dynamic> _$SearchWarningToJson(SearchWarning instance) =>
    <String, dynamic>{
      'channel_search_cids': instance.channelSearchCids,
      'channel_search_count': instance.channelSearchCount,
      'warning_code': instance.warningCode,
      'warning_description': instance.warningDescription,
    };
