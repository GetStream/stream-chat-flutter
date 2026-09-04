import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:synchronized/synchronized.dart';

import '../core/api/general_api.dart';
import '../core/api/requests.dart';
import '../core/error/error.dart';
import '../core/models/filter.dart';
import 'client.dart';

/// Catches the client up on the events it missed while offline.
///
/// Obtained via [StreamChatClient.sync]. Not intended to be constructed
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
  /// advances, so callers relying on the replayed state should refresh it
  /// themselves.
  Future<void> sync({List<String>? cids, DateTime? lastSyncAt}) {
    return _sync(cids: cids, lastSyncAt: lastSyncAt);
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
    if (client.persistenceEnabled) {
      refreshed = await _sync(cids: cids, refreshChannelsOnSkip: true);
    }

    if (!client.recoverStateOnReconnect) return;

    final stale = cids.whereNot(refreshed.contains).toList();
    if (stale.isEmpty) return;

    await refreshChannels(stale);
  }

  // Runs the sync flow, returning the cids whose state was refreshed in place
  // of an oversized payload. Empty when the payload was replayed as usual.
  //
  // Set [refreshChannelsOnSkip] to refresh the channels being recovered when
  // an oversized payload skips event replay, so that their state takes the
  // place of the events that were dropped.
  Future<Set<String>> _sync({
    List<String>? cids,
    DateTime? lastSyncAt,
    bool refreshChannelsOnSkip = false,
  }) {
    return _syncLock.synchronized(() async {
      final persistenceClient = client.chatPersistenceClient;

      final channels = cids ?? await persistenceClient?.getChannelCids();
      if (channels == null || channels.isEmpty) return const {};

      final syncAt = lastSyncAt ?? await persistenceClient?.getLastSyncAt();
      if (syncAt == null) {
        _logger?.info('Fresh sync start: lastSyncAt initialized to now.');
        await persistenceClient?.updateLastSyncAt(DateTime.timestamp());
        return const {};
      }

      try {
        _logger?.info('Syncing events since $syncAt for channels: $channels');

        final res = await _api.sync(channels, syncAt);
        final events = res.events.sorted((a, b) => a.createdAt.compareTo(b.createdAt));
        final updatedSyncAt = events.lastOrNull?.createdAt ?? DateTime.timestamp();

        // Replaying a large payload through [StreamChatClient.handleEvent] can
        // hold local persistence and state updates long enough to slow down the
        // regular requests that need them. Refreshing the channels the payload
        // covered takes its place, because `queryChannels` returns the
        // messages, members and read state those events would have rebuilt.
        if (events.length > _eventReplayMaximumEventCount) {
          _logger?.info(
            'Skipping replay of ${events.length} events, exceeding the '
            'limit of $_eventReplayMaximumEventCount.',
          );

          // The pointer moves past the dropped events only once their state has
          // been re-fetched; advancing past a failed refresh would lose them.
          final refreshed = refreshChannelsOnSkip ? await refreshChannels(channels) : const <String>{};
          await persistenceClient?.updateLastSyncAt(updatedSyncAt);
          return refreshed;
        }

        for (final event in events) {
          _logger?.fine('Syncing event: ${event.type}');
          client.handleEvent(event);
        }

        await persistenceClient?.updateLastSyncAt(updatedSyncAt);
        return const {};
      } catch (error, stk) {
        // A 400 means the sync window is too old, or the channel list or event
        // count too large for the server to answer, so local state is flushed
        // and the pointer reset to start over. Anything else is left for the
        // next attempt.
        if (error is! StreamChatNetworkError || error.statusCode != 400) {
          _logger?.warning('Error syncing events', error, stk);
          return const {};
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

        return const {};
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
