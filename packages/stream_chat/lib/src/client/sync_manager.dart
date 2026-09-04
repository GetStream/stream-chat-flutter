import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:synchronized/synchronized.dart';

import '../core/api/general_api.dart';
import '../core/api/requests.dart';
import '../core/error/error.dart';
import '../core/models/filter.dart';
import 'client.dart';

/// Catches a client up on the state it missed while offline.
///
/// Created and driven by [StreamChatClient]; not intended to be constructed
/// directly.
class SyncManager {
  /// Instantiate a new SyncManager object.
  SyncManager({
    required this.client,
    required this._api,
    this._logger,
  });

  /// The client this manager recovers state for.
  final StreamChatClient client;

  final GeneralApi _api;
  final Logger? _logger;

  // Lock to make sure only one sync process is running at a time.
  final _syncLock = Lock();

  // Maximum number of events replayed from a single `/sync` response before
  // skipping replay to avoid stalling local persistence on reconnect.
  static const _eventReplayMaximumEventCount = 250;

  // Maximum number of channels a single `queryChannels` request returns.
  static const _channelQueryMaximumPageSize = 30;

  /// Recovers the events missed since [lastSyncAt] for [cids] and replays them,
  /// advancing the sync pointer once they are applied.
  ///
  /// Both arguments fall back to the values held by the client's persistence
  /// client. Does nothing when there are no channels to recover.
  ///
  /// Events from an oversized payload are not replayed. The pointer still
  /// moves past them, so callers relying on the replayed state should refresh
  /// it themselves.
  Future<void> sync({List<String>? cids, DateTime? lastSyncAt}) async {
    final replaySkipped = await _sync(cids: cids, lastSyncAt: lastSyncAt);
    if (!replaySkipped) return;

    // Nothing takes the place of the skipped events here, so the pointer moves
    // past them regardless; leaving it behind would re-fetch the same oversized
    // payload on every sync.
    await client.chatPersistenceClient?.updateLastSyncAt(DateTime.timestamp());
  }

  /// Recovers the state of the channels that were active before the connection
  /// was lost.
  ///
  /// Replays the events missed while offline, refreshes the channels an
  /// oversized payload left behind, and re-queries the rest when the client is
  /// configured to recover state on reconnect. Does nothing when no channels
  /// are active.
  ///
  /// Completes once the recovered state has been applied, so callers can
  /// signal recovery only after this returns.
  Future<void> recoverState() async {
    final cids = client.state.channels.keys.toList();
    if (cids.isEmpty) return;

    var refreshed = const <String>{};
    if (client.persistenceEnabled && await _sync(cids: cids)) {
      // Replay was skipped, so the channels the payload covered take the place
      // of those events. The pointer moves past them only once that succeeded:
      // advancing over a failed refresh would lose them.
      refreshed = await refreshChannels(cids);
      await client.chatPersistenceClient?.updateLastSyncAt(DateTime.timestamp());
    }

    if (!client.recoverStateOnReconnect) return;

    final stale = cids.whereNot(refreshed.contains).toList();
    if (stale.isEmpty) return;

    await refreshChannels(stale);
  }

  // Fetches the events missed since the last sync and replays them, advancing
  // the sync pointer once they are applied.
  //
  // Returns whether an oversized payload skipped replay. The pointer is left
  // where it was in that case: the caller decides what takes the place of the
  // dropped events before moving past them.
  Future<bool> _sync({List<String>? cids, DateTime? lastSyncAt}) {
    return _syncLock.synchronized(() async {
      final persistenceClient = client.chatPersistenceClient;

      final channelCids = cids ?? await persistenceClient?.getChannelCids();
      if (channelCids == null || channelCids.isEmpty) return false;

      final syncAt = lastSyncAt ?? await persistenceClient?.getLastSyncAt();
      if (syncAt == null) {
        _logger?.info('Fresh sync start: lastSyncAt initialized to now.');
        await persistenceClient?.updateLastSyncAt(DateTime.timestamp());
        return false;
      }

      try {
        _logger?.info('Syncing events since $syncAt for channels: $channelCids');

        final res = await _api.sync(channelCids, syncAt);
        final events = res.events.sortedBy((it) => it.createdAt);
        final updatedSyncAt = events.lastOrNull?.createdAt ?? DateTime.timestamp();

        // Replaying a large payload through [StreamChatClient.handleEvent] can
        // hold local persistence and state updates long enough to slow down the
        // regular requests that need them.
        if (events.length > _eventReplayMaximumEventCount) {
          _logger?.info(
            'Skipping replay of ${events.length} events, exceeding the '
            'limit of $_eventReplayMaximumEventCount.',
          );

          return true;
        }

        for (final event in events) {
          _logger?.fine('Syncing event: ${event.type}');
          client.handleEvent(event);
        }

        await persistenceClient?.updateLastSyncAt(updatedSyncAt);
        return false;
      } catch (error, stk) {
        // A 400 means the sync window is too old, or the channel list or event
        // count too large for the server to answer, so local state is flushed
        // and the pointer reset to start over. Anything else is left for the
        // next attempt.
        if (error is! StreamChatNetworkError || error.statusCode != 400) {
          _logger?.warning('Error syncing events', error, stk);
          return false;
        }

        _logger?.warning(
          'Failed to sync events due to stale or oversized state. '
          'Resetting the persistence client to enable a fresh start.',
        );

        try {
          await persistenceClient?.flush();
          await persistenceClient?.updateLastSyncAt(DateTime.timestamp());
        } catch (resetError, resetStk) {
          _logger?.warning('Error resetting the persistence client', resetError, resetStk);
        }

        return false;
      }
    });
  }

  /// Refreshes the state of the channels in [cids] from the server.
  ///
  /// Queries a page at a time so that sets larger than a single
  /// `queryChannels` response are covered in full rather than truncated to the
  /// first page. Returns the cids that were refreshed.
  Future<Set<String>> refreshChannels(List<String> cids) async {
    _logger?.info('Refreshing ${cids.length} channels');

    final refreshed = <String>{};
    for (final batch in cids.slices(_channelQueryMaximumPageSize)) {
      final channels = await client.queryChannelsOnline(
        filter: Filter.in_('cid', batch),
        paginationParams: PaginationParams(limit: batch.length),
        // Fail fast if the connection dropped again: waiting for it here would
        // hold the sync lock, blocking the sync the next reconnect starts.
        waitForConnect: false,
      );

      refreshed.addAll(channels.map((it) => it.cid).nonNulls);
    }

    return refreshed;
  }
}
