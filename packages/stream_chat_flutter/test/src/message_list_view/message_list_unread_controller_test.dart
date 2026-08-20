// Unit tests for [MessageListUnreadController], the unread state machine
// behind StreamMessageListView.
//
// The widget-level behaviour is already locked by mark_read_test.dart and
// unread_divider_test.dart; these tests target the branches that are awkward
// to reach through a pumped widget — the arrival filter matrix, each
// individual condition of the mark-read gate, the attempt-dedupe key, the
// mark-unread viewport divergence latch, and the pill's jump fallbacks.

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stream_chat_flutter/src/message_list_view/message_list_unread_controller.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  late MockClient client;
  late MockChannel channel;
  late MockChannelState channelState;
  late OwnUser ownUser;

  // Mutable fixture the controller reads through its injected accessors.
  late List<Message> messages;
  late Message? parentMessage;
  late List<ItemPosition> itemPositions;
  late bool markReadWhenAtTheBottom;
  late Message? firstUnreadMessage;
  late Object? attachToken;

  // Records every scroll the controller asks for, and controls whether the
  // scroll is reported as having landed.
  late List<String> scrollRequests;
  late bool scrollLands;

  MessageListUnreadController buildController() {
    final controller = MessageListUnreadController(
      channel: () => channel,
      getFirstUnreadMessage: (_) => firstUnreadMessage,
      parentMessage: () => parentMessage,
      messages: () => messages,
      itemPositions: () => itemPositions,
      markReadWhenAtTheBottom: () => markReadWhenAtTheBottom,
      scrollToMessage: (id) async {
        scrollRequests.add(id);
        return scrollLands;
      },
      attachToken: () => attachToken,
    );
    addTearDown(controller.dispose);
    return controller;
  }

  Message message({
    String id = 'msg-1',
    User? user,
    bool silent = false,
    bool shadowed = false,
    String? parentId,
    bool? showInChannel,
    String? type,
    List<String>? restrictedVisibility,
  }) {
    return Message(
      id: id,
      text: 'hello',
      user: user ?? User(id: 'other'),
      silent: silent,
      shadowed: shadowed,
      parentId: parentId,
      showInChannel: showInChannel,
      type: type ?? MessageType.regular,
      restrictedVisibility: restrictedVisibility,
    );
  }

  // A viewport showing the given item indices, all fully visible.
  List<ItemPosition> viewport(List<int> indices) {
    return [
      for (final index in indices) ItemPosition(index: index, itemLeadingEdge: 0.1, itemTrailingEdge: 0.2),
    ];
  }

  // Delivers a positions tick, keeping the injected `itemPositions` in step
  // with what is handed to the controller — the list reads both from the same
  // listener, so a test that only passed one would let the gate's fallback
  // divergence check compare against a viewport that never existed.
  void tick(
    MessageListUnreadController controller,
    List<int> indices, {
    required bool isAtBottom,
  }) {
    itemPositions = viewport(indices);
    controller.handleItemPositionsChanged(itemPositions, isAtBottom: isAtBottom);
  }

  Read read({
    DateTime? lastRead,
    String? lastReadMessageId,
    int unreadMessages = 0,
  }) {
    return Read(
      user: ownUser,
      lastRead: lastRead ?? DateTime.utc(2024),
      lastReadMessageId: lastReadMessageId,
      unreadMessages: unreadMessages,
    );
  }

  setUp(() {
    client = MockClient();
    // `canUseReadReceipts` is an extension getter over `ownCapabilities`, so
    // it is granted through the capability rather than stubbed.
    channel = MockChannel(ownCapabilities: const [ChannelCapability.readEvents]);
    channelState = MockChannelState();
    ownUser = OwnUser(id: 'ownid');

    when(() => channel.client).thenReturn(client);
    when(() => channel.state).thenReturn(channelState);
    when(() => client.isLocalUnreadCountEnabled).thenReturn(false);
    when(() => channel.markRead()).thenAnswer((_) async => EmptyResponse());
    when(() => channel.markRead(messageId: any(named: 'messageId'))).thenAnswer((_) async => EmptyResponse());
    when(() => channel.markThreadRead(any())).thenAnswer((_) async => EmptyResponse());
    when(() => channelState.currentUserRead).thenReturn(null);

    messages = <Message>[];
    parentMessage = null;
    itemPositions = <ItemPosition>[];
    markReadWhenAtTheBottom = true;
    firstUnreadMessage = null;
    attachToken = 'channel-1';
    scrollRequests = <String>[];
    scrollLands = true;
  });

  group('message arrivals', () {
    test('a qualifying arrival bumps the divider growth and the badge', () {
      final controller = buildController()..handleMessageArrived(message(), currentUser: ownUser, isAtBottom: false);

      expect(controller.unreadDividerGrowth.value, 1);
      expect(controller.scrollToBottomBadge.value, 1);
    });

    test('an arrival seen at the bottom counts for the divider but not the badge', () {
      final controller = buildController()..handleMessageArrived(message(), currentUser: ownUser, isAtBottom: true);

      expect(controller.unreadDividerGrowth.value, 1);
      expect(controller.scrollToBottomBadge.value, 0);
    });

    test('nothing counts in a thread', () {
      parentMessage = message(id: 'parent');
      final controller = buildController()..handleMessageArrived(message(), currentUser: ownUser, isAtBottom: false);

      expect(controller.unreadDividerGrowth.value, 0);
      expect(controller.scrollToBottomBadge.value, 0);
    });

    test('nothing counts without a current user', () {
      final controller = buildController()..handleMessageArrived(message(), currentUser: null, isAtBottom: false);

      expect(controller.unreadDividerGrowth.value, 0);
      expect(controller.scrollToBottomBadge.value, 0);
    });

    test('nothing counts while the user has read receipts disabled', () {
      final controller = buildController();
      final optedOut = OwnUser(
        id: 'ownid',
        privacySettings: const PrivacySettings(readReceipts: ReadReceipts(enabled: false)),
      );

      controller.handleMessageArrived(message(), currentUser: optedOut, isAtBottom: false);

      expect(controller.unreadDividerGrowth.value, 0);
      expect(controller.scrollToBottomBadge.value, 0);
    });

    test("the current user's own messages do not count", () {
      final controller = buildController()
        ..handleMessageArrived(message(user: ownUser), currentUser: ownUser, isAtBottom: false);

      expect(controller.unreadDividerGrowth.value, 0);
    });

    test('a message from a muted user does not count', () {
      final controller = buildController();
      final muter = OwnUser(
        id: 'ownid',
        mutes: [
          Mute(
            user: ownUser,
            target: User(id: 'other'),
            createdAt: DateTime.utc(2024),
            updatedAt: DateTime.utc(2024),
          ),
        ],
      );

      controller.handleMessageArrived(message(), currentUser: muter, isAtBottom: false);

      expect(controller.unreadDividerGrowth.value, 0);
    });

    test('silent, shadowed and ephemeral messages do not count', () {
      final controller = buildController()
        ..handleMessageArrived(message(id: 'a', silent: true), currentUser: ownUser, isAtBottom: false)
        ..handleMessageArrived(message(id: 'b', shadowed: true), currentUser: ownUser, isAtBottom: false)
        ..handleMessageArrived(
          message(id: 'c', type: MessageType.ephemeral),
          currentUser: ownUser,
          isAtBottom: false,
        );

      expect(controller.unreadDividerGrowth.value, 0);
    });

    test('a thread reply not also sent to the channel does not count', () {
      final controller = buildController()
        ..handleMessageArrived(
          message(parentId: 'parent'),
          currentUser: ownUser,
          isAtBottom: false,
        );

      expect(controller.unreadDividerGrowth.value, 0);
    });

    test('a thread reply also sent to the channel counts', () {
      final controller = buildController()
        ..handleMessageArrived(
          message(parentId: 'parent', showInChannel: true),
          currentUser: ownUser,
          isAtBottom: false,
        );

      expect(controller.unreadDividerGrowth.value, 1);
    });

    test('a message restricted to other users does not count', () {
      final controller = buildController()
        ..handleMessageArrived(
          message(restrictedVisibility: const ['someone-else']),
          currentUser: ownUser,
          isAtBottom: false,
        );

      expect(controller.unreadDividerGrowth.value, 0);
    });
  });

  group('badge reset', () {
    test('reaching the bottom clears the badge but keeps the divider growth', () {
      markReadWhenAtTheBottom = false;
      final controller = buildController()..handleMessageArrived(message(), currentUser: ownUser, isAtBottom: false);

      tick(controller, [2, 3], isAtBottom: true);

      expect(controller.scrollToBottomBadge.value, 0);
      expect(controller.unreadDividerGrowth.value, 1);
    });

    test('a tick away from the bottom leaves the badge alone', () {
      markReadWhenAtTheBottom = false;
      final controller = buildController()..handleMessageArrived(message(), currentUser: ownUser, isAtBottom: false);

      tick(controller, [8, 9], isAtBottom: false);

      expect(controller.scrollToBottomBadge.value, 1);
    });
  });

  group('baseline capture', () {
    test('publishes the frozen count before the anchor resolves', () {
      when(() => channelState.currentUserRead).thenReturn(read(unreadMessages: 5, lastReadMessageId: 'm-5'));
      firstUnreadMessage = null; // pagination hasn't reached the boundary yet
      final controller = buildController()..attach();

      expect(controller.unreadDivider.value.count, 5);
      expect(controller.unreadDivider.value.anchorId, isNull);
      expect(controller.needsAnchorResolution, isTrue);
    });

    test('resolveDividerAnchor fills in the anchor once the boundary loads', () {
      when(() => channelState.currentUserRead).thenReturn(read(unreadMessages: 5, lastReadMessageId: 'm-5'));
      final controller = buildController()..attach();

      firstUnreadMessage = message(id: 'm-6');
      controller.resolveDividerAnchor();

      expect(controller.unreadDivider.value, (count: 5, anchorId: 'm-6'));
      expect(controller.needsAnchorResolution, isFalse);
    });

    test('the anchor is frozen once resolved', () {
      when(() => channelState.currentUserRead).thenReturn(read(unreadMessages: 5, lastReadMessageId: 'm-5'));
      firstUnreadMessage = message(id: 'm-6');
      final controller = buildController()..attach();

      firstUnreadMessage = message(id: 'm-99');
      controller.resolveDividerAnchor();

      expect(controller.unreadDivider.value.anchorId, 'm-6');
    });

    test('a channel opened fully read publishes no divider', () {
      when(() => channelState.currentUserRead).thenReturn(read(unreadMessages: 0, lastReadMessageId: 'm-9'));
      final controller = buildController()..attach();

      expect(controller.unreadDivider.value, (count: 0, anchorId: null));
      expect(controller.needsAnchorResolution, isFalse);
    });

    test('no baseline is captured in a thread', () {
      parentMessage = message(id: 'parent');
      when(() => channelState.currentUserRead).thenReturn(read(unreadMessages: 5, lastReadMessageId: 'm-5'));
      final controller = buildController()..attach();

      expect(controller.unreadDivider.value, (count: 0, anchorId: null));
    });
  });

  group('read state changes', () {
    test('a fresh mark-unread restarts the divider session', () {
      when(() => channelState.currentUserRead).thenReturn(read(unreadMessages: 2, lastReadMessageId: 'm-8'));
      firstUnreadMessage = message(id: 'm-9');
      final controller = buildController()
        ..attach()
        ..handleMessageArrived(message(), currentUser: ownUser, isAtBottom: false);
      expect(controller.unreadDividerGrowth.value, 1);

      // The user marks an older message unread: the flag flips on and the
      // boundary moves backward.
      when(() => channelState.isMarkedAsUnread).thenReturn(true);
      when(() => channelState.currentUserRead).thenReturn(read(unreadMessages: 6, lastReadMessageId: 'm-4'));
      firstUnreadMessage = message(id: 'm-5');
      controller.handleCurrentUserReadChanged();

      expect(controller.unreadDivider.value, (count: 6, anchorId: 'm-5'));
      expect(controller.unreadDividerGrowth.value, 0);
      expect(controller.hasSeenFirstUnread.value, isFalse);
    });

    test('an emission that leaves the boundary alone does not restart the session', () {
      when(() => channelState.isMarkedAsUnread).thenReturn(true);
      when(() => channelState.currentUserRead).thenReturn(read(unreadMessages: 3, lastReadMessageId: 'm-4'));
      firstUnreadMessage = message(id: 'm-5');
      final controller = buildController()..attach();
      // The session came from a manual mark-unread, so only scrolling *past*
      // the anchor retires the pill: the anchor sits at item index 2, so a
      // viewport showing only older items (higher indices) is past it.
      messages = [message(id: 'm-5'), message(id: 'm-4')];
      tick(controller, [3], isAtBottom: false);
      expect(controller.hasSeenFirstUnread.value, isTrue);

      // A new message arrives: unreadMessages grows, the boundary does not move.
      when(() => channelState.currentUserRead).thenReturn(read(unreadMessages: 4, lastReadMessageId: 'm-4'));
      controller.handleCurrentUserReadChanged();

      expect(controller.hasSeenFirstUnread.value, isTrue, reason: 'the pill must not flicker back in');
    });

    test('a second mark-unread further back re-anchors the divider', () {
      when(() => channelState.isMarkedAsUnread).thenReturn(true);
      when(() => channelState.currentUserRead).thenReturn(read(unreadMessages: 3, lastReadMessageId: 'm-6'));
      firstUnreadMessage = message(id: 'm-7');
      final controller = buildController()..attach();

      when(() => channelState.currentUserRead).thenReturn(read(unreadMessages: 7, lastReadMessageId: 'm-2'));
      firstUnreadMessage = message(id: 'm-3');
      controller.handleCurrentUserReadChanged();

      expect(controller.unreadDivider.value, (count: 7, anchorId: 'm-3'));
    });
  });

  group('mark-read gate', () {
    test('marks read once the bottom is reached with something unread', () {
      when(() => channelState.unreadCount).thenReturn(3);
      when(() => channelState.currentUserRead).thenReturn(read(unreadMessages: 3));
      messages = [message(id: 'newest')];
      final controller = buildController()..attach();

      tick(controller, [2], isAtBottom: true);

      verify(() => channel.markRead()).called(1);
    });

    test('does not mark read while the channel is not up to date', () {
      when(() => channelState.isUpToDate).thenReturn(false);
      when(() => channelState.unreadCount).thenReturn(3);
      when(() => channelState.currentUserRead).thenReturn(read(unreadMessages: 3));
      final controller = buildController()..attach();

      tick(controller, [2], isAtBottom: true);

      verifyNever(() => channel.markRead());
    });

    test('does not mark read when there is nothing unread', () {
      when(() => channelState.unreadCount).thenReturn(0);
      final controller = buildController()..attach();

      tick(controller, [2], isAtBottom: true);

      verifyNever(() => channel.markRead());
    });

    test('does not mark read while the bottom has never been seen', () {
      when(() => channelState.unreadCount).thenReturn(3);
      when(() => channelState.currentUserRead).thenReturn(read(unreadMessages: 3));
      firstUnreadMessage = message(id: 'm-5');
      messages = [message(id: 'm-5')];
      final controller = buildController()..attach();

      // Seeing the boundary opens condition 5, but the bottom is still away.
      tick(controller, [2], isAtBottom: false);

      expect(controller.hasSeenFirstUnread.value, isTrue);
      verifyNever(() => channel.markRead());
    });

    test('does not mark read while the unread boundary has not been seen', () {
      when(() => channelState.unreadCount).thenReturn(3);
      when(() => channelState.currentUserRead).thenReturn(read(unreadMessages: 3, lastReadMessageId: 'm-4'));
      firstUnreadMessage = message(id: 'm-5');
      messages = [message(id: 'newest'), message(id: 'm-5')];
      final controller = buildController()..attach();

      // At the bottom, but the anchor (item index 3) is out of view.
      tick(controller, [2], isAtBottom: true);

      verifyNever(() => channel.markRead());
    });

    test('marks read on a never-opened channel that has no boundary to reach', () {
      when(() => channelState.unreadCount).thenReturn(3);
      when(() => channelState.currentUserRead).thenReturn(read(unreadMessages: 3));
      final controller = buildController()..attach();

      tick(controller, [2], isAtBottom: true);

      verify(() => channel.markRead()).called(1);
    });

    test('does nothing while markReadWhenAtTheBottom is off', () {
      markReadWhenAtTheBottom = false;
      when(() => channelState.unreadCount).thenReturn(3);
      when(() => channelState.currentUserRead).thenReturn(read(unreadMessages: 3));
      final controller = buildController()..attach();

      tick(controller, [2], isAtBottom: true);

      verifyNever(() => channel.markRead());
    });

    test('a repeated tick against unchanged state does not retry the attempt', () {
      when(() => channelState.unreadCount).thenReturn(3);
      when(() => channelState.currentUserRead).thenReturn(read(unreadMessages: 3));
      messages = [message(id: 'newest')];
      final controller = buildController()..attach();

      tick(controller, [2], isAtBottom: true);
      tick(controller, [2], isAtBottom: true);
      tick(controller, [2], isAtBottom: true);

      verify(() => channel.markRead()).called(1);
    });

    test('a new newest message earns a fresh attempt', () async {
      when(() => channelState.unreadCount).thenReturn(3);
      when(() => channelState.currentUserRead).thenReturn(read(unreadMessages: 3));
      messages = [message(id: 'newest')];
      final controller = buildController()..attach();
      tick(controller, [2], isAtBottom: true);

      // The debounce is leading-edge, so let its window lapse before the
      // second attempt, which is otherwise swallowed by the debouncer
      // rather than by the dedupe key under test.
      await Future<void>.delayed(const Duration(milliseconds: 1100));
      messages = [message(id: 'even-newer'), message(id: 'newest')];
      tick(controller, [2], isAtBottom: true);

      verify(() => channel.markRead()).called(2);
    });

    group('with an active manual mark-unread', () {
      setUp(() {
        when(() => channelState.isMarkedAsUnread).thenReturn(true);
        when(() => channelState.unreadCount).thenReturn(3);
        when(() => channelState.currentUserRead).thenReturn(read(unreadMessages: 3));
        messages = [message(id: 'newest')];
      });

      test('does not mark read while the viewport has not moved', () {
        final controller = buildController()..attach();

        tick(controller, [2, 3], isAtBottom: true);
        tick(controller, [2, 3], isAtBottom: true);

        verifyNever(() => channel.markRead());
      });

      test('marks read once the viewport genuinely differs', () {
        final controller = buildController()..attach();

        tick(controller, [2, 3], isAtBottom: false);
        tick(controller, [4, 5], isAtBottom: true);

        verify(() => channel.markRead()).called(1);
      });

      test('divergence latches, so returning to the same rest position still marks read', () {
        final controller = buildController()..attach();

        tick(controller, [2, 3], isAtBottom: true);
        tick(controller, [6, 7], isAtBottom: false);
        tick(controller, [2, 3], isAtBottom: true);

        verify(() => channel.markRead()).called(1);
      });
    });

    group('in a thread', () {
      test('marks the thread read once the parent has replies', () {
        parentMessage = Message(id: 'parent', text: 'p', replyCount: 2);
        final controller = buildController()..attach();

        tick(controller, [2], isAtBottom: true);

        verify(() => channel.markThreadRead('parent')).called(1);
      });

      test('does not mark a reply-less parent read', () {
        parentMessage = Message(id: 'parent', text: 'p', replyCount: 0);
        final controller = buildController()..attach();

        tick(controller, [2], isAtBottom: true);

        verifyNever(() => channel.markThreadRead(any()));
      });
    });
  });

  group('pill taps', () {
    test('jump scrolls to the resolved anchor and retires the pill', () async {
      when(() => channelState.currentUserRead).thenReturn(read(unreadMessages: 4, lastReadMessageId: 'm-4'));
      firstUnreadMessage = message(id: 'm-5');
      final controller = buildController()..attach();

      await controller.onPillJumpTapped();

      expect(scrollRequests, ['m-5']);
      expect(controller.hasSeenFirstUnread.value, isTrue);
    });

    test('jump falls back to the baseline boundary when the anchor is unresolved', () async {
      when(() => channelState.currentUserRead).thenReturn(read(unreadMessages: 4, lastReadMessageId: 'm-4'));
      firstUnreadMessage = null;
      final controller = buildController()..attach();

      await controller.onPillJumpTapped();

      expect(scrollRequests, ['m-4']);
    });

    test('jump heads for the oldest loaded message when there is no boundary at all', () async {
      when(() => channelState.currentUserRead).thenReturn(read(unreadMessages: 4));
      messages = [message(id: 'newest'), message(id: 'oldest')];
      final controller = buildController()..attach();

      await controller.onPillJumpTapped();

      expect(scrollRequests, ['oldest']);
      expect(
        controller.hasSeenFirstUnread.value,
        isFalse,
        reason: 'the real boundary is further back than this lands',
      );
    });

    test('a jump that never landed leaves the pill up', () async {
      scrollLands = false;
      when(() => channelState.currentUserRead).thenReturn(read(unreadMessages: 4, lastReadMessageId: 'm-4'));
      firstUnreadMessage = message(id: 'm-5');
      final controller = buildController()..attach();

      await controller.onPillJumpTapped();

      expect(controller.hasSeenFirstUnread.value, isFalse);
    });

    test('a jump result arriving after a channel change is dropped', () async {
      when(() => channelState.currentUserRead).thenReturn(read(unreadMessages: 4, lastReadMessageId: 'm-4'));
      firstUnreadMessage = message(id: 'm-5');
      final controller = buildController()..attach();

      final jump = controller.onPillJumpTapped();
      attachToken = 'channel-2';
      await jump;

      expect(controller.hasSeenFirstUnread.value, isFalse);
    });

    test('dismiss retires the pill and marks the channel read immediately', () async {
      final controller = buildController();

      await controller.onPillDismissTapped();

      expect(controller.hasSeenFirstUnread.value, isTrue);
      verify(() => channel.markRead()).called(1);
    });

    test('dismiss in a thread marks the thread read', () async {
      parentMessage = message(id: 'parent');
      final controller = buildController();

      await controller.onPillDismissTapped();

      verify(() => channel.markThreadRead('parent')).called(1);
    });
  });
}
