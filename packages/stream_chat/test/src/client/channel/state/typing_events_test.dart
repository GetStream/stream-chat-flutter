import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

void main() {
  group('Typing events', () {
    channelTest(
      '${EventType.typingStart} from another user is added to typingEvents',
      channelType: 'test-channel-type',
      channelId: 'test-channel-id',
      setUp: (tester) => tester.watch(),
      body: (tester) async {
        final otherUser = User(id: 'other-user');

        await tester.emitEvent(
          createDefaultEvent(type: EventType.typingStart, cid: tester.channel.cid, user: otherUser),
        );

        final typingEvents = tester.channelState!.typingEvents;
        expect(typingEvents.keys.map((u) => u.id), ['other-user']);
        expect(typingEvents.values.single.type, EventType.typingStart);
      },
    );

    channelTest(
      '${EventType.typingStop} removes only the stopping user',
      channelType: 'test-channel-type',
      channelId: 'test-channel-id',
      setUp: (tester) => tester.watch(),
      body: (tester) async {
        final user1 = User(id: 'other-user-1');
        final user2 = User(id: 'other-user-2');

        await tester.emitEvent(createDefaultEvent(type: EventType.typingStart, cid: tester.channel.cid, user: user1));
        await tester.emitEvent(createDefaultEvent(type: EventType.typingStart, cid: tester.channel.cid, user: user2));
        expect(tester.channelState!.typingEvents, hasLength(2));

        await tester.emitEvent(createDefaultEvent(type: EventType.typingStop, cid: tester.channel.cid, user: user1));

        expect(tester.channelState!.typingEvents.keys.map((u) => u.id), ['other-user-2']);
      },
    );

    channelTest(
      '${EventType.typingStart} from the current user is ignored',
      channelType: 'test-channel-type',
      channelId: 'test-channel-id',
      setUp: (tester) => tester.watch(),
      body: (tester) async {
        final currentUser = User(id: tester.currentUser!.id);

        await tester.emitEvent(
          createDefaultEvent(type: EventType.typingStart, cid: tester.channel.cid, user: currentUser),
        );

        expect(tester.channelState!.typingEvents, isEmpty);
      },
    );

    channelTest(
      '${EventType.typingStart} without a user is ignored',
      channelType: 'test-channel-type',
      channelId: 'test-channel-id',
      setUp: (tester) => tester.watch(),
      body: (tester) async {
        await tester.emitEvent(createDefaultEvent(type: EventType.typingStart, cid: tester.channel.cid));

        expect(tester.channelState!.typingEvents, isEmpty);
      },
    );

    channelTest(
      '${EventType.typingStop} from the current user is ignored',
      channelType: 'test-channel-type',
      channelId: 'test-channel-id',
      setUp: (tester) => tester.watch(),
      body: (tester) async {
        final currentUser = User(id: tester.currentUser!.id);

        await tester.emitEvent(
          createDefaultEvent(type: EventType.typingStop, cid: tester.channel.cid, user: currentUser),
        );

        expect(tester.channelState!.typingEvents, isEmpty);
      },
    );

    channelTest(
      '${EventType.typingStop} without a user is ignored',
      channelType: 'test-channel-type',
      channelId: 'test-channel-id',
      setUp: (tester) => tester.watch(),
      body: (tester) async {
        await tester.emitEvent(createDefaultEvent(type: EventType.typingStop, cid: tester.channel.cid));

        expect(tester.channelState!.typingEvents, isEmpty);
      },
    );
  });
}
