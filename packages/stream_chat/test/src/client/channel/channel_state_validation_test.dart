import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

const _cooldownDuration = 30; // seconds

// A bare channel state (no config, no capabilities).
ChannelState Function(ChannelState) _seedChannel() {
  return (_) => createDefaultChannelState(
    channel: createDefaultChannelModel(cid: _channelCid),
  );
}

// A channel with an active cooldown and the slow-mode capability.
// `isUpToDate` is seeded true by default.
ChannelState Function(ChannelState) _seedChannelWithCooldown() {
  return (_) => createDefaultChannelState(
    channel: createDefaultChannelModel(
      cid: _channelCid,
      cooldown: _cooldownDuration,
      ownCapabilities: [ChannelCapability.slowMode],
    ),
  );
}

void main() {
  group('Channel State Validation and Cooldown', () {
    group('Non-initialized channel state validation', () {
      channelTest(
        'should throw StateError when accessing cooldown on non-initialized channel',
        channelType: _channelType,
        channelId: _channelId,
        body: (tester) async {
          final channel = tester.channel;
          expect(() => channel.cooldown, throwsA(isA<StateError>()));
        },
      );

      channelTest(
        'should throw StateError when accessing getRemainingCooldown on non-initialized channel',
        channelType: _channelType,
        channelId: _channelId,
        body: (tester) async {
          final channel = tester.channel;
          expect(channel.getRemainingCooldown, throwsA(isA<StateError>()));
        },
      );

      channelTest(
        'should throw StateError when accessing cooldownStream on non-initialized channel',
        channelType: _channelType,
        channelId: _channelId,
        body: (tester) async {
          final channel = tester.channel;
          expect(() => channel.cooldownStream, throwsA(isA<StateError>()));
        },
      );
    });

    group('Initialized channel cooldown functionality', () {
      channelTest(
        'should return default cooldown value of 0 for initialized channel',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) => expect(tester.channel.cooldown, equals(0)),
      );

      channelTest(
        'should return custom cooldown value when set in channel model',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final channelWithCooldown = ChannelModel(
            id: _channelId,
            type: _channelType,
            cooldown: 30,
          );

          final stateWithCooldown = ChannelState(channel: channelWithCooldown);
          final testChannel = Channel.fromState(tester.client, stateWithCooldown);
          addTearDown(testChannel.dispose);

          expect(testChannel.cooldown, equals(30));
        },
      );

      channelTest(
        'should return 0 remaining cooldown when no cooldown is set',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          expect(tester.channel.getRemainingCooldown(), equals(0));
        },
      );

      channelTest(
        'should return cooldown stream with default value',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          await expectLater(tester.channel.cooldownStream.take(1), emits(0));
        },
      );
    });

    group('Thread reply cooldown', () {
      channelTest(
        'should return positive cooldown after current user sends a thread reply',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelWithCooldown()),
        body: (tester) async {
          // Simulate a thread reply by the current user sent just now.
          final threadReply = Message(
            id: 'thread-reply-1',
            parentId: 'parent-msg-1',
            showInChannel: false,
            createdAt: DateTime.timestamp(),
            user: User(id: tester.currentUser!.id),
          );
          tester.channelState!.updateThreadInfo('parent-msg-1', [threadReply]);

          expect(tester.channel.getRemainingCooldown(), greaterThan(0));
        },
      );

      channelTest(
        'should return 0 cooldown when thread reply was sent outside the cooldown window',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelWithCooldown()),
        body: (tester) async {
          // Reply sent cooldownDuration+5 seconds ago — outside the window.
          final oldReply = Message(
            id: 'thread-reply-old',
            parentId: 'parent-msg-1',
            showInChannel: false,
            createdAt: DateTime.timestamp().subtract(
              const Duration(seconds: _cooldownDuration + 5),
            ),
            user: User(id: tester.currentUser!.id),
          );
          tester.channelState!.updateThreadInfo('parent-msg-1', [oldReply]);

          expect(tester.channel.getRemainingCooldown(), equals(0));
        },
      );

      channelTest(
        'should not trigger cooldown for a thread reply from another user',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelWithCooldown()),
        body: (tester) async {
          final otherUserReply = Message(
            id: 'thread-reply-other',
            parentId: 'parent-msg-1',
            showInChannel: false,
            createdAt: DateTime.timestamp(),
            user: User(id: 'other-user-id'),
          );
          tester.channelState!.updateThreadInfo('parent-msg-1', [otherUserReply]);

          expect(tester.channel.getRemainingCooldown(), equals(0));
        },
      );

      channelTest(
        'should clear cooldown when the most-recent own message is hard-deleted',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelWithCooldown()),
        body: (tester) async {
          final ownMessage = Message(
            id: 'msg-1',
            createdAt: DateTime.timestamp(),
            user: User(id: tester.currentUser!.id),
          );
          tester.channelState!.updateMessage(ownMessage);
          expect(tester.channel.getRemainingCooldown(), greaterThan(0));

          tester.channelState!.deleteMessage(ownMessage, hardDelete: true);
          expect(tester.channel.getRemainingCooldown(), equals(0));
        },
      );

      channelTest(
        'currentUserLastMessageAtStream emits a new timestamp when own message is added',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelWithCooldown()),
        body: (tester) async {
          final emissions = <DateTime?>[];
          final sub = tester.channel.currentUserLastMessageAtStream.listen(emissions.add);
          addTearDown(sub.cancel);

          // Let the seed emission settle.
          await Future<void>.delayed(Duration.zero);
          final seededLast = emissions.last;

          tester.channelState!.updateMessage(
            Message(
              id: 'msg-1',
              createdAt: DateTime.timestamp(),
              user: User(id: tester.currentUser!.id),
            ),
          );
          await Future<void>.delayed(Duration.zero);

          expect(emissions.last, isNotNull);
          expect(emissions.last, isNot(equals(seededLast)));
        },
      );

      channelTest(
        'getRemainingCooldown uses the explicit [lastMessageAt] override',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelWithCooldown()),
        body: (tester) async {
          // No messages in state, so the default path returns 0.
          expect(tester.channel.getRemainingCooldown(), equals(0));

          // Override pointing inside the cooldown window → positive remaining.
          final recent = DateTime.timestamp().subtract(const Duration(seconds: 5));
          expect(tester.channel.getRemainingCooldown(lastMessageAt: recent), greaterThan(0));

          // Override pointing outside the window → 0.
          final old = DateTime.timestamp().subtract(
            const Duration(seconds: _cooldownDuration + 5),
          );
          expect(tester.channel.getRemainingCooldown(lastMessageAt: old), equals(0));
        },
      );

      channelTest(
        'currentUserLastMessageAt picks the latest across channel messages and threads',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelWithCooldown()),
        body: (tester) async {
          final older = DateTime.timestamp().subtract(const Duration(seconds: 20));
          final newer = DateTime.timestamp().subtract(const Duration(seconds: 5));

          // Older message in the main channel.
          tester.channelState!.updateMessage(
            Message(
              id: 'msg-1',
              createdAt: older,
              user: User(id: tester.currentUser!.id),
            ),
          );
          // Newer reply in a thread.
          tester.channelState!.updateThreadInfo('parent-msg-1', [
            Message(
              id: 'thread-reply-1',
              parentId: 'parent-msg-1',
              showInChannel: false,
              createdAt: newer,
              user: User(id: tester.currentUser!.id),
            ),
          ]);

          // Should pick the newer thread reply, not the older channel message.
          final result = tester.channel.currentUserLastMessageAt;
          expect(result, isNotNull);
          expect(result!.isAtSameMomentAs(newer), isTrue);
        },
      );
    });

    group('Disposed channel state validation', () {
      channelTest(
        'should throw StateError when accessing cooldown after disposal',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final channel = tester.channel;

          // First verify it works when initialized
          expect(channel.cooldown, equals(0));

          // Dispose the channel
          channel.dispose();

          // Now accessing cooldown should throw
          expect(() => channel.cooldown, throwsA(isA<StateError>()));
        },
      );

      channelTest(
        'should throw StateError when accessing getRemainingCooldown after disposal',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final channel = tester.channel;

          // First verify it works when initialized
          expect(channel.getRemainingCooldown(), equals(0));

          // Dispose the channel
          channel.dispose();

          // Now accessing getRemainingCooldown should throw
          expect(channel.getRemainingCooldown, throwsA(isA<StateError>()));
        },
      );

      channelTest(
        'should throw StateError when accessing cooldownStream after disposal',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final channel = tester.channel;

          // First verify it works when initialized
          await expectLater(channel.cooldownStream.take(1), emits(0));

          // Dispose the channel
          channel.dispose();

          // Now accessing cooldownStream should throw
          expect(() => channel.cooldownStream, throwsA(isA<StateError>()));
        },
      );

      channelTest(
        'should handle race condition scenario - initialization then quick disposal',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          // This test simulates the race condition that was causing the production crash
          final channelState = createDefaultChannelState(
            channel: createDefaultChannelModel(cid: _channelCid),
          );
          final raceChannel = Channel.fromState(tester.client, channelState);

          // Verify it works initially
          expect(raceChannel.cooldown, equals(0));

          // Simulate quick disposal (like what happens with rapid navigation)
          raceChannel.dispose();

          // This should throw StateError instead of crashing with null check operator
          expect(() => raceChannel.cooldown, throwsA(isA<StateError>()));

          expect(raceChannel.getRemainingCooldown, throwsA(isA<StateError>()));
        },
      );
    });
  });
}
