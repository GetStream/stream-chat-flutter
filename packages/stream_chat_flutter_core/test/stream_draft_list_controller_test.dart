// ignore_for_file: avoid_redundant_argument_values

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart' hide Success;
import 'package:stream_chat_flutter_core/src/paged_value_notifier.dart';
import 'package:stream_chat_flutter_core/src/stream_draft_list_controller.dart';

import 'mocks.dart';

Draft generateDraft({
  String? channelCid,
  String? text,
  String? parentId,
  DateTime? createdAt,
}) {
  return Draft(
    channelCid: channelCid ?? 'messaging:123',
    createdAt: createdAt ?? DateTime.now(),
    message: DraftMessage(
      text: text ?? 'Test draft message',
    ),
    parentId: parentId,
  );
}

List<Draft> generateDrafts({
  int count = 2,
  List<String>? texts,
  int? startId,
  bool withThreads = false,
}) {
  final now = DateTime.now();
  final baseId = startId ?? 123;

  return List.generate(count, (index) {
    final text = texts != null && index < texts.length ? texts[index] : 'Draft ${index + 1}';

    return generateDraft(
      channelCid: 'messaging:${baseId + index}',
      text: text,
      createdAt: now.subtract(Duration(minutes: index)),
      parentId: withThreads && index.isOdd ? 'parent${index ~/ 2}' : null,
    );
  });
}

void main() {
  final client = MockClient();

  setUp(() {
    when(client.on).thenAnswer((_) => const Stream.empty());
  });

  tearDown(() {
    reset(client);
  });

  group('Initialization', () {
    test('should start in loading state when created with client', () {
      final controller = StreamDraftListController(client: client);
      expect(controller.value, isA<Loading>());
    });

    test('should preserve provided value when created with fromValue', () {
      final drafts = generateDrafts();
      final value = PagedValue<String, Draft>(items: drafts);
      final controller = StreamDraftListController.fromValue(
        value,
        client: client,
      );

      expect(controller.value, same(value));
      expect(controller.value.asSuccess.items, equals(drafts));
    });
  });

  group('Initial loading', () {
    test('successfully loads drafts from API', () async {
      final drafts = generateDrafts();
      final response = QueryDraftsResponse()
        ..drafts = drafts
        ..next = '';

      when(
        () => client.queryDrafts(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((_) async => response);

      final controller = StreamDraftListController(client: client);

      await controller.doInitialLoad();
      await pumpEventQueue();

      verify(
        () => client.queryDrafts(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).called(1);

      expect(controller.value, isA<Success<String, Draft>>());
      expect(controller.value.asSuccess.items, equals(drafts));
    });

    test('handles API exceptions by transitioning to error state', () async {
      final exception = Exception('API unavailable');
      when(
        () => client.queryDrafts(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenThrow(exception);

      final controller = StreamDraftListController(client: client);

      await controller.doInitialLoad();
      await pumpEventQueue();

      expect(controller.value, isA<Error>());
      expect(
        (controller.value as Error).error.message,
        contains('API unavailable'),
      );
    });
  });

  group('Pagination', () {
    test('loadMore appends new drafts to existing items', () async {
      const nextKey = 'next_page_token';
      final existingDrafts = generateDrafts();
      final additionalDrafts = generateDrafts(
        count: 1,
        startId: 789,
        texts: ['Draft 3'],
      );

      final response = QueryDraftsResponse()
        ..drafts = additionalDrafts
        ..next = '';

      when(
        () => client.queryDrafts(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((_) async => response);

      final controller = StreamDraftListController.fromValue(
        PagedValue<String, Draft>(
          items: existingDrafts,
          nextPageKey: nextKey,
        ),
        client: client,
      );

      await controller.loadMore(nextKey);
      await pumpEventQueue();

      // We need to verify that all the drafts are there, but not necessarily in
      // the same order since the controller might sort them differently
      final mergedDrafts = [...existingDrafts, ...additionalDrafts];

      // Verify all drafts are present by checking the number and content
      expect(
        controller.value.asSuccess.items.length,
        equals(mergedDrafts.length),
      );

      for (final draft in mergedDrafts) {
        expect(
          controller.value.asSuccess.items.any(
            (d) => d.channelCid == draft.channelCid && d.message.text == draft.message.text,
          ),
          isTrue,
        );
      }

      expect(controller.value.asSuccess.nextPageKey, isNull);
    });

    test('loadMore preserves existing items when API throws exception', () async {
      const nextKey = 'next_page_token';
      final existingDrafts = generateDrafts();
      final exception = Exception('Network error');

      when(
        () => client.queryDrafts(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenThrow(exception);

      final controller = StreamDraftListController.fromValue(
        PagedValue<String, Draft>(
          items: existingDrafts,
          nextPageKey: nextKey,
        ),
        client: client,
      );

      await controller.loadMore(nextKey);
      await pumpEventQueue();

      expect(controller.value.isSuccess, isTrue);
      expect(controller.value.asSuccess.items, equals(existingDrafts));
      expect(controller.value.asSuccess.error, isNotNull);
      expect(
        controller.value.asSuccess.error!.message,
        contains('Network error'),
      );
    });
  });

  group('Draft CRUD operations', () {
    test('updateDraft replaces existing draft with same predicate', () {
      final drafts = generateDrafts(texts: ['Draft 1', 'Draft 2']);
      final controller = StreamDraftListController.fromValue(
        PagedValue<String, Draft>(items: drafts),
        client: client,
      );

      final updatedDraft = drafts[0].copyWith(
        message: DraftMessage(
          text: 'Updated Draft 1',
        ),
      );

      final result = controller.updateDraft(updatedDraft);

      expect(result, isTrue);
      expect(
        controller.value.asSuccess.items.first.message.text,
        equals('Updated Draft 1'),
      );
      expect(controller.value.asSuccess.items.length, equals(drafts.length));
    });

    test('updateDraft adds draft when no matching draft exists', () {
      final drafts = generateDrafts();
      final controller = StreamDraftListController.fromValue(
        PagedValue<String, Draft>(items: drafts),
        client: client,
      );

      final newDraft = generateDraft(
        channelCid: 'messaging:789',
        text: 'New Draft',
      );

      final result = controller.updateDraft(newDraft);

      expect(result, isTrue);

      expect(
        controller.value.asSuccess.items.length,
        equals(drafts.length + 1),
      );

      expect(
        controller.value.asSuccess.items.any(
          (d) => d.message.text == 'New Draft',
        ),
        isTrue,
      );
    });

    test('deleteDraft removes draft and returns true when draft exists', () {
      final drafts = generateDrafts();
      final controller = StreamDraftListController.fromValue(
        PagedValue<String, Draft>(items: drafts),
        client: client,
      );

      final result = controller.deleteDraft(drafts[0]);

      expect(result, isTrue);
      expect(
        controller.value.asSuccess.items.length,
        equals(drafts.length - 1),
      );
      expect(controller.value.asSuccess.items.contains(drafts[0]), isFalse);
    });

    test('deleteDraft returns false when draft does not exist', () {
      final drafts = generateDrafts();
      final controller = StreamDraftListController.fromValue(
        PagedValue<String, Draft>(items: drafts),
        client: client,
      );

      final nonExistentDraft = generateDraft(
        channelCid: 'messaging:999',
        text: 'Non-existent Draft',
      );

      final result = controller.deleteDraft(nonExistentDraft);

      expect(result, isFalse);
      expect(controller.value.asSuccess.items.length, equals(drafts.length));
    });

    test('deleteDraft correctly handles drafts with parentId', () {
      final threadDraft1 = generateDraft(
        channelCid: 'messaging:thread',
        text: 'Thread Draft 1',
        parentId: 'parent1',
      );

      final threadDraft2 = generateDraft(
        channelCid: 'messaging:thread',
        text: 'Thread Draft 2',
        parentId: 'parent2',
      );

      final regularDrafts = generateDrafts();
      final allDrafts = [...regularDrafts, threadDraft1, threadDraft2];

      final controller = StreamDraftListController.fromValue(
        PagedValue<String, Draft>(items: allDrafts),
        client: client,
      );

      final result = controller.deleteDraft(threadDraft1);

      expect(result, isTrue);
      expect(
        controller.value.asSuccess.items.length,
        equals(allDrafts.length - 1),
      );

      final remainingDraftTexts = [...controller.value.asSuccess.items.map((d) => d.message.text)];

      expect(remainingDraftTexts, contains('Thread Draft 2'));
      expect(remainingDraftTexts, isNot(contains('Thread Draft 1')));
    });
  });

  group('Order preservation', () {
    test('controller preserves explicit draft order', () {
      final draftA = generateDraft(
        channelCid: 'messaging:A',
        text: 'Draft A',
      );

      final draftB = generateDraft(
        channelCid: 'messaging:B',
        text: 'Draft B',
      );

      final abOrder = [draftA, draftB];
      final controllerAB = StreamDraftListController.fromValue(
        PagedValue<String, Draft>(items: abOrder),
        client: client,
      );

      final baOrder = [draftB, draftA];
      final controllerBA = StreamDraftListController.fromValue(
        PagedValue<String, Draft>(items: baOrder),
        client: client,
      );

      expect(
        controllerAB.value.asSuccess.items.first.message.text,
        equals('Draft A'),
      );
      expect(
        controllerBA.value.asSuccess.items.first.message.text,
        equals('Draft B'),
      );
    });
  });

  group('Event handling', () {
    late StreamController<Event> eventController;

    setUp(() {
      eventController = StreamController<Event>.broadcast();
      when(client.on).thenAnswer((_) => eventController.stream);
    });

    tearDown(() {
      eventController.close();
    });

    test('draft_updated event triggers draft update', () async {
      final drafts = generateDrafts();
      final queryResponse = QueryDraftsResponse()
        ..drafts = drafts
        ..next = '';

      when(
        () => client.queryDrafts(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((_) async => queryResponse);

      final controller = StreamDraftListController.fromValue(
        PagedValue<String, Draft>(items: drafts),
        client: client,
      );

      await controller.doInitialLoad();
      await pumpEventQueue();

      final updatedDraft = drafts[0].copyWith(
        message: DraftMessage(text: 'Updated via event'),
      );

      final event = Event(
        type: EventType.draftUpdated,
        draft: updatedDraft,
      );

      eventController.add(event);
      await pumpEventQueue();

      final hasUpdatedDraft = controller.value.asSuccess.items.any(
        (draft) => draft.message.text == 'Updated via event',
      );

      expect(hasUpdatedDraft, isTrue);
    });

    test('draft_deleted event triggers draft removal', () async {
      final drafts = generateDrafts();
      final queryResponse = QueryDraftsResponse()
        ..drafts = drafts
        ..next = '';

      when(
        () => client.queryDrafts(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((_) async => queryResponse);

      final controller = StreamDraftListController.fromValue(
        PagedValue<String, Draft>(items: drafts),
        client: client,
      );

      await controller.doInitialLoad();
      await pumpEventQueue();

      final initialItemCount = controller.value.asSuccess.items.length;

      final event = Event(
        type: EventType.draftDeleted,
        draft: drafts[0],
      );

      eventController.add(event);
      await pumpEventQueue();

      expect(
        controller.value.asSuccess.items.length,
        equals(initialItemCount - 1),
      );

      expect(
        controller.value.asSuccess.items.any(
          (d) => d.channelCid == drafts[0].channelCid,
        ),
        isFalse,
      );
    });

    test('connection_recovered event triggers refresh', () async {
      final drafts = generateDrafts();
      var queryCallCount = 0;

      when(
        () => client.queryDrafts(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((_) async {
        queryCallCount++;
        return QueryDraftsResponse()
          ..drafts = drafts
          ..next = '';
      });

      final controller = StreamDraftListController.fromValue(
        PagedValue<String, Draft>(items: drafts),
        client: client,
      );

      await controller.doInitialLoad();
      await pumpEventQueue();

      // Reset the counter after initial load
      queryCallCount = 0;

      // When connection recovered is triggered, verify another query is made
      final event = Event(type: EventType.connectionRecovered);
      eventController.add(event);

      // Give it enough time for the async operations to complete
      await pumpEventQueue(times: 10);

      // The controller should re-query during refresh
      expect(queryCallCount, equals(1));
    });

    test('custom event listener can prevent default handling', () async {
      final drafts = generateDrafts();
      final queryResponse = QueryDraftsResponse()
        ..drafts = drafts
        ..next = '';

      when(
        () => client.queryDrafts(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((_) async => queryResponse);

      final controller = StreamDraftListController.fromValue(
        PagedValue<String, Draft>(items: drafts),
        client: client,
      );

      await controller.doInitialLoad();
      await pumpEventQueue();

      final initialItems = List.of(controller.value.asSuccess.items);

      var listenerCalled = false;
      controller.eventListener = (event) {
        listenerCalled = true;
        return true;
      };

      final updatedDraft = drafts[0].copyWith(
        message: DraftMessage(
          text: 'Should not update',
        ),
      );

      final event = Event(
        type: EventType.draftUpdated,
        draft: updatedDraft,
      );

      eventController.add(event);
      await pumpEventQueue();

      expect(listenerCalled, isTrue);
      expect(controller.value.asSuccess.items, equals(initialItems));
      expect(
        controller.value.asSuccess.items.any(
          (d) => d.message.text == 'Should not update',
        ),
        isFalse,
      );
    });
  });

  group('Subscription lifecycle', () {
    test('pause and resume correctly affect event subscription', () async {
      final drafts = generateDrafts();
      final eventController = StreamController<Event>.broadcast();
      when(client.on).thenAnswer((_) => eventController.stream);

      final response = QueryDraftsResponse()
        ..drafts = drafts
        ..next = '';

      when(
        () => client.queryDrafts(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((_) async => response);

      final controller = StreamDraftListController.fromValue(
        PagedValue<String, Draft>(items: drafts),
        client: client,
      );

      await controller.doInitialLoad();
      await pumpEventQueue();

      controller
        ..pauseEventsSubscription()
        ..resumeEventsSubscription();

      eventController.close();
    });
  });

  group('Filtering and sorting', () {
    test('refresh resets filter and sort to initial values', () async {
      final drafts = generateDrafts();
      final initialFilter = Filter.equal('type', 'messaging');
      const initialSort = [SortOption<Draft>.desc(DraftSortKey.createdAt)];

      final apiCalls = <Map<String, dynamic>>[];

      when(
        () => client.queryDrafts(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((invocation) async {
        apiCalls.add({
          'filter': invocation.namedArguments[const Symbol('filter')],
          'sort': invocation.namedArguments[const Symbol('sort')],
        });
        return QueryDraftsResponse()
          ..drafts = drafts
          ..next = '';
      });

      final controller = StreamDraftListController(
        client: client,
        filter: initialFilter,
        sort: initialSort,
      );

      await controller.doInitialLoad();
      await pumpEventQueue();

      controller
        ..filter = Filter.equal('type', 'team')
        ..sort = const [SortOption<Draft>.asc(DraftSortKey.createdAt)];

      await controller.refresh();
      await pumpEventQueue();

      expect(apiCalls.length, equals(2));

      final refreshCall = apiCalls.last;
      expect(refreshCall['filter'], equals(initialFilter));
      expect(refreshCall['sort'], equals(initialSort));
    });

    test(
      'refresh with resetValue=false preserves current filter and sort',
      () async {
        final drafts = generateDrafts();
        final initialFilter = Filter.equal('type', 'messaging');
        const initialSort = [SortOption<Draft>.desc(DraftSortKey.createdAt)];
        final newFilter = Filter.equal('type', 'team');
        const newSort = [SortOption<Draft>.asc(DraftSortKey.createdAt)];

        final apiCalls = <Map<String, dynamic>>[];

        when(
          () => client.queryDrafts(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            pagination: any(named: 'pagination'),
          ),
        ).thenAnswer((invocation) {
          apiCalls.add({
            'filter': invocation.namedArguments[const Symbol('filter')],
            'sort': invocation.namedArguments[const Symbol('sort')],
          });
          return Future.value(
            QueryDraftsResponse()
              ..drafts = drafts
              ..next = '',
          );
        });

        final controller = StreamDraftListController(
          client: client,
          filter: initialFilter,
          sort: initialSort,
        );

        await controller.doInitialLoad();
        await pumpEventQueue();

        controller
          ..filter = newFilter
          ..sort = newSort;

        await controller.refresh(resetValue: false);
        await pumpEventQueue();

        expect(apiCalls.length, equals(2));

        final refreshCall = apiCalls.last;
        expect(refreshCall['filter'], equals(newFilter));
        expect(refreshCall['sort'], equals(newSort));
      },
    );
  });

  group('Disposal', () {
    test('dispose cancels subscriptions without errors', () {
      final controller = StreamDraftListController(client: client)..doInitialLoad();

      expect(controller.dispose, returnsNormally);
    });
  });
}
