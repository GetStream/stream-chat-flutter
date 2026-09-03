import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:synchronized/synchronized.dart';

import '../core/api/general_api.dart';
import '../core/api/requests.dart';
import '../core/error/error.dart';
import '../core/models/filter.dart';
import '../event_type.dart';
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
  /// An oversized payload is not replayed. Pass [refreshChannelsOnSkip] to
  /// refresh the channels being recovered in place of those events; the
  /// pointer then advances only once that refresh succeeded.
  ///
  /// Returns the cids whose state was refreshed, so the caller can skip
  /// querying them again. Empty when the payload was replayed as usual.
  Future<Set<String>> recoverMissedEvents({
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

        // Bail out of oversized event replay. Replaying a large payload through
        // [StreamChatClient.handleEvent] can hold local persistence and state
        // updates long enough to slow down regular requests. Refresh the
        // channels instead, and only advance the sync pointer once that
        // succeeded: dropping the events is safe when their state has been
        // re-fetched, but advancing past a failed refresh loses them for good.
        if (events.length > _eventReplayMaximumEventCount) {
          _logger?.info(
            'Skipping replay of ${events.length} events, exceeding the '
            'limit of $_eventReplayMaximumEventCount.',
          );

          var refreshed = const <String>{};
          if (refreshChannelsOnSkip) refreshed = await refreshChannels(channels);

          // A channel refresh does not carry the read state, so keep honouring
          // the mark-all-read events instead of losing them with the rest of
          // the payload.
          for (final event in events) {
            if (event.type != EventType.notificationMarkRead) continue;
            if (event.cid != null) continue;
            client.handleEvent(event);
          }

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
        // If we got a 400 error, it means that either the sync time is too
        // old or the channel list is too long or too many events need to be
        // synced. In this case, we should just flush the persistence client
        // and start over.
        if (error is StreamChatNetworkError && error.statusCode == 400) {
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

        _logger?.warning('Error syncing events', error, stk);
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
