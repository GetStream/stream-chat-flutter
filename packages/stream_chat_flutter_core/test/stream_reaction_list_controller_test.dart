// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart' hide Success;
import 'package:stream_chat_flutter_core/src/paged_value_notifier.dart';
import 'package:stream_chat_flutter_core/src/stream_reaction_list_controller.dart';

import 'mocks.dart';

Reaction generateReaction({
  String? messageId,
  String? type,
  String? userId,
  DateTime? createdAt,
}) {
  return Reaction(
    messageId: messageId ?? 'message_123',
    type: type ?? 'like',
    userId: userId ?? 'user_123',
    createdAt: createdAt ?? DateTime.now(),
  );
}

List<Reaction> generateReactions({
  int count = 2,
  String? messageId,
  List<String>? types,
  List<String>? userIds,
  int? startId,
}) {
  final now = DateTime.now();
  final baseId = startId ?? 1;

  return List.generate(count, (index) {
    final type = types != null && index < types.length ? types[index] : 'like';
    final userId = userIds != null && index < userIds.length ? userIds[index] : 'user_${baseId + index}';

    return generateReaction(
      messageId: messageId ?? 'message_123',
      type: type,
      userId: userId,
      createdAt: now.subtract(Duration(minutes: index)),
    );
  });
}

void main() {
  const messageId = 'message_123';

  final client = MockClient();

  setUpAll(() {
    registerFallbackValue(const PaginationParams());
    registerFallbackValue(Filter.equal('type', 'like'));
  });

  setUp(() {
    when(client.on).thenAnswer((_) => const Stream.empty());
  });

  tearDown(() {
    reset(client);
  });

  group('Initialization', () {
    test('should start in loading state when created with client', () {
      final controller = StreamReactionListController(
        client: client,
        messageId: messageId,
      );
      expect(controller.value, isA<Loading>());
    });

    test('should preserve provided value when created with fromValue', () {
      final reactions = generateReactions();
      final value = PagedValue<String?, Reaction>(items: reactions);
      final controller = StreamReactionListController.fromValue(
        value,
        client: client,
        messageId: messageId,
      );

      expect(controller.value, same(value));
      expect(controller.value.asSuccess.items, equals(reactions));
    });
  });

  group('Initial loading', () {
    test('successfully loads reactions from API', () async {
      final reactions = generateReactions();
      final response = QueryReactionsResponse()
        ..reactions = reactions
        ..next = null;

      when(
        () => client.queryReactions(
          any(),
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((_) async => response);

      final controller = StreamReactionListController(
        client: client,
        messageId: messageId,
      );

      await controller.doInitialLoad();
      await pumpEventQueue();

      verify(
        () => client.queryReactions(
          messageId,
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).called(1);

      expect(controller.value, isA<Success<String?, Reaction>>());
      expect(controller.value.asSuccess.items, equals(reactions));
    });

    test('sets next page key when API returns next cursor', () async {
      const nextCursor = 'next_cursor_token';
      final reactions = generateReactions();
      final response = QueryReactionsResponse()
        ..reactions = reactions
        ..next = nextCursor;

      when(
        () => client.queryReactions(
          any(),
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((_) async => response);

      final controller = StreamReactionListController(
        client: client,
        messageId: messageId,
      );

      await controller.doInitialLoad();
      await pumpEventQueue();

      expect(controller.value.asSuccess.nextPageKey, equals(nextCursor));
    });

    test('sets null next page key when API returns empty next cursor', () async {
      final reactions = generateReactions();
      final response = QueryReactionsResponse()
        ..reactions = reactions
        ..next = '';

      when(
        () => client.queryReactions(
          any(),
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((_) async => response);

      final controller = StreamReactionListController(
        client: client,
        messageId: messageId,
      );

      await controller.doInitialLoad();
      await pumpEventQueue();

      expect(controller.value.asSuccess.nextPageKey, isNull);
    });

    test('handles StreamChatError by transitioning to error state', () async {
      const chatError = StreamChatError('Network error');

      when(
        () => client.queryReactions(
          any(),
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenThrow(chatError);

      final controller = StreamReactionListController(
        client: client,
        messageId: messageId,
      );

      await controller.doInitialLoad();
      await pumpEventQueue();

      expect(controller.value, isA<Error>());
      expect((controller.value as Error).error, equals(chatError));
    });

    test('wraps generic exceptions in StreamChatError', () async {
      final exception = Exception('API unavailable');

      when(
        () => client.queryReactions(
          any(),
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenThrow(exception);

      final controller = StreamReactionListController(
        client: client,
        messageId: messageId,
      );

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
    test('loadMore appends new reactions to existing items', () async {
      const nextKey = 'next_page_token';
      final existingReactions = generateReactions();
      final additionalReactions = generateReactions(
        count: 1,
        userIds: ['user_999'],
        startId: 999,
      );

      final response = QueryReactionsResponse()
        ..reactions = additionalReactions
        ..next = null;

      when(
        () => client.queryReactions(
          any(),
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((_) async => response);

      final controller = StreamReactionListController.fromValue(
        PagedValue<String?, Reaction>(
          items: existingReactions,
          nextPageKey: nextKey,
        ),
        client: client,
        messageId: messageId,
      );

      await controller.loadMore(nextKey);
      await pumpEventQueue();

      final mergedReactions = [...existingReactions, ...additionalReactions];

      expect(
        controller.value.asSuccess.items.length,
        equals(mergedReactions.length),
      );
      expect(controller.value.asSuccess.nextPageKey, isNull);
    });

    test('loadMore passes next cursor to API', () async {
      const nextKey = 'cursor_page_2';
      final existingReactions = generateReactions();

      final response = QueryReactionsResponse()
        ..reactions = []
        ..next = null;

      PaginationParams? capturedPagination;
      when(
        () => client.queryReactions(
          any(),
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((invocation) async {
        capturedPagination = invocation.namedArguments[const Symbol('pagination')] as PaginationParams?;
        return response;
      });

      final controller = StreamReactionListController.fromValue(
        PagedValue<String?, Reaction>(
          items: existingReactions,
          nextPageKey: nextKey,
        ),
        client: client,
        messageId: messageId,
      );

      await controller.loadMore(nextKey);
      await pumpEventQueue();

      expect(capturedPagination?.next, equals(nextKey));
    });

    test('loadMore preserves existing items on StreamChatError', () async {
      const nextKey = 'next_page_token';
      final existingReactions = generateReactions();
      const chatError = StreamChatError('Network error');

      when(
        () => client.queryReactions(
          any(),
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenThrow(chatError);

      final controller = StreamReactionListController.fromValue(
        PagedValue<String?, Reaction>(
          items: existingReactions,
          nextPageKey: nextKey,
        ),
        client: client,
        messageId: messageId,
      );

      await controller.loadMore(nextKey);
      await pumpEventQueue();

      expect(controller.value.isSuccess, isTrue);
      expect(controller.value.asSuccess.items, equals(existingReactions));
      expect(controller.value.asSuccess.error, equals(chatError));
    });

    test('loadMore preserves existing items on generic error', () async {
      const nextKey = 'next_page_token';
      final existingReactions = generateReactions();
      final exception = Exception('Network error');

      when(
        () => client.queryReactions(
          any(),
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenThrow(exception);

      final controller = StreamReactionListController.fromValue(
        PagedValue<String?, Reaction>(
          items: existingReactions,
          nextPageKey: nextKey,
        ),
        client: client,
        messageId: messageId,
      );

      await controller.loadMore(nextKey);
      await pumpEventQueue();

      expect(controller.value.isSuccess, isTrue);
      expect(controller.value.asSuccess.items, equals(existingReactions));
      expect(controller.value.asSuccess.error, isNotNull);
      expect(
        controller.value.asSuccess.error!.message,
        contains('Network error'),
      );
    });
  });

  group('reactions setter', () {
    test('replaces reactions when in success state', () {
      final initial = generateReactions(count: 3);
      final replacement = generateReactions(count: 1, userIds: ['user_new']);

      final controller = StreamReactionListController.fromValue(
        PagedValue<String?, Reaction>(items: initial),
        client: client,
        messageId: messageId,
      );

      expect(controller.value.isSuccess, isTrue);
      expect(controller.value.asSuccess.items, equals(initial));

      controller.reactions = replacement;

      expect(controller.value.asSuccess.items, equals(replacement));
      expect(controller.value.asSuccess.items.length, equals(1));
    });

    test('creates new success value when not in success state', () {
      final reactions = generateReactions();
      final controller = StreamReactionListController(
        client: client,
        messageId: messageId,
      );

      // Controller is in loading state
      expect(controller.value.isNotSuccess, isTrue);

      controller.reactions = reactions;

      expect(controller.value.isSuccess, isTrue);
      expect(controller.value.asSuccess.items, equals(reactions));
    });

    test('preserves nextPageKey when replacing reactions', () {
      const nextKey = 'next_cursor';
      final initial = generateReactions();
      final replacement = generateReactions(count: 1, userIds: ['user_new']);

      final controller = StreamReactionListController.fromValue(
        PagedValue<String?, Reaction>(items: initial, nextPageKey: nextKey),
        client: client,
        messageId: messageId,
      );

      expect(controller.value.isSuccess, isTrue);
      expect(controller.value.asSuccess.items, equals(initial));
      expect(controller.value.asSuccess.nextPageKey, equals(nextKey));

      controller.reactions = replacement;

      expect(controller.value.asSuccess.items, equals(replacement));
      expect(controller.value.asSuccess.nextPageKey, equals(nextKey));
    });
  });

  group('Filtering and sorting', () {
    test('refresh resets filter and sort to initial values', () async {
      final reactions = generateReactions();
      final initialFilter = Filter.equal('type', 'like');
      final sort = [const SortOption<Reaction>.desc(ReactionSortKey.createdAt)];

      final apiCalls = <Map<String, dynamic>>[];

      when(
        () => client.queryReactions(
          any(),
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((invocation) async {
        apiCalls.add({
          'filter': invocation.namedArguments[const Symbol('filter')],
          'sort': invocation.namedArguments[const Symbol('sort')],
        });
        return QueryReactionsResponse()
          ..reactions = reactions
          ..next = null;
      });

      final controller = StreamReactionListController(
        client: client,
        messageId: messageId,
        filter: initialFilter,
        sort: sort,
      );

      await controller.doInitialLoad();
      await pumpEventQueue();

      // Change filter and sort at runtime
      controller
        ..filter = Filter.equal('type', 'love')
        ..sort = [const SortOption<Reaction>.asc(ReactionSortKey.createdAt)];

      await controller.refresh();
      await pumpEventQueue();

      expect(apiCalls.length, equals(2));

      final refreshCall = apiCalls.last;
      expect(refreshCall['filter'], equals(initialFilter));
      expect(refreshCall['sort'], equals(sort));
    });

    test('refresh with resetValue=false preserves current filter and sort', () async {
      final reactions = generateReactions();
      final initialFilter = Filter.equal('type', 'like');
      final initialSort = [const SortOption<Reaction>.desc(ReactionSortKey.createdAt)];
      final newFilter = Filter.equal('type', 'love');
      final newSort = [const SortOption<Reaction>.asc(ReactionSortKey.createdAt)];

      final apiCalls = <Map<String, dynamic>>[];

      when(
        () => client.queryReactions(
          any(),
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((invocation) async {
        apiCalls.add({
          'filter': invocation.namedArguments[const Symbol('filter')],
          'sort': invocation.namedArguments[const Symbol('sort')],
        });
        return QueryReactionsResponse()
          ..reactions = reactions
          ..next = null;
      });

      final controller = StreamReactionListController(
        client: client,
        messageId: messageId,
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
    });

    test('value setter sorts items when sort is provided', () async {
      final now = DateTime.now();
      final older = generateReaction(userId: 'user_1', createdAt: now.subtract(const Duration(hours: 1)));
      final newer = generateReaction(userId: 'user_2', createdAt: now);

      final response = QueryReactionsResponse()
        ..reactions = [older, newer]
        ..next = null;

      when(
        () => client.queryReactions(
          any(),
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((_) async => response);

      final controller = StreamReactionListController(
        client: client,
        messageId: messageId,
        sort: [const SortOption<Reaction>.desc(ReactionSortKey.createdAt)],
      );

      await controller.doInitialLoad();
      await pumpEventQueue();

      // desc order: newer first
      expect(controller.value.asSuccess.items.first.userId, equals('user_2'));
      expect(controller.value.asSuccess.items.last.userId, equals('user_1'));
    });
  });

  group('Disposal', () {
    test('dispose completes without errors', () {
      final controller = StreamReactionListController(
        client: client,
        messageId: messageId,
      )..doInitialLoad();

      expect(controller.dispose, returnsNormally);
    });
  });
}
