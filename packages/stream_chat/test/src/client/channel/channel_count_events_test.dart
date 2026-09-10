import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

// A bare channel state (no config, no capabilities).
ChannelState Function(ChannelState) _seedChannel() {
  return (_) => createDefaultChannelState(
    channel: createDefaultChannelModel(cid: _channelCid),
  );
}

void main() {
  group('Channel message count events', () {
    channelTest(
      'should update channel messageCount when event contains channelMessageCount',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        // Verify initial state - no messageCount
        expect(tester.channel.messageCount, isNull);

        // Create event with channelMessageCount
        final messageCountEvent = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.messageNew,
          channelMessageCount: 42,
        );

        // Dispatch event and wait for it to be processed
        await tester.emitEvent(messageCountEvent);

        // Verify channel messageCount was updated
        expect(tester.channel.messageCount, equals(42));
      },
    );

    channelTest(
      'should update channel messageCount from message.new and message.deleted events',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        // Test with message.new event - count increases
        final messageNewEvent = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.messageNew,
          message: createDefaultMessage(
            id: 'new-message-1',
            text: 'Hello world!',
            user: User(id: 'user-1'),
          ),
          channelMessageCount: 1,
        );

        await tester.emitEvent(messageNewEvent);
        expect(tester.channel.messageCount, equals(1));

        // Test with another message.new event - count increases
        final messageNewEvent2 = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.messageNew,
          message: createDefaultMessage(
            id: 'new-message-2',
            text: 'Second message',
            user: User(id: 'user-2'),
          ),
          channelMessageCount: 2,
        );

        await tester.emitEvent(messageNewEvent2);
        expect(tester.channel.messageCount, equals(2));

        // Test with message.deleted event - count decreases
        final messageDeletedEvent = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.messageDeleted,
          message: createDefaultMessage(
            id: 'new-message-1',
            text: 'Hello world!',
            user: User(id: 'user-1'),
          ),
          channelMessageCount: 1,
        );

        await tester.emitEvent(messageDeletedEvent);
        expect(tester.channel.messageCount, equals(1));
      },
    );

    channelTest(
      'should preserve other channel properties when updating messageCount',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        // Set initial channel state with some properties
        final initialChannel = tester.channelState?.channelState.channel?.copyWith(
          extraData: {'name': 'Test Channel'},
          memberCount: 5,
          frozen: true,
        );

        if (initialChannel != null) {
          tester.channelState?.updateChannelState(
            tester.channelState!.channelState.copyWith(channel: initialChannel),
          );
        }

        // Verify initial state
        expect(tester.channel.name, 'Test Channel');
        expect(tester.channel.memberCount, equals(5));
        expect(tester.channel.frozen, equals(true));
        expect(tester.channel.messageCount, isNull);

        // Update messageCount via event
        final messageCountEvent = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.messageNew,
          channelMessageCount: 100,
        );

        await tester.emitEvent(messageCountEvent);

        // Verify messageCount was updated while preserving other properties
        expect(tester.channel.messageCount, equals(100));
        expect(tester.channel.name, 'Test Channel');
        expect(tester.channel.memberCount, equals(5));
        expect(tester.channel.frozen, equals(true));
      },
    );

    channelTest(
      'should provide messageCountStream for reactive updates',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final emitted = <int?>[];
        final subscription = tester.channel.messageCountStream.listen(emitted.add);
        addTearDown(subscription.cancel);
        await Future.delayed(Duration.zero);

        // Update messageCount multiple times, repeating one of the counts.
        final counts = [1, 5, 5, 10];
        for (final (index, count) in counts.indexed) {
          final event = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.messageNew,
            message: createDefaultMessage(
              id: 'msg-$index',
              text: 'Message $count',
              user: User(id: 'user-1'),
            ),
            channelMessageCount: count,
          );

          await tester.emitEvent(event);
        }

        // The repeated count should not be emitted twice.
        expect(emitted, equals([null, 1, 5, 10]));
      },
    );
  });

  group('Channel member count events', () {
    channelTest(
      'should update channel memberCount when event contains channelMemberCount',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        // Verify initial state - default memberCount
        expect(tester.channel.memberCount, equals(0));

        // Create event with channelMemberCount
        final memberCountEvent = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.memberAdded,
          member: createDefaultMember(user: User(id: 'user-1')),
          channelMemberCount: 42,
        );

        // Dispatch event and wait for it to be processed
        await tester.emitEvent(memberCountEvent);

        // Verify channel memberCount was updated
        expect(tester.channel.memberCount, equals(42));
      },
    );

    channelTest(
      'should update channel memberCount from member.added and member.removed events',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        // Test with member.added event - count increases
        final memberAddedEvent = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.memberAdded,
          member: createDefaultMember(user: User(id: 'user-1')),
          channelMemberCount: 1,
        );

        await tester.emitEvent(memberAddedEvent);
        expect(tester.channel.memberCount, equals(1));
        expect(tester.channelState?.channelState.members?.map((it) => it.userId), equals(['user-1']));

        // Test with another member.added event - count increases
        final memberAddedEvent2 = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.memberAdded,
          member: createDefaultMember(user: User(id: 'user-2')),
          channelMemberCount: 2,
        );

        await tester.emitEvent(memberAddedEvent2);
        expect(tester.channel.memberCount, equals(2));
        expect(
          tester.channelState?.channelState.members?.map((it) => it.userId),
          equals(['user-1', 'user-2']),
        );

        // Test with member.removed event - count decreases
        final memberRemovedEvent = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.memberRemoved,
          user: User(id: 'user-1'),
          channelMemberCount: 1,
        );

        await tester.emitEvent(memberRemovedEvent);
        expect(tester.channel.memberCount, equals(1));
        expect(tester.channelState?.channelState.members?.map((it) => it.userId), equals(['user-2']));
      },
    );

    channelTest(
      'should preserve other channel properties when updating memberCount',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        // Set initial channel state with some properties
        final initialChannel = tester.channelState?.channelState.channel?.copyWith(
          extraData: {'name': 'Test Channel'},
          messageCount: 7,
          frozen: true,
        );

        if (initialChannel != null) {
          tester.channelState?.updateChannelState(
            tester.channelState!.channelState.copyWith(channel: initialChannel),
          );
        }

        // Verify initial state
        expect(tester.channel.name, 'Test Channel');
        expect(tester.channel.messageCount, equals(7));
        expect(tester.channel.frozen, equals(true));
        expect(tester.channel.memberCount, equals(0));

        // Update memberCount via event
        final memberCountEvent = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.memberAdded,
          member: createDefaultMember(user: User(id: 'user-1')),
          channelMemberCount: 100,
        );

        await tester.emitEvent(memberCountEvent);

        // Verify memberCount was updated while preserving other properties
        expect(tester.channel.memberCount, equals(100));
        expect(tester.channel.name, 'Test Channel');
        expect(tester.channel.messageCount, equals(7));
        expect(tester.channel.frozen, equals(true));
      },
    );

    channelTest(
      'should not update memberCount when the event omits channelMemberCount',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        // Seed a known member count.
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.memberAdded,
            member: createDefaultMember(user: User(id: 'user-1')),
            channelMemberCount: 5,
          ),
        );

        expect(tester.channel.memberCount, equals(5));

        // An event without the field should leave the count untouched.
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.memberAdded,
            member: createDefaultMember(user: User(id: 'user-2')),
          ),
        );

        expect(tester.channel.memberCount, equals(5));
      },
    );

    channelTest(
      'should provide memberCountStream for reactive updates',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final emitted = <int?>[];
        final subscription = tester.channel.memberCountStream.listen(emitted.add);
        addTearDown(subscription.cancel);
        await Future.delayed(Duration.zero);

        // Update memberCount multiple times, repeating one of the counts.
        final counts = [1, 5, 5, 10];
        for (final (index, count) in counts.indexed) {
          final event = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.memberAdded,
            member: createDefaultMember(user: User(id: 'user-$index')),
            channelMemberCount: count,
          );

          await tester.emitEvent(event);
        }

        // The repeated count should not be emitted twice.
        expect(emitted, equals([0, 1, 5, 10]));
      },
    );
  });
}
