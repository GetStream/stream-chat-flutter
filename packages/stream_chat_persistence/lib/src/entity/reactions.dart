import 'package:moor/moor.dart';
import 'package:stream_chat_persistence/src/converter/map_converter.dart';

@DataClassName('ReactionEntity')
class Reactions extends Table {
  TextColumn get userId => text()();

  TextColumn get messageId =>
      text().customConstraint('REFERENCES messages(id) ON DELETE CASCADE')();

  TextColumn get type => text()();

  DateTimeColumn get createdAt => dateTime()();

  IntColumn get score => integer().nullable()();

  TextColumn get extraData => text().nullable().map(MapConverter<Object>())();

  @override
  Set<Column> get primaryKey => {
        messageId,
        type,
        userId,
      };
}
