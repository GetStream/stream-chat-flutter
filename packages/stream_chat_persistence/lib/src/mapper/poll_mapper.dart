import 'dart:convert';

import 'package:stream_chat/stream_chat.dart';
import '../db/drift_chat_database.dart';

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
      nameI18n: nameI18n,
      description: description,
      descriptionI18n: descriptionI18n,
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
    nameI18n: nameI18n,
    description: description,
    descriptionI18n: descriptionI18n,
    // `PollOption.toJson` leaves out the server-owned `text_i18n`, as it is
    // also the payload sent to the API; the cache has to keep it.
    options: options.map((it) => jsonEncode({...it.toJson(), 'text_i18n': ?it.textI18n})).toList(),
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
