import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter_core/src/channel_list_core.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import 'mocks.dart';

void main() {
  const pagination = PaginationParams(limit: 3);

  List<Channel> _generateChannels(
    StreamChatClient client, {
    int count = 3,
    int offset = 0,
  }) =>
      List.generate(
        count,
        (index) {
          index = index + offset;
          return Channel(
            client,
            'testType$index',
            'testId$index',
            extraData: {'extra_data_key': 'extra_data_value_$index'},
          );
        },
      );

  testWidgets(
    'should throw if ChannelListCore is used where ChannelsBloc is not present '
    'in the widget tree',
    (tester) async {
      const channelListCoreKey = Key('channelListCore');
      final channelListCore = ChannelListCore(
        key: channelListCoreKey,
        listBuilder: (_, __) => const Offstage(),
        loadingBuilder: (BuildContext context) => const Offstage(),
        emptyBuilder: (BuildContext context) => const Offstage(),
        errorBuilder: (BuildContext context, Object error) => const Offstage(),
      );

      await tester.pumpWidget(channelListCore);

      expect(find.byKey(channelListCoreKey), findsNothing);
      expect(tester.takeException(), isInstanceOf<AssertionError>());
    },
  );

  testWidgets(
    'should render ChannelListCore if used with ChannelsBloc as an ancestor',
    (tester) async {
      const channelListCoreKey = Key('channelListCore');
      final channelListCore = ChannelListCore(
        key: channelListCoreKey,
        listBuilder: (_, __) => const Offstage(),
        loadingBuilder: (BuildContext context) => const Offstage(),
        emptyBuilder: (BuildContext context) => const Offstage(),
        errorBuilder: (BuildContext context, Object error) => const Offstage(),
      );

      final mockClient = MockClient();

      when(() => mockClient.on(any(), any(), any(), any()))
          .thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(
        StreamChatCore(
          client: mockClient,
          child: ChannelsBloc(
            child: channelListCore,
          ),
        ),
      );

      expect(find.byKey(channelListCoreKey), findsOneWidget);
    },
  );

  testWidgets(
    'should assign loadData and paginateData callback to '
    'ChannelListController if passed',
    (tester) async {
      const channelListCoreKey = Key('channelListCore');
      final controller = ChannelListController();
      final channelListCore = ChannelListCore(
        key: channelListCoreKey,
        listBuilder: (_, __) => const Offstage(),
        loadingBuilder: (BuildContext context) => const Offstage(),
        emptyBuilder: (BuildContext context) => const Offstage(),
        errorBuilder: (BuildContext context, Object error) => const Offstage(),
        channelListController: controller,
      );

      expect(controller.loadData, isNull);
      expect(controller.paginateData, isNull);

      final mockClient = MockClient();

      when(() => mockClient.on(any(), any(), any(), any()))
          .thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(
        StreamChatCore(
          client: mockClient,
          child: ChannelsBloc(
            child: channelListCore,
          ),
        ),
      );

      expect(find.byKey(channelListCoreKey), findsOneWidget);
      expect(controller.loadData, isNotNull);
      expect(controller.paginateData, isNotNull);
    },
  );

  testWidgets(
    'should build error widget if channelsBlocState.channelsStream emits error',
    (tester) async {
      const channelListCoreKey = Key('channelListCore');
      const errorWidgetKey = Key('errorWidget');
      final channelListCore = ChannelListCore(
        key: channelListCoreKey,
        listBuilder: (_, __) => const Offstage(),
        loadingBuilder: (BuildContext context) => const Offstage(),
        emptyBuilder: (BuildContext context) => const Offstage(),
        errorBuilder: (BuildContext context, Object error) =>
            Container(key: errorWidgetKey),
        pagination: pagination,
      );

      final mockClient = MockClient();

      when(() => mockClient.on(any(), any(), any(), any()))
          .thenAnswer((_) => const Stream.empty());

      const error = 'Error! Error! Error!';
      when(() => mockClient.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: any(named: 'messageLimit'),
            paginationParams: pagination,
          )).thenThrow(error);

      await tester.pumpWidget(
        StreamChatCore(
          client: mockClient,
          child: ChannelsBloc(
            child: channelListCore,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(errorWidgetKey), findsOneWidget);

      verify(() => mockClient.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: any(named: 'messageLimit'),
            paginationParams: pagination,
          )).called(1);
    },
  );

  testWidgets(
    '''should build empty widget if channelsBlocState.channelsStream emits empty data''',
    (tester) async {
      const channelListCoreKey = Key('channelListCore');
      const emptyWidgetKey = Key('emptyWidget');
      final channelListCore = ChannelListCore(
        key: channelListCoreKey,
        listBuilder: (_, __) => const Offstage(),
        loadingBuilder: (BuildContext context) => const Offstage(),
        emptyBuilder: (BuildContext context) => Container(key: emptyWidgetKey),
        errorBuilder: (BuildContext context, Object error) => const Offstage(),
        pagination: pagination,
      );

      final mockClient = MockClient();

      when(() => mockClient.on(any(), any(), any(), any()))
          .thenAnswer((_) => const Stream.empty());

      const channels = <Channel>[];
      when(() => mockClient.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: any(named: 'messageLimit'),
            paginationParams: pagination,
          )).thenAnswer((_) => Stream.value(channels));

      await tester.pumpWidget(
        StreamChatCore(
          client: mockClient,
          child: ChannelsBloc(
            child: channelListCore,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(emptyWidgetKey), findsOneWidget);

      verify(() => mockClient.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: any(named: 'messageLimit'),
            paginationParams: pagination,
          )).called(1);
    },
  );

  testWidgets(
    '''should build list widget if channelsBlocState.channelsStream emits some data''',
    (tester) async {
      const channelListCoreKey = Key('channelListCore');
      const listWidgetKey = Key('listWidget');
      final channelListCore = ChannelListCore(
        key: channelListCoreKey,
        listBuilder: (_, __) => Container(key: listWidgetKey),
        loadingBuilder: (BuildContext context) => const Offstage(),
        emptyBuilder: (BuildContext context) => const Offstage(),
        errorBuilder: (BuildContext context, Object error) => const Offstage(),
        pagination: pagination,
      );

      final mockClient = MockClient();

      when(() => mockClient.on(any(), any(), any(), any()))
          .thenAnswer((_) => const Stream.empty());

      final channels = _generateChannels(mockClient);
      when(() => mockClient.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: any(named: 'messageLimit'),
            paginationParams: pagination,
          )).thenAnswer((_) => Stream.value(channels));

      await tester.pumpWidget(
        StreamChatCore(
          client: mockClient,
          child: ChannelsBloc(
            child: channelListCore,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(listWidgetKey), findsOneWidget);

      verify(() => mockClient.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: any(named: 'messageLimit'),
            paginationParams: pagination,
          )).called(1);
    },
  );

  testWidgets(
    'should build list widget with paginated data '
    'on calling channelListCoreState.paginateData',
    (tester) async {
      const channelListCoreKey = Key('channelListCore');
      const listWidgetKey = Key('listWidget');
      final channelListCore = ChannelListCore(
        key: channelListCoreKey,
        listBuilder: (_, channels) => Container(
          key: listWidgetKey,
          child: Text(
            channels.map((e) => e.cid).join(','),
          ),
        ),
        loadingBuilder: (BuildContext context) => const Offstage(),
        emptyBuilder: (BuildContext context) => const Offstage(),
        errorBuilder: (BuildContext context, Object error) => const Offstage(),
        pagination: pagination,
      );

      final mockClient = MockClient();

      when(() => mockClient.on(any(), any(), any(), any()))
          .thenAnswer((_) => const Stream.empty());

      final channels = _generateChannels(mockClient);
      when(() => mockClient.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: any(named: 'messageLimit'),
            paginationParams: pagination,
          )).thenAnswer((_) => Stream.value(channels));

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: StreamChatCore(
            client: mockClient,
            child: ChannelsBloc(
              child: channelListCore,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(listWidgetKey), findsOneWidget);
      expect(find.text(channels.map((e) => e.cid).join(',')), findsOneWidget);

      verify(() => mockClient.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: any(named: 'messageLimit'),
            paginationParams: pagination,
          )).called(1);

      final channelListCoreState = tester.state<ChannelListCoreState>(
        find.byKey(channelListCoreKey),
      );

      final offset = channels.length;
      final paginatedChannels = _generateChannels(mockClient, offset: offset);
      final updatedPagination = pagination.copyWith(offset: offset);
      when(() => mockClient.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: any(named: 'messageLimit'),
            paginationParams: updatedPagination,
          )).thenAnswer((_) => Stream.value(paginatedChannels));

      await channelListCoreState.paginateData();

      await tester.pumpAndSettle();

      expect(find.byKey(listWidgetKey), findsOneWidget);
      expect(
        find.text([
          ...channels,
          ...paginatedChannels,
        ].map((e) => e.cid).join(',')),
        findsOneWidget,
      );

      verify(() => mockClient.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: any(named: 'messageLimit'),
            paginationParams: updatedPagination,
          )).called(1);
    },
  );

  testWidgets(
    'should rebuild ChannelListCore with updated widget data '
    'on calling setState()',
    (tester) async {
      StateSetter? _stateSetter;
      var limit = pagination.limit;

      const channelListCoreKey = Key('channelListCore');
      const listWidgetKey = Key('listWidget');

      ChannelListCore channelListCoreBuilder(int limit) => ChannelListCore(
            key: channelListCoreKey,
            listBuilder: (_, channels) => Container(
              key: listWidgetKey,
              child: Text(
                channels.map((e) => e.cid).join(','),
              ),
            ),
            loadingBuilder: (BuildContext context) => const Offstage(),
            emptyBuilder: (BuildContext context) => const Offstage(),
            errorBuilder: (BuildContext context, Object error) =>
                const Offstage(),
            pagination: pagination.copyWith(limit: limit),
          );

      final mockClient = MockClient();

      when(() => mockClient.on(any(), any(), any(), any()))
          .thenAnswer((_) => const Stream.empty());

      final channels = _generateChannels(mockClient);
      when(() => mockClient.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: any(named: 'messageLimit'),
            paginationParams: pagination,
          )).thenAnswer((_) => Stream.value(channels));

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: StreamChatCore(
            client: mockClient,
            child: ChannelsBloc(
              child: StatefulBuilder(builder: (context, stateSetter) {
                // Assigning stateSetter for rebuilding ChannelListCore
                _stateSetter = stateSetter;
                return channelListCoreBuilder(limit);
              }),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(listWidgetKey), findsOneWidget);
      expect(find.text(channels.map((e) => e.cid).join(',')), findsOneWidget);

      verify(() => mockClient.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: any(named: 'messageLimit'),
            paginationParams: pagination,
          )).called(1);

      // Rebuilding ChannelListCore with new pagination limit
      _stateSetter?.call(() => limit = 6);

      final updatedChannels = _generateChannels(mockClient, count: limit);
      final updatedPagination = pagination.copyWith(limit: limit);
      when(() => mockClient.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: any(named: 'messageLimit'),
            paginationParams: updatedPagination,
          )).thenAnswer((_) => Stream.value(updatedChannels));

      await tester.pumpAndSettle();

      expect(find.byKey(listWidgetKey), findsOneWidget);
      expect(
        find.text(updatedChannels.map((e) => e.cid).join(',')),
        findsOneWidget,
      );

      verify(() => mockClient.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: any(named: 'messageLimit'),
            paginationParams: updatedPagination,
          )).called(1);
    },
  );
}
