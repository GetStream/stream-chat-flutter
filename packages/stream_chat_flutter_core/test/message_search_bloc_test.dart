import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/message_search_bloc.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import 'matchers/get_message_response_matcher.dart';
import 'mocks.dart';

const testFilter = Filter.custom(operator: '\$test', value: 'testValue');

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
              cid: 'testCid:id',
            );
        },
      );

  testWidgets(
    '''messageSearchBlocState.search() should throw if used where StreamChat is not present in the widget tree''',
    (tester) async {
      const messageSearchBloc = MessageSearchBloc(
        child: Offstage(),
      );

      await tester.pumpWidget(messageSearchBloc);
      expect(tester.takeException(), isInstanceOf<AssertionError>());
    },
  );

  testWidgets(
    'messageSearchBlocState.search() should emit data through usersStream',
    (tester) async {
      const messageSearchBlocKey = Key('messageSearchBloc');
      const childKey = Key('child');
      const messageSearchBloc = MessageSearchBloc(
        key: messageSearchBlocKey,
        child: Offstage(key: childKey),
      );

      final mockClient = MockClient();

      await tester.pumpWidget(
        StreamChatCore(
          client: mockClient,
          child: messageSearchBloc,
        ),
      );
      final messageSearchBlocState = tester.state<MessageSearchBlocState>(
        find.byKey(messageSearchBlocKey),
      );

      final messageResponseList = _generateMessages();

      when(() => mockClient.search(
            testFilter,
            query: any(named: 'query'),
            sort: any(named: 'sort'),
            messageFilters: any(named: 'messageFilters'),
            paginationParams: any(named: 'paginationParams'),
          )).thenAnswer(
        (_) async => SearchMessagesResponse()
          ..results = messageResponseList
          ..next = null
          ..previous = null,
      );

      messageSearchBlocState.search(filter: testFilter);

      await expectLater(
        messageSearchBlocState.messagesStream,
        emits(isSameMessageResponseListAs(messageResponseList)),
      );

      verify(() => mockClient.search(
            testFilter,
            query: any(named: 'query'),
            sort: any(named: 'sort'),
            messageFilters: any(named: 'messageFilters'),
            paginationParams: any(named: 'paginationParams'),
          )).called(1);
    },
  );

  testWidgets(
    '''messageSearchBlocState.messagesStream should emit error if client.search() throws''',
    (tester) async {
      const messageSearchBlocKey = Key('messageSearchBloc');
      const childKey = Key('child');
      const messageSearchBloc = MessageSearchBloc(
        key: messageSearchBlocKey,
        child: Offstage(key: childKey),
      );

      final mockClient = MockClient();

      await tester.pumpWidget(
        StreamChatCore(
          client: mockClient,
          child: messageSearchBloc,
        ),
      );
      final messageSearchBlocState = tester.state<MessageSearchBlocState>(
        find.byKey(messageSearchBlocKey),
      );

      const error = 'Error! Error! Error!';
      when(() => mockClient.search(
            testFilter,
            query: any(named: 'query'),
            sort: any(named: 'sort'),
            messageFilters: any(named: 'messageFilters'),
            paginationParams: any(named: 'paginationParams'),
          )).thenThrow(error);

      messageSearchBlocState.search(filter: testFilter);

      await expectLater(
        messageSearchBlocState.messagesStream,
        emitsError(error),
      );

      verify(() => mockClient.search(
            testFilter,
            query: any(named: 'query'),
            sort: any(named: 'sort'),
            messageFilters: any(named: 'messageFilters'),
            paginationParams: any(named: 'paginationParams'),
          )).called(1);
    },
  );

  testWidgets(
    '''calling messageSearchBlocState.search() again with an offset should emit new data through messagesStream and also emit loading state through queryMessagesLoading''',
    (tester) async {
      const messageSearchBlocKey = Key('messageSearchBloc');
      const childKey = Key('child');
      const messageSearchBloc = MessageSearchBloc(
        key: messageSearchBlocKey,
        child: Offstage(key: childKey),
      );

      final mockClient = MockClient();

      await tester.pumpWidget(
        StreamChatCore(
          client: mockClient,
          child: messageSearchBloc,
        ),
      );

      final messageSearchBlocState = tester.state<MessageSearchBlocState>(
        find.byKey(messageSearchBlocKey),
      );

      const pagination = PaginationParams(limit: 25);
      final messageResponseList = _generateMessages(count: 25);

      when(() => mockClient.search(
            testFilter,
            query: any(named: 'query'),
            sort: any(named: 'sort'),
            messageFilters: any(named: 'messageFilters'),
            paginationParams: pagination,
          )).thenAnswer(
        (_) async => SearchMessagesResponse()
          ..results = messageResponseList
          ..next = null
          ..previous = null,
      );

      messageSearchBlocState.search(pagination: pagination, filter: testFilter);

      await expectLater(
        messageSearchBlocState.messagesStream,
        emits(isSameMessageResponseListAs(messageResponseList)),
      );

      verify(() => mockClient.search(
            testFilter,
            query: any(named: 'query'),
            sort: any(named: 'sort'),
            messageFilters: any(named: 'messageFilters'),
            paginationParams: pagination,
          )).called(1);

      final offset = messageResponseList.length;
      final paginatedMessageResponseList = _generateMessages(offset: offset);
      final newPagination = pagination.copyWith(offset: offset);

      when(() => mockClient.search(
            testFilter,
            query: any(named: 'query'),
            sort: any(named: 'sort'),
            messageFilters: any(named: 'messageFilters'),
            paginationParams: newPagination,
          )).thenAnswer(
        (_) async => SearchMessagesResponse()
          ..results = paginatedMessageResponseList
          ..next = null
          ..previous = null,
      );

      messageSearchBlocState.search(pagination: pagination, filter: testFilter);

      await Future.wait([
        expectLater(
          messageSearchBlocState.queryMessagesLoading,
          emitsInOrder([true, false]),
        ),
        expectLater(
          messageSearchBlocState.messagesStream,
          emits(isSameMessageResponseListAs(
            messageResponseList + paginatedMessageResponseList,
          )),
        ),
      ]);

      verify(() => mockClient.search(
            testFilter,
            query: any(named: 'query'),
            sort: any(named: 'sort'),
            messageFilters: any(named: 'messageFilters'),
            paginationParams: pagination,
          )).called(1);
    },
  );

  testWidgets(
    '''calling messageSearchBlocState.search() again with an offset should emit error through queryUsersLoading if client.search() throws''',
    (tester) async {
      const messageSearchBlocKey = Key('messageSearchBloc');
      const childKey = Key('child');
      const messageSearchBloc = MessageSearchBloc(
        key: messageSearchBlocKey,
        child: Offstage(key: childKey),
      );

      final mockClient = MockClient();

      await tester.pumpWidget(
        StreamChatCore(
          client: mockClient,
          child: messageSearchBloc,
        ),
      );

      final messageSearchBlocState = tester.state<MessageSearchBlocState>(
        find.byKey(messageSearchBlocKey),
      );

      const pagination = PaginationParams(limit: 25);
      final messageResponseList = _generateMessages(count: 25);

      when(() => mockClient.search(
            testFilter,
            query: any(named: 'query'),
            sort: any(named: 'sort'),
            messageFilters: any(named: 'messageFilters'),
            paginationParams: pagination,
          )).thenAnswer(
        (_) async => SearchMessagesResponse()
          ..results = messageResponseList
          ..next = null
          ..previous = null,
      );

      messageSearchBlocState.search(pagination: pagination, filter: testFilter);

      await expectLater(
        messageSearchBlocState.messagesStream,
        emits(isSameMessageResponseListAs(messageResponseList)),
      );

      verify(() => mockClient.search(
            testFilter,
            query: any(named: 'query'),
            sort: any(named: 'sort'),
            messageFilters: any(named: 'messageFilters'),
            paginationParams: pagination,
          )).called(1);

      final offset = messageResponseList.length;
      final newPagination = pagination.copyWith(offset: offset);

      const error = 'Error! Error! Error!';
      when(() => mockClient.search(
            testFilter,
            query: any(named: 'query'),
            sort: any(named: 'sort'),
            messageFilters: any(named: 'messageFilters'),
            paginationParams: newPagination,
          )).thenThrow(error);

      messageSearchBlocState.search(
        pagination: newPagination,
        filter: testFilter,
      );

      await expectLater(
        messageSearchBlocState.queryMessagesLoading,
        emitsError(error),
      );

      verify(() => mockClient.search(
            testFilter,
            query: any(named: 'query'),
            sort: any(named: 'sort'),
            messageFilters: any(named: 'messageFilters'),
            paginationParams: newPagination,
          )).called(1);
    },
  );

  testWidgets(
    '''calling messageSearchBlocState.search() again with an offset should do nothing and return if pagination is completed''',
    (tester) async {
      const messageSearchBlocKey = Key('messageSearchBloc');
      const childKey = Key('child');
      const messageSearchBloc = MessageSearchBloc(
        key: messageSearchBlocKey,
        child: Offstage(key: childKey),
      );

      final mockClient = MockClient();

      await tester.pumpWidget(
        StreamChatCore(
          client: mockClient,
          child: messageSearchBloc,
        ),
      );

      final messageSearchBlocState = tester.state<MessageSearchBlocState>(
        find.byKey(messageSearchBlocKey),
      );

      const pagination = PaginationParams(limit: 25);

      final messageResponseList = _generateMessages(count: 20);

      when(() => mockClient.search(
            testFilter,
            query: any(named: 'query'),
            sort: any(named: 'sort'),
            messageFilters: any(named: 'messageFilters'),
            paginationParams: pagination,
          )).thenAnswer(
        (_) async => SearchMessagesResponse()
          ..results = messageResponseList
          ..next = null
          ..previous = null,
      );

      messageSearchBlocState.search(pagination: pagination, filter: testFilter);

      await expectLater(
        messageSearchBlocState.messagesStream,
        emits(isSameMessageResponseListAs(messageResponseList)),
      );

      verify(() => mockClient.search(
            testFilter,
            query: any(named: 'query'),
            sort: any(named: 'sort'),
            messageFilters: any(named: 'messageFilters'),
            paginationParams: pagination,
          )).called(1);

      final offset = messageResponseList.length;
      final newPagination = pagination.copyWith(offset: offset);

      messageSearchBlocState.search(
        filter: testFilter,
        pagination: newPagination,
      );

      // should emit nothing.
      await expectLater(
        // skipping the initial data (behaviorSubject).
        messageSearchBlocState.messagesStream.skip(1),
        emitsInOrder([]),
      );
    },
  );
}
