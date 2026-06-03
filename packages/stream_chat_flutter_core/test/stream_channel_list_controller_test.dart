// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart' hide Success;
import 'package:stream_chat_flutter_core/src/paged_value_notifier.dart';
import 'package:stream_chat_flutter_core/src/stream_channel_list_controller.dart';

import 'mocks.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(const PaginationParams());
  });

  final client = MockClient();

  setUp(() {
    when(client.on).thenAnswer((_) => const Stream.empty());
  });

  tearDown(() {
    reset(client);
  });

  test('creates with loading state by default', () {
    final controller = StreamChannelListController(client: client);
    expect(controller.value, isA<Loading>());
  });

  test('fromValue preserves the provided value', () {
    const value = PagedValue<int, Channel>(items: []);
    final controller = StreamChannelListController.fromValue(
      value,
      client: client,
    );
    expect(controller.value, same(value));
  });

  test('doInitialLoad forwards inline filter and sort to queryChannels',
      () async {
    final filter = Filter.in_('members', const ['u1']);
    const sort = [SortOption<ChannelState>.desc(ChannelSortKey.lastMessageAt)];

    when(
      () => client.queryChannelsWithResult(
        filter: any(named: 'filter'),
        channelStateSort: any(named: 'channelStateSort'),
        predefinedFilter: any(named: 'predefinedFilter'),
        filterValues: any(named: 'filterValues'),
        sortValues: any(named: 'sortValues'),
        memberLimit: any(named: 'memberLimit'),
        messageLimit: any(named: 'messageLimit'),
        presence: any(named: 'presence'),
        paginationParams: any(named: 'paginationParams'),
      ),
    ).thenAnswer((_) => Stream.value(const QueryChannelsResult(channels: [])));

    final controller = StreamChannelListController(
      client: client,
      filter: filter,
      channelStateSort: sort,
    );

    await controller.doInitialLoad();
    await pumpEventQueue();

    verify(
      () => client.queryChannelsWithResult(
        filter: filter,
        channelStateSort: sort,
        predefinedFilter: null,
        filterValues: null,
        sortValues: null,
        memberLimit: any(named: 'memberLimit'),
        messageLimit: any(named: 'messageLimit'),
        presence: any(named: 'presence'),
        paginationParams: any(named: 'paginationParams'),
      ),
    ).called(1);
  });

  test(
      'doInitialLoad forwards predefinedFilter, filterValues, sortValues to queryChannels',
      () async {
    const presetName = 'sample_app_filter';
    const filterValues = {'user_id': 'u1'};
    const sortValues = {'preset': 'recent'};

    when(
      () => client.queryChannelsWithResult(
        filter: any(named: 'filter'),
        channelStateSort: any(named: 'channelStateSort'),
        predefinedFilter: any(named: 'predefinedFilter'),
        filterValues: any(named: 'filterValues'),
        sortValues: any(named: 'sortValues'),
        memberLimit: any(named: 'memberLimit'),
        messageLimit: any(named: 'messageLimit'),
        presence: any(named: 'presence'),
        paginationParams: any(named: 'paginationParams'),
      ),
    ).thenAnswer((_) => Stream.value(const QueryChannelsResult(channels: [])));

    final controller = StreamChannelListController(
      client: client,
      predefinedFilter: presetName,
      filterValues: filterValues,
      sortValues: sortValues,
      channelStateSort: null,
    );

    await controller.doInitialLoad();
    await pumpEventQueue();

    verify(
      () => client.queryChannelsWithResult(
        filter: null,
        channelStateSort: null,
        predefinedFilter: presetName,
        filterValues: filterValues,
        sortValues: sortValues,
        memberLimit: any(named: 'memberLimit'),
        messageLimit: any(named: 'messageLimit'),
        presence: any(named: 'presence'),
        paginationParams: any(named: 'paginationParams'),
      ),
    ).called(1);
  });

  test('doInitialLoad transitions to error state on exception', () async {
    final exception = Exception('API unavailable');
    when(
      () => client.queryChannelsWithResult(
        filter: any(named: 'filter'),
        channelStateSort: any(named: 'channelStateSort'),
        predefinedFilter: any(named: 'predefinedFilter'),
        filterValues: any(named: 'filterValues'),
        sortValues: any(named: 'sortValues'),
        memberLimit: any(named: 'memberLimit'),
        messageLimit: any(named: 'messageLimit'),
        presence: any(named: 'presence'),
        paginationParams: any(named: 'paginationParams'),
      ),
    ).thenAnswer((_) => Stream.error(exception));

    final controller = StreamChannelListController(
      client: client,
      channelStateSort: null,
    );

    await controller.doInitialLoad();
    await pumpEventQueue();

    expect(controller.value, isA<Error>());
    expect(
      (controller.value as Error).error.message,
      contains('API unavailable'),
    );
  });

  test('loadMore appends new channels and forwards inline filter', () async {
    final filter = Filter.in_('members', const ['u1']);
    const nextPageKey = 2;

    final existing = [MockChannel(), MockChannel()];
    final fetched = [MockChannel()];

    when(
      () => client.queryChannelsWithResult(
        filter: any(named: 'filter'),
        channelStateSort: any(named: 'channelStateSort'),
        predefinedFilter: any(named: 'predefinedFilter'),
        filterValues: any(named: 'filterValues'),
        sortValues: any(named: 'sortValues'),
        memberLimit: any(named: 'memberLimit'),
        messageLimit: any(named: 'messageLimit'),
        presence: any(named: 'presence'),
        paginationParams: any(named: 'paginationParams'),
      ),
    ).thenAnswer((_) => Stream.value(QueryChannelsResult(channels: fetched)));

    final controller = StreamChannelListController.fromValue(
      PagedValue<int, Channel>(
        items: existing,
        nextPageKey: nextPageKey,
      ),
      client: client,
      filter: filter,
      channelStateSort: null,
    );

    await controller.loadMore(nextPageKey);
    await pumpEventQueue();

    expect(
      controller.value.asSuccess.items,
      equals([...existing, ...fetched]),
    );

    final captured = verify(
      () => client.queryChannelsWithResult(
        filter: filter,
        channelStateSort: null,
        predefinedFilter: null,
        filterValues: null,
        sortValues: null,
        memberLimit: any(named: 'memberLimit'),
        messageLimit: any(named: 'messageLimit'),
        presence: any(named: 'presence'),
        paginationParams: captureAny(named: 'paginationParams'),
      ),
    ).captured;

    expect(captured, hasLength(1));
    expect((captured.single as PaginationParams).offset, equals(nextPageKey));
  });

  test('loadMore appends new channels and forwards predefined params',
      () async {
    const presetName = 'sample_app_filter';
    const filterValues = {'user_id': 'u1'};
    const sortValues = {'preset': 'recent'};
    const nextPageKey = 2;

    final existing = [MockChannel(), MockChannel()];
    final fetched = [MockChannel()];

    when(
      () => client.queryChannelsWithResult(
        filter: any(named: 'filter'),
        channelStateSort: any(named: 'channelStateSort'),
        predefinedFilter: any(named: 'predefinedFilter'),
        filterValues: any(named: 'filterValues'),
        sortValues: any(named: 'sortValues'),
        memberLimit: any(named: 'memberLimit'),
        messageLimit: any(named: 'messageLimit'),
        presence: any(named: 'presence'),
        paginationParams: any(named: 'paginationParams'),
      ),
    ).thenAnswer((_) => Stream.value(QueryChannelsResult(channels: fetched)));

    final controller = StreamChannelListController.fromValue(
      PagedValue<int, Channel>(
        items: existing,
        nextPageKey: nextPageKey,
      ),
      client: client,
      predefinedFilter: presetName,
      filterValues: filterValues,
      sortValues: sortValues,
      channelStateSort: null,
    );

    await controller.loadMore(nextPageKey);
    await pumpEventQueue();

    expect(
      controller.value.asSuccess.items,
      equals([...existing, ...fetched]),
    );

    final captured = verify(
      () => client.queryChannelsWithResult(
        filter: null,
        channelStateSort: null,
        predefinedFilter: presetName,
        filterValues: filterValues,
        sortValues: sortValues,
        memberLimit: any(named: 'memberLimit'),
        messageLimit: any(named: 'messageLimit'),
        presence: any(named: 'presence'),
        paginationParams: captureAny(named: 'paginationParams'),
      ),
    ).captured;

    expect(captured, hasLength(1));
    expect((captured.single as PaginationParams).offset, equals(nextPageKey));
  });

  test('channels setter replaces items while keeping success state', () {
    const initial = PagedValue<int, Channel>(items: []);
    final controller = StreamChannelListController.fromValue(
      initial,
      client: client,
      channelStateSort: null,
    )..channels = const [];

    expect(controller.value.isSuccess, isTrue);
  });
}
