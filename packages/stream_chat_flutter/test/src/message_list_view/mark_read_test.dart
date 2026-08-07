// Tests for `StreamMessageListView`'s mark-read-at-the-bottom behavior.
//
// The logic lives in `_handleItemPositionsChanged` →
// `_maybeMarkMessagesAsRead` (FLU-640). Marking the channel read requires all
// of:
//
//   1. `markReadWhenAtTheBottom` is true (the default).
//   2. `channel.state.isUpToDate` is true (or we're in a thread).
//   3. `channel.state.unreadCount > 0`.
//   4. The bottom has been seen (now, or earlier then scrolled away).
//   5. The pre-existing unread boundary (if any) has been seen or scrolled
//      past — trivially satisfied when the channel opened fully read.
//   6. There is no active manual mark-unread (`channel.state.isMarkedAsUnread`).
//
// `StreamMessageListViewConfiguration.shouldMarkRead` can override 4-6.
//
// In a thread, it fires `channel.markThreadRead(parentId)` instead, gated
// only on the parent having at least one reply and the channel being up to
// date — conditions 4-6 don't apply there.
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
  late OwnUser ownUser;

  late StreamController<bool> isUpToDateController;
  late StreamController<int> unreadCountController;
  late StreamController<List<Message>> messagesController;
  late StreamController<Map<String, List<Message>>> threadsController;
  late StreamController<Read?> currentUserReadController;

  setUpAll(() {
    registerFallbackValue(EventType.messageNew);
  });

  setUp(() {
    client = MockClient();
    clientState = MockClientState();
    when(() => client.state).thenAnswer((_) => clientState);
    ownUser = OwnUser(id: 'ownid');
    when(() => clientState.currentUser).thenReturn(ownUser);
    when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(ownUser));

    channel = MockChannel();
    channelClientState = MockChannelState();
    when(() => channel.client).thenReturn(client);
    when(() => channel.state).thenReturn(channelClientState);
    when(() => client.isLocalUnreadCountEnabled).thenReturn(false);

    isUpToDateController = StreamController<bool>.broadcast();
    unreadCountController = StreamController<int>.broadcast();
    messagesController = StreamController<List<Message>>.broadcast();
    threadsController = StreamController<Map<String, List<Message>>>.broadcast();
    currentUserReadController = StreamController<Read?>.broadcast();
    addTearDown(isUpToDateController.close);
    addTearDown(unreadCountController.close);
    addTearDown(messagesController.close);
    addTearDown(threadsController.close);
    addTearDown(currentUserReadController.close);

    when(() => channelClientState.threadsStream).thenAnswer((_) => threadsController.stream);
    when(() => channelClientState.threads).thenReturn(const {});
    when(() => channelClientState.isUpToDateStream).thenAnswer((_) => isUpToDateController.stream);
    when(() => channelClientState.unreadCountStream).thenAnswer((_) => unreadCountController.stream);
    when(() => channelClientState.readStream).thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.read).thenReturn([]);
    when(() => channelClientState.membersStream).thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.members).thenReturn([]);
    when(() => channelClientState.currentUserReadStream).thenAnswer((_) => currentUserReadController.stream);
    when(() => channelClientState.messagesStream).thenAnswer((_) => messagesController.stream);
    when(() => channelClientState.isMarkedAsUnread).thenReturn(false);

    // Mark-read mocks return immediately.
    when(() => channel.markRead(messageId: any(named: 'messageId'))).thenAnswer((_) async => EmptyResponse());
    when(() => channel.markThreadRead(any())).thenAnswer((_) async => EmptyResponse());
    // Thread reply loader called by MessageListCore when parentMessage is set.
    when(
      () => channel.getReplies(
        any(),
        options: any(named: 'options'),
        preferOffline: any(named: 'preferOffline'),
      ),
    ).thenAnswer((_) async => QueryRepliesResponse()..messages = []);
  });

  // Default: opened with nothing pre-existing unread, so the FLU-640
  // "has seen the first unread boundary" condition is trivially satisfied
  // and doesn't gate these tests unless a `currentUserRead` override says
  // otherwise.
  Read noPreexistingUnreadRead() => Read(user: ownUser, lastRead: DateTime.now(), unreadMessages: 0);

  Future<void> pumpMessageList(
    WidgetTester tester, {
    required List<Message> messages,
    required bool isUpToDate,
    required int unreadCount,
    bool markReadWhenAtTheBottom = true,
    Message? parentMessage,
    Read? currentUserRead,
    bool openAtFirstUnread = false,
    StreamShouldMarkReadPredicate? shouldMarkRead,
  }) async {
    when(() => channelClientState.isUpToDate).thenReturn(isUpToDate);
    when(() => channelClientState.unreadCount).thenReturn(unreadCount);
    when(() => channelClientState.messages).thenReturn(messages);

    final resolvedRead = currentUserRead ?? noPreexistingUnreadRead();
    when(() => channelClientState.currentUserRead).thenReturn(resolvedRead);

    // In thread mode, MessageListCore reads from state.threads[parentId] and
    // subscribes to state.threadsStream. Seed both so the reply list renders.
    if (parentMessage != null) {
      when(() => channelClientState.threads).thenReturn({parentMessage.id: messages});
    }

    await tester.runAsync(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: DefaultAssetBundle(
            bundle: rootBundle,
            child: StreamChat(
              client: client,
              themeData: StreamChatThemeData(),
              child: StreamChannel(
                channel: channel,
                openAtFirstUnread: openAtFirstUnread,
                child: StreamMessageListView(
                  parentMessage: parentMessage,
                  config: StreamMessageListViewConfiguration(
                    markReadWhenAtTheBottom: markReadWhenAtTheBottom,
                    shouldMarkRead: shouldMarkRead,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      // Prime the streams.
      isUpToDateController.add(isUpToDate);
      unreadCountController.add(unreadCount);
      currentUserReadController.add(resolvedRead);
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
        final messages = generateConversation(20, users: [other]).reversed.toList();

        await pumpMessageList(
          tester,
          messages: messages,
          isUpToDate: true,
          unreadCount: 5,
        );

        verify(() => channel.markRead(messageId: any(named: 'messageId'))).called(1);
      },
    );

    testWidgets(
      'does NOT fire when isUpToDate=false (gate on incomplete state)',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]).reversed.toList();

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
        final messages = generateConversation(20, users: [other]).reversed.toList();

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
        final messages = generateConversation(20, users: [other]).reversed.toList();

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

    testWidgets(
      'does NOT fire when opened at the bottom with an unseen pre-existing '
      'unread boundary (FLU-640)',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]).reversed.toList();
        // A boundary partway through the list — the user hasn't scrolled up
        // to see it since the list opens at the bottom.
        final lastReadMessageId = messages[10].id;

        await pumpMessageList(
          tester,
          messages: messages,
          isUpToDate: true,
          unreadCount: 5,
          openAtFirstUnread: false,
          currentUserRead: Read(
            user: ownUser,
            lastRead: DateTime.now(),
            unreadMessages: 5,
            lastReadMessageId: lastReadMessageId,
          ),
        );

        verifyNever(() => channel.markRead(messageId: any(named: 'messageId')));
      },
    );

    testWidgets(
      'does NOT fire when the channel has an active manual mark-unread',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]).reversed.toList();
        when(() => channelClientState.isMarkedAsUnread).thenReturn(true);

        await pumpMessageList(
          tester,
          messages: messages,
          isUpToDate: true,
          unreadCount: 5,
        );

        verifyNever(() => channel.markRead(messageId: any(named: 'messageId')));
      },
    );

    testWidgets(
      'fires once the viewport genuinely changes after mounting with an '
      'already-active manual mark-unread (no live transition for '
      '_handleCurrentUserReadChanged to hook the snapshot on)',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(40, users: [other]).reversed.toList();
        when(() => channelClientState.isMarkedAsUnread).thenReturn(true);

        await pumpMessageList(
          tester,
          messages: messages,
          isUpToDate: true,
          unreadCount: 5,
        );

        // The very first layout — at the bottom, nothing scrolled yet — is
        // exactly the moment the viewport snapshot gets captured. Marking
        // read here would be the reintroduced deadlock: a channel that
        // opens already marked unread and happens to land at the bottom
        // would get instantly marked read again before the user did
        // anything.
        verifyNever(() => channel.markRead(messageId: any(named: 'messageId')));

        // A genuine scroll away and back changes the viewport, proving the
        // user did something since the snapshot was taken — this should
        // no longer be blocked.
        await tester.drag(find.byType(StreamMessageListView), const Offset(0, 400));
        await tester.pumpAndSettle();
        await tester.drag(find.byType(StreamMessageListView), const Offset(0, -1000));
        await tester.pumpAndSettle();

        verify(() => channel.markRead(messageId: any(named: 'messageId'))).called(1);
      },
    );

    testWidgets(
      'a shouldMarkRead override that returns false blocks an otherwise-allowed mark-read',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]).reversed.toList();
        StreamMarkReadDetails? capturedDetails;

        await pumpMessageList(
          tester,
          messages: messages,
          isUpToDate: true,
          unreadCount: 5,
          shouldMarkRead: (details) {
            capturedDetails = details;
            return false;
          },
        );

        verifyNever(() => channel.markRead(messageId: any(named: 'messageId')));

        // Opened at the bottom with nothing pre-existing unread and no
        // active manual mark-unread — the default gating would have
        // allowed this; only the override blocks it.
        expect(capturedDetails, isNotNull);
        expect(capturedDetails!.unreadCount, 5);
        expect(capturedDetails!.hasSeenLastMessage, isTrue);
        expect(capturedDetails!.hasSeenFirstUnreadMessage, isTrue);
        expect(capturedDetails!.isMarkedAsUnread, isFalse);
      },
    );

    testWidgets(
      'a shouldMarkRead override that returns true allows a mark-read the default gating would block',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]).reversed.toList();
        final lastReadMessageId = messages[10].id;
        StreamMarkReadDetails? capturedDetails;

        await pumpMessageList(
          tester,
          messages: messages,
          isUpToDate: true,
          unreadCount: 5,
          openAtFirstUnread: false,
          currentUserRead: Read(
            user: ownUser,
            lastRead: DateTime.now(),
            unreadMessages: 5,
            lastReadMessageId: lastReadMessageId,
          ),
          shouldMarkRead: (details) {
            capturedDetails = details;
            return true;
          },
        );

        verify(() => channel.markRead(messageId: any(named: 'messageId'))).called(1);

        // The unseen pre-existing unread boundary is exactly what the
        // default gating would have blocked on; the override allows it
        // anyway.
        expect(capturedDetails, isNotNull);
        expect(capturedDetails!.unreadCount, 5);
        expect(capturedDetails!.hasSeenFirstUnreadMessage, isFalse);
        expect(capturedDetails!.isMarkedAsUnread, isFalse);
      },
    );

    testWidgets(
      'a shouldMarkRead override sees isMarkedAsUnread when the channel has an active manual mark-unread',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]).reversed.toList();
        when(() => channelClientState.isMarkedAsUnread).thenReturn(true);
        StreamMarkReadDetails? capturedDetails;

        await pumpMessageList(
          tester,
          messages: messages,
          isUpToDate: true,
          unreadCount: 5,
          shouldMarkRead: (details) {
            capturedDetails = details;
            return false;
          },
        );

        expect(capturedDetails, isNotNull);
        expect(capturedDetails!.isMarkedAsUnread, isTrue);
        expect(capturedDetails!.unreadCount, 5);
      },
    );
  });

  group('thread markThreadRead gates', () {
    testWidgets(
      'does NOT fire when parentMessage.replyCount is 0 (thread does not yet exist server-side)',
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

        verifyNever(() => channel.markRead(messageId: any(named: 'messageId')));
      },
    );
  });

  group('scroll-to-bottom button visibility', () {
    testWidgets(
      'is hidden when the user lands at the bottom with isUpToDate=true',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]).reversed.toList();

        await pumpMessageList(
          tester,
          messages: messages,
          isUpToDate: true,
          unreadCount: 0,
        );

        // The default scroll-to-bottom button is a floating StreamButton,
        // shown only while scrolled away from the bottom.
        expect(find.byType(StreamButton), findsNothing);
      },
    );
  });

  group('unread pill', () {
    testWidgets(
      'shown when opened at the bottom with an unseen pre-existing unread boundary',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]).reversed.toList();
        final lastReadMessageId = messages[10].id;

        await pumpMessageList(
          tester,
          messages: messages,
          isUpToDate: true,
          unreadCount: 5,
          openAtFirstUnread: false,
          currentUserRead: Read(
            user: ownUser,
            lastRead: DateTime.now(),
            unreadMessages: 5,
            lastReadMessageId: lastReadMessageId,
          ),
        );

        expect(find.byType(UnreadIndicatorButton), findsOneWidget);
      },
    );

    testWidgets(
      'absent when the channel opened with nothing pre-existing unread',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]).reversed.toList();

        await pumpMessageList(
          tester,
          messages: messages,
          isUpToDate: true,
          unreadCount: 0,
          openAtFirstUnread: false,
        );

        expect(find.byType(UnreadIndicatorButton), findsNothing);
      },
    );

    testWidgets(
      'is shown immediately even when the boundary message has not loaded yet '
      '(top pagination pending)',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]).reversed.toList();
        // Not part of the loaded window — simulates the read boundary sitting
        // further back in history than top pagination has reached yet. The
        // pill's count is known from the `Read` itself, so it shouldn't have
        // to wait on the anchor message to load before appearing.
        const lastReadMessageId = 'not-yet-loaded-message-id';

        await pumpMessageList(
          tester,
          messages: messages,
          isUpToDate: true,
          unreadCount: 5,
          openAtFirstUnread: false,
          currentUserRead: Read(
            user: ownUser,
            lastRead: DateTime.now(),
            unreadMessages: 5,
            lastReadMessageId: lastReadMessageId,
          ),
        );

        final indicator = tester.widget<UnreadIndicatorButton>(
          find.byType(UnreadIndicatorButton),
        );
        expect(indicator.unreadCount, 5);
      },
    );

    testWidgets(
      "tapping jump before the anchor resolves falls back to the boundary's "
      'lastReadMessageId instead of doing nothing',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]).reversed.toList();
        const lastReadMessageId = 'not-yet-loaded-message-id';

        when(
          () => channel.query(
            preferOffline: any(named: 'preferOffline'),
            messagesPagination: any(named: 'messagesPagination'),
          ),
        ).thenAnswer((_) async => const ChannelState(messages: []));

        await pumpMessageList(
          tester,
          messages: messages,
          isUpToDate: true,
          unreadCount: 5,
          openAtFirstUnread: false,
          currentUserRead: Read(
            user: ownUser,
            lastRead: DateTime.now(),
            unreadMessages: 5,
            lastReadMessageId: lastReadMessageId,
          ),
        );

        final indicator = tester.widget<UnreadIndicatorButton>(
          find.byType(UnreadIndicatorButton),
        );
        // Not awaited directly: `_scrollToMessage`'s fallback awaits
        // `WidgetsBinding.instance.endOfFrame` after the query, which only
        // resolves once the test binding actually pumps a frame.
        unawaited(indicator.onJumpTap());
        await tester.pumpAndSettle();

        verify(
          () => channel.query(
            preferOffline: false,
            messagesPagination: const PaginationParams(limit: 30, idAround: lastReadMessageId),
          ),
        ).called(1);
      },
    );
  });

  group('unread indicator dismiss', () {
    testWidgets(
      'marks the channel read immediately when tapped',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]).reversed.toList();
        final lastReadMessageId = messages[10].id;

        await pumpMessageList(
          tester,
          messages: messages,
          isUpToDate: true,
          unreadCount: 5,
          markReadWhenAtTheBottom: false,
          openAtFirstUnread: false,
          currentUserRead: Read(
            user: ownUser,
            lastRead: DateTime.now(),
            unreadMessages: 5,
            lastReadMessageId: lastReadMessageId,
          ),
        );

        // Nothing has marked the channel read yet.
        verifyNever(() => channel.markRead(messageId: any(named: 'messageId')));

        final indicator = tester.widget<UnreadIndicatorButton>(
          find.byType(UnreadIndicatorButton),
        );
        await indicator.onDismissTap();

        verify(() => channel.markRead(messageId: any(named: 'messageId'))).called(1);
      },
    );

    testWidgets(
      'fires markRead on every tap (not debounced)',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]).reversed.toList();
        final lastReadMessageId = messages[10].id;

        await pumpMessageList(
          tester,
          messages: messages,
          isUpToDate: true,
          unreadCount: 5,
          markReadWhenAtTheBottom: false,
          openAtFirstUnread: false,
          currentUserRead: Read(
            user: ownUser,
            lastRead: DateTime.now(),
            unreadMessages: 5,
            lastReadMessageId: lastReadMessageId,
          ),
        );

        final indicator = tester.widget<UnreadIndicatorButton>(
          find.byType(UnreadIndicatorButton),
        );

        // Three taps in quick succession, well within the 1s debounce window.
        // A debounced dismiss (leading: true) would collapse these into a
        // single immediate call; the fix fires one markRead per tap.
        await indicator.onDismissTap();
        await indicator.onDismissTap();
        await indicator.onDismissTap();

        verify(() => channel.markRead(messageId: any(named: 'messageId'))).called(3);
      },
    );

    testWidgets(
      'dismisses the pill permanently, even though markReadWhenAtTheBottom is off',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]).reversed.toList();
        final lastReadMessageId = messages[10].id;

        await pumpMessageList(
          tester,
          messages: messages,
          isUpToDate: true,
          unreadCount: 5,
          markReadWhenAtTheBottom: false,
          openAtFirstUnread: false,
          currentUserRead: Read(
            user: ownUser,
            lastRead: DateTime.now(),
            unreadMessages: 5,
            lastReadMessageId: lastReadMessageId,
          ),
        );

        final indicator = tester.widget<UnreadIndicatorButton>(
          find.byType(UnreadIndicatorButton),
        );
        await indicator.onDismissTap();
        await tester.pumpAndSettle();

        expect(find.byType(UnreadIndicatorButton), findsNothing);
      },
    );
  });
}
