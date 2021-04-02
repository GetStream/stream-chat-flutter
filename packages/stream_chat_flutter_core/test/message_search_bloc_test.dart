import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/message_search_bloc.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import 'matchers/get_message_response_matcher.dart';
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
    'should throw assertion error if child is null',
    () async {
      const messageSearchBlocKey = Key('messageSearchBloc');
      final messageSearchBloc = () => MessageSearchBloc(
            key: messageSearchBlocKey,
            child: null,
          );
      expect(messageSearchBloc, throwsA(isA<AssertionError>()));
    },
  );

  testWidgets(
    'messageSearchBlocState.search() should throw if used where '
    'StreamChat is not present in the widget tree',
    (tester) async {
      const messageSearchBlocKey = Key('messageSearchBloc');
      const childKey = Key('child');
      final messageSearchBloc = MessageSearchBloc(
        key: messageSearchBlocKey,
        child: Offstage(key: childKey),
      );

      await tester.pumpWidget(messageSearchBloc);

      expect(find.byKey(messageSearchBlocKey), findsOneWidget);
      expect(find.byKey(childKey), findsOneWidget);

      final usersBlocState = tester.state<MessageSearchBlocState>(
        find.byKey(messageSearchBlocKey),
      );

      try {
        await usersBlocState.search();
      } catch (e) {
        expect(e, isInstanceOf<Exception>());
      }
    },
  );

  testWidgets(
    'messageSearchBlocState.search() should emit data through usersStream',
    (tester) async {
      const messageSearchBlocKey = Key('messageSearchBloc');
      const childKey = Key('child');
      final messageSearchBloc = MessageSearchBloc(
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

      when(mockClient.search(
        any,
        query: anyNamed('query'),
        sort: anyNamed('sort'),
        messageFilters: anyNamed('messageFilters'),
        paginationParams: anyNamed('paginationParams'),
      )).thenAnswer(
        (_) async => SearchMessagesResponse()..results = messageResponseList,
      );

      messageSearchBlocState.search();

      await expectLater(
        messageSearchBlocState.messagesStream,
        emits(isSameMessageResponseListAs(messageResponseList)),
      );

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
    'messageSearchBlocState.messagesStream should emit error '
    'if client.search() throws',
    (tester) async {
      const messageSearchBlocKey = Key('messageSearchBloc');
      const childKey = Key('child');
      final messageSearchBloc = MessageSearchBloc(
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
      when(mockClient.search(
        any,
        query: anyNamed('query'),
        sort: anyNamed('sort'),
        messageFilters: anyNamed('messageFilters'),
        paginationParams: anyNamed('paginationParams'),
      )).thenThrow(error);

      messageSearchBlocState.search();

      await expectLater(
        messageSearchBlocState.messagesStream,
        emitsError(error),
      );

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
    'calling messageSearchBlocState.search() again with an offset '
    'should emit new data through messagesStream and also emit loading state '
    'through queryMessagesLoading',
    (tester) async {
      const messageSearchBlocKey = Key('messageSearchBloc');
      const childKey = Key('child');
      final messageSearchBloc = MessageSearchBloc(
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

      when(mockClient.search(
        any,
        query: anyNamed('query'),
        sort: anyNamed('sort'),
        messageFilters: anyNamed('messageFilters'),
        paginationParams: anyNamed('paginationParams'),
      )).thenAnswer(
        (_) async => SearchMessagesResponse()..results = messageResponseList,
      );

      messageSearchBlocState.search();

      await expectLater(
        messageSearchBlocState.messagesStream,
        emits(isSameMessageResponseListAs(messageResponseList)),
      );

      verify(mockClient.search(
        any,
        query: anyNamed('query'),
        sort: anyNamed('sort'),
        messageFilters: anyNamed('messageFilters'),
        paginationParams: anyNamed('paginationParams'),
      )).called(1);

      final offset = messageResponseList.length;
      final paginatedMessageResponseList = _generateMessages(offset: offset);
      final pagination = PaginationParams(offset: offset);

      when(mockClient.search(
        any,
        query: anyNamed('query'),
        sort: anyNamed('sort'),
        messageFilters: anyNamed('messageFilters'),
        paginationParams: pagination,
      )).thenAnswer(
        (_) async =>
            SearchMessagesResponse()..results = paginatedMessageResponseList,
      );

      messageSearchBlocState.search(pagination: pagination);

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

      verify(mockClient.search(
        any,
        query: anyNamed('query'),
        sort: anyNamed('sort'),
        messageFilters: anyNamed('messageFilters'),
        paginationParams: pagination,
      )).called(1);
    },
  );

  testWidgets(
    'calling messageSearchBlocState.search() again with an offset '
    'should emit error through queryUsersLoading if '
    'client.search() throws',
    (tester) async {
      const messageSearchBlocKey = Key('messageSearchBloc');
      const childKey = Key('child');
      final messageSearchBloc = MessageSearchBloc(
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

      when(mockClient.search(
        any,
        query: anyNamed('query'),
        sort: anyNamed('sort'),
        messageFilters: anyNamed('messageFilters'),
        paginationParams: anyNamed('paginationParams'),
      )).thenAnswer(
        (_) async => SearchMessagesResponse()..results = messageResponseList,
      );

      messageSearchBlocState.search();

      await expectLater(
        messageSearchBlocState.messagesStream,
        emits(isSameMessageResponseListAs(messageResponseList)),
      );

      verify(mockClient.search(
        any,
        query: anyNamed('query'),
        sort: anyNamed('sort'),
        messageFilters: anyNamed('messageFilters'),
        paginationParams: anyNamed('paginationParams'),
      )).called(1);

      final offset = messageResponseList.length;
      final pagination = PaginationParams(offset: offset);

      const error = 'Error! Error! Error!';
      when(mockClient.search(
        any,
        query: anyNamed('query'),
        sort: anyNamed('sort'),
        messageFilters: anyNamed('messageFilters'),
        paginationParams: pagination,
      )).thenThrow(error);

      messageSearchBlocState.search(pagination: pagination);

      await expectLater(
        messageSearchBlocState.queryMessagesLoading,
        emitsError(error),
      );

      verify(mockClient.search(
        any,
        query: anyNamed('query'),
        sort: anyNamed('sort'),
        messageFilters: anyNamed('messageFilters'),
        paginationParams: pagination,
      )).called(1);
    },
  );
}
