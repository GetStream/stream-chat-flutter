// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fork_channel_target.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForkChannelTarget _$ForkChannelTargetFromJson(Map<String, dynamic> json) => ForkChannelTarget(
  data: json['data'] == null ? null : ChannelInput.fromJson(json['data'] as Map<String, dynamic>),
  id: json['id'] as String,
  members: (json['members'] as List<dynamic>?)
      ?.map((e) => ChannelMemberRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ForkChannelTargetToJson(ForkChannelTarget instance) => <String, dynamic>{
  'data': instance.data?.toJson(),
  'id': instance.id,
  'members': instance.members?.map((e) => e.toJson()).toList(),
};
