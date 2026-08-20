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
// In a thread, it fires `channel.markThreadRead(parentId)` instead, gated
// only on the parent having at least one reply. A thread read is independent
// of the parent channel's own loaded window, so conditions 2 and 4-6 don't
// apply there.
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
          // Scaffold supplies the Material ancestor some message widgets
          // need once older messages scroll into view.
          home: Scaffold(
            body: DefaultAssetBundle(
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
                    ),
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
      'fires even when the parent channel is not up to date',
      (tester) async {
        // A thread read has nothing to do with where the parent channel's
        // own loaded window sits — gating it on the channel's `isUpToDate`
        // silently blocked thread reads whenever the channel was scrolled
        // back into history.
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

        // A channel that isn't up to date triggers a reload; stub it so the
        // thread's own list still renders and the gate is actually reached.
        when(
          () => channel.query(
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            messagesPagination: any(named: 'messagesPagination'),
            membersPagination: any(named: 'membersPagination'),
            watchersPagination: any(named: 'watchersPagination'),
            preferOffline: any(named: 'preferOffline'),
          ),
        ).thenAnswer((_) async => ChannelState(messages: [parent, reply]));

        await pumpMessageList(
          tester,
          parentMessage: parent,
          messages: [parent, reply],
          isUpToDate: false,
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
        unawaited(indicator.onJumpTap(null));
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

  group('unread pill after a manual mark-unread', () {
    // Marking a message unread restarts the pill's session against the
    // moved-back boundary. Its anchor is the message the user was looking at,
    // so it starts out on screen — which used to retire the pill on the very
    // next layout tick.
    Future<List<Message>> pumpMarkedUnread(
      WidgetTester tester, {
      required User other,
    }) async {
      final messages = generateConversation(40, users: [other]).reversed.toList();

      await pumpMessageList(
        tester,
        messages: messages,
        isUpToDate: true,
        unreadCount: 0,
        markReadWhenAtTheBottom: false,
      );

      // Now the user marks a visible message unread: the channel reports an
      // active manual mark-unread and a boundary pointing back at it.
      when(() => channelClientState.isMarkedAsUnread).thenReturn(true);
      when(() => channelClientState.unreadCount).thenReturn(3);
      final markedRead = Read(
        user: ownUser,
        lastRead: DateTime.now(),
        unreadMessages: 3,
        lastReadMessageId: messages[messages.length - 2].id,
      );
      when(() => channelClientState.currentUserRead).thenReturn(markedRead);

      await tester.runAsync(() async {
        unreadCountController.add(3);
        currentUserReadController.add(markedRead);
        await tester.pumpAndSettle();
      });

      return messages;
    }

    testWidgets(
      'a small scroll that keeps the boundary on screen does not dismiss it',
      (tester) async {
        final other = User(id: 'otherid');
        await pumpMarkedUnread(tester, other: other);

        expect(find.byType(UnreadIndicatorButton), findsOneWidget);

        // The slightest scroll used to be enough to retire the pill, because
        // simply having the anchor visible counted as reaching the boundary.
        await tester.drag(find.byType(StreamMessageListView), const Offset(0, 30));
        await tester.pumpAndSettle();

        expect(find.byType(UnreadIndicatorButton), findsOneWidget);
      },
    );

    testWidgets(
      'stays dismissed when further messages arrive after being dismissed',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = await pumpMarkedUnread(tester, other: other);

        expect(find.byType(UnreadIndicatorButton), findsOneWidget);

        final indicator = tester.widget<UnreadIndicatorButton>(
          find.byType(UnreadIndicatorButton),
        );
        await indicator.onDismissTap();
        await tester.pumpAndSettle();

        expect(find.byType(UnreadIndicatorButton), findsNothing);

        // Each arrival re-emits the read stream while `isMarkedAsUnread` is
        // still set. That used to re-run the whole mark-unread reset and
        // flicker the pill back in and straight out again.
        final arrival = Message(
          id: 'arrived-after-dismiss',
          text: 'After dismiss',
          user: other,
          createdAt: DateTime.now(),
        );
        final updated = [...messages, arrival];
        when(() => channelClientState.messages).thenReturn(updated);
        final laterRead = Read(
          user: ownUser,
          lastRead: DateTime.now(),
          unreadMessages: 4,
          lastReadMessageId: messages[messages.length - 2].id,
        );
        when(() => channelClientState.currentUserRead).thenReturn(laterRead);

        await tester.runAsync(() async {
          messagesController.add(updated);
          currentUserReadController.add(laterRead);

          // Pumped one frame at a time: the regression was a *transient*
          // reappearance — the reset cleared `_hasSeenFirstUnread` on the
          // read emission and the next layout latched it straight back — so
          // it is invisible to an end-state assertion after pumpAndSettle.
          for (var i = 0; i < 5; i++) {
            await tester.pump();
            expect(
              find.byType(UnreadIndicatorButton),
              findsNothing,
              reason: 'pill reappeared on frame $i after a later arrival',
            );
          }
          await tester.pumpAndSettle();
        });

        expect(find.byType(UnreadIndicatorButton), findsNothing);
      },
    );
  });

  group('unread pill on a never-read channel', () {
    testWidgets(
      'tapping jump scrolls to the oldest loaded message instead of doing nothing',
      (tester) async {
        // A channel the user has never opened reports unread messages with no
        // read boundary at all: no `lastReadMessageId`, and the anchor can't
        // resolve until top pagination ends. The tap used to be inert.
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]).reversed.toList();

        await pumpMessageList(
          tester,
          messages: messages,
          isUpToDate: true,
          unreadCount: 5,
          openAtFirstUnread: false,
          currentUserRead: Read(
            user: ownUser,
            lastRead: DateTime.utc(1970),
            unreadMessages: 5,
          ),
        );

        expect(find.byType(UnreadIndicatorButton), findsOneWidget);

        final indicator = tester.widget<UnreadIndicatorButton>(
          find.byType(UnreadIndicatorButton),
        );

        // This list is in production order (oldest first), so the oldest
        // loaded message is the first entry. It's already in the window, so
        // the jump scrolls without needing a query.
        final oldestLoaded = messages.first;

        // Not awaited directly: the scroll only completes once the test
        // binding pumps frames (same reason as the fallback-jump test above).
        unawaited(indicator.onJumpTap(null));
        await tester.pumpAndSettle();

        expect(find.text(oldestLoaded.text!), findsOneWidget);
        // The real boundary is further back than this landed, so the pill
        // stays up rather than latching as seen.
        expect(find.byType(UnreadIndicatorButton), findsOneWidget);
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
