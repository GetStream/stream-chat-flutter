import 'package:moor/moor.dart';

@DataClassName('ConnectionEventEntity')
class ConnectionEvents extends Table {
  IntColumn get id => integer()();

  TextColumn get ownUserId => text().nullable()();

  IntColumn get totalUnreadCount => integer().nullable()();

  IntColumn get unreadChannels => integer().nullable()();

  DateTimeColumn get lastEventAt => dateTime().nullable()();

  DateTimeColumn get lastSyncAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
