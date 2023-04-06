import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import 'mocks.dart';

void main() {
  List<Message> _generateMessages({
    int count = 3,
    int offset = 0,
    bool threads = false,
  }) {
    final users = List.generate(count, (index) {
      index = count + offset;
      return User(id: 'testUserId$index');
    });
    final messages = List.generate(
      count,
      (index) {
        index = index + offset;
        return Message(
          id: 'testMessageId$index',
          type: 'testType',
          user: users[index],
          createdAt: DateTime.now(),
          replyCount: index,
          updatedAt: DateTime.now(),
          extraData: const {'extra_test_field': 'extraTestData'},
          text: 'Dummy text #$index',
          pinned: true,
          pinnedAt: DateTime.now(),
          pinnedBy: User(id: 'testUserId$index'),
        );
      },
    );
    final threadMessages = List.generate(
      count,
      (index) {
        index = index + offset;
        return Message(
          id: 'testThreadMessageId$index',
          type: 'testType',
          user: users[index],
          parentId: messages[0].id,
          createdAt: DateTime.now(),
          replyCount: index,
          updatedAt: DateTime.now(),
          extraData: const {'extra_test_field': 'extraTestData'},
          text: 'Dummy text #$index',
          pinned: true,
          pinnedAt: DateTime.now(),
          pinnedBy: User(id: 'testUserId$index'),
        );
      },
    );
    return threads ? threadMessages : messages;
  }

  testWidgets(
    'should render StreamChannel if both channel and child is provided',
    (tester) async {
      final mockChannel = MockChannel();
      const streamChannelKey = Key('streamChannel');
      const childKey = Key('childKey');
      when(() => mockChannel.initialized).thenAnswer((_) => Future.value(true));
      when(() => mockChannel.state.unreadCount).thenReturn(0);
      final streamChannel = StreamChannel(
        key: streamChannelKey,
        channel: mockChannel,
        child: const Offstage(key: childKey),
      );

      await tester.pumpWidget(streamChannel);

      expect(find.byKey(streamChannelKey), findsOneWidget);
      expect(find.byKey(childKey), findsOneWidget);
    },
  );

  testWidgets(
    'should build error widget if channel.initialized throws',
    (tester) async {
      final mockChannel = MockChannel();
      const streamChannelKey = Key('streamChannel');
      const childKey = Key('childKey');
      final streamChannel = StreamChannel(
        key: streamChannelKey,
        channel: mockChannel,
        child: const Offstage(key: childKey),
      );

      const errorMessage = 'Error! Error! Error!';
      final error = DioError(
        type: DioErrorType.badResponse,
        message: errorMessage,
        requestOptions: RequestOptions(),
      );
      when(() => mockChannel.initialized)
          .thenAnswer((_) => Future.error(error));
      when(() => mockChannel.state.unreadCount).thenReturn(0);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: streamChannel,
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text(errorMessage), findsOneWidget);

      verify(() => mockChannel.initialized).called(1);
    },
  );

  testWidgets(
    'should show circular progress indicator showLoading is true '
    'and channel is still not initialized',
    (tester) async {
      final mockChannel = MockChannel();
      const streamChannelKey = Key('streamChannel');
      const childKey = Key('childKey');
      final streamChannel = StreamChannel(
        key: streamChannelKey,
        channel: mockChannel,
        child: const Offstage(key: childKey),
      );

      when(() => mockChannel.initialized).thenAnswer((_) async => false);
      when(() => mockChannel.state.unreadCount).thenReturn(0);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: streamChannel,
        ),
      );

      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      verify(() => mockChannel.initialized).called(1);
    },
  );

  testWidgets(
    'should preload extra messages if initialMessageId is provided',
    (tester) async {
      final mockChannel = MockChannel();
      const streamChannelKey = Key('streamChannel');
      const childKey = Key('childKey');
      final streamChannel = StreamChannel(
        key: streamChannelKey,
        channel: mockChannel,
        initialMessageId: 'testInitialMessageId',
        child: const Offstage(key: childKey),
      );

      when(() => mockChannel.initialized).thenAnswer((_) async => true);
      final messages = _generateMessages();
      when(() => mockChannel.query(
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            messagesPagination: any(named: 'messagesPagination'),
            membersPagination: any(named: 'membersPagination'),
            watchersPagination: any(named: 'watchersPagination'),
            preferOffline: any(named: 'preferOffline'),
          )).thenAnswer((_) async => ChannelState(messages: messages));

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: streamChannel,
        ),
      );

      await tester.pumpAndSettle();

      verify(() => mockChannel.initialized).called(1);
      verify(() => mockChannel.query(
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            messagesPagination: any(named: 'messagesPagination'),
            membersPagination: any(named: 'membersPagination'),
            watchersPagination: any(named: 'watchersPagination'),
            preferOffline: any(named: 'preferOffline'),
          )).called(1);
    },
  );

  testWidgets(
    'should rebuild StreamChannel with updated widget data '
    'on calling setState()',
    (tester) async {
      StateSetter? _stateSetter;

      var initialMessageId = 'testInitialMessageId';

      final mockChannel = MockChannel();
      const streamChannelKey = Key('streamChannel');
      const childKey = Key('childKey');
      StreamChannel streamChannelBuilder(String initialMessageId) =>
          StreamChannel(
            key: streamChannelKey,
            channel: mockChannel,
            initialMessageId: initialMessageId,
            child: const Offstage(key: childKey),
          );

      final paginationParams = PaginationParams(
        idAround: initialMessageId,
        limit: 20,
      );

      when(() => mockChannel.initialized).thenAnswer((_) async => true);

      final messages = _generateMessages();

      when(() => mockChannel.query(
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            messagesPagination: paginationParams,
            membersPagination: any(named: 'membersPagination'),
            watchersPagination: any(named: 'watchersPagination'),
            preferOffline: any(named: 'preferOffline'),
          )).thenAnswer((_) async => ChannelState(messages: messages));

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: StatefulBuilder(
            builder: (context, stateSetter) {
              // Assigning stateSetter for rebuilding StreamChannel
              _stateSetter = stateSetter;
              return streamChannelBuilder(initialMessageId);
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      verify(() => mockChannel.query(
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            messagesPagination: paginationParams,
            membersPagination: any(named: 'membersPagination'),
            watchersPagination: any(named: 'watchersPagination'),
            preferOffline: any(named: 'preferOffline'),
          )).called(1);

      _stateSetter?.call(() => initialMessageId = 'testInitialMessageId2');

      final updatedPaginationParams = paginationParams.copyWith(
        idAround: initialMessageId,
      );

      when(() => mockChannel.query(
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            messagesPagination: updatedPaginationParams,
            membersPagination: any(named: 'membersPagination'),
            watchersPagination: any(named: 'watchersPagination'),
            preferOffline: any(named: 'preferOffline'),
          )).thenAnswer((_) async => ChannelState(messages: messages));

      await tester.pumpAndSettle();

      verify(() => mockChannel.query(
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            messagesPagination: updatedPaginationParams,
            membersPagination: any(named: 'membersPagination'),
            watchersPagination: any(named: 'watchersPagination'),
            preferOffline: any(named: 'preferOffline'),
          )).called(1);
    },
  );
}
