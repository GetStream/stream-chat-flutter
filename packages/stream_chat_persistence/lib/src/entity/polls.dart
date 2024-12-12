import 'package:drift/drift.dart';
import 'package:stream_chat_persistence/src/converter/list_converter.dart';
import 'package:stream_chat_persistence/src/converter/map_converter.dart';
import 'package:stream_chat_persistence/src/converter/voting_visibility_converter.dart';

/// Represents a [Polls] table in [MoorChatDatabase].
@DataClassName('PollEntity')
class Polls extends Table {
  /// The unique identifier of the poll.
  TextColumn get id => text()();

  /// The name of the poll.
  TextColumn get name => text()();

  /// The description of the poll.
  TextColumn get description => text().nullable()();

  /// The list of options available for the poll.
  TextColumn get options => text().map(ListConverter<String>())();

  /// Represents the visibility of the voting process.
  ///
  /// Defaults to 'public'.
  TextColumn get votingVisibility => text()
      .map(const VotingVisibilityConverter())
      .withDefault(const Constant('public'))();

  /// If true, only unique votes are allowed.
  ///
  /// Defaults to false.
  BoolColumn get enforceUniqueVote =>
      boolean().withDefault(const Constant(false))();

  /// The maximum number of votes allowed per user.
  IntColumn get maxVotesAllowed => integer().nullable()();

  /// If true, users can suggest their own options.
  ///
  /// Defaults to false.
  BoolColumn get allowUserSuggestedOptions =>
      boolean().withDefault(const Constant(false))();

  /// If true, users can provide their own answers/comments.
  ///
  /// Defaults to false.
  BoolColumn get allowAnswers => boolean().withDefault(const Constant(false))();

  /// Indicates if the poll is closed.
  BoolColumn get isClosed => boolean().withDefault(const Constant(false))();

  /// The total number of answers received by the poll.
  IntColumn get answersCount => integer().withDefault(const Constant(0))();

  /// Map of vote counts by option.
  TextColumn get voteCountsByOption => text().map(MapConverter<int>())();

  /// The total number of votes received by the poll.
  IntColumn get voteCount => integer().withDefault(const Constant(0))();

  /// The id of the user who created the poll.
  TextColumn get createdById => text().nullable()();

  /// The date when the poll was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// The date when the poll was last updated.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  /// Map of custom poll extraData
  TextColumn get extraData => text().nullable().map(MapConverter())();

  @override
  Set<Column> get primaryKey => {id};
}
