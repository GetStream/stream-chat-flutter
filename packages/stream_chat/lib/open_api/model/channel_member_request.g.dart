// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_member_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelMemberRequest _$ChannelMemberRequestFromJson(
  Map<String, dynamic> json,
) => ChannelMemberRequest(
  channelRole: json['channel_role'] as String?,
  custom: json['custom'] as Map<String, dynamic>?,
  user: json['user'] == null
      ? null
      : MemberUserRequest.fromJson(json['user'] as Map<String, dynamic>),
  userId: json['user_id'] as String?,
);

Map<String, dynamic> _$ChannelMemberRequestToJson(
  ChannelMemberRequest instance,
) => <String, dynamic>{
  'channel_role': instance.channelRole,
  'custom': instance.custom,
  'user': instance.user?.toJson(),
  'user_id': instance.userId,
};
