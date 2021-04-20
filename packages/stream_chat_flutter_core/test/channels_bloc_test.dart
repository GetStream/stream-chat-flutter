import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import 'matchers/channel_matcher.dart';
import 'mocks.dart';

void main() {
  setUpAll(() {
    registerFallbackValue<PaginationParams>(const PaginationParams());
  });

  List<Channel> _generateChannels(
    StreamChatClient client, {
    int count = 3,
    int offset = 0,
  }) {
    return List.generate(
      count,
      (index) {
        index = index + offset;
        return Channel(
          client,
          'testType$index',
          'testId$index',
          {'extra_data_key': 'extra_data_value_$index'},
        );
      },
    );
  }

  testWidgets(
    'should throw if ChannelsBloc is used where StreamChat is not present in the widget tree',
    (tester) async {
      const channelsBlocKey = Key('channelsBloc');
      const childKey = Key('child');
      final channelsBloc = ChannelsBloc(
        key: channelsBlocKey,
        child: Offstage(key: childKey),
      );

      await tester.pumpWidget(channelsBloc);

      expect(find.byKey(channelsBlocKey), findsNothing);
      expect(find.byKey(childKey), findsNothing);
      expect(tester.takeException(), isInstanceOf<Exception>());
    },
  );

  testWidgets(
    'should render ChannelsBloc if used with StreamChatCore as an ancestor',
    (tester) async {
      const channelsBlocKey = Key('channelsBloc');
      const childKey = Key('child');
      final channelsBloc = ChannelsBloc(
        key: channelsBlocKey,
        child: Offstage(key: childKey),
      );

      final mockClient = MockClient();

      when(() => mockClient.on(any(), any(), any(), any()))
          .thenAnswer((_) => Stream.empty());

      await tester.pumpWidget(
        StreamChatCore(
          client: mockClient,
          child: channelsBloc,
        ),
      );

      expect(find.byKey(channelsBlocKey), findsOneWidget);
      expect(find.byKey(childKey), findsOneWidget);
    },
  );

  testWidgets(
    'channelsBlocState.queryChannels() should emit data through channelsStream',
    (tester) async {
      const channelsBlocKey = Key('channelsBloc');
      const childKey = Key('child');
      final channelsBloc = ChannelsBloc(
        key: channelsBlocKey,
        child: Builder(
          key: childKey,
          builder: (context) {
            return Offstage();
          },
        ),
      );

      final mockClient = MockClient();

      when(() => mockClient.on(any(), any(), any(), any()))
          .thenAnswer((_) => Stream.empty());

      await tester.pumpWidget(
        StreamChatCore(
          client: mockClient,
          child: channelsBloc,
        ),
      );

      final channelsBlocState = tester.state<ChannelsBlocState>(
        find.byKey(channelsBlocKey),
      );

      final offlineChannels = _generateChannels(mockClient);
      final onlineChannels = _generateChannels(mockClient, offset: 3);

      when(() => mockClient.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            options: any(named: 'options'),
            paginationParams: any(named: 'paginationParams'),
          )).thenAnswer(
        (_) => Stream.fromIterable([offlineChannels, onlineChannels]),
      );

      channelsBlocState.queryChannels();

      await expectLater(
        channelsBlocState.channelsStream,
        emitsInOrder([
          isSameChannelListAs(offlineChannels),
          isSameChannelListAs(onlineChannels),
        ]),
      );

      verify(() => mockClient.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            options: any(named: 'options'),
            paginationParams: any(named: 'paginationParams'),
          )).called(1);
    },
  );

  testWidgets(
    'channelsBlocState.channelsStream should emit error '
    'if client.queryChannels() throws',
    (tester) async {
      const channelsBlocKey = Key('channelsBloc');
      const childKey = Key('child');
      final channelsBloc = ChannelsBloc(
        key: channelsBlocKey,
        child: Builder(
          key: childKey,
          builder: (context) {
            return Offstage();
          },
        ),
      );

      final mockClient = MockClient();

      when(() => mockClient.on(any(), any(), any(), any()))
          .thenAnswer((_) => Stream.empty());

      await tester.pumpWidget(
        StreamChatCore(
          client: mockClient,
          child: channelsBloc,
        ),
      );

      final channelsBlocState = tester.state<ChannelsBlocState>(
        find.byKey(channelsBlocKey),
      );

      const error = 'Error! Error! Error!';

      when(() => mockClient.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            options: any(named: 'options'),
            paginationParams: any(named: 'paginationParams'),
          )).thenThrow(error);

      channelsBlocState.queryChannels();

      await expectLater(
        channelsBlocState.channelsStream,
        emitsError(error),
      );

      verify(() => mockClient.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            options: any(named: 'options'),
            paginationParams: any(named: 'paginationParams'),
          )).called(1);
    },
  );

  testWidgets(
    'calling channelsBlocState.queryChannels() again with an offset '
    'should emit new data through channelsStream and also emit loading state '
    'through queryChannelsLoading',
    (tester) async {
      const channelsBlocKey = Key('channelsBloc');
      final channelsBloc = ChannelsBloc(
        key: channelsBlocKey,
        child: Offstage(),
      );

      final mockClient = MockClient();

      when(() => mockClient.on(any(), any(), any(), any()))
          .thenAnswer((_) => Stream.empty());

      await tester.pumpWidget(
        StreamChatCore(
          client: mockClient,
          child: channelsBloc,
        ),
      );

      final channelsBlocState = tester.state<ChannelsBlocState>(
        find.byKey(channelsBlocKey),
      );

      final channels = _generateChannels(mockClient);

      when(() => mockClient.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            options: any(named: 'options'),
            paginationParams: any(named: 'paginationParams'),
          )).thenAnswer((_) => Stream.value(channels));

      const pagination = PaginationParams(limit: 3);
      channelsBlocState.queryChannels(
        paginationParams: pagination,
      );

      await expectLater(
        channelsBlocState.channelsStream,
        emits(isSameChannelListAs(channels)),
      );

      verify(() => mockClient.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            options: any(named: 'options'),
            paginationParams: any(named: 'paginationParams'),
          )).called(1);

      final offset = channels.length;
      final paginationParams = pagination.copyWith(offset: offset);

      final newChannels = _generateChannels(mockClient, offset: offset);

      when(() => mockClient.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            options: any(named: 'options'),
            paginationParams: paginationParams,
          )).thenAnswer(
        (_) => Stream.value(newChannels),
      );

      channelsBlocState.queryChannels(paginationParams: paginationParams);

      await Future.wait([
        expectLater(
          channelsBlocState.queryChannelsLoading,
          emitsInOrder([true, false]),
        ),
        expectLater(
          channelsBlocState.channelsStream,
          emits(isSameChannelListAs(channels + newChannels)),
        ),
      ]);

      verify(() => mockClient.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            options: any(named: 'options'),
            paginationParams: paginationParams,
          )).called(1);
    },
  );

  testWidgets(
    'calling channelsBlocState.queryChannels() again with an offset '
    'should emit error through queryChannelsLoading if '
    'client.queryChannels() throws',
    (tester) async {
      const channelsBlocKey = Key('channelsBloc');
      final channelsBloc = ChannelsBloc(
        key: channelsBlocKey,
        child: Offstage(),
      );

      final mockClient = MockClient();

      when(() => mockClient.on(any(), any(), any(), any()))
          .thenAnswer((_) => Stream.empty());

      await tester.pumpWidget(
        StreamChatCore(
          client: mockClient,
          child: channelsBloc,
        ),
      );

      final channelsBlocState = tester.state<ChannelsBlocState>(
        find.byKey(channelsBlocKey),
      );

      final channels = _generateChannels(mockClient);
      final paginationParams = const PaginationParams(
        limit: 3,
      );

      when(() => mockClient.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            options: any(named: 'options'),
            paginationParams: paginationParams,
          )).thenAnswer((_) => Stream.value(channels));

      channelsBlocState.queryChannels(
        paginationParams: paginationParams,
      );

      await expectLater(
        channelsBlocState.channelsStream,
        emits(isSameChannelListAs(channels)),
      );

      verify(() => mockClient.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            options: any(named: 'options'),
            paginationParams: paginationParams,
          )).called(1);

      final error = 'Error! Error! Error!';

      when(() => mockClient.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            options: any(named: 'options'),
            paginationParams: paginationParams,
          )).thenThrow(error);

      channelsBlocState.queryChannels(paginationParams: paginationParams);

      await expectLater(
        channelsBlocState.queryChannelsLoading,
        emitsError(error),
      );

      verify(() => mockClient.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            options: any(named: 'options'),
            paginationParams: paginationParams,
          )).called(1);
    },
  );

  group('event controller test', () {
    late StreamController<Event> eventController;
    setUp(() {
      eventController = StreamController<Event>.broadcast();
    });

    testWidgets(
      'channel should get hide when EventType.channelHidden event is received',
      (tester) async {
        final mockClient = MockClient();
        const channelsBlocKey = Key('channelsBloc');
        final channelsBloc = ChannelsBloc(
          key: channelsBlocKey,
          child: Offstage(),
        );

        when(() => mockClient.on(any(), any(), any(), any()))
            .thenAnswer((_) => Stream.empty());

        when(() => mockClient.on(
              EventType.channelHidden,
            )).thenAnswer((_) => eventController.stream);

        await tester.pumpWidget(
          StreamChatCore(
            client: mockClient,
            child: channelsBloc,
          ),
        );

        final channelsBlocState = tester.state<ChannelsBlocState>(
          find.byKey(channelsBlocKey),
        );

        final channels = _generateChannels(mockClient);

        when(() => mockClient.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              options: any(named: 'options'),
              paginationParams: any(named: 'paginationParams'),
            )).thenAnswer(
          (_) => Stream.value(channels),
        );

        await channelsBlocState.queryChannels();

        verify(() => mockClient.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              options: any(named: 'options'),
              paginationParams: any(named: 'paginationParams'),
            )).called(1);

        final channelHiddenEvent = Event(
          type: EventType.channelHidden,
          cid: channels.first.cid,
        );

        eventController.add(channelHiddenEvent);

        final newChannels = [...channels]
          ..removeWhere((it) => it.cid == channelHiddenEvent.cid);

        await expectLater(
          channelsBlocState.channelsStream,
          emitsInOrder([
            isSameChannelListAs(channels),
            isSameChannelListAs(newChannels),
          ]),
        );

        verify(() => mockClient.on(EventType.channelHidden)).called(1);
      },
    );

    testWidgets(
      'channel should get removed when EventType.channelDeleted or '
      'EventType.notificationRemovedFromChannel, event is received',
      (tester) async {
        final mockClient = MockClient();
        const channelsBlocKey = Key('channelsBloc');
        final channelsBloc = ChannelsBloc(
          key: channelsBlocKey,
          child: Offstage(),
        );

        when(() => mockClient.on(any(), any(), any(), any()))
            .thenAnswer((_) => Stream.empty());

        when(() => mockClient.on(
              EventType.channelDeleted,
              EventType.notificationRemovedFromChannel,
            )).thenAnswer((_) => eventController.stream);

        await tester.pumpWidget(
          StreamChatCore(
            client: mockClient,
            child: channelsBloc,
          ),
        );

        final channelsBlocState = tester.state<ChannelsBlocState>(
          find.byKey(channelsBlocKey),
        );

        final channels = _generateChannels(mockClient);

        when(() => mockClient.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              options: any(named: 'options'),
              paginationParams: any(named: 'paginationParams'),
            )).thenAnswer(
          (_) => Stream.value(channels),
        );

        await channelsBlocState.queryChannels();

        verify(() => mockClient.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              options: any(named: 'options'),
              paginationParams: any(named: 'paginationParams'),
            )).called(1);

        final channelDeletedOrNotificationRemovedEvent = Event(
          channel: EventChannel(
            cid: channels.first.cid!,
            updatedAt: DateTime.now(),
            config: ChannelConfig(),
            createdAt: DateTime.now(),
            memberCount: 1,
          ),
        );

        eventController.add(channelDeletedOrNotificationRemovedEvent);

        final channelCid =
            channelDeletedOrNotificationRemovedEvent.channel?.cid;
        final newChannels = [...channels]
          ..removeWhere((it) => it.cid == channelCid);

        await expectLater(
          channelsBlocState.channelsStream,
          emitsInOrder([
            isSameChannelListAs(channels),
            isSameChannelListAs(newChannels),
          ]),
        );

        verify(() => mockClient.on(
              EventType.channelDeleted,
              EventType.notificationRemovedFromChannel,
            )).called(1);
      },
    );

    testWidgets(
      'event channel should be moved to top of the list if present when'
      'EventType.messageNew event is received',
      (tester) async {
        final mockClient = MockClient();
        const channelsBlocKey = Key('channelsBloc');
        final channelsBloc = ChannelsBloc(
          key: channelsBlocKey,
          child: Offstage(),
        );

        when(() => mockClient.on(any(), any(), any(), any()))
            .thenAnswer((_) => Stream.empty());

        when(() => mockClient.on(
              EventType.messageNew,
            )).thenAnswer((_) => eventController.stream);

        await tester.pumpWidget(
          StreamChatCore(
            client: mockClient,
            child: channelsBloc,
          ),
        );

        final channelsBlocState = tester.state<ChannelsBlocState>(
          find.byKey(channelsBlocKey),
        );

        final channels = _generateChannels(mockClient);

        when(() => mockClient.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              options: any(named: 'options'),
              paginationParams: any(named: 'paginationParams'),
            )).thenAnswer(
          (_) => Stream.value(channels),
        );

        await channelsBlocState.queryChannels();

        verify(() => mockClient.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              options: any(named: 'options'),
              paginationParams: any(named: 'paginationParams'),
            )).called(1);

        final messageNewEvent = Event(
          type: EventType.messageNew,
          cid: channels.last.cid,
        );

        eventController.add(messageNewEvent);

        final channelCid = messageNewEvent.cid;
        final index = channels.indexWhere((it) => it.cid == channelCid);
        final updatedChannel = channels[index];
        final newChannels = [...channels]
          ..removeAt(index)
          ..insert(0, updatedChannel);

        await expectLater(
          channelsBlocState.channelsStream,
          emitsInOrder([
            isSameChannelListAs(channels),
            isSameChannelListAs(newChannels),
          ]),
        );

        verify(() => mockClient.on(EventType.messageNew)).called(1);
      },
    );

    testWidgets(
      'event channel should be moved to top of the list if present inside '
      'hiddenChannels list and shouldAddChannel is true when '
      'EventType.messageNew event is received',
      (tester) async {
        final hiddenChannelEventController = StreamController<Event>();

        addTearDown(() {
          hiddenChannelEventController.close();
        });

        final mockClient = MockClient();
        final channels = _generateChannels(mockClient);
        const channelsBlocKey = Key('channelsBloc');
        final channelsBloc = ChannelsBloc(
          key: channelsBlocKey,
          child: Offstage(),
          shouldAddChannel: (e) => channels.map((it) => it.cid).contains(e.cid),
        );

        when(() => mockClient.on(any(), any(), any(), any()))
            .thenAnswer((_) => Stream.empty());

        when(() => mockClient.on(
              EventType.channelHidden,
            )).thenAnswer((_) => hiddenChannelEventController.stream);

        when(() => mockClient.on(
              EventType.messageNew,
            )).thenAnswer((_) => eventController.stream);

        final messageNewEvent = Event(
          type: EventType.messageNew,
          cid: channels.last.cid,
        );

        await tester.pumpWidget(
          StreamChatCore(
            client: mockClient,
            child: channelsBloc,
          ),
        );

        final channelsBlocState = tester.state<ChannelsBlocState>(
          find.byKey(channelsBlocKey),
        );

        when(() => mockClient.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              options: any(named: 'options'),
              paginationParams: any(named: 'paginationParams'),
            )).thenAnswer(
          (_) => Stream.value(channels),
        );

        await channelsBlocState.queryChannels();

        verify(() => mockClient.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              options: any(named: 'options'),
              paginationParams: any(named: 'paginationParams'),
            )).called(1);

        final channelHiddenEvent = Event(
          type: EventType.channelHidden,
          cid: channels.last.cid,
        );

        // Hiding the channel before passing messageNew event
        hiddenChannelEventController.add(channelHiddenEvent);

        final channelsAfterHiddenEvent = [...channels]..removeLast();

        eventController.add(messageNewEvent);

        final channelCid = messageNewEvent.cid;
        final index = channels.indexWhere((it) => it.cid == channelCid);
        final newChannels = [...channels]
          ..removeAt(index)
          ..insert(0, channels[index]);

        await expectLater(
          channelsBlocState.channelsStream,
          emitsInOrder([
            isSameChannelListAs(channels),
            isSameChannelListAs(channelsAfterHiddenEvent),
            isSameChannelListAs(newChannels),
          ]),
        );

        verify(() => mockClient.on(EventType.channelHidden)).called(1);
        verify(() => mockClient.on(EventType.messageNew)).called(1);
      },
    );

    testWidgets(
      'event channel should be moved to top of the list if present inside '
      'channel state and shouldAddChannel is true when '
      'EventType.messageNew event is received',
      (tester) async {
        final mockClient = MockClient();
        final channels = _generateChannels(mockClient);
        final stateChannels = {
          for (var c in _generateChannels(mockClient, offset: 5)) c.cid: c
        };
        const channelsBlocKey = Key('channelsBloc');
        final channelsBloc = ChannelsBloc(
          key: channelsBlocKey,
          child: Offstage(),
          shouldAddChannel: (_) => true,
        );

        when(() => mockClient.state.channels).thenReturn(stateChannels);

        when(() => mockClient.on(any(), any(), any(), any()))
            .thenAnswer((_) => Stream.empty());

        when(() => mockClient.on(
              EventType.messageNew,
            )).thenAnswer((_) => eventController.stream);

        await tester.pumpWidget(
          StreamChatCore(
            client: mockClient,
            child: channelsBloc,
          ),
        );

        final channelsBlocState = tester.state<ChannelsBlocState>(
          find.byKey(channelsBlocKey),
        );

        when(() => mockClient.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              options: any(named: 'options'),
              paginationParams: any(named: 'paginationParams'),
            )).thenAnswer(
          (_) => Stream.value(channels),
        );

        await channelsBlocState.queryChannels();

        verify(() => mockClient.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              options: any(named: 'options'),
              paginationParams: any(named: 'paginationParams'),
            )).called(1);

        final messageNewEvent = Event(
          type: EventType.messageNew,
          cid: stateChannels.keys.first,
        );

        eventController.add(messageNewEvent);

        final newChannels = [...channels]
          ..insert(0, stateChannels[stateChannels.keys.first]!);

        await expectLater(
          channelsBlocState.channelsStream,
          emitsInOrder([
            isSameChannelListAs(channels),
            isSameChannelListAs(newChannels),
          ]),
        );

        verify(() => mockClient.on(EventType.messageNew)).called(1);
      },
    );

    testWidgets(
      'channels should get sorted according to channelsComparator when '
      'EventType.messageNew event is received',
      (tester) async {
        final mockClient = MockClient();
        final channels = _generateChannels(mockClient);
        int channelComparator(Channel a, Channel b) {
          final aData = a.extraData!['extra_data_key'] as String;
          final bData = b.extraData!['extra_data_key'] as String;
          return bData.compareTo(aData);
        }

        const channelsBlocKey = Key('channelsBloc');
        final channelsBloc = ChannelsBloc(
          key: channelsBlocKey,
          child: Offstage(),
          shouldAddChannel: (_) => true,
          channelsComparator: channelComparator,
        );

        when(() => mockClient.on(any(), any(), any(), any()))
            .thenAnswer((_) => Stream.empty());

        when(() => mockClient.on(
              EventType.messageNew,
            )).thenAnswer((_) => eventController.stream);

        await tester.pumpWidget(
          StreamChatCore(
            client: mockClient,
            child: channelsBloc,
          ),
        );

        final channelsBlocState = tester.state<ChannelsBlocState>(
          find.byKey(channelsBlocKey),
        );

        when(() => mockClient.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              options: any(named: 'options'),
              paginationParams: any(named: 'paginationParams'),
            )).thenAnswer(
          (_) => Stream.value(channels),
        );

        await channelsBlocState.queryChannels();

        verify(() => mockClient.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              options: any(named: 'options'),
              paginationParams: any(named: 'paginationParams'),
            )).called(1);

        final messageNewEvent = Event(
          type: EventType.messageNew,
          cid: channels.first.cid,
        );

        eventController.add(messageNewEvent);

        final newChannels = [...channels]..sort(channelComparator);

        await expectLater(
          channelsBlocState.channelsStream,
          emitsInOrder([
            isSameChannelListAs(channels),
            isSameChannelListAs(newChannels),
          ]),
        );

        verify(() => mockClient.on(EventType.messageNew)).called(1);
      },
    );

    tearDown(() {
      eventController.close();
    });
  });
}
