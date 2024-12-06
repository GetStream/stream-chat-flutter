import 'dart:convert';

import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';

/// Useful mapping functions for [PollEntity]
extension PollEntityX on PollEntity {
  /// Maps a [PollEntity] into [Poll]
  Poll toPoll({
    User? createdBy,
    List<PollVote> latestAnswers = const [],
    List<PollVote> ownVotesAndAnswers = const [],
    Map<String, List<PollVote>> latestVotesByOption = const {},
  }) {
    return Poll(
      id: id,
      name: name,
      description: description,
      options: options.map((it) {
        final json = jsonDecode(it);
        return PollOption.fromJson(json);
      }).toList(),
      votingVisibility: votingVisibility,
      enforceUniqueVote: enforceUniqueVote,
      maxVotesAllowed: maxVotesAllowed,
      allowAnswers: allowAnswers,
      latestAnswers: latestAnswers,
      answersCount: answersCount,
      allowUserSuggestedOptions: allowUserSuggestedOptions,
      isClosed: isClosed,
      createdAt: createdAt,
      updatedAt: updatedAt,
      voteCountsByOption: voteCountsByOption,
      voteCount: voteCount,
      latestVotesByOption: latestVotesByOption,
      createdById: createdById,
      createdBy: createdBy,
      ownVotesAndAnswers: ownVotesAndAnswers,
      extraData: extraData ?? <String, Object>{},
    );
  }
}

/// Useful mapping functions for [Poll]
extension PollX on Poll {
  /// Maps a [Poll] into [PollEntity]
  PollEntity toEntity() => PollEntity(
        id: id,
        name: name,
        description: description,
        options: options.map(jsonEncode).toList(),
        votingVisibility: votingVisibility,
        enforceUniqueVote: enforceUniqueVote,
        maxVotesAllowed: maxVotesAllowed,
        allowAnswers: allowAnswers,
        answersCount: answersCount,
        allowUserSuggestedOptions: allowUserSuggestedOptions,
        isClosed: isClosed,
        createdAt: createdAt,
        updatedAt: updatedAt,
        voteCountsByOption: voteCountsByOption,
        voteCount: voteCount,
        createdById: createdById,
        extraData: extraData,
      );
}
