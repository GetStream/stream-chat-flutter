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
    await _sync(cids: cids, lastSyncAt: lastSyncAt);
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
  ///
  /// Recovery is best-effort and never throws: the connection can drop again
  /// while it is in flight, and the caller is a connection listener with no
  /// way to hand that failure to the app.
  Future<void> recoverState() async {
    final cids = client.state.channels.keys.toList();
    if (cids.isEmpty) return;

    try {
      // The sync does not catch the channels up when it drops an oversized
      // payload or fails outright, and it does not run at all without a
      // persistence client to catch up.
      var caughtUp = true;
      if (client.persistenceEnabled) caughtUp = await _sync(cids: cids);

      // Refreshing stands in for the events the sync did not apply, and is
      // also the recovery the client can be configured to always run.
      if (caughtUp && !client.recoverStateOnReconnect) return;

      await refreshChannels(cids);
    } catch (error, stk) {
      _logger?.warning('Error recovering state on reconnect', error, stk);
    }
  }

  // Fetches the events missed since the last sync and replays them.
  //
  // Returns whether the channels were caught up. An oversized payload is not
  // replayed and a failed request applies nothing, so in both cases the caller
  // is left to put something in the place of those events.
  //
  // The sync pointer moves past a dropped payload — it would otherwise be
  // re-fetched on every later sync — but is left alone when the request
  // failed, so that window is fetched again.
  Future<bool> _sync({List<String>? cids, DateTime? lastSyncAt}) {
    return _syncLock.synchronized(() async {
      final persistenceClient = client.chatPersistenceClient;

      final channelCids = cids ?? await persistenceClient?.getChannelCids();
      if (channelCids == null || channelCids.isEmpty) return true;

      final syncAt = lastSyncAt ?? await persistenceClient?.getLastSyncAt();
      if (syncAt == null) {
        _logger?.info('Fresh sync start: lastSyncAt initialized to now.');
        await persistenceClient?.updateLastSyncAt(DateTime.timestamp());
        return true;
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

          await persistenceClient?.updateLastSyncAt(updatedSyncAt);
          return false;
        }

        for (final event in events) {
          _logger?.fine('Syncing event: ${event.type}');
          client.handleEvent(event);
        }

        await persistenceClient?.updateLastSyncAt(updatedSyncAt);
        return true;
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
  /// first page.
  Future<void> refreshChannels(List<String> cids) async {
    _logger?.info('Refreshing ${cids.length} channels');

    for (final batch in cids.slices(_channelQueryMaximumPageSize)) {
      await client.queryChannelsOnline(
        filter: Filter.in_('cid', batch),
        paginationParams: PaginationParams(limit: batch.length),
        // Fail fast if the connection dropped again: waiting for it here would
        // hold the sync lock, blocking the sync the next reconnect starts.
        waitForConnect: false,
      );
    }
  }
}
