import 'package:clock/clock.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/client/sync_manager.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../mocks.dart';

// Records what `/sync` was asked for, and answers with events or an error.
// Callable, so it can be passed straight in as a [FetchMissedEvents].
class _FakeSyncEndpoint {
  _FakeSyncEndpoint({this.events = const [], this.error});

  List<Event> events;
  Exception? error;

  final calls = <({List<String> cids, DateTime lastSyncAt})>[];

  Future<SyncResponse> call(List<String> cids, DateTime lastSyncAt) async {
    calls.add((cids: cids, lastSyncAt: lastSyncAt));
    if (error case final error?) throw error;
    return SyncResponse()..events = events;
  }
}

// Fails every checkpoint read, standing in for a corrupt or closed database.
class _ThrowingPersistenceClient extends Fake implements ChatPersistenceClient {
  @override
  Future<DateTime?> getLastSyncAt() async => throw Exception('database is gone');
}

// A channel is only ever read for its cid here. A plain fake rather than a mock:
// stubbing one inside another stub's `thenAnswer` re-enters mocktail and
// silently yields a null cid.
class _FakeChannel extends Fake implements Channel {
  _FakeChannel(this.cid);

  @override
  final String? cid;
}

// The handles a test needs to observe a manager: what it replayed, and which
// channel pages it queried.
typedef _Harness = ({
  SyncManager manager,
  MockStreamChatClient client,
  List<Event> replayed,
  List<List<String>> queriedPages,
});

void main() {
  registerFallbackValue(FakeEvent());
  registerFallbackValue(const PaginationParams());
  registerFallbackValue(const Filter.empty());

  final t0 = DateTime.utc(2026, 3, 1, 12);
  final anHourAgo = t0.subtract(const Duration(hours: 1));

  Event eventAt(DateTime createdAt) => Event(type: EventType.messageNew, createdAt: createdAt);

  List<Event> eventsOf(int count) {
    return List.generate(count, (i) => eventAt(anHourAgo.add(Duration(seconds: i + 1))));
  }

  StreamChatNetworkError badRequest() {
    return StreamChatNetworkError.raw(code: 4, message: 'too many events', statusCode: 400);
  }

  // [onQueryPage] decides what a page of `queryChannels` does: returning an
  // Exception throws it, a List of cids answers with only those, and null
  // answers with the whole page.
  _Harness buildHarness({
    required _FakeSyncEndpoint api,
    required ChatPersistenceClient persistence,
    List<String> activeCids = const ['messaging:a'],
    bool persistenceEnabled = true,
    bool recoverStateOnReconnect = true,
    Object? Function(List<String> page)? onQueryPage,
  }) {
    final client = MockStreamChatClient();
    final state = MockClientState();
    final replayed = <Event>[];
    final queriedPages = <List<String>>[];

    when(() => client.chatPersistenceClient).thenReturn(persistence);
    client.persistenceEnabled = persistenceEnabled;
    when(() => client.recoverStateOnReconnect).thenReturn(recoverStateOnReconnect);
    when(() => client.state).thenReturn(state);
    when(() => state.channels).thenReturn({for (final cid in activeCids) cid: _FakeChannel(cid)});
    when(() => client.handleEvent(any())).thenAnswer((invocation) {
      replayed.add(invocation.positionalArguments.first as Event);
    });

    when(
      () => client.queryChannelsOnline(
        filter: any(named: 'filter'),
        paginationParams: any(named: 'paginationParams'),
        waitForConnect: any(named: 'waitForConnect'),
      ),
    ).thenAnswer((invocation) async {
      final filter = invocation.namedArguments[#filter] as Filter;
      final page = (filter.value as List).cast<String>();
      queriedPages.add(page);

      final outcome = onQueryPage?.call(page);
      if (outcome is Exception) throw outcome;

      final answered = outcome is List<String> ? outcome : page;
      return [for (final cid in answered) _FakeChannel(cid)];
    });

    return (
      manager: SyncManager(client: client, fetchMissedEvents: api.call),
      client: client,
      replayed: replayed,
      queriedPages: queriedPages,
    );
  }

  // Every test pins "now" to [t0] so the checkpoint-age rules are deterministic.
  void testWithClock(String description, Future<void> Function() body) {
    test(description, () => withClock(Clock.fixed(t0), body));
  }

  testWithClock('sync caps the channel ids named in the request at 100', () async {
    final api = _FakeSyncEndpoint();
    final harness = buildHarness(
      api: api,
      persistence: FakePersistenceClient(lastSyncAt: anHourAgo),
    );

    final cids = List.generate(300, (i) => 'messaging:$i');
    await harness.manager.sync(cids: cids);

    expect(api.calls.single.cids, cids.take(100));
  });

  testWithClock('sync collapses duplicate channel ids before the cap applies', () async {
    final api = _FakeSyncEndpoint();
    final harness = buildHarness(
      api: api,
      persistence: FakePersistenceClient(lastSyncAt: anHourAgo),
    );

    await harness.manager.sync(cids: ['messaging:a', 'messaging:a', 'messaging:b']);

    expect(api.calls.single.cids, ['messaging:a', 'messaging:b']);
  });

  testWithClock('sync asks for a window the server may refuse rather than pre-judging it', () async {
    final api = _FakeSyncEndpoint();
    final persistence = FakePersistenceClient(lastSyncAt: t0.subtract(const Duration(days: 31)));
    final harness = buildHarness(api: api, persistence: persistence);

    await harness.manager.sync(cids: ['messaging:a']);

    expect(
      api.calls,
      hasLength(1),
      reason: 'the server owns the age limit; a refusal is handled, not predicted',
    );
  });

  testWithClock('sync does not request anything on a first sync', () async {
    final api = _FakeSyncEndpoint();
    final harness = buildHarness(api: api, persistence: FakePersistenceClient());

    await harness.manager.sync(cids: ['messaging:a']);

    expect(api.calls, isEmpty);
  });

  testWithClock('sync seeds the checkpoint to now on a first sync', () async {
    final persistence = FakePersistenceClient();
    final harness = buildHarness(api: _FakeSyncEndpoint(), persistence: persistence);

    await harness.manager.sync(cids: ['messaging:a']);

    expect(await persistence.getLastSyncAt(), t0);
  });

  testWithClock('sync does nothing when there are no channels to catch up on', () async {
    final api = _FakeSyncEndpoint();
    final persistence = FakePersistenceClient();
    final harness = buildHarness(api: api, persistence: persistence);

    await harness.manager.sync();

    expect(api.calls, isEmpty);
    expect(await persistence.getLastSyncAt(), isNull);
  });

  testWithClock('sync falls back to the persisted channel ids when none are named', () async {
    final api = _FakeSyncEndpoint();
    final persistence = FakePersistenceClient(lastSyncAt: anHourAgo, channelCids: ['messaging:a']);
    final harness = buildHarness(api: api, persistence: persistence);

    await harness.manager.sync();

    expect(api.calls.single.cids, ['messaging:a']);
  });

  testWithClock('sync replays a window sitting exactly on the limit', () async {
    final harness = buildHarness(
      api: _FakeSyncEndpoint(events: eventsOf(250)),
      persistence: FakePersistenceClient(lastSyncAt: anHourAgo),
    );

    await harness.manager.sync(cids: ['messaging:a']);

    expect(harness.replayed, hasLength(250));
  });

  testWithClock('sync does not query channels for a window it replayed', () async {
    final harness = buildHarness(
      api: _FakeSyncEndpoint(events: eventsOf(250)),
      persistence: FakePersistenceClient(lastSyncAt: anHourAgo),
    );

    await harness.manager.sync(cids: ['messaging:a']);

    expect(harness.queriedPages, isEmpty);
  });

  testWithClock('sync advances the checkpoint to the last replayed event', () async {
    final events = eventsOf(250);
    final persistence = FakePersistenceClient(lastSyncAt: anHourAgo);
    final harness = buildHarness(
      api: _FakeSyncEndpoint(events: events),
      persistence: persistence,
    );

    await harness.manager.sync(cids: ['messaging:a']);

    expect(await persistence.getLastSyncAt(), events.last.createdAt);
  });

  testWithClock('sync does not replay a window one event over the limit', () async {
    final harness = buildHarness(
      api: _FakeSyncEndpoint(events: eventsOf(251)),
      persistence: FakePersistenceClient(lastSyncAt: anHourAgo),
    );

    await harness.manager.sync(cids: ['messaging:a']);

    expect(harness.replayed, isEmpty);
  });

  testWithClock('sync queries the channels of a window it did not replay', () async {
    final harness = buildHarness(
      api: _FakeSyncEndpoint(events: eventsOf(251)),
      persistence: FakePersistenceClient(lastSyncAt: anHourAgo),
    );

    await harness.manager.sync(cids: ['messaging:a']);

    expect(harness.queriedPages, [
      ['messaging:a'],
    ]);
  });

  testWithClock('sync flushes the store for a window it did not replay', () async {
    final persistence = FakePersistenceClient(lastSyncAt: anHourAgo);
    final harness = buildHarness(
      api: _FakeSyncEndpoint(events: eventsOf(251)),
      persistence: persistence,
    );

    await harness.manager.sync(cids: ['messaging:a']);

    expect(
      persistence.flushCallCount,
      1,
      reason: 'what the store holds is missing every change the skipped events carried',
    );
  });

  testWithClock('sync advances past a window it did not replay', () async {
    final events = eventsOf(251);
    final persistence = FakePersistenceClient(lastSyncAt: anHourAgo);
    final harness = buildHarness(
      api: _FakeSyncEndpoint(events: events),
      persistence: persistence,
    );

    await harness.manager.sync(cids: ['messaging:a']);

    expect(await persistence.getLastSyncAt(), events.last.createdAt);
  });

  testWithClock('sync takes the checkpoint from the newest event, whatever order they arrive in', () async {
    final oldest = eventAt(anHourAgo.add(const Duration(minutes: 1)));
    final newest = eventAt(anHourAgo.add(const Duration(minutes: 3)));
    final persistence = FakePersistenceClient(lastSyncAt: anHourAgo);
    final harness = buildHarness(
      api: _FakeSyncEndpoint(events: [newest, oldest]),
      persistence: persistence,
    );

    await harness.manager.sync(cids: ['messaging:a']);

    expect(await persistence.getLastSyncAt(), newest.createdAt);
  });

  testWithClock('sync does not let a persistence failure escape to the caller', () async {
    final persistence = _ThrowingPersistenceClient();
    final harness = buildHarness(api: _FakeSyncEndpoint(), persistence: persistence);

    await expectLater(harness.manager.sync(cids: ['messaging:a']), completes);
  });

  testWithClock('sync advances the checkpoint to now when the window holds no events', () async {
    final persistence = FakePersistenceClient(lastSyncAt: anHourAgo);
    final harness = buildHarness(api: _FakeSyncEndpoint(), persistence: persistence);

    await harness.manager.sync(cids: ['messaging:a']);

    expect(await persistence.getLastSyncAt(), t0);
  });

  group('when a window cannot be replayed', () {
    testWithClock('puts the checkpoint back if the refresh replacing it fails', () async {
      final persistence = FakePersistenceClient(lastSyncAt: anHourAgo);
      final harness = buildHarness(
        api: _FakeSyncEndpoint(events: eventsOf(251)),
        persistence: persistence,
        onQueryPage: (_) => Exception('offline again'),
      );

      await harness.manager.sync(cids: ['messaging:a']);

      expect(persistence.flushCallCount, 1);
      expect(
        await persistence.getLastSyncAt(),
        anHourAgo,
        reason: 'the flush took the checkpoint with it, and the skipped events must stay recoverable',
      );
    });

    testWithClock('attempts every page even when one of them fails', () async {
      final persistence = FakePersistenceClient(lastSyncAt: anHourAgo);
      final harness = buildHarness(
        api: _FakeSyncEndpoint(events: eventsOf(251)),
        persistence: persistence,
        onQueryPage: (page) => page.contains('messaging:0') ? Exception('offline again') : null,
      );

      await harness.manager.sync(cids: List.generate(90, (i) => 'messaging:$i'));

      expect(harness.queriedPages, hasLength(3), reason: 'a failing page must not skip the others');
    });

    testWithClock('credits the pages that landed so recovery does not redo them', () async {
      final cids = List.generate(90, (i) => 'messaging:$i');
      final lastPage = cids.sublist(60);
      final persistence = FakePersistenceClient(lastSyncAt: anHourAgo);
      final harness = buildHarness(
        api: _FakeSyncEndpoint(events: eventsOf(251)),
        persistence: persistence,
        activeCids: cids,
        onQueryPage: (page) => page.contains(lastPage.first) ? Exception('offline again') : null,
      );

      await harness.manager.recoverState();

      expect(
        await persistence.getLastSyncAt(),
        anHourAgo,
        reason: 'a channel left unrefreshed still has a window of events to catch up on',
      );
      expect(
        harness.queriedPages.skip(3),
        [lastPage],
        reason: 'the two pages that landed are credited, so only the failed one is retried',
      );
    });

    testWithClock('flushes, refreshes and advances when the server refuses it', () async {
      final persistence = FakePersistenceClient(lastSyncAt: anHourAgo);
      final harness = buildHarness(
        api: _FakeSyncEndpoint(error: badRequest()),
        persistence: persistence,
      );

      await harness.manager.sync(cids: ['messaging:a']);

      expect(persistence.flushCallCount, 1);
      expect(harness.queriedPages, [
        ['messaging:a'],
      ]);
      expect(await persistence.getLastSyncAt(), t0);
    });

    testWithClock('still advances when the refresh after a refusal fails', () async {
      final persistence = FakePersistenceClient(lastSyncAt: anHourAgo);
      final harness = buildHarness(
        api: _FakeSyncEndpoint(error: badRequest()),
        persistence: persistence,
        onQueryPage: (_) => Exception('offline again'),
      );

      await harness.manager.sync(cids: ['messaging:a']);

      expect(persistence.flushCallCount, 1);
      expect(
        await persistence.getLastSyncAt(),
        t0,
        reason: 'a refused window is refused again, so holding it would flush on every reconnect',
      );
    });

    testWithClock('does not let a failed flush escape to the caller', () async {
      final harness = buildHarness(
        api: _FakeSyncEndpoint(events: eventsOf(251)),
        persistence: _ThrowingPersistenceClient(),
      );

      await expectLater(
        harness.manager.sync(cids: ['messaging:a'], lastSyncAt: anHourAgo),
        completes,
      );
    });

    testWithClock('leaves the checkpoint and the store alone on a non-400 failure', () async {
      final persistence = FakePersistenceClient(lastSyncAt: anHourAgo);
      final harness = buildHarness(
        api: _FakeSyncEndpoint(
          error: StreamChatNetworkError.raw(code: 0, message: 'boom', statusCode: 500),
        ),
        persistence: persistence,
      );

      await harness.manager.sync(cids: ['messaging:a']);

      expect(persistence.flushCallCount, 0);
      expect(harness.queriedPages, isEmpty);
      expect(await persistence.getLastSyncAt(), anHourAgo);
    });
  });

  testWithClock('recoverState does not query the channels the sync already refreshed', () async {
    final harness = buildHarness(
      api: _FakeSyncEndpoint(events: eventsOf(251)),
      persistence: FakePersistenceClient(lastSyncAt: anHourAgo),
      activeCids: ['messaging:a', 'messaging:b'],
    );

    await harness.manager.recoverState();

    expect(
      harness.queriedPages,
      [
        ['messaging:a', 'messaging:b'],
      ],
      reason: 'the sync refreshed both, so recovery has nothing left to query',
    );
  });

  testWithClock('recoverState queries the channels a replayed window left stale', () async {
    final harness = buildHarness(
      api: _FakeSyncEndpoint(events: eventsOf(2)),
      persistence: FakePersistenceClient(lastSyncAt: anHourAgo),
      activeCids: ['messaging:a', 'messaging:b'],
    );

    await harness.manager.recoverState();

    expect(harness.queriedPages, [
      ['messaging:a', 'messaging:b'],
    ]);
  });

  testWithClock('recoverState still replays when recovery on reconnect is off', () async {
    final api = _FakeSyncEndpoint(events: eventsOf(2));
    final harness = buildHarness(
      api: api,
      persistence: FakePersistenceClient(lastSyncAt: anHourAgo),
      recoverStateOnReconnect: false,
    );

    await harness.manager.recoverState();

    expect(api.calls, hasLength(1), reason: 'the replay answers to persistence, not to this flag');
  });

  testWithClock('recoverState queries nothing when recovery on reconnect is off', () async {
    final harness = buildHarness(
      api: _FakeSyncEndpoint(events: eventsOf(2)),
      persistence: FakePersistenceClient(lastSyncAt: anHourAgo),
      recoverStateOnReconnect: false,
    );

    await harness.manager.recoverState();

    expect(harness.queriedPages, isEmpty);
  });

  testWithClock('recoverState does not replay when persistence is disabled', () async {
    final api = _FakeSyncEndpoint(events: eventsOf(2));
    final harness = buildHarness(
      api: api,
      persistence: FakePersistenceClient(lastSyncAt: anHourAgo),
      persistenceEnabled: false,
    );

    await harness.manager.recoverState();

    expect(api.calls, isEmpty);
  });

  testWithClock('recoverState still refreshes when persistence is disabled', () async {
    final harness = buildHarness(
      api: _FakeSyncEndpoint(events: eventsOf(2)),
      persistence: FakePersistenceClient(lastSyncAt: anHourAgo),
      persistenceEnabled: false,
    );

    await harness.manager.recoverState();

    expect(harness.queriedPages, [
      ['messaging:a'],
    ]);
  });

  testWithClock('recoverState does nothing when no channel is active', () async {
    final api = _FakeSyncEndpoint();
    final harness = buildHarness(
      api: api,
      persistence: FakePersistenceClient(lastSyncAt: anHourAgo),
      activeCids: const [],
    );

    await harness.manager.recoverState();

    expect(api.calls, isEmpty);
    expect(harness.queriedPages, isEmpty);
  });

  testWithClock('recoverState does not throw when the refresh fails', () async {
    final harness = buildHarness(
      api: _FakeSyncEndpoint(events: eventsOf(2)),
      persistence: FakePersistenceClient(lastSyncAt: anHourAgo),
      onQueryPage: (_) => Exception('offline again'),
    );

    await expectLater(harness.manager.recoverState(), completes);
  });

  testWithClock('sync does not throw when applying an event does', () async {
    final harness = buildHarness(
      api: _FakeSyncEndpoint(events: eventsOf(2)),
      persistence: FakePersistenceClient(lastSyncAt: anHourAgo),
    );
    when(() => harness.client.handleEvent(any())).thenThrow(Exception('a listener blew up'));

    await expectLater(harness.manager.sync(cids: ['messaging:a']), completes);
  });

  testWithClock('sync keeps lastSyncAt when a window is only partly applied', () async {
    final persistence = FakePersistenceClient(lastSyncAt: anHourAgo);
    final harness = buildHarness(
      api: _FakeSyncEndpoint(events: eventsOf(2)),
      persistence: persistence,
    );
    when(() => harness.client.handleEvent(any())).thenThrow(Exception('a listener blew up'));

    await harness.manager.sync(cids: ['messaging:a']);

    expect(await persistence.getLastSyncAt(), anHourAgo);
  });

  testWithClock('recoverState pages the refresh rather than truncating it', () async {
    final cids = List.generate(300, (i) => 'messaging:$i');
    final harness = buildHarness(
      api: _FakeSyncEndpoint(events: eventsOf(2)),
      persistence: FakePersistenceClient(lastSyncAt: anHourAgo),
      activeCids: cids,
    );

    await harness.manager.recoverState();

    expect(harness.queriedPages, hasLength(10));
    expect(harness.queriedPages.every((page) => page.length == 30), isTrue);
  });

  testWithClock('a channel the server omits does not hold lastSyncAt back', () async {
    final events = eventsOf(251);
    final persistence = FakePersistenceClient(lastSyncAt: anHourAgo);
    final harness = buildHarness(
      api: _FakeSyncEndpoint(events: events),
      persistence: persistence,
      // The server answers with only the first of the two asked for, as it
      // would for a channel that has been deleted.
      onQueryPage: (page) => [page.first],
    );

    await harness.manager.sync(cids: ['messaging:a', 'messaging:b']);

    expect(await persistence.getLastSyncAt(), events.last.createdAt);
  });
}
