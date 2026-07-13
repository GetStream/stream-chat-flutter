// Tests for `StreamMessageListView`'s mark-read-at-the-bottom behavior.
//
// The logic lives in `_handleLastItemFullyVisible` →
// `_maybeMarkMessagesAsRead`. It fires `channel.markRead()` when the user
// reaches the bottom of the list, gated on:
//
//   1. `markReadWhenAtTheBottom` is true (the default).
//   2. `channel.state.isUpToDate` is true (or we're in a thread).
//   3. `channel.state.unreadCount > 0`.
//
// In a thread, it fires `channel.markThreadRead(parentId)` instead, and is
// additionally gated on the parent having at least one reply — the server-side
// thread object only exists after the first reply, so an earlier call 404s.
//
// These tests pin the expected behavior so regressions in the underlying
// position-listener flow (SPL `itemPositions`, scroll wiring, etc.) surface
// here instead of as user-visible bugs.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../test_utils/data_generator.dart';
import '../mocks.dart';

void main() {
  late StreamChatClient client;
  late Channel channel;
  late ChannelClientState channelClientState;
  late ClientState clientState;

  late StreamController<bool> isUpToDateController;
  late StreamController<int> unreadCountController;
  late StreamController<List<Message>> messagesController;
  late StreamController<Map<String, List<Message>>> threadsController;

  setUpAll(() {
    registerFallbackValue(EventType.messageNew);
  });

  setUp(() {
    client = MockClient();
    clientState = MockClientState();
    when(() => client.state).thenAnswer((_) => clientState);
    final own = OwnUser(id: 'ownid');
    when(() => clientState.currentUser).thenReturn(own);
    when(() => clientState.currentUserStream)
        .thenAnswer((_) => Stream.value(own));

    channel = MockChannel();
    when(() => channel.on(any(), any(), any(), any()))
        .thenAnswer((_) => const Stream.empty());
    channelClientState = MockChannelState();
    when(() => channel.client).thenReturn(client);
    when(() => channel.state).thenReturn(channelClientState);

    isUpToDateController = StreamController<bool>.broadcast();
    unreadCountController = StreamController<int>.broadcast();
    messagesController = StreamController<List<Message>>.broadcast();
    threadsController =
        StreamController<Map<String, List<Message>>>.broadcast();
    addTearDown(isUpToDateController.close);
    addTearDown(unreadCountController.close);
    addTearDown(messagesController.close);
    addTearDown(threadsController.close);

    when(() => channelClientState.threadsStream)
        .thenAnswer((_) => threadsController.stream);
    when(() => channelClientState.threads).thenReturn(const {});
    when(() => channelClientState.isUpToDateStream)
        .thenAnswer((_) => isUpToDateController.stream);
    when(() => channelClientState.unreadCountStream)
        .thenAnswer((_) => unreadCountController.stream);
    when(() => channelClientState.readStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.read).thenReturn([]);
    when(() => channelClientState.membersStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.members).thenReturn([]);
    when(() => channelClientState.currentUserRead).thenReturn(null);
    when(() => channelClientState.currentUserReadStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.messagesStream)
        .thenAnswer((_) => messagesController.stream);

    // Mark-read mocks return immediately.
    when(() => channel.markRead(messageId: any(named: 'messageId')))
        .thenAnswer((_) async => EmptyResponse());
    when(() => channel.markThreadRead(any()))
        .thenAnswer((_) async => EmptyResponse());
    // Thread reply loader called by MessageListCore when parentMessage is set.
    when(
      () => channel.getReplies(
        any(),
        options: any(named: 'options'),
        preferOffline: any(named: 'preferOffline'),
      ),
    ).thenAnswer((_) async => QueryRepliesResponse()..messages = []);
  });

  Future<void> pumpMessageList(
    WidgetTester tester, {
    required List<Message> messages,
    required bool isUpToDate,
    required int unreadCount,
    bool markReadWhenAtTheBottom = true,
    Message? parentMessage,
  }) async {
    when(() => channelClientState.isUpToDate).thenReturn(isUpToDate);
    when(() => channelClientState.unreadCount).thenReturn(unreadCount);
    when(() => channelClientState.messages).thenReturn(messages);

    // In thread mode, MessageListCore reads from state.threads[parentId] and
    // subscribes to state.threadsStream. Seed both so the reply list renders.
    if (parentMessage != null) {
      when(() => channelClientState.threads)
          .thenReturn({parentMessage.id: messages});
    }

    await tester.runAsync(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: DefaultAssetBundle(
            bundle: rootBundle,
            child: StreamChat(
              client: client,
              streamChatThemeData: StreamChatThemeData.light(),
              child: StreamChannel(
                channel: channel,
                child: StreamMessageListView(
                  parentMessage: parentMessage,
                  markReadWhenAtTheBottom: markReadWhenAtTheBottom,
                ),
              ),
            ),
          ),
        ),
      );
      // Prime the streams.
      isUpToDateController.add(isUpToDate);
      unreadCountController.add(unreadCount);
      if (parentMessage != null) {
        threadsController.add({parentMessage.id: messages});
      } else {
        messagesController.add(messages);
      }
      await tester.pumpAndSettle();
    });
  }

  group('markRead gates', () {
    testWidgets(
      'fires when the user lands at the bottom with isUpToDate=true and '
      'unreadCount>0',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]);

        await pumpMessageList(
          tester,
          messages: messages,
          isUpToDate: true,
          unreadCount: 5,
        );

        verify(() => channel.markRead(messageId: any(named: 'messageId')))
            .called(1);
      },
    );

    testWidgets(
      'does NOT fire when isUpToDate=false (gate on incomplete state)',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]);

        await pumpMessageList(
          tester,
          messages: messages,
          isUpToDate: false,
          unreadCount: 5,
        );

        verifyNever(
          () => channel.markRead(messageId: any(named: 'messageId')),
        );
      },
    );

    testWidgets(
      'does NOT fire when unreadCount is 0',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]);

        await pumpMessageList(
          tester,
          messages: messages,
          isUpToDate: true,
          unreadCount: 0,
        );

        verifyNever(
          () => channel.markRead(messageId: any(named: 'messageId')),
        );
      },
    );

    testWidgets(
      'does NOT fire when markReadWhenAtTheBottom is false',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]);

        await pumpMessageList(
          tester,
          messages: messages,
          isUpToDate: true,
          unreadCount: 5,
          markReadWhenAtTheBottom: false,
        );

        verifyNever(
          () => channel.markRead(messageId: any(named: 'messageId')),
        );
      },
    );
  });

  group('thread markThreadRead gates', () {
    testWidgets(
      'does NOT fire when parentMessage.replyCount is 0 '
      '(thread does not yet exist server-side)',
      (tester) async {
        final other = User(id: 'otherid');
        final parent = Message(
          id: 'parent-id',
          user: other,
          text: 'parent',
          createdAt: DateTime.utc(2026),
        );

        await pumpMessageList(
          tester,
          parentMessage: parent,
          messages: [],
          isUpToDate: true,
          unreadCount: 0,
        );

        verifyNever(() => channel.markThreadRead(any()));
      },
    );

    testWidgets(
      'fires when parentMessage.replyCount > 0',
      (tester) async {
        final other = User(id: 'otherid');
        final parent = Message(
          id: 'parent-id',
          user: other,
          text: 'parent',
          replyCount: 1,
          createdAt: DateTime.utc(2026),
        );
        final reply = Message(
          id: 'reply-id',
          user: other,
          text: 'reply',
          parentId: parent.id,
          createdAt: DateTime.utc(2026, 1, 1, 0, 1),
        );

        await pumpMessageList(
          tester,
          parentMessage: parent,
          messages: [parent, reply],
          isUpToDate: true,
          unreadCount: 0,
        );

        verify(() => channel.markThreadRead(parent.id)).called(1);
      },
    );

    testWidgets(
      'does NOT fire markRead (channel-level) when in a thread',
      (tester) async {
        final other = User(id: 'otherid');
        final parent = Message(
          id: 'parent-id',
          user: other,
          text: 'parent',
          replyCount: 1,
          createdAt: DateTime.utc(2026),
        );
        final reply = Message(
          id: 'reply-id',
          user: other,
          text: 'reply',
          parentId: parent.id,
          createdAt: DateTime.utc(2026, 1, 1, 0, 1),
        );

        await pumpMessageList(
          tester,
          parentMessage: parent,
          messages: [parent, reply],
          isUpToDate: true,
          unreadCount: 5,
        );

        verifyNever(
          () => channel.markRead(messageId: any(named: 'messageId')),
        );
      },
    );
  });

  group('scroll-to-bottom button visibility', () {
    testWidgets(
      'is hidden when the user lands at the bottom with isUpToDate=true',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]);

        await pumpMessageList(
          tester,
          messages: messages,
          isUpToDate: true,
          unreadCount: 0,
        );

        // The default scroll-to-bottom button is a FloatingActionButton.
        expect(find.byType(FloatingActionButton), findsNothing);
      },
    );
  });
}
