import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mockito/mockito.dart';
import 'package:stream_chat_flutter_core/src/channel_list_core.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import 'mocks.dart';

void main() {
  const pagination = PaginationParams(offset: 0, limit: 3);

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

  test(
    'should throw assertion error in case listBuilder is null',
    () {
      final channelListCore = () => ChannelListCore(
            listBuilder: null,
            loadingBuilder: (BuildContext context) => Offstage(),
            emptyBuilder: (BuildContext context) => Offstage(),
            errorBuilder: (BuildContext context, Object error) => Offstage(),
          );
      expect(channelListCore, throwsA(isA<AssertionError>()));
    },
  );

  test(
    'should throw assertion error in case loadingBuilder is null',
    () {
      final channelListCore = () => ChannelListCore(
            listBuilder: (_, __) => Offstage(),
            loadingBuilder: null,
            emptyBuilder: (BuildContext context) => Offstage(),
            errorBuilder: (BuildContext context, Object error) => Offstage(),
          );
      expect(channelListCore, throwsA(isA<AssertionError>()));
    },
  );

  test(
    'should throw assertion error in case emptyBuilder is null',
    () {
      final channelListCore = () => ChannelListCore(
            listBuilder: (_, __) => Offstage(),
            loadingBuilder: (BuildContext context) => Offstage(),
            emptyBuilder: null,
            errorBuilder: (BuildContext context, Object error) => Offstage(),
          );
      expect(channelListCore, throwsA(isA<AssertionError>()));
    },
  );

  test(
    'should throw assertion error in case errorBuilder is null',
    () {
      final channelListCore = () => ChannelListCore(
            listBuilder: (_, __) => Offstage(),
            loadingBuilder: (BuildContext context) => Offstage(),
            emptyBuilder: (BuildContext context) => Offstage(),
            errorBuilder: null,
          );
      expect(channelListCore, throwsA(isA<AssertionError>()));
    },
  );

  testWidgets(
    'should throw if ChannelListCore is used where ChannelsBloc is not present '
    'in the widget tree',
    (tester) async {
      const channelListCoreKey = Key('channelListCore');
      final channelListCore = ChannelListCore(
        key: channelListCoreKey,
        listBuilder: (_, __) => Offstage(),
        loadingBuilder: (BuildContext context) => Offstage(),
        emptyBuilder: (BuildContext context) => Offstage(),
        errorBuilder: (BuildContext context, Object error) => Offstage(),
      );

      await tester.pumpWidget(channelListCore);

      expect(find.byKey(channelListCoreKey), findsNothing);
      expect(tester.takeException(), isInstanceOf<Exception>());
    },
  );

  testWidgets(
    'should render ChannelListCore if used with ChannelsBloc as an ancestor',
    (tester) async {
      const channelListCoreKey = Key('channelListCore');
      final channelListCore = ChannelListCore(
        key: channelListCoreKey,
        listBuilder: (_, __) => Offstage(),
        loadingBuilder: (BuildContext context) => Offstage(),
        emptyBuilder: (BuildContext context) => Offstage(),
        errorBuilder: (BuildContext context, Object error) => Offstage(),
      );

      final mockClient = MockClient();

      when(mockClient.on(any, any, any, any)).thenAnswer((_) => Stream.empty());

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
        listBuilder: (_, __) => Offstage(),
        loadingBuilder: (BuildContext context) => Offstage(),
        emptyBuilder: (BuildContext context) => Offstage(),
        errorBuilder: (BuildContext context, Object error) => Offstage(),
        channelListController: controller,
      );

      expect(controller.loadData, isNull);
      expect(controller.paginateData, isNull);

      final mockClient = MockClient();

      when(mockClient.on(any, any, any, any)).thenAnswer((_) => Stream.empty());

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
        listBuilder: (_, __) => Offstage(),
        loadingBuilder: (BuildContext context) => Offstage(),
        emptyBuilder: (BuildContext context) => Offstage(),
        errorBuilder: (BuildContext context, Object error) =>
            Container(key: errorWidgetKey),
        pagination: pagination,
      );

      final mockClient = MockClient();

      when(mockClient.on(any, any, any, any)).thenAnswer((_) => Stream.empty());

      const error = 'Error! Error! Error!';
      when(mockClient.queryChannels(
        filter: anyNamed('filter'),
        sort: anyNamed('sort'),
        options: anyNamed('options'),
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

      verify(mockClient.queryChannels(
        filter: anyNamed('filter'),
        sort: anyNamed('sort'),
        options: anyNamed('options'),
        paginationParams: pagination,
      )).called(1);
    },
  );

  testWidgets(
    'should build empty widget if channelsBlocState.channelsStream emits empty data',
    (tester) async {
      const channelListCoreKey = Key('channelListCore');
      const emptyWidgetKey = Key('emptyWidget');
      final channelListCore = ChannelListCore(
        key: channelListCoreKey,
        listBuilder: (_, __) => Offstage(),
        loadingBuilder: (BuildContext context) => Offstage(),
        emptyBuilder: (BuildContext context) => Container(key: emptyWidgetKey),
        errorBuilder: (BuildContext context, Object error) => Offstage(),
        pagination: pagination,
      );

      final mockClient = MockClient();

      when(mockClient.on(any, any, any, any)).thenAnswer((_) => Stream.empty());

      const channels = <Channel>[];
      when(mockClient.queryChannels(
        filter: anyNamed('filter'),
        sort: anyNamed('sort'),
        options: anyNamed('options'),
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

      verify(mockClient.queryChannels(
        filter: anyNamed('filter'),
        sort: anyNamed('sort'),
        options: anyNamed('options'),
        paginationParams: pagination,
      )).called(1);
    },
  );

  testWidgets(
    'should build list widget if channelsBlocState.channelsStream emits some data',
    (tester) async {
      const channelListCoreKey = Key('channelListCore');
      const listWidgetKey = Key('listWidget');
      final channelListCore = ChannelListCore(
        key: channelListCoreKey,
        listBuilder: (_, __) => Container(key: listWidgetKey),
        loadingBuilder: (BuildContext context) => Offstage(),
        emptyBuilder: (BuildContext context) => Offstage(),
        errorBuilder: (BuildContext context, Object error) => Offstage(),
        pagination: pagination,
      );

      final mockClient = MockClient();

      when(mockClient.on(any, any, any, any)).thenAnswer((_) => Stream.empty());

      final channels = _generateChannels(mockClient);
      when(mockClient.queryChannels(
        filter: anyNamed('filter'),
        sort: anyNamed('sort'),
        options: anyNamed('options'),
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

      verify(mockClient.queryChannels(
        filter: anyNamed('filter'),
        sort: anyNamed('sort'),
        options: anyNamed('options'),
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
        listBuilder: (_, channels) {
          return Container(
            key: listWidgetKey,
            child: Text(
              channels.map((e) => e.cid).join(','),
            ),
          );
        },
        loadingBuilder: (BuildContext context) => Offstage(),
        emptyBuilder: (BuildContext context) => Offstage(),
        errorBuilder: (BuildContext context, Object error) => Offstage(),
        pagination: pagination,
      );

      final mockClient = MockClient();

      when(mockClient.on(any, any, any, any)).thenAnswer((_) => Stream.empty());

      final channels = _generateChannels(mockClient);
      when(mockClient.queryChannels(
        filter: anyNamed('filter'),
        sort: anyNamed('sort'),
        options: anyNamed('options'),
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

      verify(mockClient.queryChannels(
        filter: anyNamed('filter'),
        sort: anyNamed('sort'),
        options: anyNamed('options'),
        paginationParams: pagination,
      )).called(1);

      final channelListCoreState = tester.state<ChannelListCoreState>(
        find.byKey(channelListCoreKey),
      );

      final offset = channels.length;
      final paginatedChannels = _generateChannels(mockClient, offset: offset);
      final updatedPagination = pagination.copyWith(offset: offset);
      when(mockClient.queryChannels(
        filter: anyNamed('filter'),
        sort: anyNamed('sort'),
        options: anyNamed('options'),
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

      verify(mockClient.queryChannels(
        filter: anyNamed('filter'),
        sort: anyNamed('sort'),
        options: anyNamed('options'),
        paginationParams: updatedPagination,
      )).called(1);
    },
  );

  testWidgets(
    'should rebuild ChannelListCore with updated widget data '
    'on calling setState()',
    (tester) async {
      StateSetter _stateSetter;
      int limit = pagination.limit;

      const channelListCoreKey = Key('channelListCore');
      const listWidgetKey = Key('listWidget');

      ChannelListCore channelListCoreBuilder(int limit) => ChannelListCore(
            key: channelListCoreKey,
            listBuilder: (_, channels) {
              return Container(
                key: listWidgetKey,
                child: Text(
                  channels.map((e) => e.cid).join(','),
                ),
              );
            },
            loadingBuilder: (BuildContext context) => Offstage(),
            emptyBuilder: (BuildContext context) => Offstage(),
            errorBuilder: (BuildContext context, Object error) => Offstage(),
            pagination: pagination.copyWith(limit: limit),
          );

      final mockClient = MockClient();

      when(mockClient.on(any, any, any, any)).thenAnswer((_) => Stream.empty());

      final channels = _generateChannels(mockClient);
      when(mockClient.queryChannels(
        filter: anyNamed('filter'),
        sort: anyNamed('sort'),
        options: anyNamed('options'),
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

      verify(mockClient.queryChannels(
        filter: anyNamed('filter'),
        sort: anyNamed('sort'),
        options: anyNamed('options'),
        paginationParams: pagination,
      )).called(1);

      // Rebuilding ChannelListCore with new pagination limit
      _stateSetter(() => limit = 6);

      final updatedChannels = _generateChannels(mockClient, count: limit);
      final updatedPagination = pagination.copyWith(limit: limit);
      when(mockClient.queryChannels(
        filter: anyNamed('filter'),
        sort: anyNamed('sort'),
        options: anyNamed('options'),
        paginationParams: updatedPagination,
      )).thenAnswer((_) => Stream.value(updatedChannels));

      await tester.pumpAndSettle();

      expect(find.byKey(listWidgetKey), findsOneWidget);
      expect(
        find.text(updatedChannels.map((e) => e.cid).join(',')),
        findsOneWidget,
      );

      verify(mockClient.queryChannels(
        filter: anyNamed('filter'),
        sort: anyNamed('sort'),
        options: anyNamed('options'),
        paginationParams: updatedPagination,
      )).called(1);
    },
  );
}
