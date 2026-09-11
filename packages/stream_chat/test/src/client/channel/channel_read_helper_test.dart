import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

void main() {
  // A date in the distant past (Unix epoch), useful for representing old dates.
  final distantPast = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

  final sender = createDefaultUser(id: 'sender-id', name: 'Sender');
  final user1 = createDefaultUser(id: 'user-1', name: 'User 1');
  final user2 = createDefaultUser(id: 'user-2', name: 'User 2');
  final user3 = createDefaultUser(id: 'user-3', name: 'User 3');
  final user4 = createDefaultUser(id: 'user-4', name: 'User 4');

  // The message all read/delivery checks are evaluated against; reads use
  // timestamps relative to its creation time.
  final messageSentAt = testCreatedAt;
  final message = createDefaultMessage(
    id: 'msg-1',
    text: 'Test message',
    user: sender,
    createdAt: messageSentAt,
  );

  // ============================================================
  // FEATURE: User Reads
  // ============================================================

  group('Channel Read Helper - User Reads', () {
    channelTest(
      'userReadOf - should return read for specific user',
      setUp: (tester) => tester.watch(
        modifyResponse: (state) => state.copyWith(
          read: [
            createDefaultRead(user: user1, lastRead: messageSentAt),
            createDefaultRead(user: user2, lastRead: messageSentAt.add(const Duration(minutes: 1))),
          ],
        ),
      ),
      body: (tester) async {
        final user1Read = tester.channelState!.userReadOf(userId: 'user-1');
        expect(user1Read, isNotNull);
        expect(user1Read!.user.id, 'user-1');
        expect(user1Read.lastRead, messageSentAt);

        final user2Read = tester.channelState!.userReadOf(userId: 'user-2');
        expect(user2Read, isNotNull);
        expect(user2Read!.user.id, 'user-2');

        final nonExistentRead = tester.channelState!.userReadOf(userId: 'user-3');
        expect(nonExistentRead, isNull);
      },
    );

    channelTest(
      'userReadOf - should return null when userId is null',
      setUp: (tester) => tester.watch(),
      body: (tester) async {
        final read = tester.channelState!.userReadOf(userId: null);
        expect(read, isNull);
      },
    );

    channelTest(
      'userReadStreamOf - should emit read updates for specific user',
      setUp: (tester) => tester.watch(),
      body: (tester) async {
        final readStream = tester.channelState!.userReadStreamOf(userId: 'user-1');

        final readEmitted = expectLater(
          readStream,
          emitsInOrder([
            isNull, // initial state
            isA<Read>().having((r) => r.user.id, 'userId', 'user-1'),
          ]),
        );

        // Update with read
        tester.channelState!.updateChannelState(
          ChannelState(
            read: [createDefaultRead(user: user1, lastRead: messageSentAt)],
          ),
        );

        await readEmitted;
      },
    );
  });

  // ============================================================
  // FEATURE: Message Reads
  // ============================================================

  group('Channel Read Helper - Message Reads', () {
    channelTest(
      'readsOf - should return reads that have marked message as read',
      setUp: (tester) => tester.watch(
        modifyResponse: (state) => state.copyWith(
          read: [
            // user1 has read the message
            createDefaultRead(user: user1, lastRead: messageSentAt.add(const Duration(seconds: 1))),
            // user2 has not read the message yet
            createDefaultRead(user: user2, lastRead: distantPast),
            // user3 has read the message
            createDefaultRead(user: user3, lastRead: messageSentAt.add(const Duration(seconds: 2))),
            // sender should be excluded
            createDefaultRead(user: sender, lastRead: messageSentAt.add(const Duration(seconds: 10))),
          ],
        ),
      ),
      body: (tester) async {
        final messageReads = tester.channelState!.readsOf(message: message);

        expect(messageReads.length, 2);
        expect(messageReads.map((r) => r.user.id), containsAll(['user-1', 'user-3']));
        expect(messageReads.map((r) => r.user.id), isNot(contains('user-2')));
        expect(messageReads.map((r) => r.user.id), isNot(contains('sender-id')));
      },
    );

    channelTest(
      'readsOfStream - should emit read updates for a message',
      setUp: (tester) => tester.watch(),
      body: (tester) async {
        final readsStream = tester.channelState!.readsOfStream(message: message);

        final readsEmitted = expectLater(
          readsStream,
          emitsInOrder([
            isEmpty, // initial state
            hasLength(1), // after adding read
          ]),
        );

        // Update with read
        tester.channelState!.updateChannelState(
          ChannelState(
            read: [
              createDefaultRead(user: user1, lastRead: messageSentAt.add(const Duration(seconds: 1))),
            ],
          ),
        );

        await readsEmitted;
      },
    );
  });

  // ============================================================
  // FEATURE: Message Deliveries
  // ============================================================

  group('Channel Read Helper - Message Deliveries', () {
    channelTest(
      'deliveriesOf - should return reads that have delivered the message',
      setUp: (tester) => tester.watch(
        modifyResponse: (state) => state.copyWith(
          read: [
            // user1 has delivered the message
            createDefaultRead(
              user: user1,
              lastRead: distantPast,
              lastDeliveredAt: messageSentAt.add(const Duration(seconds: 1)),
            ),
            // user2 has not delivered the message yet (lastDeliveredAt is before message)
            createDefaultRead(
              user: user2,
              lastRead: distantPast,
              lastDeliveredAt: distantPast,
            ),
            // user3 has no lastDeliveredAt
            createDefaultRead(
              user: user3,
              lastRead: distantPast,
            ),
            // user4 has read the message (implicitly delivered)
            createDefaultRead(
              user: user4,
              lastRead: messageSentAt.add(const Duration(seconds: 1)),
            ),
            // sender should be excluded
            createDefaultRead(
              user: sender,
              lastRead: messageSentAt.add(const Duration(seconds: 10)),
              lastDeliveredAt: messageSentAt.add(const Duration(seconds: 10)),
            ),
          ],
        ),
      ),
      body: (tester) async {
        final deliveries = tester.channelState!.deliveriesOf(message: message);

        expect(deliveries.length, 2);
        expect(deliveries.map((r) => r.user.id), containsAll(['user-1', 'user-4']));
        expect(deliveries.map((r) => r.user.id), isNot(contains('user-2')));
        expect(deliveries.map((r) => r.user.id), isNot(contains('user-3')));
        expect(deliveries.map((r) => r.user.id), isNot(contains('sender-id')));
      },
    );

    channelTest(
      'deliveriesOfStream - should emit delivery updates for a message',
      setUp: (tester) => tester.watch(),
      body: (tester) async {
        final deliveriesStream = tester.channelState!.deliveriesOfStream(message: message);

        final deliveriesEmitted = expectLater(
          deliveriesStream,
          emitsInOrder([
            isEmpty, // initial state
            hasLength(1), // after adding delivery
          ]),
        );

        // Update with delivery
        tester.channelState!.updateChannelState(
          ChannelState(
            read: [
              createDefaultRead(
                user: user1,
                lastRead: distantPast,
                lastDeliveredAt: messageSentAt.add(const Duration(seconds: 1)),
              ),
            ],
          ),
        );

        await deliveriesEmitted;
      },
    );
  });
}
