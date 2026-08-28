// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_poll_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePollRequest _$CreatePollRequestFromJson(Map<String, dynamic> json) =>
    CreatePollRequest(
      allowAnswers: json['allow_answers'] as bool?,
      allowUserSuggestedOptions: json['allow_user_suggested_options'] as bool?,
      custom: json['custom'] as Map<String, dynamic>?,
      description: json['description'] as String?,
      enforceUniqueVote: json['enforce_unique_vote'] as bool?,
      id: json['id'] as String?,
      isClosed: json['is_closed'] as bool?,
      maxVotesAllowed: (json['max_votes_allowed'] as num?)?.toInt(),
      name: json['name'] as String,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => PollOptionInput.fromJson(e as Map<String, dynamic>))
          .toList(),
      votingVisibility: json['voting_visibility'] == null
          ? null
          : CreatePollRequestVotingVisibility.fromJson(
              json['voting_visibility'] as String,
            ),
    );

Map<String, dynamic> _$CreatePollRequestToJson(CreatePollRequest instance) =>
    <String, dynamic>{
      'allow_answers': instance.allowAnswers,
      'allow_user_suggested_options': instance.allowUserSuggestedOptions,
      'custom': instance.custom,
      'description': instance.description,
      'enforce_unique_vote': instance.enforceUniqueVote,
      'id': instance.id,
      'is_closed': instance.isClosed,
      'max_votes_allowed': instance.maxVotesAllowed,
      'name': instance.name,
      'options': instance.options?.map((e) => e.toJson()).toList(),
      'voting_visibility': instance.votingVisibility?.toJson(),
    };
