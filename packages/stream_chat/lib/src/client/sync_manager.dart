import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:synchronized/synchronized.dart';

import '../core/api/requests.dart';
import '../core/api/responses.dart';
import '../core/error/error.dart';
import '../core/models/event.dart';
import '../core/models/filter.dart';
import '../db/chat_persistence_client.dart';
import 'client.dart';

/// Fetches the events missed on [cids] since [lastSyncAt].
typedef FetchMissedEvents = Future<SyncResponse> Function(List<String> cids, DateTime lastSyncAt);

/// Catches a client up on the state it missed while it was disconnected.
///
/// Created and driven by `StreamChatClient`; not intended to be constructed
/// directly.
class SyncManager {
  /// Instantiate a new SyncManager object.
  SyncManager({
    required this.client,
    required this.fetchMissedEvents,
    this.logger,
    @visibleForTesting this.maxReplayEvents = _defaultMaxReplayEvents,
  });

  // The endpoint rejects more than 255, counted before duplicates collapse.
  // Well under it because the 2000-event ceiling is shared across every channel
  // asked about rather than applied per channel, so fewer channels buys more
  // events each before the window is refused — and a refusal drops the store.
  //
  // Channels past the cap are left to [recoverState]; a direct [sync] leaves
  // them as they were.
  static const _maxSyncCids = 100;

  // The endpoint returns up to 2000 events. Replaying that many runs a state
  // update and a persistence write for each, on the reconnect path, while the
  // app is trying to render.
  static const _defaultMaxReplayEvents = 250;

  // A `queryChannels` response holds at most 30 channels.
  static const _channelPageSize = 30;

  // The endpoint cannot serve a window older than this, so give one up locally
  // rather than spending a request to be told so.
  static const _maxSyncAge = Duration(days: 30);

  /// The client this manager catches up.
  final StreamChatClient client;

  /// Fetches the missed events, passed separately because the client does not
  /// expose the endpoint itself.
  final FetchMissedEvents fetchMissedEvents;

  /// The logger associated to this manager.
  final Logger? logger;

  /// How many events may be replayed from one window before it is given up on
  /// and its channels refreshed instead.
  final int maxReplayEvents;

  // Only one catch-up runs at a time.
  final _syncLock = Lock();

  ChatPersistenceClient? get _store => client.chatPersistenceClient;

  // Swallows a write failure: a catch-up that applied its events but could not
  // record how far it got is not a failed catch-up. The next one asks for a
  // window it has already seen, which is wasted work rather than lost events.
  Future<void> _advanceLastSyncAt(DateTime to) async {
    try {
      await _store?.updateLastSyncAt(to);
    } catch (error, stk) {
      logger?.warning('Failed to record lastSyncAt as $to', error, stk);
    }
  }

  /// Replays the events missed since [lastSyncAt] for [cids], both falling back
  /// to the values held by the persistence client.
  ///
  /// A window that cannot be replayed — too many events, or refused by the
  /// server — is given up on, and the channels it covered are refreshed in its
  /// place. Does nothing when there are no channels to catch up on.
  ///
  /// Those channels are returned so a caller doing its own recovery can skip
  /// them; the set is empty when the events were replayed normally.
  ///
  /// Never throws: a failed catch-up is logged and left for the next one.
  Future<Set<String>> sync({List<String>? cids, DateTime? lastSyncAt}) {
    return _syncLock.synchronized(() async {
      final List<String>? channelCids;
      final DateTime? syncAt;
      try {
        channelCids = cids ?? await _store?.getChannelCids();
        syncAt = lastSyncAt ?? await _store?.getLastSyncAt();
      } catch (error, stk) {
        // Not treated as "never synced": seeding lastSyncAt off an unreadable
        // store would discard a history that is still there.
        logger?.warning('Could not read where the last catch-up left off', error, stk);
        return const <String>{};
      }

      if (channelCids == null || channelCids.isEmpty) return const <String>{};

      final now = clock.now();

      if (syncAt == null) {
        logger?.info('Fresh sync start: lastSyncAt initialized to $now.');
        await _advanceLastSyncAt(now);
        return const <String>{};
      }

      if (now.difference(syncAt) > _maxSyncAge) {
        logger?.warning('Giving up on events since $syncAt, past the $_maxSyncAge limit.');
        await _advanceLastSyncAt(now);
        return const <String>{};
      }

      return _performSync(channelCids, syncAt);
    });
  }

  /// Recovers the state of the channels that were active before the connection
  /// was lost, re-querying the ones the replay did not already refresh.
  ///
  /// Best-effort and never throws: the connection can drop again while this is
  /// in flight, and what did not recover is left for the next reconnect.
  Future<void> recoverState() async {
    final cids = client.state.channels.keys.toList();
    if (cids.isEmpty) return;

    // A failed replay reports no refreshed channels rather than throwing, so the
    // refresh below still runs — it needs the network, not the local store.
    var refreshed = const <String>{};
    if (client.persistenceEnabled) refreshed = await sync(cids: cids);

    if (client.recoverStateOnReconnect) {
      final stale = cids.whereNot(refreshed.contains).toList();
      if (stale.isNotEmpty) await _refreshPages(stale);
    }
  }

  // Refreshes [cids] a page at a time, so a set larger than one request is
  // covered in full rather than truncated.
  //
  // Every page is attempted: one failing says nothing about the others. Returns
  // the channels the server answered with — fewer when one is deleted or no
  // longer visible, which is not a failure — and the first request that failed.
  Future<(Set<String>, (Object, StackTrace)?)> _refreshPages(List<String> cids) async {
    final refreshed = <String>{};
    (Object, StackTrace)? failure;

    for (final page in cids.slices(_channelPageSize)) {
      try {
        final channels = await client.queryChannelsOnline(
          filter: Filter.in_('cid', page),
          paginationParams: PaginationParams(limit: page.length),
          // Fail fast if the connection dropped again: the reconnect handler is
          // waiting to announce recovery, and a sync would hold its lock.
          waitForConnect: false,
        );

        refreshed.addAll(channels.map((it) => it.cid).nonNulls);
      } catch (error, stk) {
        logger?.warning('Failed to refresh ${page.length} channels', error, stk);
        failure ??= (error, stk);
      }
    }

    return (refreshed, failure);
  }

  // Asks for the window [lastSyncAt] opens on [cids] and applies what comes
  // back. [sync] has already decided there is a window worth asking for, and
  // holds the lock while this runs.
  Future<Set<String>> _performSync(List<String> cids, DateTime lastSyncAt) async {
    // Deduplicated before capping: the endpoint counts duplicates against its
    // own limit, so leaving them in would spend slots on nothing.
    final cappedCids = cids.toSet().take(_maxSyncCids).toList();
    logger?.info('Syncing events since $lastSyncAt for channels: $cappedCids');

    final List<Event> events;
    try {
      final res = await fetchMissedEvents(cappedCids, lastSyncAt);
      // lastSyncAt becomes the newest event's date, so the order has to be ours.
      events = res.events.sortedBy((it) => it.createdAt);
    } catch (error, stk) {
      // A 400 means the window is too old, or too large to serve. The two are
      // indistinguishable, and both say local state has drifted beyond
      // reconciling, so the store is dropped and repopulated.
      if (error is StreamChatNetworkError && error.statusCode == 400) {
        logger?.warning('Resetting local state after a refused window', error, stk);
        return _discardRefusedWindow(cappedCids, clock.now());
      }

      // Anything else could succeed next time, so lastSyncAt stays put.
      logger?.warning('Error syncing events', error, stk);
      return const <String>{};
    }

    final nextSyncAt = events.lastOrNull?.createdAt ?? clock.now();
    if (events.length > maxReplayEvents) {
      logger?.warning('Skipping replay of ${events.length} events, over the $maxReplayEvents limit.');
      return _discardOversizedWindow(cappedCids, nextSyncAt);
    }

    for (final event in events) {
      logger?.fine('Syncing event: ${event.type}');
      client.handleEvent(event);
    }

    await _advanceLastSyncAt(nextSyncAt);
    return const <String>{};
  }

  // Gives up on a window that arrived but held more events than may be replayed.
  //
  // lastSyncAt moves past it only once every page of the refresh landed: a
  // channel left unrefreshed is stale and its events are gone. On failure the
  // next reconnect asks for the same window instead of losing it.
  Future<Set<String>> _discardOversizedWindow(List<String> cids, DateTime syncAt) async {
    final (refreshed, failure) = await _refreshPages(cids);

    // Reported even on failure, so the caller does not query them again.
    if (failure != null) {
      logger?.warning('Refreshed only ${refreshed.length} of ${cids.length} channels, keeping lastSyncAt');
      return refreshed;
    }

    await _advanceLastSyncAt(syncAt);
    return refreshed;
  }

  // Gives up on a window the server would not serve, dropping the local store
  // and repopulating it from the refresh.
  //
  // Unlike a window we chose to discard, lastSyncAt moves to [syncAt] whether
  // or not that succeeded: the server refused this window for what it is, so
  // asking again would be refused again and flush the store every reconnect.
  //
  // [syncAt] is taken before the repopulation, so anything arriving during it
  // is asked for again rather than skipped.
  Future<Set<String>> _discardRefusedWindow(List<String> cids, DateTime syncAt) async {
    // Caught locally: a failed flush must not stop lastSyncAt from advancing,
    // or the same window is requested — and refused — on every reconnect.
    try {
      await _store?.flush();
    } catch (error, stk) {
      logger?.warning('Failed to reset the persistence client after a refused window', error, stk);
    }

    // A failed page is already logged, and changes nothing here: unlike a window
    // we chose to discard, lastSyncAt advances either way.
    final (refreshed, _) = await _refreshPages(cids);
    await _advanceLastSyncAt(syncAt);
    return refreshed;
  }
}
