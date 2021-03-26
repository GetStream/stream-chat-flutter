import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_chat_flutter_core/src/message_search_list_core.dart';

import 'mocks.dart';

void main() {
  List<GetMessageResponse> _generateMessages({
    int count = 3,
    int offset = 0,
  }) {
    return List.generate(
      count,
      (index) {
        index = index + offset;
        return GetMessageResponse()
          ..message = Message(
            id: 'testId$index',
            text: 'testTextData$index',
          )
          ..channel = ChannelModel(
            cid: 'testCid',
          );
      },
    );
  }

  test(
    'should throw assertion error in case childBuilder is null',
    () {
      final messageSearchListCore = () => MessageSearchListCore(
            childBuilder: null,
            loadingBuilder: (BuildContext context) => Offstage(),
            emptyBuilder: (BuildContext context) => Offstage(),
            errorBuilder: (BuildContext context, Object error) => Offstage(),
          );
      expect(messageSearchListCore, throwsA(isA<AssertionError>()));
    },
  );

  test(
    'should throw assertion error in case loadingBuilder is null',
    () {
      final messageSearchListCore = () => MessageSearchListCore(
            childBuilder: (List<GetMessageResponse> messages) => Offstage(),
            loadingBuilder: null,
            emptyBuilder: (BuildContext context) => Offstage(),
            errorBuilder: (BuildContext context, Object error) => Offstage(),
          );
      expect(messageSearchListCore, throwsA(isA<AssertionError>()));
    },
  );

  test(
    'should throw assertion error in case emptyBuilder is null',
    () {
      final messageSearchListCore = () => MessageSearchListCore(
            childBuilder: (List<GetMessageResponse> messages) => Offstage(),
            loadingBuilder: (BuildContext context) => Offstage(),
            emptyBuilder: null,
            errorBuilder: (BuildContext context, Object error) => Offstage(),
          );
      expect(messageSearchListCore, throwsA(isA<AssertionError>()));
    },
  );

  test(
    'should throw assertion error in case errorBuilder is null',
    () {
      final messageSearchListCore = () => MessageSearchListCore(
            childBuilder: (List<GetMessageResponse> messages) => Offstage(),
            loadingBuilder: (BuildContext context) => Offstage(),
            emptyBuilder: (BuildContext context) => Offstage(),
            errorBuilder: null,
          );
      expect(messageSearchListCore, throwsA(isA<AssertionError>()));
    },
  );

  testWidgets(
    'should throw if MessageSearchListCore is used where MessageSearchBloc '
    'is not present in the widget tree',
    (tester) async {
      const messageSearchListCoreKey = Key('messageSearchListCore');
      final messageSearchListCore = MessageSearchListCore(
        key: messageSearchListCoreKey,
        childBuilder: (List<GetMessageResponse> messages) => Offstage(),
        loadingBuilder: (BuildContext context) => Offstage(),
        emptyBuilder: (BuildContext context) => Offstage(),
        errorBuilder: (BuildContext context, Object error) => Offstage(),
      );

      await tester.pumpWidget(messageSearchListCore);

      expect(find.byKey(messageSearchListCoreKey), findsNothing);
      expect(tester.takeException(), isInstanceOf<Exception>());
    },
  );

  testWidgets(
    'should render MessageSearchListCore if used with '
    'MessageSearchListCore as an ancestor',
    (tester) async {
      const messageSearchListCoreKey = Key('messageSearchListCore');
      final messageSearchListCore = MessageSearchListCore(
        key: messageSearchListCoreKey,
        childBuilder: (List<GetMessageResponse> messages) => Offstage(),
        loadingBuilder: (BuildContext context) => Offstage(),
        emptyBuilder: (BuildContext context) => Offstage(),
        errorBuilder: (BuildContext context, Object error) => Offstage(),
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
        childBuilder: (List<GetMessageResponse> messages) => Offstage(),
        loadingBuilder: (BuildContext context) => Offstage(),
        emptyBuilder: (BuildContext context) => Offstage(),
        errorBuilder: (BuildContext context, Object error) => Offstage(),
        messageSearchListController: controller,
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
        childBuilder: (List<GetMessageResponse> messages) => Offstage(),
        loadingBuilder: (BuildContext context) => Offstage(),
        emptyBuilder: (BuildContext context) => Offstage(),
        errorBuilder: (BuildContext context, Object error) => Offstage(
          key: errorWidgetKey,
        ),
      );

      final mockClient = MockClient();

      const error = 'Error! Error! Error!';
      when(mockClient.search(
        any,
        query: anyNamed('query'),
        sort: anyNamed('sort'),
        messageFilters: anyNamed('messageFilters'),
        paginationParams: anyNamed('paginationParams'),
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

      verify(mockClient.search(
        any,
        query: anyNamed('query'),
        sort: anyNamed('sort'),
        messageFilters: anyNamed('messageFilters'),
        paginationParams: anyNamed('paginationParams'),
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
        childBuilder: (List<GetMessageResponse> messages) => Offstage(),
        loadingBuilder: (BuildContext context) => Offstage(),
        emptyBuilder: (BuildContext context) => Offstage(key: emptyWidgetKey),
        errorBuilder: (BuildContext context, Object error) => Offstage(),
      );

      final mockClient = MockClient();

      final messageResponseList = <GetMessageResponse>[];
      when(mockClient.search(
        any,
        query: anyNamed('query'),
        sort: anyNamed('sort'),
        messageFilters: anyNamed('messageFilters'),
        paginationParams: anyNamed('paginationParams'),
      )).thenAnswer(
        (_) async => SearchMessagesResponse()..results = messageResponseList,
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

      verify(mockClient.search(
        any,
        query: anyNamed('query'),
        sort: anyNamed('sort'),
        messageFilters: anyNamed('messageFilters'),
        paginationParams: anyNamed('paginationParams'),
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
        childBuilder: (List<GetMessageResponse> messages) => Offstage(
          key: childWidgetKey,
        ),
        loadingBuilder: (BuildContext context) => Offstage(),
        emptyBuilder: (BuildContext context) => Offstage(),
        errorBuilder: (BuildContext context, Object error) => Offstage(),
      );

      final mockClient = MockClient();

      final messageResponseList = _generateMessages();
      when(mockClient.search(
        any,
        query: anyNamed('query'),
        sort: anyNamed('sort'),
        messageFilters: anyNamed('messageFilters'),
        paginationParams: anyNamed('paginationParams'),
      )).thenAnswer(
        (_) async => SearchMessagesResponse()..results = messageResponseList,
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

      verify(mockClient.search(
        any,
        query: anyNamed('query'),
        sort: anyNamed('sort'),
        messageFilters: anyNamed('messageFilters'),
        paginationParams: anyNamed('paginationParams'),
      )).called(1);
    },
  );

  testWidgets(
    'should build child widget with paginated data '
    'on calling channelListCoreState.paginateData',
    (tester) async {
      const messageSearchListCoreKey = Key('messageSearchListCore');
      const childWidgetKey = Key('childWidget');
      const pagination = PaginationParams();
      final messageSearchListCore = MessageSearchListCore(
        key: messageSearchListCoreKey,
        childBuilder: (List<GetMessageResponse> messages) => Container(
          key: childWidgetKey,
          child: Text(
            messages.map((e) => '${e.channel.cid}-${e.message.id}').join(','),
          ),
        ),
        loadingBuilder: (BuildContext context) => Offstage(),
        emptyBuilder: (BuildContext context) => Offstage(),
        errorBuilder: (BuildContext context, Object error) => Offstage(),
        paginationParams: pagination,
      );

      final mockClient = MockClient();

      final messageResponseList = _generateMessages();
      when(mockClient.search(
        any,
        query: anyNamed('query'),
        sort: anyNamed('sort'),
        messageFilters: anyNamed('messageFilters'),
        paginationParams: pagination,
      )).thenAnswer(
        (_) async => SearchMessagesResponse()..results = messageResponseList,
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
              .map((e) => '${e.channel.cid}-${e.message.id}')
              .join(','),
        ),
        findsOneWidget,
      );

      verify(mockClient.search(
        any,
        query: anyNamed('query'),
        sort: anyNamed('sort'),
        messageFilters: anyNamed('messageFilters'),
        paginationParams: pagination,
      )).called(1);

      final messageSearchListCoreState =
          tester.state<MessageSearchListCoreState>(
        find.byKey(messageSearchListCoreKey),
      );

      final offset = messageResponseList.length;
      final paginatedMessageResponseList = _generateMessages(offset: offset);
      final updatedPagination = pagination.copyWith(offset: offset);
      when(mockClient.search(
        any,
        query: anyNamed('query'),
        sort: anyNamed('sort'),
        messageFilters: anyNamed('messageFilters'),
        paginationParams: updatedPagination,
      )).thenAnswer(
        (_) async =>
            SearchMessagesResponse()..results = paginatedMessageResponseList,
      );

      await messageSearchListCoreState.paginateData();

      await tester.pumpAndSettle();

      expect(find.byKey(childWidgetKey), findsOneWidget);
      expect(
        find.text([
          ...messageResponseList,
          ...paginatedMessageResponseList,
        ].map((e) => '${e.channel.cid}-${e.message.id}').join(',')),
        findsOneWidget,
      );

      verify(mockClient.search(
        any,
        query: anyNamed('query'),
        sort: anyNamed('sort'),
        messageFilters: anyNamed('messageFilters'),
        paginationParams: updatedPagination,
      )).called(1);
    },
  );

  testWidgets(
    'should rebuild MessageSearchListCore with updated widget data '
    'on calling setState()',
    (tester) async {
      const pagination = PaginationParams();

      StateSetter _stateSetter;
      int limit = pagination.limit;

      const messageSearchListCoreKey = Key('messageSearchListCore');
      const childWidgetKey = Key('childWidget');
      MessageSearchListCore messageSearchListCoreBuilder(int limit) =>
          MessageSearchListCore(
            key: messageSearchListCoreKey,
            childBuilder: (List<GetMessageResponse> messages) => Container(
              key: childWidgetKey,
              child: Text(
                messages
                    .map((e) => '${e.channel.cid}-${e.message.id}')
                    .join(','),
              ),
            ),
            loadingBuilder: (BuildContext context) => Offstage(),
            emptyBuilder: (BuildContext context) => Offstage(),
            errorBuilder: (BuildContext context, Object error) => Offstage(),
            paginationParams: pagination.copyWith(limit: limit),
          );

      final mockClient = MockClient();

      final messageResponseList = _generateMessages();
      when(mockClient.search(
        any,
        query: anyNamed('query'),
        sort: anyNamed('sort'),
        messageFilters: anyNamed('messageFilters'),
        paginationParams: pagination,
      )).thenAnswer(
        (_) async => SearchMessagesResponse()..results = messageResponseList,
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
              .map((e) => '${e.channel.cid}-${e.message.id}')
              .join(','),
        ),
        findsOneWidget,
      );

      verify(mockClient.search(
        any,
        query: anyNamed('query'),
        sort: anyNamed('sort'),
        messageFilters: anyNamed('messageFilters'),
        paginationParams: pagination,
      )).called(1);

      // Rebuilding MessageSearchListCore with new pagination limit
      _stateSetter(() => limit = 6);

      final updatedMessageResponseList = _generateMessages(count: limit);
      final updatedPagination = pagination.copyWith(limit: limit);
      when(mockClient.search(
        any,
        query: anyNamed('query'),
        sort: anyNamed('sort'),
        messageFilters: anyNamed('messageFilters'),
        paginationParams: updatedPagination,
      )).thenAnswer(
        (_) async =>
            SearchMessagesResponse()..results = updatedMessageResponseList,
      );

      await tester.pumpAndSettle();

      expect(find.byKey(childWidgetKey), findsOneWidget);
      expect(
        find.text(updatedMessageResponseList
            .map((e) => '${e.channel.cid}-${e.message.id}')
            .join(',')),
        findsOneWidget,
      );

      verify(mockClient.search(
        any,
        query: anyNamed('query'),
        sort: anyNamed('sort'),
        messageFilters: anyNamed('messageFilters'),
        paginationParams: updatedPagination,
      )).called(1);
    },
  );
}
