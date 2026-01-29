import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';

/// Useful mapping functions for [PollVoteEntity]
extension PollVoteEntityX on PollVoteEntity {
  /// Maps a [PollVoteEntity] into [PollVote]
  PollVote toPollVote({
    User? user,
  }) => PollVote(
    id: id,
    pollId: pollId,
    optionId: optionId,
    answerText: answerText,
    createdAt: createdAt,
    updatedAt: updatedAt,
    userId: userId,
    user: user,
  );
}

/// Useful mapping functions for [PollVote]
extension PollVoteX on PollVote {
  /// Maps a [PollVote] into [PollVoteEntity]
  PollVoteEntity toEntity() => PollVoteEntity(
    id: id,
    pollId: pollId,
    optionId: optionId,
    answerText: answerText,
    createdAt: createdAt,
    updatedAt: updatedAt,
    userId: userId,
  );
}
