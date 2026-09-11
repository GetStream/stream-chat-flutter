// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_channels_result_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteChannelsResultResponse _$DeleteChannelsResultResponseFromJson(
  Map<String, dynamic> json,
) => DeleteChannelsResultResponse(
  error: json['error'] as String?,
  status: json['status'] as String,
);

Map<String, dynamic> _$DeleteChannelsResultResponseToJson(
  DeleteChannelsResultResponse instance,
) => <String, dynamic>{'error': instance.error, 'status': instance.status};
