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
      final i = index + offset;
      return User(id: 'testUserId$i');
    });
    final messages = List.generate(
      count,
      (index) {
        final i = index + offset;
        return Message(
          id: 'testMessageId$i',
          type: 'testType',
          user: users[index],
          createdAt: DateTime.now(),
          replyCount: i,
          updatedAt: DateTime.now(),
          extraData: const {'extra_test_field': 'extraTestData'},
          text: 'Dummy text #$i',
          pinned: true,
          pinnedAt: DateTime.now(),
          pinnedBy: User(id: 'testUserId$i'),
        );
      },
    );
    final threadMessages = List.generate(
      count,
      (index) {
        final i = index + offset;
        return Message(
          id: 'testThreadMessageId$i',
          type: 'testType',
          user: users[index],
          parentId: messages[0].id,
          createdAt: DateTime.now(),
          replyCount: i,
          updatedAt: DateTime.now(),
          extraData: const {'extra_test_field': 'extraTestData'},
          text: 'Dummy text #$i',
          pinned: true,
          pinnedAt: DateTime.now(),
          pinnedBy: User(id: 'testUserId$i'),
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
      when(() => mockChannel.state.unreadCount).thenReturn(0);
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

      await tester.pumpAndSettle();

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
      when(() => mockChannel.state.unreadCount).thenReturn(0);
      when(() => mockChannel.state.messagesStream)
          .thenAnswer((_) => Stream.value([]));
      when(() => mockChannel.state.messages).thenReturn([]);

      await tester.pumpWidget(
        StreamChannel(
          channel: mockChannel,
          child: messageListCore,
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(messageListCoreKey), findsOneWidget);
      expect(controller.paginateData, isNotNull);
    },
  );

  testWidgets(
    '''should assign paginateData callback and paginate data correctly if a MessageListController is passed''',
    (tester) async {
      const messageListCoreKey = Key('messageListCore');
      final controller = MessageListController();
      const paginationLimit = 10;
      final messageListCore = MessageListCore(
        paginationLimit: paginationLimit,
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
      when(() => mockChannel.state.unreadCount).thenReturn(0);
      final messages = _generateMessages();
      when(() => mockChannel.state.messages).thenReturn(messages);
      when(() => mockChannel.state.messagesStream)
          .thenAnswer((_) => Stream.value(messages));
      when(() => mockChannel.state.messages).thenReturn(messages);

      await tester.pumpWidget(
        StreamChannel(
          channel: mockChannel,
          child: messageListCore,
        ),
      );

      await tester.pumpAndSettle();

      final finder = find.byKey(messageListCoreKey);
      final coreState = tester.firstState<MessageListCoreState>(finder);
      expect(finder, findsOneWidget);
      expect(controller.paginateData, isNotNull);

      await coreState.paginateData();

      verify(() => mockChannel.query(
            messagesPagination: any(
              named: 'messagesPagination',
              that: wrapMatcher((it) => it.limit == paginationLimit),
            ),
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

      const error = 'Error! Error! Error!';
      when(() => mockChannel.state.messagesStream)
          .thenAnswer((_) => Stream.error(error));
      when(() => mockChannel.state.messages).thenReturn([]);
      when(() => mockChannel.state.unreadCount).thenReturn(0);

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

      const messages = <Message>[];
      when(() => mockChannel.state.messagesStream)
          .thenAnswer((_) => Stream.value(messages));
      when(() => mockChannel.state.messages).thenReturn(messages);
      when(() => mockChannel.state.unreadCount).thenReturn(0);

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
      when(() => mockChannel.query(
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            membersPagination: any(named: 'membersPagination'),
            messagesPagination: any(named: 'messagesPagination'),
            preferOffline: any(named: 'preferOffline'),
            watchersPagination: any(named: 'watchersPagination'),
          )).thenAnswer((_) async => const ChannelState());

      const messages = <Message>[];
      when(() => mockChannel.state.messagesStream)
          .thenAnswer((_) => Stream.value(messages));
      when(() => mockChannel.state.messages).thenReturn(messages);
      when(() => mockChannel.state.unreadCount).thenReturn(0);

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

      final messages = _generateMessages();
      when(() => mockChannel.state.messagesStream)
          .thenAnswer((_) => Stream.value(messages));
      when(() => mockChannel.state.messages).thenReturn(messages);
      when(() => mockChannel.state.unreadCount).thenReturn(0);

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
    'should call channel.state.pruneOldest when a new message arrives and '
    'count exceeds maximumMessageLimit',
    (tester) async {
      const messageListCoreKey = Key('messageListCore');
      const maximumMessageLimit = 5;

      final messageListCore = MessageListCore(
        key: messageListCoreKey,
        maximumMessageLimit: maximumMessageLimit,
        retentionTrimBuffer: 0,
        messageListBuilder: (_, __) => const Offstage(),
        loadingBuilder: (BuildContext context) => const Offstage(),
        emptyBuilder: (BuildContext context) => const Offstage(),
        errorBuilder: (BuildContext context, Object error) => const Offstage(),
      );

      final mockChannel = MockChannel();
      final initialMessages = _generateMessages(count: 10);
      // A new arrival shifts the tail — that's what should trigger pruning.
      // `offset` keeps the appended id distinct from `initialMessages`.
      final withNewArrival = [
        ...initialMessages,
        _generateMessages(count: 1, offset: initialMessages.length).first,
      ];
      final controller = StreamController<List<Message>>.broadcast();
      addTearDown(controller.close);

      when(() => mockChannel.state.isUpToDate).thenReturn(true);
      when(() => mockChannel.state.unreadCount).thenReturn(0);
      when(() => mockChannel.state.messages).thenReturn(initialMessages);
      when(() => mockChannel.state.messagesStream)
          .thenAnswer((_) => controller.stream);
      when(() => mockChannel.state.pruneOldest(any())).thenReturn(null);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: StreamChannel(
            channel: mockChannel,
            child: messageListCore,
          ),
        ),
      );

      // First emission carries the seeded tail — gate compares against
      // itself and does not prune (matches Android's "wait for new message
      // event before enforcing the cap on cached history").
      controller.add(initialMessages);
      await tester.pumpAndSettle();
      verifyNever(() => mockChannel.state.pruneOldest(any()));

      // Subsequent emission with a new tail does trigger a prune.
      controller.add(withNewArrival);
      await tester.pumpAndSettle();
      verify(() => mockChannel.state.pruneOldest(maximumMessageLimit))
          .called(greaterThanOrEqualTo(1));
    },
  );

  testWidgets(
    'should not call channel.state.pruneOldest when channel is not '
    'up to date',
    (tester) async {
      const messageListCoreKey = Key('messageListCore');

      final messageListCore = MessageListCore(
        key: messageListCoreKey,
        maximumMessageLimit: 5,
        messageListBuilder: (_, __) => const Offstage(),
        loadingBuilder: (BuildContext context) => const Offstage(),
        emptyBuilder: (BuildContext context) => const Offstage(),
        errorBuilder: (BuildContext context, Object error) => const Offstage(),
      );

      final mockChannel = MockChannel();
      final messages = _generateMessages(count: 10);

      when(() => mockChannel.state.isUpToDate).thenReturn(false);
      when(() => mockChannel.state.unreadCount).thenReturn(0);
      when(() => mockChannel.state.messages).thenReturn(messages);
      when(() => mockChannel.state.messagesStream)
          .thenAnswer((_) => Stream.value(messages));
      when(() => mockChannel.query(
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            membersPagination: any(named: 'membersPagination'),
            messagesPagination: any(named: 'messagesPagination'),
            preferOffline: any(named: 'preferOffline'),
            watchersPagination: any(named: 'watchersPagination'),
          )).thenAnswer((_) async => const ChannelState());

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

      verifyNever(() => mockChannel.state.pruneOldest(any()));
    },
  );

  testWidgets(
    'should not call channel.state.pruneOldest when count is within the limit',
    (tester) async {
      const messageListCoreKey = Key('messageListCore');

      final messageListCore = MessageListCore(
        key: messageListCoreKey,
        maximumMessageLimit: 100,
        messageListBuilder: (_, __) => const Offstage(),
        loadingBuilder: (BuildContext context) => const Offstage(),
        emptyBuilder: (BuildContext context) => const Offstage(),
        errorBuilder: (BuildContext context, Object error) => const Offstage(),
      );

      final mockChannel = MockChannel();
      final messages = _generateMessages();

      when(() => mockChannel.state.isUpToDate).thenReturn(true);
      when(() => mockChannel.state.unreadCount).thenReturn(0);
      when(() => mockChannel.state.messages).thenReturn(messages);
      when(() => mockChannel.state.messagesStream)
          .thenAnswer((_) => Stream.value(messages));

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

      verifyNever(() => mockChannel.state.pruneOldest(any()));
    },
  );

  Message _testMessage(String id) => Message(
        id: id,
        type: 'testType',
        user: User(id: 'testUserId'),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        text: 'message $id',
      );

  testWidgets(
    'should not call channel.state.pruneOldest when growth came from '
    'paginating older messages (tail unchanged across emissions)',
    (tester) async {
      const messageListCoreKey = Key('messageListCore');
      const maximumMessageLimit = 5;

      final messageListCore = MessageListCore(
        key: messageListCoreKey,
        maximumMessageLimit: maximumMessageLimit,
        messageListBuilder: (_, __) => const Offstage(),
        loadingBuilder: (BuildContext context) => const Offstage(),
        emptyBuilder: (BuildContext context) => const Offstage(),
        errorBuilder: (BuildContext context, Object error) => const Offstage(),
      );

      final mockChannel = MockChannel();

      // Initial emission: a list at the limit.
      final initial = [for (var i = 0; i < 5; i++) _testMessage('msg-$i')];
      // Second emission: same tail, with older messages prepended (the user
      // paginated up to load history).
      final prepended = [
        for (var i = 0; i < 8; i++) _testMessage('older-$i'),
        ...initial,
      ];

      final controller = StreamController<List<Message>>();
      addTearDown(controller.close);

      when(() => mockChannel.state.isUpToDate).thenReturn(true);
      when(() => mockChannel.state.unreadCount).thenReturn(0);
      when(() => mockChannel.state.messages).thenReturn(initial);
      when(() => mockChannel.state.messagesStream)
          .thenAnswer((_) => controller.stream);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: StreamChannel(
            channel: mockChannel,
            child: messageListCore,
          ),
        ),
      );

      controller.add(initial);
      await tester.pumpAndSettle();

      when(() => mockChannel.state.messages).thenReturn(prepended);
      controller.add(prepended);
      await tester.pumpAndSettle();

      // Tail message is unchanged across emissions, so growth is from
      // pagination — pruning must not fire or the just-loaded older
      // messages would be dropped immediately.
      verifyNever(() => mockChannel.state.pruneOldest(any()));
    },
  );

  testWidgets(
    'should call channel.state.pruneOldest when growth came from a new '
    'message arriving (tail changed)',
    (tester) async {
      const messageListCoreKey = Key('messageListCore');
      const maximumMessageLimit = 5;

      final messageListCore = MessageListCore(
        key: messageListCoreKey,
        maximumMessageLimit: maximumMessageLimit,
        retentionTrimBuffer: 0,
        messageListBuilder: (_, __) => const Offstage(),
        loadingBuilder: (BuildContext context) => const Offstage(),
        emptyBuilder: (BuildContext context) => const Offstage(),
        errorBuilder: (BuildContext context, Object error) => const Offstage(),
      );

      final mockChannel = MockChannel();

      final initial = [for (var i = 0; i < 5; i++) _testMessage('msg-$i')];
      final appended = [
        ...initial,
        for (var i = 0; i < 3; i++) _testMessage('newer-$i'),
      ];

      final controller = StreamController<List<Message>>();
      addTearDown(controller.close);

      when(() => mockChannel.state.isUpToDate).thenReturn(true);
      when(() => mockChannel.state.unreadCount).thenReturn(0);
      when(() => mockChannel.state.messages).thenReturn(initial);
      when(() => mockChannel.state.messagesStream)
          .thenAnswer((_) => controller.stream);
      when(() => mockChannel.state.pruneOldest(any())).thenReturn(null);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: StreamChannel(
            channel: mockChannel,
            child: messageListCore,
          ),
        ),
      );

      controller.add(initial);
      await tester.pumpAndSettle();

      when(() => mockChannel.state.messages).thenReturn(appended);
      controller.add(appended);
      await tester.pumpAndSettle();

      verify(() => mockChannel.state.pruneOldest(maximumMessageLimit))
          .called(greaterThanOrEqualTo(1));
    },
  );

  testWidgets(
    'should not call channel.state.pruneOldest when the tail message is '
    'edited (tail id unchanged)',
    (tester) async {
      const messageListCoreKey = Key('messageListCore');
      const maximumMessageLimit = 5;

      final messageListCore = MessageListCore(
        key: messageListCoreKey,
        maximumMessageLimit: maximumMessageLimit,
        retentionTrimBuffer: 0,
        messageListBuilder: (_, __) => const Offstage(),
        loadingBuilder: (BuildContext context) => const Offstage(),
        emptyBuilder: (BuildContext context) => const Offstage(),
        errorBuilder: (BuildContext context, Object error) => const Offstage(),
      );

      final mockChannel = MockChannel();

      // List is already over the cap; the gate is seeded with this tail.
      final initial = [for (var i = 0; i < 10; i++) _testMessage('msg-$i')];
      // Same ids, but the tail message is replaced with an edited copy.
      // Same length, same tail id — only the content of msg-9 changed.
      final edited = [
        ...initial.sublist(0, initial.length - 1),
        initial.last.copyWith(text: 'edited'),
      ];

      final controller = StreamController<List<Message>>();
      addTearDown(controller.close);

      when(() => mockChannel.state.isUpToDate).thenReturn(true);
      when(() => mockChannel.state.unreadCount).thenReturn(0);
      when(() => mockChannel.state.messages).thenReturn(initial);
      when(() => mockChannel.state.messagesStream)
          .thenAnswer((_) => controller.stream);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: StreamChannel(
            channel: mockChannel,
            child: messageListCore,
          ),
        ),
      );

      controller.add(initial);
      await tester.pumpAndSettle();

      when(() => mockChannel.state.messages).thenReturn(edited);
      controller.add(edited);
      await tester.pumpAndSettle();

      // Edits never shift the tail id, so retention must stay quiet — even
      // when the cap is already exceeded. Matches Android's "trim only on
      // new message arrivals" semantics; an edit on the latest message does
      // not invalidate the trimmed window.
      verifyNever(() => mockChannel.state.pruneOldest(any()));
    },
  );

  testWidgets(
    'should not call channel.state.pruneOldest when a non-tail message is '
    'edited',
    (tester) async {
      const messageListCoreKey = Key('messageListCore');
      const maximumMessageLimit = 5;

      final messageListCore = MessageListCore(
        key: messageListCoreKey,
        maximumMessageLimit: maximumMessageLimit,
        retentionTrimBuffer: 0,
        messageListBuilder: (_, __) => const Offstage(),
        loadingBuilder: (BuildContext context) => const Offstage(),
        emptyBuilder: (BuildContext context) => const Offstage(),
        errorBuilder: (BuildContext context, Object error) => const Offstage(),
      );

      final mockChannel = MockChannel();

      final initial = [for (var i = 0; i < 10; i++) _testMessage('msg-$i')];
      // Edit a message mid-list (reactions, soft-delete and content edits
      // all flow through this shape).
      final edited = [...initial]..[3] =
          initial[3].copyWith(text: 'edited mid-list');

      final controller = StreamController<List<Message>>();
      addTearDown(controller.close);

      when(() => mockChannel.state.isUpToDate).thenReturn(true);
      when(() => mockChannel.state.unreadCount).thenReturn(0);
      when(() => mockChannel.state.messages).thenReturn(initial);
      when(() => mockChannel.state.messagesStream)
          .thenAnswer((_) => controller.stream);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: StreamChannel(
            channel: mockChannel,
            child: messageListCore,
          ),
        ),
      );

      controller.add(initial);
      await tester.pumpAndSettle();

      when(() => mockChannel.state.messages).thenReturn(edited);
      controller.add(edited);
      await tester.pumpAndSettle();

      verifyNever(() => mockChannel.state.pruneOldest(any()));
    },
  );

  testWidgets(
    'should not call channel.state.pruneOldest in a thread conversation',
    (tester) async {
      const messageListCoreKey = Key('messageListCore');
      final threadMessages = _generateMessages(count: 10, threads: true);
      final parentMessage = Message(id: threadMessages.first.parentId);

      final messageListCore = MessageListCore(
        key: messageListCoreKey,
        maximumMessageLimit: 3,
        parentMessage: parentMessage,
        messageListBuilder: (_, __) => const Offstage(),
        loadingBuilder: (BuildContext context) => const Offstage(),
        emptyBuilder: (BuildContext context) => const Offstage(),
        errorBuilder: (BuildContext context, Object error) => const Offstage(),
      );

      final mockChannel = MockChannel();
      final threads = {parentMessage.id: threadMessages};

      when(() => mockChannel.state.isUpToDate).thenReturn(true);
      when(() => mockChannel.state.unreadCount).thenReturn(0);
      when(() => mockChannel.state.threads).thenReturn(threads);
      when(() => mockChannel.state.threadsStream)
          .thenAnswer((_) => Stream.value(threads));
      when(
        () => mockChannel.getReplies(
          parentMessage.id,
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => QueryRepliesResponse()..messages = []);

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

      verifyNever(() => mockChannel.state.pruneOldest(any()));
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

      final threads = {parentMessage.id: messages};

      when(() => mockChannel.state.threads).thenReturn(threads);
      when(() => mockChannel.state.threadsStream)
          .thenAnswer((_) => Stream.value(threads));
      when(() => mockChannel.state.unreadCount).thenReturn(0);

      when(
        () => mockChannel.getReplies(
          parentMessage.id,
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => QueryRepliesResponse()..messages = []);

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

  group('MessageRetentionGate', () {
    Message msg(String id) => Message(
          id: id,
          type: 'testType',
          user: User(id: 'testUserId'),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          text: id,
        );

    test('does not prune when limit is null', () {
      final gate = MessageRetentionGate(limit: null);
      final data = [for (var i = 0; i < 100; i++) msg('m$i')];
      expect(gate.evaluate(data: data, isUpToDate: true), isFalse);
    });

    test('does not prune when channel is not up to date', () {
      final gate = MessageRetentionGate(limit: 5, trimBuffer: 0);
      final data = [for (var i = 0; i < 10; i++) msg('m$i')];
      expect(gate.evaluate(data: data, isUpToDate: false), isFalse);
    });

    test('does not prune when count is at or below limit + buffer', () {
      final gate = MessageRetentionGate(limit: 5, trimBuffer: 5);
      final atThreshold = [for (var i = 0; i < 10; i++) msg('m$i')];
      expect(gate.evaluate(data: atThreshold, isUpToDate: true), isFalse);
    });

    test('prunes when count exceeds limit + buffer and tail changed', () {
      final gate = MessageRetentionGate(limit: 5, trimBuffer: 5);
      // First emission has no prior tail — gate treats it as a change.
      final first = [for (var i = 0; i < 11; i++) msg('m$i')];
      expect(gate.evaluate(data: first, isUpToDate: true), isTrue);
    });

    test('does not prune when tail is unchanged across emissions', () {
      final gate = MessageRetentionGate(limit: 5, trimBuffer: 0);
      final first = [for (var i = 0; i < 10; i++) msg('m$i')];
      gate.evaluate(data: first, isUpToDate: true);
      // Same tail, more head (top-pagination shape).
      final prepended = [
        for (var i = 0; i < 5; i++) msg('older-$i'),
        ...first,
      ];
      expect(gate.evaluate(data: prepended, isUpToDate: true), isFalse);
    });

    test('prunes again when tail changes after a prepend-only emission', () {
      final gate = MessageRetentionGate(limit: 5, trimBuffer: 0);
      final first = [for (var i = 0; i < 10; i++) msg('m$i')];
      gate.evaluate(data: first, isUpToDate: true);
      // Pagination top — no prune.
      final prepended = [msg('older-0'), ...first];
      gate.evaluate(data: prepended, isUpToDate: true);
      // New live message — prune fires.
      final appended = [...prepended, msg('m-new')];
      expect(gate.evaluate(data: appended, isUpToDate: true), isTrue);
    });

    test('does not prune when the tail message is deleted', () {
      final gate = MessageRetentionGate(limit: 5, trimBuffer: 0);
      // Push the cached count above threshold via top-pagination (tail
      // unchanged) so a later tail-id change can't be explained by growth.
      final first = [for (var i = 0; i < 10; i++) msg('m$i')];
      gate.evaluate(data: first, isUpToDate: true);
      final prepended = [
        for (var i = 0; i < 5; i++) msg('older-$i'),
        ...first,
      ];
      gate.evaluate(data: prepended, isUpToDate: true);
      // Deleting the tail shrinks the list and rotates the tail id — must
      // not be mistaken for "new data" or pruning would also reset the
      // top-pagination tracker on StreamChannel.
      final tailDeleted = prepended.sublist(0, prepended.length - 1);
      expect(gate.evaluate(data: tailDeleted, isUpToDate: true), isFalse);
    });

    test('configure updates limit without clearing cached tail', () {
      final gate = MessageRetentionGate(limit: 100, trimBuffer: 0);
      final data = [for (var i = 0; i < 50; i++) msg('m$i')];
      gate
        ..evaluate(data: data, isUpToDate: true)
        // Below the original limit — no prune.
        ..configure(limit: 10, trimBuffer: 0);
      // Now the same data should prune because the limit shrank, but the
      // tail hasn't changed since the previous observation, so the gate
      // still reports false. This is intentional: a configure-only path
      // doesn't force-prune mid-stream — the caller drives that.
      expect(gate.evaluate(data: data, isUpToDate: true), isFalse);
    });

    test('seed keeps the cached tail in sync with external mutations', () {
      final gate = MessageRetentionGate(limit: 5, trimBuffer: 0);
      final initial = [for (var i = 0; i < 10; i++) msg('m$i')];
      gate.evaluate(data: initial, isUpToDate: true);
      // Caller pruned externally — tell the gate the new tail.
      final pruned = initial.sublist(5);
      gate.seed(pruned);
      // Re-emitting the pruned list with the same tail is treated as
      // unchanged → no prune.
      expect(gate.evaluate(data: pruned, isUpToDate: true), isFalse);
    });

    test('seed with cached history suppresses prune on the first emission', () {
      final gate = MessageRetentionGate(limit: 5, trimBuffer: 0);
      final initial = [for (var i = 0; i < 10; i++) msg('m$i')];
      // Mount-time seed primes the gate with whatever the channel had
      // cached. The next emission carrying the same tail must NOT
      // trigger a prune — that's how Android-parity cached history is
      // preserved on attach.
      gate.seed(initial);
      expect(gate.evaluate(data: initial, isUpToDate: true), isFalse);
    });

    test('handles empty emissions without throwing', () {
      final gate = MessageRetentionGate(limit: 5, trimBuffer: 0);
      expect(
        () => gate.evaluate(data: const [], isUpToDate: true),
        returnsNormally,
      );
    });
  });

  group('MessageListCore retention lifecycle', () {
    Message msg(String id) => Message(
          id: id,
          type: 'testType',
          user: User(id: 'testUserId'),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          text: id,
        );

    Widget _hostListCore({
      required Channel channel,
      required Key coreKey,
      int? maximumMessageLimit,
      int retentionTrimBuffer = 0,
      Message? parentMessage,
    }) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: StreamChannel(
          key: ValueKey(channel),
          channel: channel,
          child: MessageListCore(
            key: coreKey,
            maximumMessageLimit: maximumMessageLimit,
            retentionTrimBuffer: retentionTrimBuffer,
            parentMessage: parentMessage,
            messageListBuilder: (_, __) => const Offstage(),
            loadingBuilder: (_) => const Offstage(),
            emptyBuilder: (_) => const Offstage(),
            errorBuilder: (_, __) => const Offstage(),
          ),
        ),
      );
    }

    testWidgets(
      'reseeds gate when channel changes so the new tail is treated fresh',
      (tester) async {
        const coreKey = Key('messageListCore');

        final channelA = MockChannel();
        final channelB = MockChannel();
        final messagesA = [for (var i = 0; i < 10; i++) msg('a-$i')];
        final messagesB = [for (var i = 0; i < 10; i++) msg('b-$i')];

        for (final entry in [
          (channelA, messagesA),
          (channelB, messagesB),
        ]) {
          final c = entry.$1;
          final m = entry.$2;
          when(() => c.state.isUpToDate).thenReturn(true);
          when(() => c.state.unreadCount).thenReturn(0);
          when(() => c.state.messages).thenReturn(m);
          when(() => c.state.messagesStream).thenAnswer((_) => Stream.value(m));
          when(() => c.state.pruneOldest(any())).thenReturn(null);
        }

        await tester.pumpWidget(_hostListCore(
          channel: channelA,
          coreKey: coreKey,
          maximumMessageLimit: 5,
        ));
        await tester.pumpAndSettle();

        // Channel A's first emission is compared against the seeded tail —
        // no prune on cached history.
        verifyNever(() => channelA.state.pruneOldest(any()));

        await tester.pumpWidget(_hostListCore(
          channel: channelB,
          coreKey: coreKey,
          maximumMessageLimit: 5,
        ));
        await tester.pumpAndSettle();

        // After the channel switch the gate is re-seeded with channel B's
        // tail, so channel B's first emission also doesn't prune (and the
        // gate doesn't compare against channel A's stale tail).
        verifyNever(() => channelB.state.pruneOldest(any()));
      },
    );

    testWidgets(
      'reseeds gate when toggling thread mode',
      (tester) async {
        const coreKey = Key('messageListCore');

        final mockChannel = MockChannel();
        final mainMessages = [for (var i = 0; i < 10; i++) msg('main-$i')];
        final parent = msg('parent');
        final threadMessages = [
          for (var i = 0; i < 3; i++)
            msg('reply-$i').copyWith(parentId: parent.id),
        ];

        when(() => mockChannel.state.isUpToDate).thenReturn(true);
        when(() => mockChannel.state.unreadCount).thenReturn(0);
        when(() => mockChannel.state.messages).thenReturn(mainMessages);
        when(() => mockChannel.state.messagesStream)
            .thenAnswer((_) => Stream.value(mainMessages));
        when(() => mockChannel.state.pruneOldest(any())).thenReturn(null);
        when(() => mockChannel.state.threads)
            .thenReturn({parent.id: threadMessages});
        when(() => mockChannel.state.threadsStream)
            .thenAnswer((_) => Stream.value({parent.id: threadMessages}));
        when(() => mockChannel.getReplies(
              parent.id,
              options: any(named: 'options'),
            )).thenAnswer((_) async => QueryRepliesResponse()..messages = []);

        // Start on main channel — first emission is compared against the
        // seeded tail and does not prune.
        await tester.pumpWidget(_hostListCore(
          channel: mockChannel,
          coreKey: coreKey,
          maximumMessageLimit: 5,
        ));
        await tester.pumpAndSettle();

        verifyNever(() => mockChannel.state.pruneOldest(any()));
        clearInteractions(mockChannel.state);

        // Switch to thread mode — gate is re-seeded with the thread tail.
        await tester.pumpWidget(_hostListCore(
          channel: mockChannel,
          coreKey: coreKey,
          maximumMessageLimit: 5,
          parentMessage: parent,
        ));
        await tester.pumpAndSettle();

        // While in thread mode, the gate must never prune (threads are
        // out of scope for this auto-prune logic).
        verifyNever(() => mockChannel.state.pruneOldest(any()));

        // Switch back to main — the gate is re-seeded with the main
        // channel's tail; the first emission still doesn't prune cached
        // history (consistent with the seed semantics on every channel /
        // mode transition).
        clearInteractions(mockChannel.state);
        await tester.pumpWidget(_hostListCore(
          channel: mockChannel,
          coreKey: coreKey,
          maximumMessageLimit: 5,
        ));
        await tester.pumpAndSettle();

        verifyNever(() => mockChannel.state.pruneOldest(any()));
      },
    );

    testWidgets(
      'respects the trim buffer (does not prune until limit + buffer exceeded)',
      (tester) async {
        const coreKey = Key('messageListCore');

        final mockChannel = MockChannel();
        // Limit 5 + buffer 30 → trim threshold is 36. 30 messages should
        // not trigger a prune.
        final under = [for (var i = 0; i < 30; i++) msg('m-$i')];

        when(() => mockChannel.state.isUpToDate).thenReturn(true);
        when(() => mockChannel.state.unreadCount).thenReturn(0);
        when(() => mockChannel.state.messages).thenReturn(under);
        when(() => mockChannel.state.messagesStream)
            .thenAnswer((_) => Stream.value(under));

        await tester.pumpWidget(_hostListCore(
          channel: mockChannel,
          coreKey: coreKey,
          maximumMessageLimit: 5,
          retentionTrimBuffer: 30,
        ));
        await tester.pumpAndSettle();

        verifyNever(() => mockChannel.state.pruneOldest(any()));
      },
    );
  });
}
