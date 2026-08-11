import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart' hide Success;
import 'package:stream_chat_flutter_core/src/paged_value_notifier.dart';
import 'package:stream_chat_flutter_core/src/search_debouncer.dart';
import 'package:stream_chat_flutter_core/src/stream_user_list_controller.dart';

import 'mocks.dart';

void main() {
  final client = MockClient();

  setUp(() {
    // Run searches without waiting out the real debounce delays; the delays
    // themselves are covered in search_debouncer_test.dart.
    SearchDebouncer.debugPolicyOverride = const SearchDebouncePolicy.constant(Duration.zero);
  });

  tearDown(() {
    SearchDebouncer.debugPolicyOverride = null;
    reset(client);
  });

  QueryUsersResponse usersResponse(List<User> users) {
    return QueryUsersResponse()..users = users;
  }

  group('search', () {
    test('queries users with the provided filter after debouncing', () async {
      final usedFilter = Completer<Filter?>();
      when(
        () => client.queryUsers(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          presence: any(named: 'presence'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((invocation) async {
        final filter = invocation.namedArguments[#filter] as Filter?;
        if (!usedFilter.isCompleted) usedFilter.complete(filter);
        return usersResponse([User(id: 'user-1')]);
      });

      final controller = StreamUserListController(client: client);
      addTearDown(controller.dispose);

      controller.search('abc');

      // Waits for the debounced query to fire rather than a fixed timeout.
      expect(
        await usedFilter.future,
        Filter.or([Filter.autoComplete('name', 'abc'), Filter.autoComplete('id', 'abc')]),
      );
    });

    test('doInitialLoad does not query while a search is pending', () async {
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

      final controller = StreamUserListController(client: client);
      addTearDown(controller.dispose);

      controller.search('a');
      // An immediate load (e.g. a list view mounting) must not fire its own
      // request while the debounced search is scheduled.
      await controller.doInitialLoad();
      expect(queryCount, 0);

      // Once the debounce elapses, exactly one query fires.
      await pumpEventQueue();
      expect(queryCount, 1);
    });

    test('coalesces rapid searches into a single debounced query', () async {
      var queryCount = 0;
      Filter? lastFilter;
      final fired = Completer<void>();
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
        if (!fired.isCompleted) fired.complete();
        return usersResponse([]);
      });

      final controller = StreamUserListController(client: client);
      addTearDown(controller.dispose);

      // Rapid keystrokes, all issued before the debounce elapses.
      controller
        ..search('a')
        ..search('ab')
        ..search('abc');

      // The three calls coalesce into a single query for the latest term.
      await fired.future;
      expect(queryCount, 1);
      expect(
        lastFilter,
        Filter.or([Filter.autoComplete('name', 'abc'), Filter.autoComplete('id', 'abc')]),
      );

      // Pump the event queue to prove no superseded query fires afterwards.
      await pumpEventQueue();
      expect(queryCount, 1);
    });
  });

  group('searchWithFilter', () {
    test('debounces a filter that carries search text', () async {
      final usedFilter = Completer<Filter?>();
      when(
        () => client.queryUsers(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          presence: any(named: 'presence'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((invocation) async {
        final filter = invocation.namedArguments[#filter] as Filter?;
        if (!usedFilter.isCompleted) usedFilter.complete(filter);
        return usersResponse([]);
      });

      final controller = StreamUserListController(client: client);
      addTearDown(controller.dispose);

      final filter = Filter.and([
        Filter.autoComplete('name', 'jo'),
        Filter.notEqual('id', 'me'),
      ]);
      controller.searchWithFilter(filter);

      expect(await usedFilter.future, filter);
    });

    test('runs a filter with no search text immediately', () async {
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

      // A delay long enough that any debounced search would still be pending,
      // so an immediate query is the only way this can pass.
      SearchDebouncer.debugPolicyOverride = const SearchDebouncePolicy.constant(Duration(minutes: 1));

      final controller = StreamUserListController(client: client);
      addTearDown(controller.dispose);

      controller.searchWithFilter(Filter.equal('id', 'user-1'));
      await pumpEventQueue();

      expect(queryCount, 1);
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

    test('a search invalidates a load already in flight', () async {
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
      final inFlight = controller.doInitialLoad();
      // A new search is scheduled while A is still in flight; it must
      // supersede A so its response can no longer be applied.
      controller.search('abc');

      // A completes during the new search's debounce window; its result is
      // dropped rather than briefly shown.
      responses[0].complete(usersResponse([User(id: 'stale')]));
      await inFlight;
      expect(controller.value.isSuccess, isFalse);

      // The debounced search then fires and applies its own result.
      responses[1].complete(usersResponse([User(id: 'fresh')]));
      await pumpEventQueue();
      expect(controller.value.asSuccess.items.single.id, 'fresh');
    });
  });

  group('clearResults', () {
    test('cancels a pending debounced search', () async {
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

      final controller = StreamUserListController(client: client)
        ..search('ab')
        ..clearResults();
      addTearDown(controller.dispose);

      // Pump the event queue to prove the cancelled search never fires.
      await pumpEventQueue();
      expect(queried, isFalse);
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
}
