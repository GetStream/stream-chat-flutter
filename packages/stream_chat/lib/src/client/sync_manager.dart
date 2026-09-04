import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:synchronized/synchronized.dart';

import '../core/api/general_api.dart';
import '../core/api/requests.dart';
import '../core/error/error.dart';
import '../core/models/event.dart';
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

        var refreshed = const <String>{};
        if (events.length > _eventReplayMaximumEventCount) {
          refreshed = await _skipEventReplay(events, cids: channels, refresh: refreshChannelsOnSkip);
        } else {
          _replayEvents(events);
        }

        await persistenceClient?.updateLastSyncAt(updatedSyncAt);
        return refreshed;
      } catch (error, stk) {
        await _handleSyncFailure(error, stk);
        return const {};
      }
    });
  }

  // Applies every event of a payload small enough to replay.
  void _replayEvents(List<Event> events) {
    for (final event in events) {
      _logger?.fine('Syncing event: ${event.type}');
      client.handleEvent(event);
    }
  }

  // Bails out of oversized event replay. Replaying a large payload through
  // [StreamChatClient.handleEvent] can hold local persistence and state updates
  // long enough to slow down regular requests, so the channels the payload
  // covered are refreshed instead when [refresh] is set.
  //
  // Returns the cids that were refreshed. The caller advances the sync pointer
  // only once this has succeeded: dropping the events is safe when their state
  // has been re-fetched, but advancing past a failed refresh loses them for
  // good.
  Future<Set<String>> _skipEventReplay(
    List<Event> events, {
    required List<String> cids,
    required bool refresh,
  }) async {
    _logger?.info(
      'Skipping replay of ${events.length} events, exceeding the '
      'limit of $_eventReplayMaximumEventCount.',
    );

    var refreshed = const <String>{};
    if (refresh) refreshed = await refreshChannels(cids);

    // A channel refresh does not carry the read state, so keep honouring the
    // mark-all-read events instead of losing them with the rest of the payload.
    for (final event in events) {
      if (event.type != EventType.notificationMarkRead) continue;
      if (event.cid != null) continue;
      client.handleEvent(event);
    }

    return refreshed;
  }

  // Handles a sync attempt that failed.
  //
  // A 400 means the sync window is too old, or the channel list or event count
  // too large for the server to answer, so local state is flushed and the sync
  // pointer reset to start over. Anything else is left for the next attempt.
  Future<void> _handleSyncFailure(Object error, StackTrace stk) async {
    if (error is! StreamChatNetworkError || error.statusCode != 400) {
      _logger?.warning('Error syncing events', error, stk);
      return;
    }

    _logger?.warning(
      'Failed to sync events due to stale or oversized state. '
      'Resetting the persistence client to enable a fresh start.',
    );

    try {
      final persistenceClient = client.chatPersistenceClient;
      await persistenceClient?.flush();
      await persistenceClient?.updateLastSyncAt(DateTime.timestamp());
    } catch (resetError, resetStk) {
      _logger?.warning('Error resetting the persistence client', resetError, resetStk);
    }
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
