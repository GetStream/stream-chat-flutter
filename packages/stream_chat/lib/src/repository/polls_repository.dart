import 'package:stream_core/stream_core.dart' show PatternMatching, Result, Sort;

import '../../open_api/api.dart' as api;
import '../core/models/poll.dart';
import '../core/models/poll_option.dart';
import '../core/models/poll_vote.dart';
import '../core/models/response/poll_option_response.dart';
import '../core/models/response/poll_response.dart';
import '../core/models/response/poll_vote_response.dart';
import '../core/models/response/query_poll_votes_response.dart';
import '../core/models/response/query_polls_response.dart';
import 'mapper/polls_mapper.dart';
import 'mapper/result_mapper.dart';

/// Repository dedicated to poll operations.
class PollsRepository {
  /// Initialize a new polls repository.
  const PollsRepository(this._api);

  final api.DefaultApi _api;

  /// Creates [poll] with its settings and options.
  Future<Result<PollResponse>> createPoll(Poll poll) async {
    final result = await _api.createPoll(createPollRequest: poll.toCreatePollRequest());

    return result.map((response) => response.toModel());
  }

  /// Fetches the poll with the id [pollId].
  Future<Result<PollResponse>> getPoll(String pollId) async {
    final result = await _api.getPoll(pollId: pollId);

    return result.map((response) => response.toModel());
  }

  /// Updates [poll] to match the settings and options it carries.
  ///
  /// [Poll.options] becomes the poll's full list of options, each matched by its id.
  Future<Result<PollResponse>> updatePoll(Poll poll) async {
    final result = await _api.updatePoll(updatePollRequest: poll.toUpdatePollRequest());

    return result.map((response) => response.toModel());
  }

  /// Sets the fields in [set] and removes the fields named in [unset] on the poll with the id [pollId].
  Future<Result<PollResponse>> partialUpdatePoll(
    String pollId, {
    Map<String, Object?>? set,
    List<String>? unset,
  }) async {
    final result = await _api.updatePollPartial(
      pollId: pollId,
      updatePollPartialRequest: api.UpdatePollPartialRequest(set: set, unset: unset),
    );

    return result.map((response) => response.toModel());
  }

  /// Deletes the poll with the id [pollId].
  Future<Result<void>> deletePoll(String pollId) async {
    final result = await _api.deletePoll(pollId: pollId);

    return result.ignoreValue();
  }

  /// Adds [option] to the poll with the id [pollId].
  Future<Result<PollOptionResponse>> createPollOption(String pollId, PollOption option) async {
    final result = await _api.createPollOption(
      pollId: pollId,
      createPollOptionRequest: option.toCreatePollOptionRequest(),
    );

    return result.map((response) => response.toModel());
  }

  /// Fetches an option of a poll, identified by [optionId] and [pollId].
  Future<Result<PollOptionResponse>> getPollOption(String pollId, String optionId) async {
    final result = await _api.getPollOption(pollId: pollId, optionId: optionId);

    return result.map((response) => response.toModel());
  }

  /// Replaces the text and custom data of [option] in the poll with the id [pollId].
  ///
  /// The [option] is matched by its id.
  Future<Result<PollOptionResponse>> updatePollOption(String pollId, PollOption option) async {
    final result = await _api.updatePollOption(
      pollId: pollId,
      updatePollOptionRequest: option.toUpdatePollOptionRequest(),
    );

    return result.map((response) => response.toModel());
  }

  /// Removes an option from a poll, identified by [optionId] and [pollId].
  Future<Result<void>> deletePollOption(String pollId, String optionId) async {
    final result = await _api.deletePollOption(pollId: pollId, optionId: optionId);

    return result.ignoreValue();
  }

  /// Casts a vote for an option of a poll sent in a message, identified by [optionId], [pollId] and [messageId].
  Future<Result<PollVoteResponse>> castPollVote(
    String messageId,
    String pollId, {
    required String optionId,
  }) => _castPollVote(messageId, pollId, api.VoteData(optionId: optionId));

  /// Adds [answerText] as an answer to a poll sent in a message, identified by [pollId] and [messageId].
  Future<Result<PollVoteResponse>> addPollAnswer(
    String messageId,
    String pollId, {
    required String answerText,
  }) => _castPollVote(messageId, pollId, api.VoteData(answerText: answerText));

  Future<Result<PollVoteResponse>> _castPollVote(String messageId, String pollId, api.VoteData vote) async {
    final result = await _api.castPollVote(
      messageId: messageId,
      pollId: pollId,
      castPollVoteRequest: api.CastPollVoteRequest(vote: vote),
    );

    return result.map((response) => response.toModel());
  }

  /// Removes a vote or answer from a poll sent in a message, identified by [voteId], [pollId] and [messageId].
  Future<Result<PollVoteResponse>> removePollVote(String messageId, String pollId, String voteId) async {
    final result = await _api.deletePollVote(messageId: messageId, pollId: pollId, voteId: voteId);

    return result.map((response) => response.toModel());
  }

  /// Fetches one page of the polls matching [filter], ordered by [sort].
  ///
  /// [next] and [prev] are the cursors a previous page returned; at most one of them may be given.
  Future<Result<QueryPollsResponse>> queryPolls({
    PollFilter? filter,
    List<PollSort>? sort,
    int? limit,
    String? next,
    String? prev,
  }) async {
    final result = await _api.queryPolls(
      queryPollsRequest: api.QueryPollsRequest(
        filter: filter?.toJson(),
        sort: sort?.map(_sortParam).toList(),
        limit: limit,
        next: next,
        prev: prev,
      ),
    );

    return result.map((response) => response.toModel());
  }

  /// Fetches one page of the votes and answers matching [filter] on the poll with the id [pollId], ordered by [sort].
  ///
  /// [next] and [prev] are the cursors a previous page returned; at most one of them may be given.
  Future<Result<QueryPollVotesResponse>> queryPollVotes(
    String pollId, {
    PollVoteFilter? filter,
    List<PollVoteSort>? sort,
    int? limit,
    String? next,
    String? prev,
  }) async {
    final result = await _api.queryPollVotes(
      pollId: pollId,
      queryPollVotesRequest: api.QueryPollVotesRequest(
        filter: filter?.toJson(),
        sort: sort?.map(_sortParam).toList(),
        limit: limit,
        next: next,
        prev: prev,
      ),
    );

    return result.map((response) => response.toModel());
  }
}

api.SortParamRequest _sortParam(Sort<Object?> sort) {
  final json = sort.toJson();
  return api.SortParamRequest(field: json['field'] as String?, direction: json['direction'] as int?);
}
