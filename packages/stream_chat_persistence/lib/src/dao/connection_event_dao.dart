import 'package:moor/moor.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';
import 'package:stream_chat_persistence/src/entity/connection_events.dart';
import 'package:stream_chat_persistence/src/entity/users.dart';
import '../mapper/mapper.dart';

part 'connection_event_dao.g.dart';

///
@UseDao(tables: [ConnectionEvents, Users])
class ConnectionEventDao extends DatabaseAccessor<MoorChatDatabase>
    with _$ConnectionEventDaoMixin {
  ///
  ConnectionEventDao(MoorChatDatabase db) : super(db);

  /// Get the latest stored connection event
  Future<Event> get connectionEvent {
    return select(connectionEvents).join([
      leftOuterJoin(users, connectionEvents.ownUserId.equalsExp(users.id)),
    ]).map((rows) {
      final event = rows.readTable(connectionEvents);
      final user = rows.readTable(users);
      return event.toEvent(user: user?.toUser());
    }).getSingle();
  }

  /// Get the latest stored lastSyncAt
  Future<DateTime> get lastSyncAt {
    return select(connectionEvents).getSingle().then((r) => r?.lastSyncAt);
  }

  /// Update stored connection event with latest data
  Future<int> updateConnectionEvent(Event event) async {
    final connectionInfo = await select(connectionEvents).getSingle();
    return into(connectionEvents).insert(
      ConnectionEventEntity(
        id: 1,
        lastSyncAt: connectionInfo?.lastSyncAt,
        lastEventAt: event.createdAt ?? connectionInfo?.lastEventAt,
        totalUnreadCount:
            event.totalUnreadCount ?? connectionInfo?.totalUnreadCount,
        ownUserId: event.me?.id ?? connectionInfo?.ownUserId,
        unreadChannels: event.unreadChannels ?? connectionInfo?.unreadChannels,
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  /// Update stored lastSyncAt with latest data
  Future<int> updateLastSyncAt(DateTime lastSyncAt) async {
    return (update(connectionEvents)..where((tbl) => tbl.id.equals(1))).write(
      ConnectionEventsCompanion(
        lastSyncAt: Value(lastSyncAt),
      ),
    );
  }
}
