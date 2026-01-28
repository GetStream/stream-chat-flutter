// coverage:ignore-file
import 'package:drift/drift.dart';
import 'package:stream_chat_persistence/src/converter/map_converter.dart';
import 'package:stream_chat_persistence/src/entity/messages.dart';

/// Represents a [Reactions] table in [MoorChatDatabase].
@DataClassName('ReactionEntity')
class Reactions extends Table {
  /// The id of the user that sent the reaction
  TextColumn get userId => text().nullable()();

  /// The messageId to which the reaction belongs
  TextColumn get messageId => text()
      .nullable()
      .references(Messages, #id, onDelete: KeyAction.cascade)();

  /// The type of the reaction
  TextColumn get type => text()();

  /// The emoji code for the reaction
  TextColumn get emojiCode => text().nullable()();

  /// The DateTime on which the reaction is created
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// The DateTime on which the reaction was last updated
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  /// The score of the reaction (ie. number of reactions sent)
  IntColumn get score => integer().withDefault(const Constant(0))();

  /// Reaction custom extraData
  TextColumn get extraData => text().nullable().map(MapConverter())();

  @override
  Set<Column> get primaryKey => {
        messageId,
        type,
        userId,
      };
}
