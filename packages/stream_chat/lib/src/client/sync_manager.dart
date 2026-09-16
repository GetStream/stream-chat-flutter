import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:stream_core/stream_core.dart' show StreamApiException, StreamLogger;
import 'package:synchronized/synchronized.dart';

import '../core/api/requests.dart';
import '../core/api/responses.dart';
import '../core/models/channel_state.dart';
import '../core/models/event.dart';
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
  ///
  /// Reports under [tag], so one prefix selects every record a catch-up wrote.
  SyncManager({
    required this.client,
    required this.fetchMissedEvents,
    String tag = 'SCh:Sync',
    @visibleForTesting this.maxReplayEvents = _defaultMaxReplayEvents,
  }) : _logger = StreamLogger(tag);

  // The endpoint rejects more than 255, counted before duplicates collapse.
  //
  // Capped rather than left to the refusal: unlike one refused for its age or
  // its events, a window refused for its size is refused again next time, and
  // every refusal drops the store.
  //
  // Channels past the cap are left to [recoverState]; a direct [sync] leaves
  // them as they were.
  static const _maxSyncCids = 255;

  // The endpoint returns up to 2000 events. Replaying that many runs a state
  // update and a persistence write for each, on the reconnect path, while the
  // app is trying to render.
  static const _defaultMaxReplayEvents = 250;

  // A `queryChannels` response holds at most 30 channels.
  static const _channelPageSize = 30;

  /// The client this manager catches up.
  final StreamChatClient client;

  /// Fetches the missed events, passed separately because the client does not
  /// expose the endpoint itself.
  final FetchMissedEvents fetchMissedEvents;

  /// How many events may be replayed from one window before it is given up on
  /// and its channels refreshed instead.
  final int maxReplayEvents;

  final StreamLogger _logger;

  // Only one catch-up runs at a time.
  final _syncLock = Lock();

  ChatPersistenceClient? get _store => client.chatPersistenceClient;

  // Records how far a catch-up got.
  //
  // Swallows a write failure: there is nowhere else to keep the checkpoint, and
  // a catch-up that applied its events but could not write it down is not a
  // failed catch-up.
  Future<void> _recordLastSyncAt(DateTime to) async {
    try {
      await _store?.updateLastSyncAt(to);
    } catch (error, stk) {
      _logger.w(() => 'Failed to record lastSyncAt as $to', error: error, stackTrace: stk);
    }
  }

  // Drops everything the local store holds, lastSyncAt included, so every
  // caller has to write the checkpoint afterwards.
  //
  // Reports whether it worked rather than throwing: a store that could not be
  // dropped still holds the state the discarded events would have updated, so
  // a caller may not want to advance past them. The refresh that repopulates
  // it still has to run either way.
  Future<bool> _flushStore() async {
    try {
      await _store?.flush();
      return true;
    } catch (error, stk) {
      _logger.w(() => 'Failed to reset the persistence client', error: error, stackTrace: stk);
      return false;
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
        _logger.w(() => 'Could not read where the last catch-up left off', error: error, stackTrace: stk);
        return const <String>{};
      }

      if (channelCids == null || channelCids.isEmpty) return const <String>{};

      if (syncAt == null) {
        final now = clock.now();
        _logger.i(() => 'Fresh sync start: lastSyncAt initialized to $now.');
        await _recordLastSyncAt(now);
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
    final cids = _sortActiveCidsByRecency();
    if (cids.isEmpty) return;

    // A failed replay reports no refreshed channels rather than throwing, so the
    // refresh below still runs — it needs the network, not the local store.
    // Guarded so the contract above holds: `persistenceEnabled` reads a
    // user-supplied persistence client, and a throw would stop the caller
    // announcing recovery.
    try {
      var refreshed = const <String>{};
      if (client.persistenceEnabled) refreshed = await sync(cids: cids);

      if (client.recoverStateOnReconnect) {
        final stale = cids.whereNot(refreshed.contains).toList();
        if (stale.isNotEmpty) await _refreshPages(stale);
      }
    } catch (error, stk) {
      _logger.w(() => 'Error recovering state on reconnect', error: error, stackTrace: stk);
    }
  }

  // Stands in for the recency of a channel whose state was never loaded, so it
  // sorts behind every channel that has one.
  static final _neverActive = DateTime.fromMillisecondsSinceEpoch(0);

  // Sorts the channels held in memory, most recently active first.
  //
  // Ordered to match the cids the persistence client hands back, so the cap in
  // [_performSync] keeps the most recently active channels whichever path the
  // list arrived by rather than whichever ones a query paged through first.
  //
  // Recency is read off the channel state rather than through the date getters
  // on `Channel`, which throw for one that was never initialized or has since
  // been disposed. [recoverState] must not throw.
  List<String> _sortActiveCidsByRecency() {
    final byRecency = client.state.channels.entries.sortedByCompare(
      (it) => it.value.state?.channelState.channel?.lastUpdatedAt ?? _neverActive,
      (a, b) => b.compareTo(a),
    );

    return byRecency.map((it) => it.key).toList();
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
          filter: ChannelFilter.in_(ChannelFilterField.cid, page),
          paginationParams: PaginationParams(limit: page.length),
          // Fail fast if the connection dropped again: the reconnect handler is
          // waiting to announce recovery, and a sync would hold its lock.
          waitForConnect: false,
        );

        refreshed.addAll(channels.map((it) => it.cid).nonNulls);
      } catch (error, stk) {
        _logger.w(() => 'Failed to refresh ${page.length} channels', error: error, stackTrace: stk);
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
    _logger.i(() => 'Syncing events since $lastSyncAt for channels: $cappedCids');

    final List<Event> events;
    try {
      final res = await fetchMissedEvents(cappedCids, lastSyncAt);
      // lastSyncAt becomes the newest event's date, so the order has to be ours.
      events = res.events.sortedBy((it) => it.createdAt);
    } catch (error, stk) {
      // A 400 means the window is too old, or held too many events to return.
      // The two are indistinguishable, and either way the server refusing it is
      // the signal that local state is too far behind to reconcile — so the
      // store is dropped and repopulated rather than reconciled.
      if (error is StreamApiException && error.statusCode == 400) {
        _logger.w(() => 'Resetting local state after a refused window', error: error, stackTrace: stk);
        return _discardRefusedWindow(cappedCids, to: clock.now());
      }

      // Anything else could succeed next time, so lastSyncAt stays put.
      _logger.w(() => 'Error syncing events', error: error, stackTrace: stk);
      return const <String>{};
    }

    final nextSyncAt = events.lastOrNull?.createdAt ?? clock.now();
    if (events.length > maxReplayEvents) {
      _logger.w(() => 'Skipping replay of ${events.length} events, over the $maxReplayEvents limit.');
      return _discardOversizedWindow(cappedCids, from: lastSyncAt, to: nextSyncAt);
    }

    // Resolving an event or applying it to client state can throw. lastSyncAt
    // stays put when one does: the window was only partly applied, and the next
    // catch-up should ask for it again.
    try {
      for (final event in events) {
        _logger.d(() => 'Syncing event: ${event.type}');
        client.handleEvent(event);
      }
    } catch (error, stk) {
      _logger.w(() => 'Stopped replaying the missed events, keeping lastSyncAt', error: error, stackTrace: stk);
      return const <String>{};
    }

    await _recordLastSyncAt(nextSyncAt);
    return const <String>{};
  }

  // Gives up on a window that arrived but held more events than may be replayed.
  //
  // The store is dropped and repopulated from the refresh, since what it holds
  // is missing every change those events carried. lastSyncAt moves to [to] only
  // once both of those worked: a channel left unrefreshed, or a store that
  // would not drop, still needs the events being discarded, so the checkpoint
  // goes back to [from] and the next reconnect asks for the window again.
  Future<Set<String>> _discardOversizedWindow(List<String> cids, {required DateTime from, required DateTime to}) async {
    final flushed = await _flushStore();
    final (refreshed, failure) = await _refreshPages(cids);

    // Refreshed channels are reported even on failure, so the caller does not
    // query them again.
    if (!flushed || failure != null) {
      _logger.w(
        () =>
            '''
Putting lastSyncAt back: store dropped: $flushed,
refreshed ${refreshed.length} of ${cids.length} channels''',
      );
      await _recordLastSyncAt(from);
      return refreshed;
    }

    await _recordLastSyncAt(to);
    return refreshed;
  }

  // Gives up on a window the server would not serve.
  //
  // The store is dropped and repopulated from the refresh, as it is for an
  // oversized window. Only the checkpoint differs: it has nowhere to go back
  // to, and moves to [to] whatever the flush and the refresh did, because a
  // window refused for what it is would be refused again on every reconnect
  // for as long as it is held.
  //
  // [to] is taken before the repopulation, so anything arriving during it is
  // asked for again rather than skipped.
  Future<Set<String>> _discardRefusedWindow(List<String> cids, {required DateTime to}) async {
    // A failed flush or page is already logged, and changes nothing here: the
    // checkpoint advances either way.
    await _flushStore();
    final (refreshed, _) = await _refreshPages(cids);
    await _recordLastSyncAt(to);
    return refreshed;
  }
}
