// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_reaction_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteReactionResponse _$DeleteReactionResponseFromJson(
  Map<String, dynamic> json,
) => DeleteReactionResponse(
  duration: json['duration'] as String,
  message: MessageResponse.fromJson(json['message'] as Map<String, dynamic>),
  reaction: ReactionResponse.fromJson(json['reaction'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DeleteReactionResponseToJson(
  DeleteReactionResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'message': instance.message.toJson(),
  'reaction': instance.reaction.toJson(),
};
