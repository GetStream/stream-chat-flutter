import 'package:moor/moor.dart';
import 'package:stream_chat_persistence/src/converter/map_converter.dart';

@DataClassName('ConnectionEventEntity')
class ConnectionEvents extends Table {
  IntColumn get id => integer()();

  TextColumn get ownUser => text().nullable().map(MapConverter<Object>())();

  IntColumn get totalUnreadCount => integer().nullable()();

  IntColumn get unreadChannels => integer().nullable()();

  DateTimeColumn get lastEventAt => dateTime().nullable()();

  DateTimeColumn get lastSyncAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
