import 'package:drift/drift.dart';
import 'package:stream_chat/stream_chat.dart';
import '../db/drift_chat_database.dart';
import '../entity/connection_events.dart';

import '../mapper/mapper.dart';

part 'connection_event_dao.g.dart';

/// The Data Access Object for operations in [ConnectionEvents] table.
@DriftAccessor(tables: [ConnectionEvents])
class ConnectionEventDao extends DatabaseAccessor<DriftChatDatabase> with _$ConnectionEventDaoMixin {
  /// Creates a new connection event dao instance
  ConnectionEventDao(super.db);

  /// Get the latest stored connection event
  Future<Event?> get connectionEvent => select(connectionEvents)
      .map((eventEntity) => eventEntity.toEvent())
      .getSingleOrNull()
      // A row that only carries a checkpoint is not a connection event.
      .then((event) => event?.type == EventType.any ? null : event);

  /// Get the latest stored lastSyncAt
  Future<DateTime?> get lastSyncAt => select(connectionEvents).getSingleOrNull().then((r) => r?.lastSyncAt);

  /// Update stored connection event with latest data
  Future<int> updateConnectionEvent(Event event) => transaction(() async {
    final connectionInfo = await select(connectionEvents).getSingleOrNull();
    return into(connectionEvents).insertOnConflictUpdate(
      ConnectionEventEntity(
        id: 1,
        type: event.type,
        lastSyncAt: connectionInfo?.lastSyncAt,
        lastEventAt: event.createdAt,
        totalUnreadCount: event.totalUnreadCount ?? connectionInfo?.totalUnreadCount,
        ownUser: event.me?.toJson() ?? connectionInfo?.ownUser,
        unreadChannels: event.unreadChannels ?? connectionInfo?.unreadChannels,
      ),
    );
  });

  /// Update stored lastSyncAt with latest data
  ///
  /// Inserts the row when there is none, so a checkpoint written after the
  /// database was reset is kept rather than silently matching no rows.
  Future<int> updateLastSyncAt(DateTime lastSyncAt) => transaction(() async {
    final connectionInfo = await select(connectionEvents).getSingleOrNull();
    return into(connectionEvents).insertOnConflictUpdate(
      ConnectionEventEntity(
        id: 1,
        type: connectionInfo?.type ?? EventType.any,
        lastSyncAt: lastSyncAt,
        lastEventAt: connectionInfo?.lastEventAt,
        totalUnreadCount: connectionInfo?.totalUnreadCount,
        ownUser: connectionInfo?.ownUser,
        unreadChannels: connectionInfo?.unreadChannels,
      ),
    );
  });
}
