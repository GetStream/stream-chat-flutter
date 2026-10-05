import '../../../open_api/api.dart' as api;
import '../../core/models/poll.dart';
import '../../core/models/poll_option.dart';
import '../../core/models/poll_vote.dart';
import '../../core/models/response/poll_option_response.dart';
import '../../core/models/response/poll_response.dart';
import '../../core/models/response/poll_vote_response.dart';
import '../../core/models/response/query_poll_votes_response.dart';
import '../../core/models/response/query_polls_response.dart';
import '../../core/models/voting_visibility.dart';
import 'user_mapper.dart';

/// Maps a generated [api.PollResponseData] to a [Poll].
extension PollResponseDataMapper on api.PollResponseData {
  /// Converts this poll into a [Poll].
  ///
  /// [custom] becomes [Poll.extraData], without the keys named after a field of the poll's own, so a custom field
  /// never stands in for one of them.
  Poll toModel() => Poll(
    id: id,
    name: name,
    nameI18n: nameI18n,
    description: description,
    descriptionI18n: descriptionI18n,
    options: [for (final option in options) option.toModel()],
    votingVisibility: VotingVisibility(votingVisibility),
    enforceUniqueVote: enforceUniqueVote,
    maxVotesAllowed: maxVotesAllowed,
    allowAnswers: allowAnswers,
    latestAnswers: [for (final answer in latestAnswers) answer.toModel()],
    answersCount: answersCount,
    allowUserSuggestedOptions: allowUserSuggestedOptions,
    isClosed: isClosed ?? false,
    createdAt: createdAt,
    updatedAt: updatedAt,
    voteCountsByOption: voteCountsByOption,
    voteCount: voteCount,
    latestVotesByOption: {
      for (final MapEntry(key: optionId, value: votes) in latestVotesByOption.entries)
        optionId: [for (final vote in votes) vote.toModel()],
    },
    createdById: createdById,
    createdBy: createdBy?.toModel(),
    ownVotesAndAnswers: [for (final vote in ownVotes) vote.toModel()],
    extraData: _withoutKeys(custom, Poll.topLevelFields),
  );
}

/// Maps a generated [api.PollOptionResponseData] to a [PollOption].
extension PollOptionResponseDataMapper on api.PollOptionResponseData {
  /// Converts this option into a [PollOption].
  ///
  /// [custom] becomes [PollOption.extraData], without the keys named after a field of the option's own.
  PollOption toModel() => PollOption(
    id: id,
    text: text,
    textI18n: textI18n,
    extraData: _withoutKeys(custom, PollOption.topLevelFields),
  );
}

/// Maps a generated [api.PollVoteResponseData] to a [PollVote].
extension PollVoteResponseDataMapper on api.PollVoteResponseData {
  /// Converts this vote into a [PollVote].
  PollVote toModel() => PollVote(
    id: id,
    pollId: pollId,
    optionId: optionId,
    answerText: answerText,
    answerTextI18n: answerTextI18n,
    createdAt: createdAt,
    updatedAt: updatedAt,
    userId: userId,
    user: user?.toModel(),
  );
}

/// Maps a generated [api.PollResponse] to a [PollResponse].
extension PollResponseMapper on api.PollResponse {
  /// Converts this response into a [PollResponse].
  PollResponse toModel() => PollResponse(duration: duration, poll: poll.toModel());
}

/// Maps a generated [api.PollOptionResponse] to a [PollOptionResponse].
extension PollOptionResponseMapper on api.PollOptionResponse {
  /// Converts this response into a [PollOptionResponse].
  PollOptionResponse toModel() => PollOptionResponse(duration: duration, pollOption: pollOption.toModel());
}

/// Maps a generated [api.PollVoteResponse] to a [PollVoteResponse].
extension PollVoteResponseMapper on api.PollVoteResponse {
  /// Converts this response into a [PollVoteResponse].
  PollVoteResponse toModel() => PollVoteResponse(duration: duration, vote: vote?.toModel());
}

/// Maps a generated [api.QueryPollsResponse] to a [QueryPollsResponse].
extension QueryPollsResponseMapper on api.QueryPollsResponse {
  /// Converts this response into a [QueryPollsResponse].
  QueryPollsResponse toModel() => QueryPollsResponse(
    duration: duration,
    polls: [for (final poll in polls) poll.toModel()],
    next: next,
    prev: prev,
  );
}

/// Maps a generated [api.PollVotesResponse] to a [QueryPollVotesResponse].
extension PollVotesResponseMapper on api.PollVotesResponse {
  /// Converts this response into a [QueryPollVotesResponse].
  QueryPollVotesResponse toModel() => QueryPollVotesResponse(
    duration: duration,
    votes: [for (final vote in votes) vote.toModel()],
    next: next,
    prev: prev,
  );
}

/// Maps a [Poll] to the generated requests that create and update it.
///
/// Only the settings of the poll are sent; the vote summary is not.
extension PollRequestMapper on Poll {
  /// Converts this poll into an [api.CreatePollRequest].
  ///
  /// The ids of the [options] are left out: every option gets a new one when the poll is created.
  api.CreatePollRequest toCreatePollRequest() => api.CreatePollRequest(
    id: id,
    name: name,
    description: description,
    options: [for (final option in options) option.toPollOptionInput()],
    votingVisibility: api.CreatePollRequestVotingVisibility.fromJson(votingVisibility),
    enforceUniqueVote: enforceUniqueVote,
    maxVotesAllowed: maxVotesAllowed,
    allowAnswers: allowAnswers,
    allowUserSuggestedOptions: allowUserSuggestedOptions,
    isClosed: isClosed,
    custom: extraData,
  );

  /// Converts this poll into an [api.UpdatePollRequest].
  api.UpdatePollRequest toUpdatePollRequest() => api.UpdatePollRequest(
    id: id,
    name: name,
    description: description,
    options: [for (final option in options) option.toPollOptionRequest()],
    votingVisibility: api.UpdatePollRequestVotingVisibility.fromJson(votingVisibility),
    enforceUniqueVote: enforceUniqueVote,
    maxVotesAllowed: maxVotesAllowed,
    allowAnswers: allowAnswers,
    allowUserSuggestedOptions: allowUserSuggestedOptions,
    isClosed: isClosed,
    custom: extraData,
  );
}

/// Maps a [PollOption] to the generated requests that create and update it.
extension PollOptionRequestMapper on PollOption {
  /// Converts this option into an [api.PollOptionInput], an option of a poll being created.
  api.PollOptionInput toPollOptionInput() => api.PollOptionInput(text: text, custom: extraData);

  /// Converts this option into an [api.PollOptionRequest], an option of a poll being updated.
  ///
  /// An option without an [id] is sent with an empty one.
  api.PollOptionRequest toPollOptionRequest() => api.PollOptionRequest(id: id ?? '', text: text, custom: extraData);

  /// Converts this option into an [api.CreatePollOptionRequest].
  api.CreatePollOptionRequest toCreatePollOptionRequest() => api.CreatePollOptionRequest(
    text: text,
    custom: extraData,
  );

  /// Converts this option into an [api.UpdatePollOptionRequest].
  ///
  /// An option without an [id] is sent with an empty one.
  api.UpdatePollOptionRequest toUpdatePollOptionRequest() =>
      api.UpdatePollOptionRequest(id: id ?? '', text: text, custom: extraData);
}

Map<String, Object?> _withoutKeys(Map<String, Object?> custom, List<String> keys) =>
    {...custom}..removeWhere((key, _) => keys.contains(key));
