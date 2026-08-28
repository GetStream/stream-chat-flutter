// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_reaction_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendReactionRequest _$SendReactionRequestFromJson(Map<String, dynamic> json) =>
    SendReactionRequest(
      enforceUnique: json['enforce_unique'] as bool?,
      reaction: ReactionRequest.fromJson(
        json['reaction'] as Map<String, dynamic>,
      ),
      skipPush: json['skip_push'] as bool?,
    );

Map<String, dynamic> _$SendReactionRequestToJson(
  SendReactionRequest instance,
) => <String, dynamic>{
  'enforce_unique': instance.enforceUnique,
  'reaction': instance.reaction.toJson(),
  'skip_push': instance.skipPush,
};
