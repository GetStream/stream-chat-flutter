// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_channels_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteChannelsRequest _$DeleteChannelsRequestFromJson(
  Map<String, dynamic> json,
) => DeleteChannelsRequest(
  cids: (json['cids'] as List<dynamic>).map((e) => e as String).toList(),
  hardDelete: json['hard_delete'] as bool?,
);

Map<String, dynamic> _$DeleteChannelsRequestToJson(
  DeleteChannelsRequest instance,
) => <String, dynamic>{
  'cids': instance.cids,
  'hard_delete': instance.hardDelete,
};
