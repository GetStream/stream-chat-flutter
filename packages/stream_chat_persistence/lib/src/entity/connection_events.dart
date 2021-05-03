// coverage:ignore-file
import 'package:moor/moor.dart';
import 'package:stream_chat_persistence/src/converter/map_converter.dart';

/// Represents a [ConnectionEvents] table in [MoorChatDatabase].
@DataClassName('ConnectionEventEntity')
class ConnectionEvents extends Table {
  /// event id
  IntColumn get id => integer()();

  /// User object of the current user
  TextColumn get ownUser => text().nullable().map(MapConverter())();

  /// The number of unread messages for current user
  IntColumn get totalUnreadCount => integer().nullable()();

  /// User total unread channels for current user
  IntColumn get unreadChannels => integer().nullable()();

  /// DateTime of the last event
  DateTimeColumn get lastEventAt => dateTime().nullable()();

  /// DateTime of the last sync
  DateTimeColumn get lastSyncAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
