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

  /// The current user stored from the last opened connection, or null when
  /// none was stored.
  Future<OwnUser?> get connectedUser =>
      select(connectionEvents).getSingleOrNull()
      // A row carrying only a checkpoint names no user.
      .then((entity) => entity?.type == EventType.any ? null : entity?.toOwnUser());

  /// Get the latest stored lastSyncAt
  Future<DateTime?> get lastSyncAt => select(connectionEvents).getSingleOrNull().then((r) => r?.lastSyncAt);

  /// Stores the current user named by [event], which a connection opens with.
  Future<int> updateConnectionEvent(HealthCheckEvent event) => transaction(() async {
    final connectionInfo = await select(connectionEvents).getSingleOrNull();
    return into(connectionEvents).insertOnConflictUpdate(
      ConnectionEventEntity(
        id: 1,
        type: event.type,
        lastSyncAt: connectionInfo?.lastSyncAt,
        lastEventAt: event.createdAt,
        totalUnreadCount: event.me.totalUnreadCount,
        ownUser: event.me.toJson(),
        unreadChannels: event.me.unreadChannels,
      ),
    );
  });

  /// Update stored lastSyncAt with latest data
  ///
  /// Inserts the row if the database was reset, so the checkpoint is not lost.
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
