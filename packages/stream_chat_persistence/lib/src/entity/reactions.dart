// coverage:ignore-file
import 'package:moor/moor.dart';
import 'package:stream_chat_persistence/src/converter/map_converter.dart';

/// Represents a [Reactions] table in [MoorChatDatabase].
@DataClassName('ReactionEntity')
class Reactions extends Table {
  /// The id of the user that sent the reaction
  TextColumn get userId => text()();

  /// The messageId to which the reaction belongs
  TextColumn get messageId =>
      text().customConstraint('REFERENCES messages(id) ON DELETE CASCADE')();

  /// The type of the reaction
  TextColumn get type => text()();

  /// The DateTime on which the reaction is created
  DateTimeColumn get createdAt => dateTime()();

  /// The score of the reaction (ie. number of reactions sent)
  IntColumn get score => integer().nullable()();

  /// Reaction custom extraData
  TextColumn get extraData => text().nullable().map(MapConverter<Object>())();

  @override
  Set<Column> get primaryKey => {
        messageId,
        type,
        userId,
      };
}
