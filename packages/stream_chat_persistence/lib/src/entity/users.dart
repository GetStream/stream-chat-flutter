import 'package:moor/moor.dart';
import 'package:stream_chat_persistence/src/converter/map_converter.dart';

@DataClassName('UserEntity')
class Users extends Table {
  TextColumn get id => text()();

  TextColumn get role => text().nullable()();

  DateTimeColumn get createdAt => dateTime().nullable()();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  DateTimeColumn get lastActive => dateTime().nullable()();

  BoolColumn get online => boolean().nullable()();

  BoolColumn get banned => boolean().nullable()();

  TextColumn get extraData => text().nullable().map(MapConverter<Object>())();

  @override
  Set<Column> get primaryKey => {id};
}
