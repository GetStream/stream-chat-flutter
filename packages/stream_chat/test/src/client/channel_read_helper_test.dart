import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../mocks.dart';

void main() {
  group('ChannelReadHelper', () {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    late final client = MockStreamChatClient();

    // A date in the distant past (Unix epoch), useful for representing old dates
    final distantPast = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

    setUpAll(() {
      // detached loggers
      when(() => client.detachedLogger(any())).thenAnswer((invocation) {
        final name = invocation.positionalArguments.first;
        return _createLogger(name);
      });

      final retryPolicy = RetryPolicy(
        shouldRetry: (_, __, ___) => false,
        delayFactor: Duration.zero,
      );
      when(() => client.retryPolicy).thenReturn(retryPolicy);

      // fake clientState
      final clientState = FakeClientState();
      when(() => client.state).thenReturn(clientState);

      // client logger
      when(() => client.logger).thenReturn(_createLogger('mock-client-logger'));
    });

    test('userReadOf should return read for specific user', () {
      final now = DateTime.now();
      final user1 = User(id: 'user-1', name: 'User 1');
      final user2 = User(id: 'user-2', name: 'User 2');

      final reads = [
        Read(user: user1, lastRead: now),
        Read(user: user2, lastRead: now.add(const Duration(minutes: 1))),
      ];

      final channelState = _generateChannelState(channelId, channelType);
      final channel = Channel.fromState(client, channelState);
      addTearDown(channel.dispose);

      channel.state!.updateChannelState(
        ChannelState(channel: channelState.channel, read: reads),
      );

      final user1Read = channel.state!.userReadOf(userId: 'user-1');
      expect(user1Read, isNotNull);
      expect(user1Read!.user.id, 'user-1');
      expect(user1Read.lastRead, now);

      final user2Read = channel.state!.userReadOf(userId: 'user-2');
      expect(user2Read, isNotNull);
      expect(user2Read!.user.id, 'user-2');

      final nonExistentRead = channel.state!.userReadOf(userId: 'user-3');
      expect(nonExistentRead, isNull);
    });

    test('userReadOf should return null when userId is null', () {
      final channelState = _generateChannelState(channelId, channelType);
      final channel = Channel.fromState(client, channelState);
      addTearDown(channel.dispose);

      final read = channel.state!.userReadOf(userId: null);
      expect(read, isNull);
    });

    test(
      'userReadStreamOf should emit read updates for specific user',
      () async {
        final now = DateTime.now();
        final user1 = User(id: 'user-1', name: 'User 1');

        final channelState = _generateChannelState(channelId, channelType);
        final channel = Channel.fromState(client, channelState);
        addTearDown(channel.dispose);

        final readStream = channel.state!.userReadStreamOf(userId: 'user-1');

        expectLater(
          readStream,
          emitsInOrder([
            isNull, // initial state
            isA<Read>().having((r) => r.user.id, 'userId', 'user-1'),
          ]),
        );

        // Update with read
        channel.state!.updateChannelState(
          ChannelState(
            channel: channelState.channel,
            read: [Read(user: user1, lastRead: now)],
          ),
        );
      },
    );

    test('readsOf should return reads that have marked message as read', () {
      final now = DateTime.now();
      final sender = User(id: 'sender-id', name: 'Sender');
      final user1 = User(id: 'user-1', name: 'User 1');
      final user2 = User(id: 'user-2', name: 'User 2');
      final user3 = User(id: 'user-3', name: 'User 3');

      final message = Message(
        id: 'msg-1',
        text: 'Test message',
        user: sender,
        createdAt: now,
      );

      final reads = [
        // user1 has read the message
        Read(user: user1, lastRead: now.add(const Duration(seconds: 1))),
        // user2 has not read the message yet
        Read(user: user2, lastRead: distantPast),
        // user3 has read the message
        Read(user: user3, lastRead: now.add(const Duration(seconds: 2))),
        // sender should be excluded
        Read(user: sender, lastRead: now.add(const Duration(seconds: 10))),
      ];

      final channelState = _generateChannelState(channelId, channelType);
      final channel = Channel.fromState(client, channelState);
      addTearDown(channel.dispose);

      channel.state!.updateChannelState(
        ChannelState(channel: channelState.channel, read: reads),
      );

      final messageReads = channel.state!.readsOf(message: message);
      expect(messageReads.length, 2);
      expect(messageReads.map((r) => r.user.id), containsAll(['user-1', 'user-3']));
      expect(messageReads.map((r) => r.user.id), isNot(contains('user-2')));
      expect(messageReads.map((r) => r.user.id), isNot(contains('sender-id')));
    });

    test('readsOfStream should emit read updates for a message', () async {
      final now = DateTime.now();
      final sender = User(id: 'sender-id', name: 'Sender');
      final user1 = User(id: 'user-1', name: 'User 1');

      final message = Message(
        id: 'msg-1',
        text: 'Test message',
        user: sender,
        createdAt: now,
      );

      final channelState = _generateChannelState(channelId, channelType);
      final channel = Channel.fromState(client, channelState);
      addTearDown(channel.dispose);

      final readsStream = channel.state!.readsOfStream(message: message);

      expectLater(
        readsStream,
        emitsInOrder([
          isEmpty, // initial state
          hasLength(1), // after adding read
        ]),
      );

      // Update with read
      channel.state!.updateChannelState(
        ChannelState(
          channel: channelState.channel,
          read: [Read(user: user1, lastRead: now.add(const Duration(seconds: 1)))],
        ),
      );
    });

    test('deliveriesOf should return reads that have delivered the message', () {
      final now = DateTime.now();
      final sender = User(id: 'sender-id', name: 'Sender');
      final user1 = User(id: 'user-1', name: 'User 1');
      final user2 = User(id: 'user-2', name: 'User 2');
      final user3 = User(id: 'user-3', name: 'User 3');
      final user4 = User(id: 'user-4', name: 'User 4');

      final message = Message(
        id: 'msg-1',
        text: 'Test message',
        user: sender,
        createdAt: now,
      );

      final reads = [
        // user1 has delivered the message
        Read(
          user: user1,
          lastRead: distantPast,
          lastDeliveredAt: now.add(const Duration(seconds: 1)),
        ),
        // user2 has not delivered the message yet (lastDeliveredAt is before message)
        Read(
          user: user2,
          lastRead: distantPast,
          lastDeliveredAt: distantPast,
        ),
        // user3 has no lastDeliveredAt
        Read(
          user: user3,
          lastRead: distantPast,
        ),
        // user4 has read the message (implicitly delivered)
        Read(
          user: user4,
          lastRead: now.add(const Duration(seconds: 1)),
        ),
        // sender should be excluded
        Read(
          user: sender,
          lastRead: now.add(const Duration(seconds: 10)),
          lastDeliveredAt: now.add(const Duration(seconds: 10)),
        ),
      ];

      final channelState = _generateChannelState(channelId, channelType);
      final channel = Channel.fromState(client, channelState);
      addTearDown(channel.dispose);

      channel.state!.updateChannelState(
        ChannelState(channel: channelState.channel, read: reads),
      );

      final deliveries = channel.state!.deliveriesOf(message: message);
      expect(deliveries.length, 2);
      expect(deliveries.map((r) => r.user.id), containsAll(['user-1', 'user-4']));
      expect(deliveries.map((r) => r.user.id), isNot(contains('user-2')));
      expect(deliveries.map((r) => r.user.id), isNot(contains('user-3')));
      expect(deliveries.map((r) => r.user.id), isNot(contains('sender-id')));
    });

    test('deliveriesOfStream should emit delivery updates for a message', () async {
      final now = DateTime.now();
      final sender = User(id: 'sender-id', name: 'Sender');
      final user1 = User(id: 'user-1', name: 'User 1');

      final message = Message(
        id: 'msg-1',
        text: 'Test message',
        user: sender,
        createdAt: now,
      );

      final channelState = _generateChannelState(channelId, channelType);
      final channel = Channel.fromState(client, channelState);
      addTearDown(channel.dispose);

      final deliveriesStream = channel.state!.deliveriesOfStream(message: message);

      expectLater(
        deliveriesStream,
        emitsInOrder([
          isEmpty, // initial state
          hasLength(1), // after adding delivery
        ]),
      );

      // Update with delivery
      channel.state!.updateChannelState(
        ChannelState(
          channel: channelState.channel,
          read: [
            Read(
              user: user1,
              lastRead: distantPast,
              lastDeliveredAt: now.add(const Duration(seconds: 1)),
            ),
          ],
        ),
      );
    });
  });
}

// region Test Helpers

ChannelState _generateChannelState(
  String channelId,
  String channelType, {
  DateTime? lastMessageAt,
  List<ChannelCapability>? ownCapabilities,
  bool mockChannelConfig = false,
}) {
  ChannelConfig? config;
  if (mockChannelConfig) {
    config = MockChannelConfig();
    when(() => config!.readEvents).thenReturn(true);
    when(() => config!.typingEvents).thenReturn(true);
  }
  final channel = ChannelModel(
    id: channelId,
    type: channelType,
    config: config,
    ownCapabilities: ownCapabilities,
    lastMessageAt: lastMessageAt,
  );
  return ChannelState(channel: channel);
}

Logger _createLogger(String name) {
  final logger = Logger.detached(name)..level = Level.ALL;
  logger.onRecord.listen(print);
  return logger;
}

// endregion
