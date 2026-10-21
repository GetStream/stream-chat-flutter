import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../fakes.dart';
import '../../mocks.dart';

void main() {
  test('pinned messages seeded oldest pin first are sorted newest pin first', () {
    final channel = _channel(
      pinnedMessages: [
        _pin('pinned-first', createdAtSecond: 1, pinnedAtSecond: 0),
        _pin('pinned-second', createdAtSecond: 3, pinnedAtSecond: 4),
      ],
    );
    addTearDown(channel.dispose);

    expect(channel.state!.pinnedMessages.map((m) => m.id), ['pinned-second', 'pinned-first']);
  });

  test('pinned messages seeded newest pin first are kept as the same list', () {
    final pinnedMessages = [
      _pin('pinned-second', createdAtSecond: 3, pinnedAtSecond: 4),
      _pin('pinned-first', createdAtSecond: 1, pinnedAtSecond: 0),
    ];
    final channel = _channel(pinnedMessages: pinnedMessages);
    addTearDown(channel.dispose);

    expect(channel.state!.pinnedMessages, same(pinnedMessages));
  });

  test('pinned messages of an updated channel state are sorted newest pin first', () {
    final channel = _channel();
    addTearDown(channel.dispose);

    channel.state!.updateChannelState(
      ChannelState(
        pinnedMessages: [
          _pin('pinned-first', createdAtSecond: 1, pinnedAtSecond: 0),
          _pin('pinned-second', createdAtSecond: 3, pinnedAtSecond: 4),
        ],
      ),
    );

    expect(channel.state!.pinnedMessages.map((m) => m.id), ['pinned-second', 'pinned-first']);
  });

  test('pinned messages of an updated channel state already newest pin first are kept as the same list', () {
    final channel = _channel();
    addTearDown(channel.dispose);

    final pinnedMessages = [
      _pin('pinned-second', createdAtSecond: 3, pinnedAtSecond: 4),
      _pin('pinned-first', createdAtSecond: 1, pinnedAtSecond: 0),
    ];
    channel.state!.updateChannelState(ChannelState(pinnedMessages: pinnedMessages));

    expect(channel.state!.pinnedMessages, same(pinnedMessages));
  });

  test('a newly pinned message is placed by pin time, not creation time', () {
    final channel = _channel(
      pinnedMessages: [
        _pin('pinned-second', createdAtSecond: 3, pinnedAtSecond: 4),
        _pin('pinned-first', createdAtSecond: 1, pinnedAtSecond: 0),
      ],
    );
    addTearDown(channel.dispose);

    channel.state!.updateMessage(_pin('pinned-third', createdAtSecond: 2, pinnedAtSecond: 8));

    expect(channel.state!.pinnedMessages.map((m) => m.id), ['pinned-third', 'pinned-second', 'pinned-first']);
  });

  test('re-pinning a pinned message moves it to the front', () {
    final channel = _channel(
      pinnedMessages: [
        _pin('pinned-second', createdAtSecond: 3, pinnedAtSecond: 4),
        _pin('pinned-first', createdAtSecond: 1, pinnedAtSecond: 0),
      ],
    );
    addTearDown(channel.dispose);

    channel.state!.updateMessage(_pin('pinned-first', createdAtSecond: 1, pinnedAtSecond: 9));

    expect(channel.state!.pinnedMessages.map((m) => m.id), ['pinned-first', 'pinned-second']);
  });

  test('unpinning the middle pin keeps the others in pin time order', () {
    final channel = _channel(
      pinnedMessages: [
        _pin('pinned-third', createdAtSecond: 2, pinnedAtSecond: 8),
        _pin('pinned-second', createdAtSecond: 3, pinnedAtSecond: 4),
        _pin('pinned-first', createdAtSecond: 1, pinnedAtSecond: 0),
      ],
    );
    addTearDown(channel.dispose);

    channel.state!.updateMessage(Message(id: 'pinned-second', text: 'pinned-second', createdAt: _createdAt(3)));

    expect(channel.state!.pinnedMessages.map((m) => m.id), ['pinned-third', 'pinned-first']);
  });

  test('updating an unpinned message leaves the pinned messages in pin time order', () {
    final channel = _channel(
      pinnedMessages: [
        _pin('pinned-second', createdAtSecond: 3, pinnedAtSecond: 4),
        _pin('pinned-first', createdAtSecond: 1, pinnedAtSecond: 0),
      ],
    );
    addTearDown(channel.dispose);

    channel.state!.updateMessage(Message(id: 'unpinned', text: 'unpinned', createdAt: _createdAt(59)));

    expect(channel.state!.pinnedMessages.map((m) => m.id), ['pinned-second', 'pinned-first']);
  });
}

Channel _channel({List<Message>? pinnedMessages}) {
  final client = MockStreamChatClient();
  when(() => client.detachedLogger(any())).thenAnswer((_) => Logger.detached('test'));
  when(() => client.logger).thenReturn(Logger.detached('test'));
  when(() => client.retryPolicy).thenReturn(
    RetryPolicy(shouldRetry: (_, __, ___) => false, delayFactor: Duration.zero),
  );
  when(() => client.state).thenReturn(FakeClientState());
  when(() => client.channelDeliveryReporter.submitForDelivery(any())).thenAnswer((_) async {});

  return Channel.fromState(
    client,
    ChannelState(
      channel: ChannelModel(id: 'test-channel-id', type: 'messaging'),
      pinnedMessages: pinnedMessages,
    ),
  );
}

Message _pin(String id, {required int createdAtSecond, required int pinnedAtSecond}) {
  return Message(
    id: id,
    text: id,
    createdAt: _createdAt(createdAtSecond),
    pinned: true,
    pinnedAt: DateTime.utc(2026, 7, 27, 8, 17, pinnedAtSecond),
  );
}

DateTime _createdAt(int second) => DateTime.utc(2026, 7, 16, 8, 30, second);
