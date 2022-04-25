// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter_core/src/message_search_list_core.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import 'mocks.dart';

const testFilter = Filter.custom(key: 'test', value: 'testValue');
const testMessageFilter = Filter.custom(key: 'test', value: 'testValue');

void main() {
  List<GetMessageResponse> _generateMessages({
    int count = 3,
    int offset = 0,
  }) =>
      List.generate(
        count,
        (index) {
          index = index + offset;
          return GetMessageResponse()
            ..message = Message(
              id: 'testId$index',
              text: 'testTextData$index',
            )
            ..channel = ChannelModel(
              cid: 'test:Cid',
            );
        },
      );

  testWidgets(
    'should throw if both `messageQuery` and `messageFilters` are provided',
    (tester) async {
      expect(
        () => MessageSearchListCore(
          childBuilder: (_) => const Offstage(),
          loadingBuilder: (_) => const Offstage(),
          emptyBuilder: (_) => const Offstage(),
          errorBuilder: (_, __) => const Offstage(),
          filters: testFilter,
          messageFilters: testMessageFilter,
          messageQuery: 'test',
        ),
        throwsAssertionError,
      );
    },
  );

  testWidgets(
    'should throw if both `messageQuery` and `messageFilters` are not provided',
    (tester) async {
      expect(
        () => MessageSearchListCore(
          childBuilder: (_) => const Offstage(),
          loadingBuilder: (_) => const Offstage(),
          emptyBuilder: (_) => const Offstage(),
          errorBuilder: (_, __) => const Offstage(),
          filters: testFilter,
        ),
        throwsAssertionError,
      );
    },
  );

  testWidgets(
    'should throw if MessageSearchListCore is used where MessageSearchBloc '
    'is not present in the widget tree',
    (tester) async {
      const messageSearchListCoreKey = Key('messageSearchListCore');
      final messageSearchListCore = MessageSearchListCore(
        key: messageSearchListCoreKey,
        childBuilder: (List<GetMessageResponse>? messages) => const Offstage(),
        loadingBuilder: (BuildContext context) => const Offstage(),
        emptyBuilder: (BuildContext context) => const Offstage(),
        errorBuilder: (BuildContext context, Object? error) => const Offstage(),
        filters: testFilter,
        messageFilters: testMessageFilter,
      );

      await tester.pumpWidget(messageSearchListCore);

      expect(find.byKey(messageSearchListCoreKey), findsNothing);
      expect(tester.takeException(), isInstanceOf<AssertionError>());
    },
  );

  testWidgets(
    'should render MessageSearchListCore if used with '
    'MessageSearchListCore as an ancestor',
    (tester) async {
      const messageSearchListCoreKey = Key('messageSearchListCore');
      final messageSearchListCore = MessageSearchListCore(
        key: messageSearchListCoreKey,
        childBuilder: (List<GetMessageResponse> messages) => const Offstage(),
        loadingBuilder: (BuildContext context) => const Offstage(),
        emptyBuilder: (BuildContext context) => const Offstage(),
        errorBuilder: (BuildContext context, Object? error) => const Offstage(),
        filters: testFilter,
        messageFilters: testMessageFilter,
      );

      final mockClient = MockClient();

      await tester.pumpWidget(
        StreamChatCore(
          client: mockClient,
          child: MessageSearchBloc(
            child: messageSearchListCore,
          ),
        ),
      );

      expect(find.byKey(messageSearchListCoreKey), findsOneWidget);
    },
  );

  testWidgets(
    'should assign loadData and paginateData callback to '
    'UserListController if passed',
    (tester) async {
      const messageSearchListCoreKey = Key('messageSearchListCore');
      final controller = MessageSearchListController();
      final messageSearchListCore = MessageSearchListCore(
        key: messageSearchListCoreKey,
        childBuilder: (List<GetMessageResponse> messages) => const Offstage(),
        loadingBuilder: (BuildContext context) => const Offstage(),
        emptyBuilder: (BuildContext context) => const Offstage(),
        errorBuilder: (BuildContext context, Object error) => const Offstage(),
        messageSearchListController: controller,
        filters: testFilter,
        messageFilters: testMessageFilter,
      );

      expect(controller.loadData, isNull);
      expect(controller.paginateData, isNull);

      final mockClient = MockClient();

      await tester.pumpWidget(
        StreamChatCore(
          client: mockClient,
          child: MessageSearchBloc(
            child: messageSearchListCore,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(messageSearchListCoreKey), findsOneWidget);
      expect(controller.loadData, isNotNull);
      expect(controller.paginateData, isNotNull);
    },
  );

  testWidgets(
    'should build error widget if messageSearchBloc.messagesStream emits error',
    (tester) async {
      const messageSearchListCoreKey = Key('messageSearchListCore');
      const errorWidgetKey = Key('errorWidget');
      final messageSearchListCore = MessageSearchListCore(
        key: messageSearchListCoreKey,
        childBuilder: (List<GetMessageResponse> messages) => const Offstage(),
        loadingBuilder: (BuildContext context) => const Offstage(),
        emptyBuilder: (BuildContext context) => const Offstage(),
        errorBuilder: (BuildContext context, Object error) => const Offstage(
          key: errorWidgetKey,
        ),
        filters: testFilter,
        messageFilters: testMessageFilter,
      );

      final mockClient = MockClient();

      const error = 'Error! Error! Error!';
      when(() => mockClient.search(
            testFilter,
            query: any(named: 'query'),
            sort: any(named: 'sort'),
            messageFilters: testMessageFilter,
            paginationParams: any(named: 'paginationParams'),
          )).thenThrow(error);

      await tester.pumpWidget(
        StreamChatCore(
          client: mockClient,
          child: MessageSearchBloc(
            child: messageSearchListCore,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(errorWidgetKey), findsOneWidget);

      verify(() => mockClient.search(
            testFilter,
            query: any(named: 'query'),
            sort: any(named: 'sort'),
            messageFilters: testMessageFilter,
            paginationParams: any(named: 'paginationParams'),
          )).called(1);
    },
  );

  testWidgets(
    'should build empty widget if messageSearchBloc.messagesStream '
    'emits empty data',
    (tester) async {
      const messageSearchListCoreKey = Key('messageSearchListCore');
      const emptyWidgetKey = Key('emptyWidget');
      final messageSearchListCore = MessageSearchListCore(
        key: messageSearchListCoreKey,
        childBuilder: (List<GetMessageResponse> messages) => const Offstage(),
        loadingBuilder: (BuildContext context) => const Offstage(),
        emptyBuilder: (BuildContext context) =>
            const Offstage(key: emptyWidgetKey),
        errorBuilder: (BuildContext context, Object error) => const Offstage(),
        filters: testFilter,
        messageFilters: testMessageFilter,
      );

      final mockClient = MockClient();

      final messageResponseList = <GetMessageResponse>[];
      when(() => mockClient.search(
            testFilter,
            query: any(named: 'query'),
            sort: any(named: 'sort'),
            messageFilters: testMessageFilter,
            paginationParams: any(named: 'paginationParams'),
          )).thenAnswer(
        (_) async => SearchMessagesResponse()
          ..results = messageResponseList
          ..next = null
          ..previous = null,
      );

      await tester.pumpWidget(
        StreamChatCore(
          client: mockClient,
          child: MessageSearchBloc(
            child: messageSearchListCore,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(emptyWidgetKey), findsOneWidget);

      verify(() => mockClient.search(
            testFilter,
            query: any(named: 'query'),
            sort: any(named: 'sort'),
            messageFilters: testMessageFilter,
            paginationParams: any(named: 'paginationParams'),
          )).called(1);
    },
  );

  testWidgets(
    'should build child widget if usersBlocState.usersStream emits some data',
    (tester) async {
      const messageSearchListCoreKey = Key('messageSearchListCore');
      const childWidgetKey = Key('childWidget');
      final messageSearchListCore = MessageSearchListCore(
        key: messageSearchListCoreKey,
        childBuilder: (List<GetMessageResponse> messages) => const Offstage(
          key: childWidgetKey,
        ),
        loadingBuilder: (BuildContext context) => const Offstage(),
        emptyBuilder: (BuildContext context) => const Offstage(),
        errorBuilder: (BuildContext context, Object error) => const Offstage(),
        filters: testFilter,
        messageFilters: testMessageFilter,
      );

      final mockClient = MockClient();

      final messageResponseList = _generateMessages();
      when(() => mockClient.search(
            testFilter,
            query: any(named: 'query'),
            sort: any(named: 'sort'),
            messageFilters: testMessageFilter,
            paginationParams: any(named: 'paginationParams'),
          )).thenAnswer(
        (_) async => SearchMessagesResponse()
          ..results = messageResponseList
          ..next = null
          ..previous = null,
      );

      await tester.pumpWidget(
        StreamChatCore(
          client: mockClient,
          child: MessageSearchBloc(
            child: messageSearchListCore,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(childWidgetKey), findsOneWidget);

      verify(() => mockClient.search(
            testFilter,
            query: any(named: 'query'),
            sort: any(named: 'sort'),
            messageFilters: testMessageFilter,
            paginationParams: any(named: 'paginationParams'),
          )).called(1);
    },
  );

  testWidgets(
    'should build child widget with paginated data '
    'on calling channelListCoreState.paginateData',
    (tester) async {
      const messageSearchListCoreKey = Key('messageSearchListCore');
      const childWidgetKey = Key('childWidget');
      const pagination = PaginationParams(limit: 25);
      final messageSearchListCore = MessageSearchListCore(
        key: messageSearchListCoreKey,
        childBuilder: (List<GetMessageResponse> messages) => Container(
          key: childWidgetKey,
          child: Text(
            messages.map((e) => '${e.channel?.cid}-${e.message.id}').join(','),
          ),
        ),
        loadingBuilder: (BuildContext context) => const Offstage(),
        emptyBuilder: (BuildContext context) => const Offstage(),
        errorBuilder: (BuildContext context, Object error) => const Offstage(),
        limit: pagination.limit,
        filters: testFilter,
        messageFilters: testMessageFilter,
      );

      final mockClient = MockClient();

      final messageResponseList = _generateMessages(count: 25);
      when(() => mockClient.search(
            testFilter,
            query: any(named: 'query'),
            sort: any(named: 'sort'),
            messageFilters: testMessageFilter,
            paginationParams: pagination,
          )).thenAnswer(
        (_) async => SearchMessagesResponse()
          ..results = messageResponseList
          ..next = null
          ..previous = null,
      );

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: StreamChatCore(
            client: mockClient,
            child: MessageSearchBloc(
              child: messageSearchListCore,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(childWidgetKey), findsOneWidget);
      expect(
        find.text(
          messageResponseList
              .map((e) => '${e.channel?.cid}-${e.message.id}')
              .join(','),
        ),
        findsOneWidget,
      );

      verify(() => mockClient.search(
            testFilter,
            query: any(named: 'query'),
            sort: any(named: 'sort'),
            messageFilters: testMessageFilter,
            paginationParams: pagination,
          )).called(1);

      final messageSearchListCoreState =
          tester.state<MessageSearchListCoreState>(
        find.byKey(messageSearchListCoreKey),
      );

      final offset = messageResponseList.length;
      final paginatedMessageResponseList = _generateMessages(offset: offset);
      final updatedPagination = pagination.copyWith(offset: offset);
      when(() => mockClient.search(
            testFilter,
            query: any(named: 'query'),
            sort: any(named: 'sort'),
            messageFilters: testMessageFilter,
            paginationParams: updatedPagination,
          )).thenAnswer(
        (_) async => SearchMessagesResponse()
          ..results = paginatedMessageResponseList
          ..next = null
          ..previous = null,
      );

      await messageSearchListCoreState.paginateData();

      await tester.pumpAndSettle();

      expect(find.byKey(childWidgetKey), findsOneWidget);
      expect(
        find.text([
          ...messageResponseList,
          ...paginatedMessageResponseList,
        ].map((e) => '${e.channel?.cid}-${e.message.id}').join(',')),
        findsOneWidget,
      );

      verify(() => mockClient.search(
            testFilter,
            query: any(named: 'query'),
            sort: any(named: 'sort'),
            messageFilters: testMessageFilter,
            paginationParams: updatedPagination,
          )).called(1);
    },
  );

  testWidgets(
    'should rebuild MessageSearchListCore with updated widget data '
    'on calling setState()',
    (tester) async {
      const pagination = PaginationParams();

      StateSetter? _stateSetter;
      var limit = pagination.limit;

      const messageSearchListCoreKey = Key('messageSearchListCore');
      const childWidgetKey = Key('childWidget');
      MessageSearchListCore messageSearchListCoreBuilder(int limit) =>
          MessageSearchListCore(
            key: messageSearchListCoreKey,
            childBuilder: (List<GetMessageResponse> messages) => Container(
              key: childWidgetKey,
              child: Text(
                messages
                    .map((e) => '${e.channel?.cid}-${e.message.id}')
                    .join(','),
              ),
            ),
            loadingBuilder: (BuildContext context) => const Offstage(),
            emptyBuilder: (BuildContext context) => const Offstage(),
            errorBuilder: (BuildContext context, Object error) =>
                const Offstage(),
            limit: limit,
            filters: testFilter,
            messageFilters: testMessageFilter,
          );

      final mockClient = MockClient();

      final messageResponseList = _generateMessages();
      when(() => mockClient.search(
            testFilter,
            query: any(named: 'query'),
            sort: any(named: 'sort'),
            messageFilters: testMessageFilter,
            paginationParams: pagination,
          )).thenAnswer(
        (_) async => SearchMessagesResponse()
          ..results = messageResponseList
          ..next = null
          ..previous = null,
      );

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: StreamChatCore(
            client: mockClient,
            child: MessageSearchBloc(
              child: StatefulBuilder(builder: (context, stateSetter) {
                // Assigning stateSetter for rebuilding UserListCore
                _stateSetter = stateSetter;
                return messageSearchListCoreBuilder(limit);
              }),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(childWidgetKey), findsOneWidget);
      expect(
        find.text(
          messageResponseList
              .map((e) => '${e.channel?.cid}-${e.message.id}')
              .join(','),
        ),
        findsOneWidget,
      );

      verify(() => mockClient.search(
            testFilter,
            query: any(named: 'query'),
            sort: any(named: 'sort'),
            messageFilters: testMessageFilter,
            paginationParams: pagination,
          )).called(1);

      // Rebuilding MessageSearchListCore with new pagination limit
      _stateSetter?.call(() => limit = 6);

      final updatedMessageResponseList = _generateMessages(count: limit);
      final updatedPagination = PaginationParams(limit: limit);
      when(() => mockClient.search(
            testFilter,
            query: any(named: 'query'),
            sort: any(named: 'sort'),
            messageFilters: testMessageFilter,
            paginationParams: updatedPagination,
          )).thenAnswer(
        (_) async => SearchMessagesResponse()
          ..results = updatedMessageResponseList
          ..next = null
          ..previous = null,
      );

      await tester.pumpAndSettle();

      expect(find.byKey(childWidgetKey), findsOneWidget);
      expect(
        find.text(updatedMessageResponseList
            .map((e) => '${e.channel?.cid}-${e.message.id}')
            .join(',')),
        findsOneWidget,
      );

      verify(() => mockClient.search(
            testFilter,
            query: any(named: 'query'),
            sort: any(named: 'sort'),
            messageFilters: testMessageFilter,
            paginationParams: updatedPagination,
          )).called(1);
    },
  );

  test('`widget.limit` should match `widget.pagination.limit`', () {
    const pagination = PaginationParams(limit: 30);
    final messageSearchListCore = MessageSearchListCore(
      childBuilder: (List<GetMessageResponse> messages) => const Offstage(),
      loadingBuilder: (BuildContext context) => const Offstage(),
      emptyBuilder: (BuildContext context) => const Offstage(),
      errorBuilder: (BuildContext context, Object? error) => const Offstage(),
      filters: testFilter,
      messageFilters: testMessageFilter,
      limit: pagination.limit,
    );

    expect(messageSearchListCore.limit, pagination.limit);
  });
}
