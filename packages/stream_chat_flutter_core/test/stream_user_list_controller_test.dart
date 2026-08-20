import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart' hide Success;
import 'package:stream_chat_flutter_core/src/paged_value_notifier.dart';
import 'package:stream_chat_flutter_core/src/stream_user_list_controller.dart';

import 'mocks.dart';

void main() {
  final client = MockClient();

  tearDown(() {
    reset(client);
  });

  QueryUsersResponse usersResponse(List<User> users) {
    return QueryUsersResponse()..users = users;
  }

  group('search', () {
    test('queries users with the provided filter after debouncing', () {
      Filter? usedFilter;
      when(
        () => client.queryUsers(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          presence: any(named: 'presence'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((invocation) async {
        usedFilter ??= invocation.namedArguments[#filter] as Filter?;
        return usersResponse([User(id: 'user-1')]);
      });

      fakeAsync((async) {
        final controller = StreamUserListController(client: client);
        addTearDown(controller.dispose);

        controller.search('abc');

        // 'abc' is longer than a short query, so the 300ms delay applies.
        async.elapse(const Duration(milliseconds: 299));
        expect(usedFilter, isNull);

        async.elapse(const Duration(milliseconds: 1));
        expect(
          usedFilter,
          Filter.or([Filter.autoComplete('name', 'abc'), Filter.autoComplete('id', 'abc')]),
        );
      });
    });

    test('a short query waits longer than a standard one', () {
      var queryCount = 0;
      when(
        () => client.queryUsers(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          presence: any(named: 'presence'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((_) async {
        queryCount += 1;
        return usersResponse([]);
      });

      fakeAsync((async) {
        final controller = StreamUserListController(client: client);
        addTearDown(controller.dispose);

        // A 2-char query is low-selectivity, so it waits the full 500ms rather
        // than the 300ms standard delay.
        controller.search('ab');

        async.elapse(const Duration(milliseconds: 499));
        expect(queryCount, 0);

        async.elapse(const Duration(milliseconds: 1));
        expect(queryCount, 1);
      });
    });

    test('replaces the base filter rather than narrowing it', () {
      Filter? usedFilter;
      when(
        () => client.queryUsers(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          presence: any(named: 'presence'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((invocation) async {
        usedFilter ??= invocation.namedArguments[#filter] as Filter?;
        return usersResponse([]);
      });

      fakeAsync((async) {
        final controller = StreamUserListController(
          client: client,
          filter: Filter.notEqual('id', 'me'),
        );
        addTearDown(controller.dispose);

        controller.search('abc');
        async.elapse(const Duration(milliseconds: 300));

        // The base filter is not merged in — combining it with the search text
        // would let it skew the debounce policy and contradict the search.
        expect(
          usedFilter,
          Filter.or([Filter.autoComplete('name', 'abc'), Filter.autoComplete('id', 'abc')]),
        );
      });
    });

    test('a blank query restores the base filter', () {
      final filters = <Filter?>[];
      when(
        () => client.queryUsers(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          presence: any(named: 'presence'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((invocation) async {
        filters.add(invocation.namedArguments[#filter] as Filter?);
        return usersResponse([]);
      });

      final baseFilter = Filter.notEqual('id', 'me');

      fakeAsync((async) {
        final controller = StreamUserListController(client: client, filter: baseFilter);
        addTearDown(controller.dispose);

        controller.search('abc');
        async.elapse(const Duration(milliseconds: 300));

        // Clearing the field restores the scope the controller was built with.
        controller.search('');
        async.elapse(const Duration(milliseconds: 500));

        expect(filters.last, baseFilter);
      });
    });

    test('doInitialLoad does not query while a search is pending', () {
      var queryCount = 0;
      when(
        () => client.queryUsers(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          presence: any(named: 'presence'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((_) async {
        queryCount += 1;
        return usersResponse([]);
      });

      fakeAsync((async) {
        final controller = StreamUserListController(client: client);
        addTearDown(controller.dispose);

        controller.search('a');
        // An immediate load (e.g. a list view mounting) must not fire its own
        // request while the debounced search is scheduled.
        unawaited(controller.doInitialLoad());
        async.flushMicrotasks();
        expect(queryCount, 0);

        // Once the debounce elapses, exactly one query fires.
        async.elapse(const Duration(milliseconds: 500));
        expect(queryCount, 1);
      });
    });

    test('coalesces rapid searches into a single debounced query', () {
      var queryCount = 0;
      Filter? lastFilter;
      when(
        () => client.queryUsers(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          presence: any(named: 'presence'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((invocation) async {
        queryCount += 1;
        lastFilter = invocation.namedArguments[#filter] as Filter?;
        return usersResponse([]);
      });

      fakeAsync((async) {
        final controller = StreamUserListController(client: client);
        addTearDown(controller.dispose);

        // Rapid keystrokes, each well within the debounce window.
        controller.search('a');
        async.elapse(const Duration(milliseconds: 50));
        controller.search('ab');
        async.elapse(const Duration(milliseconds: 50));
        controller.search('abc');

        // The three calls coalesce into a single query for the latest term.
        async.elapse(const Duration(milliseconds: 300));
        expect(queryCount, 1);
        expect(
          lastFilter,
          Filter.or([Filter.autoComplete('name', 'abc'), Filter.autoComplete('id', 'abc')]),
        );

        // No superseded query fires after the coalesced one.
        async.elapse(const Duration(seconds: 1));
        expect(queryCount, 1);
      });
    });
  });

  group('searchWithFilter', () {
    test('debounces a filter that carries search text', () {
      Filter? usedFilter;
      when(
        () => client.queryUsers(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          presence: any(named: 'presence'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((invocation) async {
        usedFilter ??= invocation.namedArguments[#filter] as Filter?;
        return usersResponse([]);
      });

      fakeAsync((async) {
        final controller = StreamUserListController(client: client);
        addTearDown(controller.dispose);

        final filter = Filter.and([
          Filter.autoComplete('name', 'jo'),
          Filter.notEqual('id', 'me'),
        ]);
        controller.searchWithFilter(filter);

        // The filter's search text is 2 chars, so the 500ms delay applies.
        async.elapse(const Duration(milliseconds: 499));
        expect(usedFilter, isNull);

        async.elapse(const Duration(milliseconds: 1));
        expect(usedFilter, filter);
      });
    });

    test('runs a filter with no search text immediately', () {
      var queryCount = 0;
      when(
        () => client.queryUsers(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          presence: any(named: 'presence'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((_) async {
        queryCount += 1;
        return usersResponse([]);
      });

      fakeAsync((async) {
        final controller = StreamUserListController(client: client);
        addTearDown(controller.dispose);

        // A non-text filter must not wait for any debounce delay.
        controller.searchWithFilter(Filter.equal('id', 'user-1'));

        async.flushMicrotasks();
        expect(queryCount, 1);
      });
    });
  });

  group('superseded results', () {
    test('a slower earlier load does not overwrite a newer load', () async {
      final responses = <Completer<QueryUsersResponse>>[
        Completer<QueryUsersResponse>(),
        Completer<QueryUsersResponse>(),
      ];
      var call = 0;
      when(
        () => client.queryUsers(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          presence: any(named: 'presence'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((_) => responses[call++].future);

      final controller = StreamUserListController(client: client);
      addTearDown(controller.dispose);

      final earlier = controller.doInitialLoad();
      final newer = controller.doInitialLoad();

      responses[1].complete(usersResponse([User(id: 'newer')]));
      await newer;
      responses[0].complete(usersResponse([User(id: 'earlier')]));
      await earlier;

      expect(controller.value.asSuccess.items.single.id, 'newer');
    });

    test('a superseded load error does not overwrite a newer load', () async {
      final responses = <Completer<QueryUsersResponse>>[
        Completer<QueryUsersResponse>(),
        Completer<QueryUsersResponse>(),
      ];
      var call = 0;
      when(
        () => client.queryUsers(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          presence: any(named: 'presence'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((_) => responses[call++].future);

      final controller = StreamUserListController(client: client);
      addTearDown(controller.dispose);

      final earlier = controller.doInitialLoad();
      final newer = controller.doInitialLoad();

      responses[1].complete(usersResponse([User(id: 'newer')]));
      await newer;
      responses[0].completeError(Exception('stale failure'));
      await earlier;

      expect(controller.value.isSuccess, isTrue);
      expect(controller.value.asSuccess.items.single.id, 'newer');
    });

    test('a loadMore superseded by clearResults does not repopulate', () async {
      final page = Completer<QueryUsersResponse>();
      when(
        () => client.queryUsers(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          presence: any(named: 'presence'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((_) => page.future);

      final controller = StreamUserListController.fromValue(
        PagedValue<int, User>(items: [User(id: 'page-1')], nextPageKey: 1),
        client: client,
      );
      addTearDown(controller.dispose);

      final more = controller.loadMore(1);
      controller.clearResults();
      // The page arrives after the search was cleared; it must be dropped.
      page.complete(usersResponse([User(id: 'page-2')]));
      await more;

      expect(controller.value.asSuccess.items, isEmpty);
    });

    test('a search invalidates a load already in flight', () {
      fakeAsync((async) {
        // Created inside the zone: a Completer built outside it schedules its
        // completion on the real microtask queue, which async cannot drain.
        final responses = <Completer<QueryUsersResponse>>[
          Completer<QueryUsersResponse>(),
          Completer<QueryUsersResponse>(),
        ];
        var call = 0;
        when(
          () => client.queryUsers(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            presence: any(named: 'presence'),
            pagination: any(named: 'pagination'),
          ),
        ).thenAnswer((_) => responses[call++].future);

        final controller = StreamUserListController(client: client);
        addTearDown(controller.dispose);

        // Request A is issued and left in flight.
        unawaited(controller.doInitialLoad());
        // A new search is scheduled while A is still in flight; it must
        // supersede A so its response can no longer be applied.
        controller.search('abc');

        // A completes during the new search's debounce window; its result is
        // dropped rather than briefly shown.
        responses[0].complete(usersResponse([User(id: 'stale')]));
        async.flushMicrotasks();
        expect(controller.value.isSuccess, isFalse);

        // The debounced search then fires and applies its own result.
        async.elapse(const Duration(milliseconds: 300));
        responses[1].complete(usersResponse([User(id: 'fresh')]));
        async.flushMicrotasks();
        expect(controller.value.asSuccess.items.single.id, 'fresh');
      });
    });
  });

  group('clearResults', () {
    test('cancels a pending debounced search', () {
      var queried = false;
      when(
        () => client.queryUsers(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          presence: any(named: 'presence'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((_) async {
        queried = true;
        return usersResponse([]);
      });

      fakeAsync((async) {
        final controller = StreamUserListController(client: client)
          ..search('ab')
          ..clearResults();
        addTearDown(controller.dispose);

        // Well past the longest debounce delay, proving the cancelled search
        // never fires.
        async.elapse(const Duration(seconds: 1));
        expect(queried, isFalse);
      });
    });

    test('drops an in-flight load and resets the results', () async {
      final response = Completer<QueryUsersResponse>();
      when(
        () => client.queryUsers(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          presence: any(named: 'presence'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((_) => response.future);

      final controller = StreamUserListController(client: client);
      addTearDown(controller.dispose);

      final load = controller.doInitialLoad();
      controller.clearResults();
      // A late response for the cleared load must not repopulate the results.
      response.complete(usersResponse([User(id: 'stale')]));
      await load;

      expect(controller.value.asSuccess.items, isEmpty);
    });

    test('a following search shows a loading state, not the cleared list', () {
      fakeAsync((async) {
        final controller = StreamUserListController(client: client);
        addTearDown(controller.dispose);

        controller.clearResults();
        expect(controller.value.asSuccess.items, isEmpty);

        // Starting a search moves to a loading state rather than leaving the
        // cleared empty list on screen (which would render as "no results").
        controller.search('abc');
        expect(controller.value.isSuccess, isFalse);
      });
    });
  });
}
