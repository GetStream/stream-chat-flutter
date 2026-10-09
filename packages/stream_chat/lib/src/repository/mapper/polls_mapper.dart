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
  // Custom keys named like one of the poll's own fields.
  static const _shadowedCustomKeys = {...Poll.topLevelFields};

  /// Converts this poll into a [Poll].
  ///
  /// Custom data named like one of the poll's own fields is left out of [Poll.extraData].
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
    extraData: {...custom}..removeWhere((key, _) => _shadowedCustomKeys.contains(key)),
  );
}

/// Maps a generated [api.PollOptionResponseData] to a [PollOption].
extension PollOptionResponseDataMapper on api.PollOptionResponseData {
  // Custom keys named like one of the option's own fields.
  static const _shadowedCustomKeys = {...PollOption.topLevelFields};

  /// Converts this option into a [PollOption].
  ///
  /// Custom data named like one of the option's own fields is left out of [PollOption.extraData].
  PollOption toModel() => PollOption(
    id: id,
    text: text,
    textI18n: textI18n,
    extraData: {...custom}..removeWhere((key, _) => _shadowedCustomKeys.contains(key)),
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
/// Only the settings of the poll are sent; the vote summary is not. Custom data named like one of the poll's own fields
/// is left out.
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
    custom: _customData,
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
    custom: _customData,
  );

  Map<String, Object?> get _customData =>
      {...extraData}..removeWhere((key, _) => PollResponseDataMapper._shadowedCustomKeys.contains(key));
}

/// Maps a [PollOption] to the generated requests that create and update it.
///
/// Custom data named like one of the option's own fields is left out.
extension PollOptionRequestMapper on PollOption {
  /// Converts this option into an [api.PollOptionInput], an option of a poll being created.
  api.PollOptionInput toPollOptionInput() => api.PollOptionInput(text: text, custom: _customData);

  /// Converts this option into an [api.PollOptionRequest], an option of a poll being updated.
  ///
  /// An option without an [id] is sent with an empty one.
  api.PollOptionRequest toPollOptionRequest() => api.PollOptionRequest(id: id ?? '', text: text, custom: _customData);

  /// Converts this option into an [api.CreatePollOptionRequest].
  api.CreatePollOptionRequest toCreatePollOptionRequest() => api.CreatePollOptionRequest(
    text: text,
    custom: _customData,
  );

  /// Converts this option into an [api.UpdatePollOptionRequest].
  ///
  /// An option without an [id] is sent with an empty one.
  api.UpdatePollOptionRequest toUpdatePollOptionRequest() =>
      api.UpdatePollOptionRequest(id: id ?? '', text: text, custom: _customData);

  Map<String, Object?> get _customData =>
      {...extraData}..removeWhere((key, _) => PollOptionResponseDataMapper._shadowedCustomKeys.contains(key));
}
