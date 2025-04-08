import 'dart:convert';

import 'package:stream_chat/src/core/api/requests.dart';
import 'package:stream_chat/src/core/api/responses.dart';
import 'package:stream_chat/src/core/http/stream_http_client.dart';
import 'package:stream_chat/src/core/models/filter.dart';
import 'package:stream_chat/src/core/models/poll.dart';
import 'package:stream_chat/src/core/models/poll_option.dart';
import 'package:stream_chat/src/core/models/poll_vote.dart';

/// Defines the api dedicated to polls operations
class PollsApi {
  /// Initialize a new polls api
  const PollsApi(this._client);

  final StreamHttpClient _client;

  /// Creates a new poll with the given [poll] data.
  Future<CreatePollResponse> createPoll(
    Poll poll,
  ) async {
    final response = await _client.post(
      '/polls',
      data: jsonEncode(poll),
    );

    return CreatePollResponse.fromJson(response.data);
  }

  /// Retrieves a poll by its [id].
  Future<GetPollResponse> getPoll(
    String id,
  ) async {
    final response = await _client.get(
      '/polls/$id',
    );

    return GetPollResponse.fromJson(response.data);
  }

  /// Updates the poll with the given [poll] data.
  Future<UpdatePollResponse> updatePoll(
    Poll poll,
  ) async {
    final response = await _client.put(
      '/polls',
      data: jsonEncode(poll),
    );

    return UpdatePollResponse.fromJson(response.data);
  }

  /// Partially updates the poll with the given [id].
  ///
  /// The [set] and [unset] parameters are used to update the poll.
  Future<UpdatePollResponse> partialUpdatePoll(
    String id, {
    Map<String, Object?>? set,
    List<String>? unset,
  }) async {
    final response = await _client.patch(
      '/polls/$id',
      data: jsonEncode({
        if (set != null) 'set': set,
        if (unset != null) 'unset': unset,
      }),
    );

    return UpdatePollResponse.fromJson(response.data);
  }

  /// Deletes the poll with the given [id].
  Future<EmptyResponse> deletePoll(String id) async {
    final response = await _client.delete(
      '/polls/$id',
    );

    return EmptyResponse.fromJson(response.data);
  }

  /// Creates a new poll option with the given [option] data.
  Future<CreatePollOptionResponse> createPollOption(
    String pollId,
    PollOption option,
  ) async {
    final response = await _client.post(
      '/polls/$pollId/options',
      data: jsonEncode(option),
    );

    return CreatePollOptionResponse.fromJson(response.data);
  }

  /// Retrieves a poll option by its [optionId].
  Future<GetPollOptionResponse> getPollOption(
    String pollId,
    String optionId,
  ) async {
    final response = await _client.get(
      '/polls/$pollId/options/$optionId',
    );

    return GetPollOptionResponse.fromJson(response.data);
  }

  /// Updates the poll option with the given [option] data.
  Future<UpdatePollOptionResponse> updatePollOption(
    String pollId,
    PollOption option,
  ) async {
    final response = await _client.put(
      '/polls/$pollId/options',
      data: jsonEncode(option),
    );

    return UpdatePollOptionResponse.fromJson(response.data);
  }

  /// Removes the poll option with the given [optionId].
  Future<EmptyResponse> deletePollOption(
    String pollId,
    String optionId,
  ) async {
    final response = await _client.delete(
      '/polls/$pollId/options/$optionId',
    );

    return EmptyResponse.fromJson(response.data);
  }

  /// Casts a vote on the poll with the given [pollId] and [vote] data.
  Future<CastPollVoteResponse> castPollVote(
    String messageId,
    String pollId,
    PollVote vote,
  ) async {
    final response = await _client.post(
      '/messages/$messageId/polls/$pollId/vote',
      data: jsonEncode({
        'vote': vote,
      }),
    );

    return CastPollVoteResponse.fromJson(response.data);
  }

  /// Removes the vote with the given [voteId] from the poll with the
  /// given [pollId].
  Future<RemovePollVoteResponse> removePollVote(
    String messageId,
    String pollId,
    String voteId,
  ) async {
    final response = await _client.delete(
      '/messages/$messageId/polls/$pollId/vote/$voteId',
    );

    return RemovePollVoteResponse.fromJson(response.data);
  }

  /// Queries polls with the given [filter], [sort], and [pagination]
  /// parameters.
  Future<QueryPollsResponse> queryPolls({
    Filter? filter,
    SortOrder<Poll>? sort,
    PaginationParams pagination = const PaginationParams(),
  }) async {
    final response = await _client.post(
      '/polls/query',
      data: jsonEncode({
        if (filter != null) 'filter': filter.toJson(),
        if (sort != null) 'sort': sort.map((e) => e.toJson()).toList(),
        ...pagination.toJson(),
      }),
    );

    return QueryPollsResponse.fromJson(response.data);
  }

  /// Queries poll votes with the given [pollId], [filter], [sort], and
  Future<QueryPollVotesResponse> queryPollVotes(
    String pollId, {
    Filter? filter,
    SortOrder<PollVote>? sort,
    PaginationParams pagination = const PaginationParams(),
  }) async {
    final response = await _client.post(
      '/polls/$pollId/votes',
      data: jsonEncode({
        if (filter != null) 'filter': filter.toJson(),
        if (sort != null) 'sort': sort.map((e) => e.toJson()).toList(),
        ...pagination.toJson(),
      }),
    );

    return QueryPollVotesResponse.fromJson(response.data);
  }
}
