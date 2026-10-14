// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_reaction_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendReactionResponse _$SendReactionResponseFromJson(
  Map<String, dynamic> json,
) => SendReactionResponse(
  duration: json['duration'] as String,
  message: MessageResponse.fromJson(json['message'] as Map<String, dynamic>),
  reaction: ReactionResponse.fromJson(json['reaction'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SendReactionResponseToJson(
  SendReactionResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'message': instance.message.toJson(),
  'reaction': instance.reaction.toJson(),
};
