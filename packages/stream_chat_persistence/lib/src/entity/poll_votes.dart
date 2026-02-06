// coverage:ignore-file
import 'package:drift/drift.dart';
import 'package:stream_chat_persistence/src/entity/entity.dart';

/// Represents a [PollVotes] table in [MoorChatDatabase].
@DataClassName('PollVoteEntity')
class PollVotes extends Table {
  /// The unique identifier of the poll vote.
  TextColumn get id => text().nullable()();

  /// The unique identifier of the poll the vote belongs to.
  TextColumn get pollId => text().nullable().references(Polls, #id, onDelete: KeyAction.cascade)();

  /// The unique identifier of the option selected in the poll.
  ///
  /// Nullable if the user provided an answer.
  TextColumn get optionId => text().nullable()();

  /// The text of the answer provided in the poll.
  ///
  /// Nullable if the user selected an option.
  TextColumn get answerText => text().nullable()();

  /// The date when the poll vote was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// The date when the poll vote was last updated.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  /// The unique identifier of the user who voted.
  ///
  /// Nullable if the poll is anonymous.
  TextColumn get userId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id, pollId};
}
