// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_member_partial_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateMemberPartialResponse _$UpdateMemberPartialResponseFromJson(
  Map<String, dynamic> json,
) => UpdateMemberPartialResponse(
  channelMember: json['channel_member'] == null
      ? null
      : ChannelMemberResponse.fromJson(
          json['channel_member'] as Map<String, dynamic>,
        ),
  duration: json['duration'] as String,
);

Map<String, dynamic> _$UpdateMemberPartialResponseToJson(
  UpdateMemberPartialResponse instance,
) => <String, dynamic>{
  'channel_member': instance.channelMember?.toJson(),
  'duration': instance.duration,
};
