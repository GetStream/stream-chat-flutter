// Tests for the unread-messages divider, the jump-to-unread pill, and the
// scroll-to-bottom badge.
//
//  - The unread divider ("{n} unread messages"): anchored to the
//    pre-existing unread boundary captured when the channel opens. The
//    anchor is frozen — it stays on screen for the whole session regardless
//    of scrolling or reads — but its displayed count keeps counting up as
//    further messages arrive out of view during the session, rather than
//    staying frozen at the open-time count.
//  - The pill shows the count of unread messages captured when the channel
//    was opened — this one *does* stay frozen — and is gated on that
//    boundary being above the viewport.
//  - The scroll-to-bottom badge counts messages that arrive while the user
//    is scrolled away from the bottom, and always resets to 0 once they
//    reach the bottom.

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
  late StreamController<Event> messageNewController;
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
    when(() => client.isLocalUnreadCountEnabled).thenReturn(false);

    isUpToDateController = StreamController<bool>.broadcast();
    unreadCountController = StreamController<int>.broadcast();
    messagesController = StreamController<List<Message>>.broadcast();
    // MockChannel.on filters this by event.type, so events pushed here
    // surface to channel.on(EventType.messageNew) subscribers.
    messageNewController = StreamController<Event>.broadcast();
    currentUserReadController = StreamController<Read?>.broadcast();
    addTearDown(isUpToDateController.close);
    addTearDown(unreadCountController.close);
    addTearDown(messagesController.close);
    addTearDown(messageNewController.close);
    addTearDown(currentUserReadController.close);

    channel = MockChannel(eventStream: messageNewController.stream);
    channelClientState = MockChannelState();
    when(() => channel.client).thenReturn(client);
    when(() => channel.state).thenReturn(channelClientState);

    when(() => channelClientState.threadsStream).thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.isUpToDateStream).thenAnswer((_) => isUpToDateController.stream);
    when(() => channelClientState.unreadCountStream).thenAnswer((_) => unreadCountController.stream);
    when(() => channelClientState.readStream).thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.read).thenReturn([]);
    when(() => channelClientState.membersStream).thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.members).thenReturn([]);
    when(() => channelClientState.currentUserReadStream).thenAnswer((_) => currentUserReadController.stream);
    when(() => channelClientState.messagesStream).thenAnswer((_) => messagesController.stream);
    when(() => channelClientState.isMarkedAsUnread).thenReturn(false);

    when(() => channel.markRead(messageId: any(named: 'messageId'))).thenAnswer((_) async => EmptyResponse());
  });

  Future<void> pumpMessageList(
    WidgetTester tester, {
    required List<Message> messages,
    bool isUpToDate = true,
    required int unreadCount,
    required Read currentUserRead,
    bool openAtFirstUnread = false,
  }) async {
    when(() => channelClientState.isUpToDate).thenReturn(isUpToDate);
    when(() => channelClientState.unreadCount).thenReturn(unreadCount);
    when(() => channelClientState.messages).thenReturn(messages);
    when(() => channelClientState.currentUserRead).thenReturn(currentUserRead);

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
                child: const StreamMessageListView(
                  config: StreamMessageListViewConfiguration(
                    markReadWhenAtTheBottom: false,
                    // Own messages otherwise auto-scroll back to the
                    // bottom by default, which would confound these
                    // tests' control over scroll position.
                    autoScrollPolicy: StreamAutoScrollPolicy.disabled,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      isUpToDateController.add(isUpToDate);
      unreadCountController.add(unreadCount);
      currentUserReadController.add(currentUserRead);
      messagesController.add(messages);
      await tester.pumpAndSettle();
    });
  }

  // Appends to the end because production state.messages is oldest-first.
  Future<void> deliverMessageNew(
    WidgetTester tester, {
    required Message newMessage,
    required List<Message> existing,
  }) async {
    final updated = [...existing, newMessage];
    when(() => channelClientState.messages).thenReturn(updated);
    await tester.runAsync(() async {
      messagesController.add(updated);
      messageNewController.add(Event(type: EventType.messageNew, message: newMessage, cid: channel.cid));
      await tester.pumpAndSettle();
    });
  }

  group('unread divider (pre-existing unread)', () {
    testWidgets(
      'shows the open-time count and stays visible after unreadCount drops to 0',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]).reversed.toList();
        // Close to the bottom so the anchor message — and its divider — are
        // guaranteed to be within the initially-rendered window regardless
        // of viewport size; the list opens at the bottom (openAtFirstUnread
        // is false in this helper) and SPL only builds visible items.
        final lastReadMessageId = messages[messages.length - 3].id;

        await pumpMessageList(
          tester,
          messages: messages,
          unreadCount: 2,
          currentUserRead: Read(
            user: ownUser,
            lastRead: DateTime.now(),
            unreadMessages: 2,
            lastReadMessageId: lastReadMessageId,
          ),
        );

        expect(find.text('2 unread messages'), findsOneWidget);

        // Simulate an auto mark-read completing server-side: the live count
        // drops to 0, but the divider must not react to it — its anchor and
        // open-time count are frozen.
        unreadCountController.add(0);
        when(() => channelClientState.unreadCount).thenReturn(0);
        await tester.pumpAndSettle();

        expect(find.text('2 unread messages'), findsOneWidget);
      },
    );

    testWidgets(
      'is absent when the channel opened with nothing pre-existing unread',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]).reversed.toList();

        await pumpMessageList(
          tester,
          messages: messages,
          unreadCount: 0,
          currentUserRead: Read(user: ownUser, lastRead: DateTime.now(), unreadMessages: 0),
        );

        expect(find.textContaining('unread message'), findsNothing);

        // Messages arriving while the channel is open must not introduce a
        // separator of their own: there is exactly one divider, anchored at
        // the boundary the channel opened with — and here there wasn't one.
        await tester.drag(find.byType(StreamMessageListView), const Offset(0, 400));
        await tester.pumpAndSettle();

        await deliverMessageNew(
          tester,
          newMessage: Message(
            id: 'arrived-while-open',
            text: 'Arrived while open',
            user: other,
            createdAt: DateTime.now(),
          ),
          existing: messages,
        );

        expect(find.textContaining('unread message'), findsNothing);
      },
    );

    testWidgets(
      'keeps counting up as further messages arrive out of view',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]).reversed.toList();
        final lastReadMessageId = messages[messages.length - 3].id;

        await pumpMessageList(
          tester,
          messages: messages,
          unreadCount: 2,
          currentUserRead: Read(
            user: ownUser,
            lastRead: DateTime.now(),
            unreadMessages: 2,
            lastReadMessageId: lastReadMessageId,
          ),
        );

        expect(find.text('2 unread messages'), findsOneWidget);

        // Scroll just enough away from the bottom (to flip `isAtBottom`)
        // while keeping the anchor, close to the bottom, within SPL's
        // rendered window — an out-of-view arrival should then grow the
        // divider's count on top of the open-time baseline.
        await tester.drag(find.byType(StreamMessageListView), const Offset(0, 120));
        await tester.pumpAndSettle();

        final fromOther = Message(
          id: 'new-from-other-growth-probe',
          text: 'Out of view',
          user: other,
          createdAt: DateTime.now(),
        );
        await deliverMessageNew(tester, newMessage: fromOther, existing: messages);

        expect(find.text('3 unread messages'), findsOneWidget);

        // A second out-of-view arrival grows it further.
        final secondFromOther = Message(
          id: 'second-new-from-other-growth-probe',
          text: 'Also out of view',
          user: other,
          createdAt: DateTime.now(),
        );
        await deliverMessageNew(tester, newMessage: secondFromOther, existing: [...messages, fromOther]);

        expect(find.text('4 unread messages'), findsOneWidget);
      },
    );

    testWidgets(
      'also grows for arrivals seen live at the bottom, unlike the badge',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]).reversed.toList();
        final lastReadMessageId = messages[messages.length - 3].id;

        await pumpMessageList(
          tester,
          messages: messages,
          unreadCount: 2,
          currentUserRead: Read(
            user: ownUser,
            lastRead: DateTime.now(),
            unreadMessages: 2,
            lastReadMessageId: lastReadMessageId,
          ),
        );

        expect(find.text('2 unread messages'), findsOneWidget);

        // Still at the bottom — no scrolling away — an arrival here would
        // never bump the scroll-to-bottom badge, but the divider isn't
        // "caught up" the way the badge's out-of-view count is; it should
        // keep counting every arrival regardless of scroll position.
        final fromOther = Message(
          id: 'new-from-other-at-bottom-probe',
          text: 'Seen immediately',
          user: other,
          createdAt: DateTime.now(),
        );
        await deliverMessageNew(tester, newMessage: fromOther, existing: messages);

        expect(find.text('3 unread messages'), findsOneWidget);
      },
    );
  });

  // The badge is a floating overlay, always built regardless of scroll
  // position — unlike the inline divider, which only exists in the widget
  // tree once SPL actually renders its anchor message.
  String? badgeLabel(WidgetTester tester) {
    final finder = find.byType(StreamBadgeNotification);
    if (finder.evaluate().isEmpty) return null;
    return tester.widget<StreamBadgeNotification>(finder).props.label;
  }

  group('openAtFirstUnread', () {
    // Deterministic texts (rather than the faker-generated ones elsewhere in
    // this file) so "which message is on screen" is a stable assertion.
    List<Message> buildMessages(User author) => [
      for (var i = 0; i < 40; i++)
        Message(
          id: 'm$i',
          text: 'message-$i',
          user: author,
          createdAt: DateTime.utc(2026).add(Duration(minutes: i)),
        ),
    ];

    testWidgets('opens positioned at the first unread message by default', (tester) async {
      final other = User(id: 'otherid');
      final messages = buildMessages(other);

      // Opening at the boundary re-queries the channel around it; the
      // mocked state keeps returning the same window.
      when(
        () => channel.query(
          preferOffline: any(named: 'preferOffline'),
          messagesPagination: any(named: 'messagesPagination'),
        ),
      ).thenAnswer((_) async => const ChannelState());

      await pumpMessageList(
        tester,
        messages: messages,
        unreadCount: 34,
        openAtFirstUnread: true,
        currentUserRead: Read(
          user: ownUser,
          lastRead: DateTime.utc(2026, 1, 1, 0, 5),
          unreadMessages: 34,
          lastReadMessageId: 'm5',
        ),
      );

      // The first unread message is on screen; the newest one is not.
      expect(find.text('message-6'), findsOneWidget);
      expect(find.text('message-39'), findsNothing);
    });

    testWidgets('opens at the latest message when set to false', (tester) async {
      final other = User(id: 'otherid');
      final messages = buildMessages(other);

      await pumpMessageList(
        tester,
        messages: messages,
        unreadCount: 34,
        openAtFirstUnread: false,
        currentUserRead: Read(
          user: ownUser,
          lastRead: DateTime.utc(2026, 1, 1, 0, 5),
          unreadMessages: 34,
          lastReadMessageId: 'm5',
        ),
      );

      expect(find.text('message-39'), findsOneWidget);
      expect(find.text('message-6'), findsNothing);
    });
  });

  group('unread counting filters', () {
    // Messages the channel's own unread count ignores must not inflate the
    // badge or the divider either. Each case scrolls away from the bottom
    // first so a counted arrival would be visible as a badge.
    Future<void> expectNotCounted(
      WidgetTester tester, {
      required Message Function(User other) build,
      OwnUser? overrideOwnUser,
    }) async {
      final other = User(id: 'otherid');
      final messages = generateConversation(40, users: [other]).reversed.toList();

      if (overrideOwnUser case final replacement?) {
        when(() => clientState.currentUser).thenReturn(replacement);
      }

      await pumpMessageList(
        tester,
        messages: messages,
        unreadCount: 0,
        currentUserRead: Read(user: ownUser, lastRead: DateTime.now(), unreadMessages: 0),
      );

      await tester.drag(find.byType(StreamMessageListView), const Offset(0, 400));
      await tester.pumpAndSettle();

      final filtered = build(other);
      await deliverMessageNew(tester, newMessage: filtered, existing: messages);

      expect(badgeLabel(tester), isNull);

      // Control: an ordinary message, delivered the same way, does bump the
      // badge. Without this the assertion above would also hold if the
      // new-message pipeline were simply inert. Sent by a third user so the
      // muted-sender case's control isn't filtered out too.
      await deliverMessageNew(
        tester,
        newMessage: Message(
          id: 'control-counted',
          text: 'Ordinary arrival',
          user: User(id: 'controlid'),
          createdAt: DateTime.now(),
        ),
        existing: [...messages, filtered],
      );

      expect(badgeLabel(tester), '1');
    }

    testWidgets('silent messages do not count', (tester) async {
      await expectNotCounted(
        tester,
        build: (other) => Message(
          id: 'silent-message',
          text: 'Silent',
          user: other,
          silent: true,
          createdAt: DateTime.now(),
        ),
      );
    });

    testWidgets('shadowed messages do not count', (tester) async {
      await expectNotCounted(
        tester,
        build: (other) => Message(
          id: 'shadowed-message',
          text: 'Shadowed',
          user: other,
          shadowed: true,
          createdAt: DateTime.now(),
        ),
      );
    });

    testWidgets('ephemeral messages do not count', (tester) async {
      await expectNotCounted(
        tester,
        build: (other) => Message(
          id: 'ephemeral-message',
          text: 'Ephemeral',
          user: other,
          type: MessageType.ephemeral,
          createdAt: DateTime.now(),
        ),
      );
    });

    testWidgets('thread replies not also sent to the channel do not count', (tester) async {
      await expectNotCounted(
        tester,
        build: (other) => Message(
          id: 'thread-only-reply',
          text: 'Thread only',
          user: other,
          parentId: 'some-parent',
          createdAt: DateTime.now(),
        ),
      );
    });

    testWidgets('messages restricted to other users do not count', (tester) async {
      await expectNotCounted(
        tester,
        build: (other) => Message(
          id: 'restricted-message',
          text: 'Not for you',
          user: other,
          restrictedVisibility: const ['someoneelse'],
          createdAt: DateTime.now(),
        ),
      );
    });

    testWidgets('nothing counts while the user has read receipts disabled', (tester) async {
      // No control arrival here, deliberately: this filter is user-level, so
      // with it on nothing counts at all. The control is every other test in
      // this group — they use the same delivery path with receipts enabled
      // (the default) and do bump the badge.
      final other = User(id: 'otherid');
      final messages = generateConversation(40, users: [other]).reversed.toList();

      when(() => clientState.currentUser).thenReturn(
        OwnUser(
          id: 'ownid',
          privacySettings: const PrivacySettings(readReceipts: ReadReceipts(enabled: false)),
        ),
      );

      await pumpMessageList(
        tester,
        messages: messages,
        unreadCount: 0,
        currentUserRead: Read(user: ownUser, lastRead: DateTime.now(), unreadMessages: 0),
      );

      await tester.drag(find.byType(StreamMessageListView), const Offset(0, 400));
      await tester.pumpAndSettle();

      await deliverMessageNew(
        tester,
        newMessage: Message(
          id: 'ordinary-arrival',
          text: 'Ordinary arrival',
          user: other,
          createdAt: DateTime.now(),
        ),
        existing: messages,
      );

      expect(badgeLabel(tester), isNull);
    });

    testWidgets('messages from a muted user do not count', (tester) async {
      final other = User(id: 'otherid');
      await expectNotCounted(
        tester,
        overrideOwnUser: OwnUser(
          id: 'ownid',
          mutes: [Mute(user: ownUser, target: other, createdAt: DateTime.now(), updatedAt: DateTime.now())],
        ),
        build: (_) => Message(
          id: 'from-muted-user',
          text: 'From muted',
          user: other,
          createdAt: DateTime.now(),
        ),
      );
    });

    testWidgets(
      'a message arriving mid-drag still counts towards the badge',
      (tester) async {
        // Regression: the "don't fight a scroll already in motion" guard used
        // to sit above the counting, so anything landing while the user was
        // dragging or flinging was dropped from both counters for good.
        final other = User(id: 'otherid');
        final messages = generateConversation(40, users: [other]).reversed.toList();

        await pumpMessageList(
          tester,
          messages: messages,
          unreadCount: 0,
          currentUserRead: Read(user: ownUser, lastRead: DateTime.now(), unreadMessages: 0),
        );

        // Hold a drag open so the underlying ScrollPosition reports
        // isScrolling == true while the message lands.
        final gesture = await tester.startGesture(
          tester.getCenter(find.byType(StreamMessageListView)),
        );
        // Stepped moves with a frame between each, so the list actually
        // scrolls and the view registers as away from the bottom. The
        // pointer stays down throughout, so the underlying ScrollPosition
        // keeps reporting isScrolling == true.
        for (var i = 0; i < 8; i++) {
          await gesture.moveBy(const Offset(0, 50));
          await tester.pump();
        }

        final midDrag = Message(
          id: 'arrived-mid-drag',
          text: 'Landed while dragging',
          user: other,
          createdAt: DateTime.now(),
        );
        await deliverMessageNew(tester, newMessage: midDrag, existing: messages);

        expect(badgeLabel(tester), '1');

        await gesture.up();
        await tester.pumpAndSettle();
      },
    );
  });

  group('scroll-to-bottom badge', () {
    testWidgets(
      'appears only once the user is scrolled away from the bottom, and skips own messages',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(40, users: [other]).reversed.toList();

        await pumpMessageList(
          tester,
          messages: messages,
          unreadCount: 0,
          currentUserRead: Read(user: ownUser, lastRead: DateTime.now(), unreadMessages: 0),
        );

        // At the bottom: an arrival is in view, so it shouldn't bump the
        // badge.
        final whileAtBottom = Message(
          id: 'while-at-bottom',
          text: 'Seen immediately',
          user: other,
          createdAt: DateTime.now(),
        );
        await deliverMessageNew(tester, newMessage: whileAtBottom, existing: messages);

        expect(badgeLabel(tester), isNull);

        // Scroll away from the bottom, then a message from another user
        // should bump the badge.
        await tester.drag(find.byType(StreamMessageListView), const Offset(0, 400));
        await tester.pumpAndSettle();

        final fromOther = Message(
          id: 'new-from-other',
          text: 'Out of view',
          user: other,
          createdAt: DateTime.now(),
        );
        await deliverMessageNew(tester, newMessage: fromOther, existing: [...messages, whileAtBottom]);

        expect(badgeLabel(tester), '1');

        // A second out-of-view arrival grows the count.
        final secondFromOther = Message(
          id: 'second-new-from-other',
          text: 'Also out of view',
          user: other,
          createdAt: DateTime.now(),
        );
        await deliverMessageNew(tester, newMessage: secondFromOther, existing: [...messages, whileAtBottom, fromOther]);

        expect(badgeLabel(tester), '2');
      },
    );

    testWidgets(
      "the current user's own messages don't count towards the badge",
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(40, users: [other]).reversed.toList();

        await pumpMessageList(
          tester,
          messages: messages,
          unreadCount: 0,
          currentUserRead: Read(user: ownUser, lastRead: DateTime.now(), unreadMessages: 0),
        );

        await tester.drag(find.byType(StreamMessageListView), const Offset(0, 400));
        await tester.pumpAndSettle();

        // Auto-scroll is disabled in this helper's config, so an own
        // message while scrolled up genuinely stays out of view too — this
        // isolates "does it count" from "does it pull me back to the
        // bottom" (a separate, already-covered concern in auto_scroll_test).
        final ownMessage = Message(
          id: 'own-while-scrolled-up',
          text: 'My own message',
          user: ownUser,
          createdAt: DateTime.now(),
        );
        await deliverMessageNew(tester, newMessage: ownMessage, existing: messages);

        expect(badgeLabel(tester), isNull);

        // Control: the same delivery path with someone else's message does
        // bump the badge, so the assertion above isn't just measuring an
        // inert pipeline.
        await deliverMessageNew(
          tester,
          newMessage: Message(
            id: 'control-from-other',
            text: 'Ordinary arrival',
            user: other,
            createdAt: DateTime.now(),
          ),
          existing: [...messages, ownMessage],
        );

        expect(badgeLabel(tester), '1');
      },
    );

    testWidgets(
      'always resets to 0 once the user reaches the bottom',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(40, users: [other]).reversed.toList();

        await pumpMessageList(
          tester,
          messages: messages,
          unreadCount: 0,
          currentUserRead: Read(user: ownUser, lastRead: DateTime.now(), unreadMessages: 0),
        );

        await tester.drag(find.byType(StreamMessageListView), const Offset(0, 400));
        await tester.pumpAndSettle();

        final fromOther = Message(
          id: 'new-from-other-reset-probe',
          text: 'Out of view',
          user: other,
          createdAt: DateTime.now(),
        );
        await deliverMessageNew(tester, newMessage: fromOther, existing: messages);

        expect(badgeLabel(tester), '1');

        // Scroll back down to the bottom.
        await tester.drag(find.byType(StreamMessageListView), const Offset(0, -1000));
        await tester.pumpAndSettle();

        // The scroll-to-bottom button itself hides at the bottom, so the
        // badge is gone too.
        expect(badgeLabel(tester), isNull);

        // Scrolling away from the bottom again, with no further arrivals in
        // between, must show the button with no badge — the earlier count
        // should have been cleared on reaching the bottom, not just hidden.
        await tester.drag(find.byType(StreamMessageListView), const Offset(0, 400));
        await tester.pumpAndSettle();

        expect(badgeLabel(tester), isNull);
      },
    );
  });
}
