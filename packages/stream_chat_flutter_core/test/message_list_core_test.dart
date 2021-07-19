import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter_core/src/message_list_core.dart';
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
    '''should throw if MessageListCore is used where StreamChannel is not present in the widget tree''',
    (tester) async {
      const messageListCoreKey = Key('messageListCore');
      final messageListCore = MessageListCore(
        key: messageListCoreKey,
        messageListBuilder: (_, __) => const Offstage(),
        loadingBuilder: (BuildContext context) => const Offstage(),
        emptyBuilder: (BuildContext context) => const Offstage(),
        errorBuilder: (BuildContext context, Object error) => const Offstage(),
      );

      await tester.pumpWidget(messageListCore);

      expect(find.byKey(messageListCoreKey), findsNothing);
      expect(tester.takeException(), isInstanceOf<AssertionError>());
    },
  );

  testWidgets(
    'should render MessageListCore if used with StreamChannel as an ancestor',
    (tester) async {
      const messageListCoreKey = Key('messageListCore');
      final messageListCore = MessageListCore(
        key: messageListCoreKey,
        messageListBuilder: (_, __) => const Offstage(),
        loadingBuilder: (BuildContext context) => const Offstage(),
        emptyBuilder: (BuildContext context) => const Offstage(),
        errorBuilder: (BuildContext context, Object error) => const Offstage(),
      );

      final mockChannel = MockChannel();
      when(() => mockChannel.initialized).thenAnswer((_) => Future.value(true));

      when(() => mockChannel.state.isUpToDate).thenReturn(true);
      when(() => mockChannel.state.messagesStream)
          .thenAnswer((_) => Stream.value([]));
      when(() => mockChannel.state.messages).thenReturn([]);

      await tester.pumpWidget(
        StreamChannel(
          channel: mockChannel,
          child: messageListCore,
        ),
      );

      expect(find.byKey(messageListCoreKey), findsOneWidget);
    },
  );

  testWidgets(
    'should assign paginateData callback to MessageListController if passed',
    (tester) async {
      const messageListCoreKey = Key('messageListCore');
      final controller = MessageListController();
      final messageListCore = MessageListCore(
        key: messageListCoreKey,
        messageListBuilder: (_, __) => const Offstage(),
        loadingBuilder: (BuildContext context) => const Offstage(),
        emptyBuilder: (BuildContext context) => const Offstage(),
        errorBuilder: (BuildContext context, Object error) => const Offstage(),
        messageListController: controller,
      );

      expect(controller.paginateData, isNull);

      final mockChannel = MockChannel();

      when(() => mockChannel.state.isUpToDate).thenReturn(true);
      when(() => mockChannel.state.messagesStream)
          .thenAnswer((_) => Stream.value([]));
      when(() => mockChannel.state.messages).thenReturn([]);
      when(() => mockChannel.initialized).thenAnswer((_) => Future.value(true));

      await tester.pumpWidget(
        StreamChannel(
          channel: mockChannel,
          child: messageListCore,
        ),
      );

      expect(find.byKey(messageListCoreKey), findsOneWidget);
      expect(controller.paginateData, isNotNull);
    },
  );

  testWidgets(
    '''should assign paginateData callback and paginate data correctly if a MessageListController is passed''',
    (tester) async {
      const messageListCoreKey = Key('messageListCore');
      final controller = MessageListController();
      final messageListCore = MessageListCore(
        key: messageListCoreKey,
        messageListBuilder: (_, __) => const Offstage(),
        loadingBuilder: (BuildContext context) => const Offstage(),
        emptyBuilder: (BuildContext context) => const Offstage(),
        errorBuilder: (BuildContext context, Object error) => const Offstage(),
        messageListController: controller,
      );

      expect(controller.paginateData, isNull);

      final mockChannel = MockChannel();

      when(() => mockChannel.state.isUpToDate).thenReturn(true);
      // when(() => mockChannel.query(
      //       messagesPagination: any(named: 'messagesPagination'),
      //       preferOffline: any(named: 'preferOffline'),
      //     )).thenAnswer((_) => mockChannel.state);
      final messages = _generateMessages();
      when(() => mockChannel.state.messages).thenReturn(messages);
      when(() => mockChannel.state.messagesStream)
          .thenAnswer((_) => Stream.value(messages));
      when(() => mockChannel.state.messages).thenReturn(messages);
      when(() => mockChannel.initialized).thenAnswer((_) => Future.value(true));

      await tester.pumpWidget(
        StreamChannel(
          channel: mockChannel,
          child: messageListCore,
        ),
      );

      final finder = find.byKey(messageListCoreKey);
      final coreState = tester.firstState<MessageListCoreState>(finder);
      expect(finder, findsOneWidget);
      expect(controller.paginateData, isNotNull);

      await coreState.paginateData();

      verify(() => mockChannel.query(
            messagesPagination: any(named: 'messagesPagination'),
            preferOffline: any(named: 'preferOffline'),
          )).called(1);
    },
  );

  testWidgets(
    'should build error widget if messagesStream emits error',
    (tester) async {
      const messageListCoreKey = Key('messageListCore');
      const errorWidgetKey = Key('errorWidget');
      final messageListCore = MessageListCore(
        key: messageListCoreKey,
        messageListBuilder: (_, __) => const Offstage(),
        loadingBuilder: (BuildContext context) => const Offstage(),
        emptyBuilder: (BuildContext context) => const Offstage(),
        errorBuilder: (BuildContext context, Object error) => const Offstage(
          key: errorWidgetKey,
        ),
      );

      final mockChannel = MockChannel();

      when(() => mockChannel.state.isUpToDate).thenReturn(true);
      when(() => mockChannel.initialized).thenAnswer((_) async => true);

      const error = 'Error! Error! Error!';
      when(() => mockChannel.state.messagesStream)
          .thenAnswer((_) => Stream.error(error));
      when(() => mockChannel.state.messages).thenReturn([]);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: StreamChannel(
            channel: mockChannel,
            child: messageListCore,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(errorWidgetKey), findsOneWidget);
    },
  );

  testWidgets(
    'should build empty widget if the channel is upToDate and '
    'messagesStream emits empty data',
    (tester) async {
      const messageListCoreKey = Key('messageListCore');
      const emptyWidgetKey = Key('emptyWidget');
      final messageListCore = MessageListCore(
        key: messageListCoreKey,
        messageListBuilder: (_, __) => const Offstage(),
        loadingBuilder: (BuildContext context) => const Offstage(),
        emptyBuilder: (BuildContext context) =>
            const Offstage(key: emptyWidgetKey),
        errorBuilder: (BuildContext context, Object error) => const Offstage(),
      );

      final mockChannel = MockChannel();

      when(() => mockChannel.state.isUpToDate).thenReturn(true);
      when(() => mockChannel.initialized).thenAnswer((_) async => true);

      const messages = <Message>[];
      when(() => mockChannel.state.messagesStream)
          .thenAnswer((_) => Stream.value(messages));
      when(() => mockChannel.state.messages).thenReturn(messages);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: StreamChannel(
            channel: mockChannel,
            child: messageListCore,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(emptyWidgetKey), findsOneWidget);
    },
  );

  testWidgets(
    'should build list widget if the channel is not upToDate and '
    'messagesStream emits empty data',
    (tester) async {
      const messageListCoreKey = Key('messageListCore');
      const listWidgetKey = Key('listWidget');
      final messageListCore = MessageListCore(
        key: messageListCoreKey,
        messageListBuilder: (_, __) => const Offstage(key: listWidgetKey),
        loadingBuilder: (BuildContext context) => const Offstage(),
        emptyBuilder: (BuildContext context) => const Offstage(),
        errorBuilder: (BuildContext context, Object error) => const Offstage(),
      );

      final mockChannel = MockChannel();

      when(() => mockChannel.state.isUpToDate).thenReturn(false);
      when(() => mockChannel.initialized).thenAnswer((_) async => true);
      when(() => mockChannel.query(
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            membersPagination: any(named: 'membersPagination'),
            messagesPagination: any(named: 'messagesPagination'),
            preferOffline: any(named: 'preferOffline'),
            watchersPagination: any(named: 'watchersPagination'),
          )).thenAnswer((_) async => ChannelState());

      const messages = <Message>[];
      when(() => mockChannel.state.messagesStream)
          .thenAnswer((_) => Stream.value(messages));
      when(() => mockChannel.state.messages).thenReturn(messages);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: StreamChannel(
            channel: mockChannel,
            child: messageListCore,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(listWidgetKey), findsOneWidget);
    },
  );

  testWidgets(
    'should build list widget and save it for future rebuilds '
    'if messagesStream emits some data',
    (tester) async {
      const messageListCoreKey = Key('messageListCore');
      const listWidgetKey = Key('listWidget');
      final messageListCore = MessageListCore(
        key: messageListCoreKey,
        messageListBuilder: (_, messages) => Container(
          key: listWidgetKey,
          child: Text(
            messages.reversed.map((it) => it.id).join(','),
          ),
        ),
        loadingBuilder: (BuildContext context) => const Offstage(),
        emptyBuilder: (BuildContext context) => const Offstage(),
        errorBuilder: (BuildContext context, Object error) => const Offstage(),
      );

      final mockChannel = MockChannel();

      when(() => mockChannel.state.isUpToDate).thenReturn(true);
      when(() => mockChannel.initialized).thenAnswer((_) async => true);

      final messages = _generateMessages();
      when(() => mockChannel.state.messagesStream)
          .thenAnswer((_) => Stream.value(messages));
      when(() => mockChannel.state.messages).thenReturn(messages);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: StreamChannel(
            channel: mockChannel,
            child: messageListCore,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(listWidgetKey), findsOneWidget);
      expect(find.text(messages.map((it) => it.id).join(',')), findsOneWidget);
    },
  );

  testWidgets(
    'should build list widget with thread messages if parentMessage is passed',
    (tester) async {
      final messages = _generateMessages(threads: true);
      final parentMessage = Message(id: messages.first.parentId);
      const messageListCoreKey = Key('messageListCore');
      const listWidgetKey = Key('listWidget');
      final messageListCore = MessageListCore(
        key: messageListCoreKey,
        messageListBuilder: (_, messages) => Container(
          key: listWidgetKey,
          child: Text(
            messages.reversed.map((it) => '${it.parentId}-${it.id}').join(','),
          ),
        ),
        loadingBuilder: (BuildContext context) => const Offstage(),
        emptyBuilder: (BuildContext context) => const Offstage(),
        errorBuilder: (BuildContext context, Object error) => const Offstage(),
        parentMessage: parentMessage,
      );

      final mockChannel = MockChannel();

      when(() => mockChannel.state.isUpToDate).thenReturn(true);
      when(() => mockChannel.initialized).thenAnswer((_) async => true);

      final threads = {parentMessage.id: messages};

      when(() => mockChannel.state.threads).thenReturn(threads);
      when(() => mockChannel.state.threadsStream)
          .thenAnswer((_) => Stream.value(threads));

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: StreamChannel(
            channel: mockChannel,
            child: messageListCore,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(listWidgetKey), findsOneWidget);
      expect(
        find.text(messages.map((it) => '${it.parentId}-${it.id}').join(',')),
        findsOneWidget,
      );
    },
  );
}
