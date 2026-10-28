// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_rewind_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelRewindResponse _$ChannelRewindResponseFromJson(
  Map<String, dynamic> json,
) => ChannelRewindResponse(
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  hiddenCountAtRewind: (json['hidden_count_at_rewind'] as num).toInt(),
  id: json['id'] as String,
  inclusive: json['inclusive'] as bool,
  messageId: json['message_id'] as String,
);

Map<String, dynamic> _$ChannelRewindResponseToJson(
  ChannelRewindResponse instance,
) => <String, dynamic>{
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'hidden_count_at_rewind': instance.hiddenCountAtRewind,
  'id': instance.id,
  'inclusive': instance.inclusive,
  'message_id': instance.messageId,
};
