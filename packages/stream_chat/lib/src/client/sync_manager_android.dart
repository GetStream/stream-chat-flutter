import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:synchronized/synchronized.dart';

import '../core/api/general_api.dart';
import '../core/api/requests.dart';
import '../core/error/error.dart';
import '../core/models/filter.dart';
import 'client.dart';

// An alternative [SyncManager] with the same API, following how the Android
// SDK sequences a reconnect catch-up. Kept alongside ours for comparison; not
// wired into [StreamChatClient].
//
// It differs from [SyncManager] in four ways, each noted where it happens:
// one flag gates the whole catch-up rather than only the recovery query, the
// cids sent to `/sync` are capped, a stale checkpoint is given up on locally
// instead of waiting for the server to refuse it, and the checkpoint tracks
// which channels a refresh covered so the recovery does not query them twice.

/// Catches a client up on the state it missed while offline.
///
/// Created and driven by [StreamChatClient]; not intended to be constructed
/// directly.
class SyncManagerAndroid {
  /// Instantiate a new SyncManagerAndroid object.
  SyncManagerAndroid({
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

  // Maximum number of cids a single `/sync` request asks about. The endpoint
  // rejects more than 255, and channels left over are covered by the refresh.
  static const _syncMaximumChannelCount = 100;

  // Maximum number of events replayed from a single `/sync` response before
  // skipping replay to avoid stalling local persistence on reconnect.
  static const _eventReplayMaximumEventCount = 250;

  // Maximum number of channels a single `queryChannels` request returns.
  static const _channelQueryMaximumPageSize = 30;

  // Age past which a checkpoint is given up on rather than synced from. The
  // endpoint cannot serve a window this old, and without a ceiling a
  // checkpoint that stops advancing would be asked for on every reconnect.
  static const _maximumSyncAge = Duration(days: 30);

  /// Recovers the events missed since [lastSyncAt] for [cids] and replays them,
  /// advancing the sync pointer once they are applied.
  ///
  /// Both arguments fall back to the values held by the client's persistence
  /// client. Does nothing when there are no channels to recover.
  ///
  /// Events from an oversized payload are not replayed. The channels it covered
  /// are refreshed in its place, and the pointer moves past it only once that
  /// refresh succeeded.
  Future<void> sync({List<String>? cids, DateTime? lastSyncAt}) async {
    await _sync(cids: cids, lastSyncAt: lastSyncAt);
  }

  /// Recovers the state of the channels that were active before the connection
  /// was lost.
  ///
  /// Replays the events missed while offline, refreshes the channels an
  /// oversized payload left behind, and re-queries the rest.
  ///
  /// Does nothing at all when the client is not configured to recover state on
  /// reconnect — the replay included — or when no channels are active.
  ///
  /// Completes once the recovered state has been applied, so callers can signal
  /// recovery only after this returns.
  ///
  /// Recovery is best-effort and never throws: the connection can drop again
  /// while it is in flight, and the caller is a connection listener with no way
  /// to hand that failure to the app.
  Future<void> recoverState() async {
    // One flag covers the whole catch-up, replay included. That is the shape
    // being compared here, and the cost of it: with recovery turned off the
    // persistence client never catches up either, which is why [SyncManager]
    // answers to `persistenceEnabled` for the sync and this flag only for the
    // recovery query.
    if (!client.recoverStateOnReconnect) return;

    final cids = client.state.channels.keys.toList();
    if (cids.isEmpty) return;

    try {
      var refreshed = const <String>{};
      if (client.persistenceEnabled) refreshed = await _sync(cids: cids);

      // Recover the channels that were active before the connection was lost,
      // skipping the ones the sync already refreshed in place of a window it
      // could not replay.
      final stale = cids.whereNot(refreshed.contains).toList();
      if (stale.isEmpty) return;

      await refreshChannels(stale);
    } catch (error, stk) {
      _logger?.warning('Error recovering state on reconnect', error, stk);
    }
  }

  /// Refreshes the state of the channels in [cids] from the server.
  ///
  /// Queries a page at a time so that sets larger than a single `queryChannels`
  /// response are covered in full rather than truncated to the first page.
  ///
  /// Returns the cids the server answered with, which can be fewer than were
  /// asked for when a channel has been deleted or is no longer visible. Throws
  /// if a page could not be fetched.
  Future<Set<String>> refreshChannels(List<String> cids) async {
    final (:refreshed, :error, :stackTrace) = await _refreshChannelPages(cids);
    if (error == null) return refreshed;
    return Error.throwWithStackTrace(error, stackTrace ?? StackTrace.current);
  }

  // Refreshes [cids] a page at a time, reporting the pages that landed even
  // when one of them fails.
  //
  // Stops at the first failure: the remaining requests would be spent on a
  // refresh the caller is going to reject anyway. A cid the server did not
  // return is not a failure — it can be deleted or no longer visible to this
  // user — so only a failed request is reported as one.
  Future<({Set<String> refreshed, Object? error, StackTrace? stackTrace})> _refreshChannelPages(
    List<String> cids,
  ) async {
    final refreshed = <String>{};
    for (final batch in cids.slices(_channelQueryMaximumPageSize)) {
      try {
        final channels = await client.queryChannelsOnline(
          filter: Filter.in_('cid', batch),
          paginationParams: PaginationParams(limit: batch.length),
          // Fail fast if the connection dropped again: waiting for it here
          // would hold the sync lock, blocking the sync the next reconnect
          // starts.
          waitForConnect: false,
        );

        refreshed.addAll(channels.map((it) => it.cid).nonNulls);
      } catch (error, stk) {
        return (refreshed: refreshed, error: error, stackTrace: stk);
      }
    }

    return (refreshed: refreshed, error: null, stackTrace: null);
  }

  // Fetches the events missed since the last sync and replays them.
  //
  // A window that cannot be replayed is discarded, and the channels it covered
  // are refreshed in its place. The sync pointer moves past a discarded window
  // only once that refresh succeeded: it is what makes discarding safe, and
  // keeping the pointer means the next sync asks for the same window again.
  //
  // Returns the cids refreshed in place of a discarded window, so the caller
  // can skip querying them a second time.
  Future<Set<String>> _sync({List<String>? cids, DateTime? lastSyncAt}) {
    return _syncLock.synchronized(() async {
      final persistenceClient = client.chatPersistenceClient;

      final channelCids = cids ?? await persistenceClient?.getChannelCids();
      if (channelCids == null || channelCids.isEmpty) return const {};

      final syncAt = lastSyncAt ?? await persistenceClient?.getLastSyncAt();
      if (syncAt == null) {
        await persistenceClient?.updateLastSyncAt(DateTime.timestamp());
        return const {};
      }

      // A window this old cannot be served, so give it up here rather than
      // spending a request to be told the same thing.
      if (DateTime.timestamp().difference(syncAt) > _maximumSyncAge) {
        _logger?.warning('Giving up on syncing events since $syncAt, past the $_maximumSyncAge limit');
        await persistenceClient?.updateLastSyncAt(DateTime.timestamp());
        return const {};
      }

      // Channels beyond the request's limit are left to the refresh rather than
      // making the request the endpoint would reject.
      final syncCids = channelCids.take(_syncMaximumChannelCount).toList();
      try {
        final res = await _api.sync(syncCids, syncAt);
        final events = res.events.sortedBy((it) => it.createdAt);
        final updatedSyncAt = events.lastOrNull?.createdAt ?? DateTime.timestamp();

        // Replaying a large payload through [StreamChatClient.handleEvent] can
        // hold local persistence and state updates long enough to slow down the
        // regular requests that need them.
        if (events.length > _eventReplayMaximumEventCount) {
          _logger?.warning(
            'Skipping replay of ${events.length} events, exceeding the limit '
            'of $_eventReplayMaximumEventCount.',
          );

          return await _refreshAndAdvance(cids: syncCids, syncAt: updatedSyncAt);
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
        // and the window given up on. Anything else is left for the next
        // attempt.
        if (error is! StreamChatNetworkError || error.statusCode != 400) {
          _logger?.warning('Error syncing events', error, stk);
          return const {};
        }

        _logger?.warning(
          'Failed to sync events due to stale or oversized state. '
          'Resetting the persistence client to enable a fresh start.',
          error,
          stk,
        );

        try {
          await persistenceClient?.flush();
        } catch (resetError, resetStk) {
          _logger?.warning('Error resetting the persistence client', resetError, resetStk);
          return const {};
        }

        return _refreshAndAdvance(cids: syncCids, syncAt: DateTime.timestamp());
      }
    });
  }

  // Refreshes the channels of a window that was given up on, and moves the
  // sync pointer to [syncAt] once that succeeded. Keeping the pointer on
  // failure is what lets the window be given up on at all: the next sync asks
  // for it again instead of it being lost.
  //
  // Returns the cids that were refreshed, empty when the refresh failed.
  Future<Set<String>> _refreshAndAdvance({
    required List<String> cids,
    required DateTime syncAt,
  }) async {
    _logger?.fine('Refreshing ${cids.length} channels in place of the window');

    final (:refreshed, :error, :stackTrace) = await _refreshChannelPages(cids);
    if (error != null) {
      _logger?.warning(
        'Refreshing the channels of the given-up window failed after '
        '${refreshed.length} of ${cids.length}, keeping lastSyncAt so the same '
        'window is asked for again.',
        error,
        stackTrace,
      );

      // The pages that did land are still reported, so the recovery query does
      // not spend requests on them a second time.
      return refreshed;
    }

    await client.chatPersistenceClient?.updateLastSyncAt(syncAt);
    return refreshed;
  }
}
