import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/stream_chat_persistence.dart';

import 'stream_chat_persistence_client_test.dart' show testDatabaseProvider;

void main() {
  late StreamChatPersistenceClient client;
  final truncatedAt = DateTime.utc(2026, 10, 29, 12);
  final channel = ChannelModel(type: 'messaging', id: 'truncated');

  setUp(() async {
    client = StreamChatPersistenceClient();
    await client.connect('test-user', databaseProvider: testDatabaseProvider);
  });

  tearDown(() => client.disconnect());

  test('truncateChannel removes only the stored messages sent before the cutoff', () async {
    final pending = Message(
      id: 'pending',
      text: 'pending',
      user: User(id: 'test-user'),
      state: MessageState.sending,
    );
    await client.updateChannelStates([
      ChannelState(
        channel: channel,
        messages: [
          _message('before', createdAt: truncatedAt.subtract(const Duration(minutes: 1))),
          _message('after', createdAt: truncatedAt.add(const Duration(minutes: 1))),
          pending,
        ],
      ),
    ]);

    await client.truncateChannel(channel.cid, truncatedAt: truncatedAt);

    final messages = await client.getMessagesByCid(channel.cid);
    expect(messages.map((it) => it.id), ['after', 'pending']);
  });

  test('truncateChannel without a truncatedAt removes the stored messages sent before now', () async {
    final now = DateTime.now().toUtc();
    await client.updateChannelStates([
      ChannelState(
        channel: channel,
        messages: [
          _message('earlier', createdAt: now.subtract(const Duration(hours: 1))),
          _message('later', createdAt: now.add(const Duration(hours: 1))),
        ],
      ),
    ]);

    await client.truncateChannel(channel.cid);

    final messages = await client.getMessagesByCid(channel.cid);
    expect(messages.map((it) => it.id), ['later']);
  });

  test('truncateChannel keeps the stored messages of other channels', () async {
    final other = ChannelModel(type: 'messaging', id: 'other');
    final before = _message('before', createdAt: truncatedAt.subtract(const Duration(minutes: 1)));
    await client.updateChannelStates([
      ChannelState(channel: other, messages: [before]),
    ]);

    await client.truncateChannel(channel.cid, truncatedAt: truncatedAt);

    final messages = await client.getMessagesByCid(other.cid);
    expect(messages.map((it) => it.id), ['before']);
  });

  test('truncateChannel removes the stored pinned messages sent before the cutoff', () async {
    final pinnedAt = truncatedAt.add(const Duration(minutes: 5));
    await client.updateChannelStates([
      ChannelState(
        channel: channel,
        pinnedMessages: [
          _message('before', createdAt: truncatedAt.subtract(const Duration(minutes: 1))),
          _message('after', createdAt: truncatedAt.add(const Duration(minutes: 1))),
        ].map((it) => it.copyWith(pinned: true, pinnedAt: pinnedAt)).toList(),
      ),
    ]);

    await client.truncateChannel(channel.cid, truncatedAt: truncatedAt);

    final pinned = await client.getPinnedMessagesByCid(channel.cid);
    expect(pinned.map((it) => it.id), ['after']);
  });
}

Message _message(String id, {required DateTime createdAt}) {
  return Message(
    id: id,
    text: id,
    user: User(id: 'other-user'),
    createdAt: createdAt,
  );
}
