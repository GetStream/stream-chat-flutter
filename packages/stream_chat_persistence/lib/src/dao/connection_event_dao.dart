import 'package:moor/moor.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';
import 'package:stream_chat_persistence/src/entity/connection_events.dart';

import 'package:stream_chat_persistence/src/mapper/mapper.dart';

part 'connection_event_dao.g.dart';

/// The Data Access Object for operations in [ConnectionEvents] table.
@UseDao(tables: [ConnectionEvents])
class ConnectionEventDao extends DatabaseAccessor<MoorChatDatabase>
    with _$ConnectionEventDaoMixin {
  /// Creates a new connection event dao instance
  ConnectionEventDao(MoorChatDatabase db) : super(db);

  /// Get the latest stored connection event
  Future<Event> get connectionEvent => select(connectionEvents)
      .map((eventEntity) => eventEntity.toEvent())
      .getSingle();

  /// Get the latest stored lastSyncAt
  Future<DateTime> get lastSyncAt =>
      select(connectionEvents).getSingle().then((r) => r?.lastSyncAt);

  /// Update stored connection event with latest data
  Future<void> updateConnectionEvent(Event event) async =>
      transaction(() async {
        final connectionInfo = await select(connectionEvents).getSingle();
        await into(connectionEvents).insert(
          ConnectionEventEntity(
            id: 1,
            lastSyncAt: connectionInfo?.lastSyncAt,
            lastEventAt: event.createdAt ?? connectionInfo?.lastEventAt,
            totalUnreadCount:
                event.totalUnreadCount ?? connectionInfo?.totalUnreadCount,
            ownUser: event.me?.toJson() ?? connectionInfo?.ownUser,
            unreadChannels:
                event.unreadChannels ?? connectionInfo?.unreadChannels,
          ),
          mode: InsertMode.insertOrReplace,
        );
      });

  /// Update stored lastSyncAt with latest data
  Future<int> updateLastSyncAt(DateTime lastSyncAt) async =>
      (update(connectionEvents)..where((tbl) => tbl.id.equals(1))).write(
        ConnectionEventsCompanion(
          lastSyncAt: Value(lastSyncAt),
        ),
      );
}
