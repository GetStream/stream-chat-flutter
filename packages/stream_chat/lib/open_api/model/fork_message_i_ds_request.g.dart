// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fork_message_i_ds_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForkMessageIDsRequest _$ForkMessageIDsRequestFromJson(
  Map<String, dynamic> json,
) => ForkMessageIDsRequest(
  sourceMessageIds: (json['source_message_ids'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$ForkMessageIDsRequestToJson(
  ForkMessageIDsRequest instance,
) => <String, dynamic>{'source_message_ids': instance.sourceMessageIds};
