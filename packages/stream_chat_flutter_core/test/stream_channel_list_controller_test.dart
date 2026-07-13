// ignore_for_file: avoid_redundant_argument_values

import 'dart:async';

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

  MockChannel mockChannel(String cid, {bool watchable = false}) {
    final channel = MockChannel();
    when(() => channel.cid).thenReturn(cid);
    if (watchable) {
      when(channel.watch).thenAnswer((_) => Future.value(const ChannelState()));
      final [type, id] = cid.split(':');
      when(() => client.channel(type, id: id)).thenReturn(channel);
    }
    return channel;
  }

  Future<StreamChannelListController> buildController({
    List<Channel> channels = const [],
    Filter? filter,
    SortOrder<ChannelState>? channelStateSort = defaultChannelListSort,
    String? predefinedFilter,
    Map<String, Object?>? filterValues,
    Map<String, Object?>? sortValues,
  }) async {
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
    ).thenAnswer((_) => Stream.value(QueryChannelsResult(channels: channels)));

    final controller = StreamChannelListController(
      client: client,
      filter: filter,
      channelStateSort: channelStateSort,
      predefinedFilter: predefinedFilter,
      filterValues: filterValues,
      sortValues: sortValues,
    );
    await controller.doInitialLoad();
    await pumpEventQueue();
    return controller;
  }

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

  test(
    'doInitialLoad forwards inline filter and sort to queryChannels',
    () async {
      final filter = Filter.in_('members', const ['u1']);
      const sort = [
        SortOption<ChannelState>.desc(ChannelSortKey.lastMessageAt),
      ];

      await buildController(filter: filter, channelStateSort: sort);

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
    },
  );

  test(
    'doInitialLoad forwards predefinedFilter, filterValues, sortValues to '
    'queryChannels',
    () async {
      const presetName = 'sample_app_filter';
      const filterValues = {'user_id': 'u1'};
      const sortValues = {'preset': 'recent'};

      await buildController(
        predefinedFilter: presetName,
        filterValues: filterValues,
        sortValues: sortValues,
        channelStateSort: null,
      );

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
    },
  );

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
      PagedValue<int, Channel>(items: existing, nextPageKey: nextPageKey),
      client: client,
      filter: filter,
      channelStateSort: null,
    );

    await controller.loadMore(nextPageKey);
    await pumpEventQueue();

    expect(controller.value.asSuccess.items, equals([...existing, ...fetched]));

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

  test(
    'loadMore appends new channels and forwards predefined params',
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
        PagedValue<int, Channel>(items: existing, nextPageKey: nextPageKey),
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
    },
  );

  group('Event handling', () {
    late StreamController<Event> eventController;

    setUp(() {
      eventController = StreamController<Event>.broadcast();
      when(client.on).thenAnswer((_) => eventController.stream);
    });

    tearDown(() {
      eventController.close();
    });

    test('channel.deleted event removes the channel from the list', () async {
      final keptChannel = mockChannel('messaging:kept');
      final deletedChannel = mockChannel('messaging:deleted');

      final controller = await buildController(
        channels: [keptChannel, deletedChannel],
        channelStateSort: null,
      );

      eventController.add(
        Event(type: EventType.channelDeleted, cid: 'messaging:deleted'),
      );
      await pumpEventQueue();

      expect(controller.value.asSuccess.items, equals([keptChannel]));
    });

    test(
      'notification.channel_deleted event removes the channel from the list',
      () async {
        final keptChannel = mockChannel('messaging:kept');
        final deletedChannel = mockChannel('messaging:deleted');

        final controller = await buildController(
          channels: [keptChannel, deletedChannel],
          channelStateSort: null,
        );

        eventController.add(
          Event(
            type: EventType.notificationChannelDeleted,
            cid: 'messaging:deleted',
          ),
        );
        await pumpEventQueue();

        expect(controller.value.asSuccess.items, equals([keptChannel]));
      },
    );

    test('channel.hidden event removes the channel from the list', () async {
      final keptChannel = mockChannel('messaging:kept');
      final hiddenChannel = mockChannel('messaging:hidden');

      final controller = await buildController(
        channels: [keptChannel, hiddenChannel],
        channelStateSort: null,
      );

      eventController.add(
        Event(type: EventType.channelHidden, cid: 'messaging:hidden'),
      );
      await pumpEventQueue();

      expect(controller.value.asSuccess.items, equals([keptChannel]));
    });

    test('channel.truncated event refreshes the list', () async {
      final channel = mockChannel('messaging:foo');

      await buildController(channels: [channel], channelStateSort: null);

      eventController.add(Event(type: EventType.channelTruncated));
      await pumpEventQueue();

      verify(
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
      ).called(2);
    });

    test('connection.recovered event refreshes the list', () async {
      await buildController(channelStateSort: null);

      eventController.add(Event(type: EventType.connectionRecovered));
      await pumpEventQueue();

      verify(
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
      ).called(2);
    });

    test('message.new event moves the matching channel to the top', () async {
      final channelA = mockChannel('messaging:a');
      final channelB = mockChannel('messaging:b');
      final channelC = mockChannel('messaging:c');

      final controller = await buildController(
        channels: [channelA, channelB, channelC],
        channelStateSort: null,
      );

      eventController.add(
        Event(type: EventType.messageNew, cid: 'messaging:b'),
      );
      await pumpEventQueue();

      expect(
        controller.value.asSuccess.items,
        equals([channelB, channelA, channelC]),
      );
    });

    test(
      'message.new event for a channel not in the list refreshes the list',
      () async {
        final channel = mockChannel('messaging:foo');

        await buildController(channels: [channel], channelStateSort: null);

        eventController.add(
          Event(type: EventType.messageNew, cid: 'messaging:unknown'),
        );
        await pumpEventQueue();

        verify(
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
        ).called(2);
      },
    );

    test('channel.visible event adds the channel to the top of the list',
        () async {
      final existingChannel = mockChannel('messaging:existing');
      final newChannel = mockChannel('messaging:new', watchable: true);

      final controller = await buildController(
        channels: [existingChannel],
        channelStateSort: null,
      );

      eventController.add(
        Event(
          type: EventType.channelVisible,
          channelId: 'new',
          channelType: 'messaging',
        ),
      );
      await pumpEventQueue();

      expect(controller.value.asSuccess.items,
          equals([newChannel, existingChannel]));
    });

    test(
      'notification.added_to_channel event adds the channel to the top of the '
      'list',
      () async {
        final existingChannel = mockChannel('messaging:existing');
        final newChannel = mockChannel('messaging:new', watchable: true);

        final controller = await buildController(
          channels: [existingChannel],
          channelStateSort: null,
        );

        eventController.add(
          Event(
            type: EventType.notificationAddedToChannel,
            channelId: 'new',
            channelType: 'messaging',
          ),
        );
        await pumpEventQueue();

        expect(controller.value.asSuccess.items,
            equals([newChannel, existingChannel]));
      },
    );

    test(
      'notification.message_new event adds the channel to the top of the list',
      () async {
        final existingChannel = mockChannel('messaging:existing');
        final newChannel = mockChannel('messaging:new', watchable: true);

        final controller = await buildController(
          channels: [existingChannel],
          channelStateSort: null,
        );

        eventController.add(
          Event(
            type: EventType.notificationMessageNew,
            channelId: 'new',
            channelType: 'messaging',
          ),
        );
        await pumpEventQueue();

        expect(controller.value.asSuccess.items,
            equals([newChannel, existingChannel]));
      },
    );

    test(
      'notification.removed_from_channel event removes the channel from the '
      'list',
      () async {
        final keptChannel = mockChannel('messaging:kept');
        final removedChannel = mockChannel('messaging:removed');

        final controller = await buildController(
          channels: [keptChannel, removedChannel],
          channelStateSort: null,
        );

        eventController.add(
          Event(
            type: EventType.notificationRemovedFromChannel,
            channel: ChannelModel(cid: 'messaging:removed'),
          ),
        );
        await pumpEventQueue();

        expect(controller.value.asSuccess.items, equals([keptChannel]));
      },
    );
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
