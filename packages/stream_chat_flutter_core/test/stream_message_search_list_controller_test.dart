import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart' hide Success;
import 'package:stream_chat_flutter_core/src/stream_message_search_list_controller.dart';

import 'mocks.dart';

void main() {
  final client = MockClient();

  setUpAll(() {
    registerFallbackValue(Filter.equal('cid', 'messaging:123'));
  });

  tearDown(() {
    reset(client);
  });

  SearchMessagesResponse searchResponse({String? next}) {
    return SearchMessagesResponse()
      ..results = []
      ..next = next;
  }

  StreamMessageSearchListController buildController() {
    return StreamMessageSearchListController(
      client: client,
      filter: Filter.in_('members', const ['user-id']),
      searchQuery: '',
    );
  }

  group('search', () {
    test('queries messages with an autocomplete filter after debouncing', () {
      Filter? usedFilter;
      when(
        () => client.search(
          any(),
          sort: any(named: 'sort'),
          query: any(named: 'query'),
          messageFilters: any(named: 'messageFilters'),
          paginationParams: any(named: 'paginationParams'),
        ),
      ).thenAnswer((invocation) async {
        usedFilter ??= invocation.namedArguments[#messageFilters] as Filter?;
        return searchResponse();
      });

      fakeAsync((async) {
        final controller = buildController();
        addTearDown(controller.dispose);

        controller.search('abc');

        // 'abc' is longer than a short query, so the 300ms delay applies.
        async.elapse(const Duration(milliseconds: 299));
        expect(usedFilter, isNull);

        async.elapse(const Duration(milliseconds: 1));
        expect(usedFilter, Filter.autoComplete('text', 'abc'));
      });
    });

    test('a blank query clears results without querying', () {
      var queried = false;
      when(
        () => client.search(
          any(),
          sort: any(named: 'sort'),
          query: any(named: 'query'),
          messageFilters: any(named: 'messageFilters'),
          paginationParams: any(named: 'paginationParams'),
        ),
      ).thenAnswer((_) async {
        queried = true;
        return searchResponse();
      });

      fakeAsync((async) {
        final controller = buildController();
        addTearDown(controller.dispose);

        controller.search('   ');

        // Well past the longest debounce delay, proving nothing was scheduled.
        async.elapse(const Duration(seconds: 1));
        expect(queried, isFalse);
        expect(controller.value.asSuccess.items, isEmpty);
      });
    });
  });

  group('superseded results', () {
    test('a slower earlier load does not overwrite a newer load', () async {
      final responses = <Completer<SearchMessagesResponse>>[
        Completer<SearchMessagesResponse>(),
        Completer<SearchMessagesResponse>(),
      ];
      var call = 0;
      when(
        () => client.search(
          any(),
          sort: any(named: 'sort'),
          query: any(named: 'query'),
          messageFilters: any(named: 'messageFilters'),
          paginationParams: any(named: 'paginationParams'),
        ),
      ).thenAnswer((_) => responses[call++].future);

      final controller = buildController();
      addTearDown(controller.dispose);

      final earlier = controller.doInitialLoad();
      final newer = controller.doInitialLoad();

      responses[1].complete(searchResponse(next: 'newer'));
      await newer;
      responses[0].complete(searchResponse(next: 'earlier'));
      await earlier;

      expect(controller.value.asSuccess.nextPageKey, 'newer');
    });
  });
}
