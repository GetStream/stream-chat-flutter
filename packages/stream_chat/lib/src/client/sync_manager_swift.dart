import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:rate_limiter/rate_limiter.dart';
import 'package:synchronized/synchronized.dart';

import '../core/api/general_api.dart';
import '../core/api/requests.dart';
import '../core/error/error.dart';
import '../core/models/event.dart';
import '../core/models/filter.dart';
import 'client.dart';

// The same API as [SyncManager], sequenced the way the iOS SDK sequences a
// reconnect catch-up: refresh what can refresh itself, ask `/sync` only about
// what is left, re-watch the rest, and retry each step before moving on. Kept
// alongside ours for comparison; not wired into [StreamChatClient].
//
// Source: stream-chat-swift @ 93664b1, SyncRepository.swift. `PORT:` marks
// where Flutter has no counterpart — chiefly the registries of active lists and
// watched channels, which live in `stream_chat_flutter_core`.

/// Catches a client up on the state it missed while offline.
///
/// Created and driven by [StreamChatClient]; not intended to be constructed
/// directly.
class SyncManagerSwift {
  /// Instantiate a new SyncManagerSwift object.
  SyncManagerSwift({
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

  // Attempts per step, fewer than the client's retry policy allows a request:
  // a reconnect the app is waiting on cannot spend a minute backing off.
  static const _maximumAttemptsPerStep = 2;

  // Maximum number of events replayed from a single `/sync` response before the
  // channels it covered are refreshed instead.
  static const _eventReplayMaximumEventCount = 250;

  // Maximum number of channels a single `queryChannels` request returns.
  static const _channelQueryMaximumPageSize = 30;

  // Age past which a checkpoint is given up on rather than synced from.
  static const _maximumSyncAge = Duration(days: 30);

  /// Recovers the events missed since [lastSyncAt] for [cids] and replays them,
  /// advancing the sync pointer once they are applied.
  ///
  /// Both arguments fall back to the values held by the client's persistence
  /// client. An oversized payload is not replayed; the channels it covered are
  /// refreshed in its place.
  Future<void> sync({List<String>? cids, DateTime? lastSyncAt}) async {
    await _syncEvents(cids: cids?.toSet(), lastSyncAt: lastSyncAt);
  }

  /// Recovers the state of the channels that were active before the connection
  /// was lost.
  ///
  /// Replays the events missed while offline and re-watches the channels that
  /// replay did not cover. Does nothing on a user's first session, or when the
  /// client is not configured to recover state on reconnect.
  ///
  /// Best-effort and never throws: the connection can drop again while this is
  /// in flight, and the caller is a connection listener with nowhere to hand a
  /// failure.
  Future<void> recoverState() async {
    try {
      final persistenceClient = client.chatPersistenceClient;

      // PORT: Swift keeps the checkpoint on the current user, so a missing one
      // means a first session, with nothing to catch up on.
      final lastSyncAt = await persistenceClient?.getLastSyncAt();
      if (lastSyncAt == null) {
        await persistenceClient?.updateLastSyncAt(DateTime.timestamp());
        return;
      }

      if (!client.recoverStateOnReconnect) return;

      // PORT: Swift refreshes the active channel lists first and subtracts what
      // they returned from the events request. Those lists live a layer up, so
      // nothing is covered before `/sync` here.
      final active = client.state.channels.keys.toSet();

      final synced = await _attempt(
        'sync missing events',
        () => _syncEvents(cids: active, lastSyncAt: lastSyncAt),
      );

      // A step that gave up reports nothing, so everything it was given is
      // still waiting for attention.
      final unsynced = synced ?? active;

      // PORT: Swift re-watches each tracked controller and chat. Without a
      // registry of what is being watched, whatever the sync left is.
      if (unsynced.isEmpty) return;
      await _attempt('re-watch channels', () => refreshChannels(unsynced.toList()));
    } catch (error, stk) {
      _logger?.warning('Error recovering state on reconnect', error, stk);
    }
  }

  /// Refreshes the state of the channels in [cids] from the server.
  ///
  /// Queries a page at a time so that larger sets are covered in full rather
  /// than truncated to the first page. Returns the cids the server answered
  /// with, which can be fewer than were asked for when a channel has been
  /// deleted or is no longer visible.
  Future<Set<String>> refreshChannels(List<String> cids) async {
    _logger?.fine('Refreshing ${cids.length} channels');

    final refreshed = <String>{};
    for (final batch in cids.slices(_channelQueryMaximumPageSize)) {
      final channels = await client.queryChannelsOnline(
        filter: Filter.in_('cid', batch),
        paginationParams: PaginationParams(limit: batch.length),
        // Recovery is best-effort and the caller is waiting to announce it, so
        // a dropped connection fails here instead of blocking.
        waitForConnect: false,
      );

      refreshed.addAll(channels.map((it) => it.cid).nonNulls);
    }

    return refreshed;
  }

  // Fetches the events missed for [cids] and replays them, returning the
  // channels it did not bring up to date. Both arguments fall back to what the
  // persistence client holds.
  Future<Set<String>> _syncEvents({Set<String>? cids, DateTime? lastSyncAt}) {
    return _syncLock.synchronized(() async {
      final persistenceClient = client.chatPersistenceClient;

      final channelCids = cids ?? {...?await persistenceClient?.getChannelCids()};
      if (channelCids.isEmpty) return const {};

      final syncAt = lastSyncAt ?? await persistenceClient?.getLastSyncAt();
      // A window this old cannot be served, so give it up rather than spending
      // a request to be told so — and leave its channels to be refreshed.
      if (syncAt == null || DateTime.timestamp().difference(syncAt) > _maximumSyncAge) {
        await persistenceClient?.updateLastSyncAt(DateTime.timestamp());
        return channelCids;
      }

      final List<Event> events;
      try {
        final res = await _api.sync(channelCids.toList(), syncAt);
        events = res.events.sortedBy((it) => it.createdAt);
      } on StreamChatNetworkError catch (error, stk) {
        if (error.statusCode != 400) rethrow;

        // The window holds more events than the endpoint will return, so it is
        // given up on. The refresh runs outside this block on purpose: a 400
        // from its own query would otherwise land back here.
        _logger?.warning('Sync refused for holding too many events', error, stk);
        return _refreshInsteadOfReplaying(channelCids, syncAt: DateTime.timestamp());
      }

      final updatedSyncAt = events.lastOrNull?.createdAt ?? DateTime.timestamp();
      if (events.length > _eventReplayMaximumEventCount) {
        _logger?.warning('Skipping replay of ${events.length} events, over $_eventReplayMaximumEventCount');
        return _refreshInsteadOfReplaying(channelCids, syncAt: updatedSyncAt);
      }

      for (final event in events) {
        _logger?.fine('Syncing event: ${event.type}');
        client.handleEvent(event);
      }

      await persistenceClient?.updateLastSyncAt(updatedSyncAt);
      return const {};
    });
  }

  // Refreshes [cids] in place of a window that will not be replayed, moving the
  // checkpoint to [syncAt] only once that succeeded — keeping it otherwise is
  // what lets the window be given up on, since the next sync asks again.
  //
  // Returns the channels the refresh did not answer for.
  Future<Set<String>> _refreshInsteadOfReplaying(
    Set<String> cids, {
    required DateTime syncAt,
  }) async {
    final refreshed = await refreshChannels(cids.toList());
    await client.chatPersistenceClient?.updateLastSyncAt(syncAt);
    return cids.difference(refreshed);
  }

  // Runs [step], retrying a retriable failure and then giving up on it rather
  // than aborting the recovery. Returns null when it never succeeded.
  //
  // The client's own [RetryPolicy] decides what is worth another attempt, the
  // question Swift asks of its `SyncError.shouldRetry`.
  Future<T?> _attempt<T>(String description, Future<T> Function() step) async {
    final retryPolicy = client.retryPolicy;
    try {
      return await backOff(
        step,
        delayFactor: retryPolicy.delayFactor,
        randomizationFactor: retryPolicy.randomizationFactor,
        maxDelay: retryPolicy.maxDelay,
        maxAttempts: _maximumAttemptsPerStep,
        retryIf: (error, attempt) {
          if (error is! StreamChatError) return false;
          return retryPolicy.shouldRetry(client, attempt, error);
        },
      );
    } catch (error, stk) {
      _logger?.warning('Giving up on $description', error, stk);
      return null;
    }
  }
}
