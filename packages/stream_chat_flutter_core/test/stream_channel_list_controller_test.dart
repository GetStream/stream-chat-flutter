// ignore_for_file: avoid_redundant_argument_values

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart' hide Success;
import 'package:stream_chat_flutter_core/src/paged_value_notifier.dart';
import 'package:stream_chat_flutter_core/src/stream_channel_list_controller.dart';
import 'package:stream_chat_flutter_core/src/stream_channel_list_event_handler.dart';

import 'mocks.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(const PaginationParams());
    registerFallbackValue(Event(type: 'fallback'));
  });

  final client = MockClient();

  setUp(() {
    when(client.on).thenAnswer((_) => const Stream.empty());
  });

  tearDown(() {
    reset(client);
  });

  Future<StreamChannelListController> buildController({
    List<Channel> channels = const [],
    Filter? filter,
    SortOrder<ChannelState>? channelStateSort = defaultChannelListSort,
    String? predefinedFilter,
    Map<String, Object?>? filterValues,
    Map<String, Object?>? sortValues,
    StreamChannelListEventHandler? eventHandler,
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
      eventHandler: eventHandler,
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

  test('doInitialLoad forwards inline filter and sort to queryChannels', () async {
    final filter = Filter.in_('members', const ['u1']);
    const sort = [SortOption<ChannelState>.desc(ChannelSortKey.lastMessageAt)];

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
  });

  test('doInitialLoad forwards predefinedFilter, filterValues, sortValues to queryChannels', () async {
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

  test('loadMore appends new channels and forwards predefined params', () async {
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

  // The controller's only responsibility for events is routing them to the
  // matching handler method. The handler's behavior for each event is covered
  // in stream_channel_list_event_handler_test.dart, so here we inject a mock
  // handler and assert only that dispatch reaches the right method.
  group('Event handling routes each event to its handler', () {
    late StreamController<Event> eventController;
    late MockStreamChannelListEventHandler handler;

    setUp(() {
      eventController = StreamController<Event>.broadcast();
      when(client.on).thenAnswer((_) => eventController.stream);
      handler = MockStreamChannelListEventHandler();
    });

    tearDown(() {
      eventController.close();
    });

    Future<StreamChannelListController> subscribe() => buildController(eventHandler: handler);

    test('channel.deleted -> onChannelDeleted', () async {
      final controller = await subscribe();
      eventController.add(Event(type: EventType.channelDeleted));
      await pumpEventQueue();
      verify(() => handler.onChannelDeleted(any(), controller)).called(1);
    });

    test('notification.channel_deleted -> onChannelDeleted', () async {
      final controller = await subscribe();
      eventController.add(Event(type: EventType.notificationChannelDeleted));
      await pumpEventQueue();
      verify(() => handler.onChannelDeleted(any(), controller)).called(1);
    });

    test('channel.hidden -> onChannelHidden', () async {
      final controller = await subscribe();
      eventController.add(Event(type: EventType.channelHidden));
      await pumpEventQueue();
      verify(() => handler.onChannelHidden(any(), controller)).called(1);
    });

    test('channel.truncated -> onChannelTruncated', () async {
      final controller = await subscribe();
      eventController.add(Event(type: EventType.channelTruncated));
      await pumpEventQueue();
      verify(() => handler.onChannelTruncated(any(), controller)).called(1);
    });

    test('channel.updated -> onChannelUpdated', () async {
      final controller = await subscribe();
      eventController.add(Event(type: EventType.channelUpdated));
      await pumpEventQueue();
      verify(() => handler.onChannelUpdated(any(), controller)).called(1);
    });

    test('member.updated -> onMemberUpdated', () async {
      final controller = await subscribe();
      eventController.add(Event(type: EventType.memberUpdated));
      await pumpEventQueue();
      verify(() => handler.onMemberUpdated(any(), controller)).called(1);
    });

    test('channel.visible -> onChannelVisible', () async {
      final controller = await subscribe();
      eventController.add(Event(type: EventType.channelVisible));
      await pumpEventQueue();
      verify(() => handler.onChannelVisible(any(), controller)).called(1);
    });

    test('connection.recovered -> onConnectionRecovered', () async {
      final controller = await subscribe();
      eventController.add(Event(type: EventType.connectionRecovered));
      await pumpEventQueue();
      verify(() => handler.onConnectionRecovered(any(), controller)).called(1);
    });

    test('message.new -> onMessageNew', () async {
      final controller = await subscribe();
      eventController.add(Event(type: EventType.messageNew));
      await pumpEventQueue();
      verify(() => handler.onMessageNew(any(), controller)).called(1);
    });

    test('notification.added_to_channel -> onNotificationAddedToChannel', () async {
      final controller = await subscribe();
      eventController.add(Event(type: EventType.notificationAddedToChannel));
      await pumpEventQueue();
      verify(
        () => handler.onNotificationAddedToChannel(any(), controller),
      ).called(1);
    });

    test('notification.message_new -> onNotificationMessageNew', () async {
      final controller = await subscribe();
      eventController.add(Event(type: EventType.notificationMessageNew));
      await pumpEventQueue();
      verify(
        () => handler.onNotificationMessageNew(any(), controller),
      ).called(1);
    });

    test('notification.removed_from_channel -> onNotificationRemovedFromChannel', () async {
      final controller = await subscribe();
      eventController.add(Event(type: EventType.notificationRemovedFromChannel));
      await pumpEventQueue();
      verify(
        () => handler.onNotificationRemovedFromChannel(any(), controller),
      ).called(1);
    });

    test('user.presence.changed -> onUserPresenceChanged', () async {
      final controller = await subscribe();
      eventController.add(Event(type: EventType.userPresenceChanged));
      await pumpEventQueue();
      verify(() => handler.onUserPresenceChanged(any(), controller)).called(1);
    });

    test('user.updated -> onUserPresenceChanged', () async {
      final controller = await subscribe();
      eventController.add(Event(type: EventType.userUpdated));
      await pumpEventQueue();
      verify(() => handler.onUserPresenceChanged(any(), controller)).called(1);
    });
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
