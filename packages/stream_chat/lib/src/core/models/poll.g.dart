// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Poll _$PollFromJson(Map<String, dynamic> json) => Poll(
      id: json['id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      options: (json['options'] as List<dynamic>)
          .map((e) => PollOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      votingVisibility: $enumDecodeNullable(
              _$VotingVisibilityEnumMap, json['voting_visibility']) ??
          VotingVisibility.public,
      enforceUniqueVote: json['enforce_unique_vote'] as bool? ?? true,
      maxVotesAllowed: (json['max_votes_allowed'] as num?)?.toInt(),
      allowAnswers: json['allow_answers'] as bool? ?? false,
      latestAnswers: (json['latest_answers'] as List<dynamic>?)
              ?.map((e) => PollVote.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      answersCount: (json['answers_count'] as num?)?.toInt() ?? 0,
      allowUserSuggestedOptions:
          json['allow_user_suggested_options'] as bool? ?? false,
      isClosed: json['is_closed'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      voteCountsByOption:
          (json['vote_counts_by_option'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toInt()),
              ) ??
              const {},
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
      latestVotesByOption:
          (json['latest_votes_by_option'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(
                    k,
                    (e as List<dynamic>)
                        .map(
                            (e) => PollVote.fromJson(e as Map<String, dynamic>))
                        .toList()),
              ) ??
              const {},
      createdById: json['created_by_id'] as String?,
      createdBy: json['created_by'] == null
          ? null
          : User.fromJson(json['created_by'] as Map<String, dynamic>),
      ownVotesAndAnswers: (json['own_votes'] as List<dynamic>?)
              ?.map((e) => PollVote.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      extraData: json['extra_data'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$PollToJson(Poll instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'options': instance.options.map((e) => e.toJson()).toList(),
      'voting_visibility':
          _$VotingVisibilityEnumMap[instance.votingVisibility]!,
      'enforce_unique_vote': instance.enforceUniqueVote,
      'max_votes_allowed': instance.maxVotesAllowed,
      'allow_user_suggested_options': instance.allowUserSuggestedOptions,
      'allow_answers': instance.allowAnswers,
      'is_closed': instance.isClosed,
      'extra_data': instance.extraData,
    };

const _$VotingVisibilityEnumMap = {
  VotingVisibility.anonymous: 'anonymous',
  VotingVisibility.public: 'public',
};
