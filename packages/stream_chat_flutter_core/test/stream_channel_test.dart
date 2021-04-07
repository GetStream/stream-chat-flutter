import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
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
          shadowed: false,
          replyCount: index,
          updatedAt: DateTime.now(),
          extraData: {'extra_test_field': 'extraTestData'},
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
          shadowed: false,
          replyCount: index,
          updatedAt: DateTime.now(),
          extraData: {'extra_test_field': 'extraTestData'},
          text: 'Dummy text #$index',
          pinned: true,
          pinnedAt: DateTime.now(),
          pinnedBy: User(id: 'testUserId$index'),
        );
      },
    );
    return threads ? threadMessages : messages;
  }

  test(
    'should throw assertion error if child is null',
    () async {
      final mockChannel = MockChannel();
      const streamChannelKey = Key('streamChannel');
      final streamChannel = () => StreamChannel(
            key: streamChannelKey,
            channel: mockChannel,
            child: null,
          );
      expect(streamChannel, throwsA(isA<AssertionError>()));
    },
  );

  test(
    'should throw assertion error if channel is null',
    () async {
      const streamChannelKey = Key('streamChannel');
      final streamChannel = () => StreamChannel(
            key: streamChannelKey,
            child: Offstage(),
            channel: null,
          );
      expect(streamChannel, throwsA(isA<AssertionError>()));
    },
  );

  testWidgets(
    'should render StreamChannel if both channel and child is provided',
    (tester) async {
      final mockChannel = MockChannel();
      const streamChannelKey = Key('streamChannel');
      const childKey = Key('childKey');
      final streamChannel = StreamChannel(
        key: streamChannelKey,
        channel: mockChannel,
        child: Offstage(key: childKey),
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
        child: Offstage(key: childKey),
      );

      final errorMessage = 'Error! Error! Error!';
      final error = DioError(type: DioErrorType.RESPONSE, error: errorMessage);
      when(mockChannel.initialized).thenAnswer((_) => Future.error(error));

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: streamChannel,
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text(errorMessage), findsOneWidget);

      verify(mockChannel.initialized).called(1);
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
        child: Offstage(key: childKey),
        showLoading: true,
      );

      when(mockChannel.initialized).thenAnswer((_) async => false);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: streamChannel,
        ),
      );

      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      verify(mockChannel.initialized).called(1);
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
        child: Offstage(key: childKey),
        initialMessageId: 'testInitialMessageId',
      );

      when(mockChannel.initialized).thenAnswer((_) async => true);
      final messages = _generateMessages();
      when(mockChannel.query(
        options: anyNamed('options'),
        messagesPagination: anyNamed('messagesPagination'),
        membersPagination: anyNamed('membersPagination'),
        watchersPagination: anyNamed('watchersPagination'),
        preferOffline: anyNamed('preferOffline'),
      )).thenAnswer((_) async => ChannelState(messages: messages));

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: streamChannel,
        ),
      );

      await tester.pumpAndSettle();

      verify(mockChannel.initialized).called(1);
      verify(mockChannel.query(
        options: anyNamed('options'),
        messagesPagination: anyNamed('messagesPagination'),
        membersPagination: anyNamed('membersPagination'),
        watchersPagination: anyNamed('watchersPagination'),
        preferOffline: anyNamed('preferOffline'),
      )).called(
        2, // Fetching After messages + Fetching Before messages,
      );
    },
  );

  testWidgets(
    'should rebuild StreamChannel with updated widget data '
    'on calling setState()',
    (tester) async {
      StateSetter _stateSetter;

      var initialMessageId = 'testInitialMessageId';

      final mockChannel = MockChannel();
      const streamChannelKey = Key('streamChannel');
      const childKey = Key('childKey');
      StreamChannel streamChannelBuilder(String initialMessageId) =>
          StreamChannel(
            key: streamChannelKey,
            channel: mockChannel,
            child: Offstage(key: childKey),
            initialMessageId: initialMessageId,
          );

      final beforePagination = PaginationParams(
        lessThan: initialMessageId,
        limit: 20,
      );

      final afterPagination = PaginationParams(
        greaterThanOrEqual: initialMessageId,
        limit: 20,
      );

      when(mockChannel.initialized).thenAnswer((_) async => true);

      final messages = _generateMessages();

      when(mockChannel.query(
        options: anyNamed('options'),
        messagesPagination: beforePagination,
        membersPagination: anyNamed('membersPagination'),
        watchersPagination: anyNamed('watchersPagination'),
        preferOffline: anyNamed('preferOffline'),
      )).thenAnswer((_) async => ChannelState(messages: messages));

      when(mockChannel.query(
        options: anyNamed('options'),
        messagesPagination: afterPagination,
        membersPagination: anyNamed('membersPagination'),
        watchersPagination: anyNamed('watchersPagination'),
        preferOffline: anyNamed('preferOffline'),
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

      verify(mockChannel.query(
        options: anyNamed('options'),
        messagesPagination: beforePagination,
        membersPagination: anyNamed('membersPagination'),
        watchersPagination: anyNamed('watchersPagination'),
        preferOffline: anyNamed('preferOffline'),
      )).called(1);

      verify(mockChannel.query(
        options: anyNamed('options'),
        messagesPagination: afterPagination,
        membersPagination: anyNamed('membersPagination'),
        watchersPagination: anyNamed('watchersPagination'),
        preferOffline: anyNamed('preferOffline'),
      )).called(1);

      _stateSetter(() => initialMessageId = 'testInitialMessageId2');

      final updatedBeforePagination = beforePagination.copyWith(
        lessThan: initialMessageId,
      );

      final updatedAfterPagination = afterPagination.copyWith(
        greaterThanOrEqual: initialMessageId,
      );

      when(mockChannel.query(
        options: anyNamed('options'),
        messagesPagination: updatedBeforePagination,
        membersPagination: anyNamed('membersPagination'),
        watchersPagination: anyNamed('watchersPagination'),
        preferOffline: anyNamed('preferOffline'),
      )).thenAnswer((_) async => ChannelState(messages: messages));

      when(mockChannel.query(
        options: anyNamed('options'),
        messagesPagination: updatedAfterPagination,
        membersPagination: anyNamed('membersPagination'),
        watchersPagination: anyNamed('watchersPagination'),
        preferOffline: anyNamed('preferOffline'),
      )).thenAnswer((_) async => ChannelState(messages: messages));

      await tester.pumpAndSettle();

      verify(mockChannel.query(
        options: anyNamed('options'),
        messagesPagination: updatedBeforePagination,
        membersPagination: anyNamed('membersPagination'),
        watchersPagination: anyNamed('watchersPagination'),
        preferOffline: anyNamed('preferOffline'),
      )).called(1);

      verify(mockChannel.query(
        options: anyNamed('options'),
        messagesPagination: updatedAfterPagination,
        membersPagination: anyNamed('membersPagination'),
        watchersPagination: anyNamed('watchersPagination'),
        preferOffline: anyNamed('preferOffline'),
      )).called(1);
    },
  );
}
