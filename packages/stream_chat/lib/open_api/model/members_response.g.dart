// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'members_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MembersResponse _$MembersResponseFromJson(Map<String, dynamic> json) => MembersResponse(
  duration: json['duration'] as String,
  members: (json['members'] as List<dynamic>)
      .map((e) => ChannelMemberResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MembersResponseToJson(MembersResponse instance) => <String, dynamic>{
  'duration': instance.duration,
  'members': instance.members.map((e) => e.toJson()).toList(),
};
