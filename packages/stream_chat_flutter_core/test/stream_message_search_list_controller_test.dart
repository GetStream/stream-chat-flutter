import 'dart:async';

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
    test('queries messages with the typed query after debouncing', () async {
      final usedQuery = Completer<String?>();
      when(
        () => client.search(
          any(),
          sort: any(named: 'sort'),
          query: any(named: 'query'),
          messageFilters: any(named: 'messageFilters'),
          paginationParams: any(named: 'paginationParams'),
        ),
      ).thenAnswer((invocation) async {
        final query = invocation.namedArguments[#query] as String?;
        if (!usedQuery.isCompleted) usedQuery.complete(query);
        return searchResponse();
      });

      final controller = buildController();
      addTearDown(controller.dispose);

      controller.search('abc');

      // Waits for the debounced query to fire rather than a fixed timeout.
      expect(await usedQuery.future, 'abc');
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
