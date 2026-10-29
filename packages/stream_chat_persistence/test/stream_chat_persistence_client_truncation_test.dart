import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/stream_chat_persistence_client.dart';

import 'stream_chat_persistence_client_test.dart' show testDatabaseProvider;

void main() {
  late StreamChatPersistenceClient client;
  final truncatedAt = DateTime.utc(2026, 10, 29, 12);
  final channel = ChannelModel(type: 'messaging', id: 'truncated');

  setUp(() async {
    client = StreamChatPersistenceClient(logLevel: Level.OFF);
    await client.connect('test-user', databaseProvider: testDatabaseProvider);
  });

  tearDown(() => client.disconnect());

  test('updateChannelStates removes the stored messages sent before the channel was truncated', () async {
    await client.updateChannelStates([
      ChannelState(channel: channel, messages: [_messageAt('before', truncatedAt), _messageAt('after', truncatedAt)]),
    ]);

    await client.updateChannelStates([
      ChannelState(channel: channel.copyWith(truncatedAt: truncatedAt)),
    ]);

    final messages = await client.getMessagesByCid(channel.cid);
    expect(messages.map((it) => it.id), ['after']);
  });

  test('updateChannelStates keeps a stored message that is not sent yet', () async {
    final pending = Message(
      id: 'pending',
      text: 'Hello',
      user: User(id: 'test-user'),
      state: MessageState.sending,
    );
    await client.updateChannelStates([
      ChannelState(channel: channel, messages: [pending]),
    ]);

    await client.updateChannelStates([
      ChannelState(channel: channel.copyWith(truncatedAt: truncatedAt)),
    ]);

    final messages = await client.getMessagesByCid(channel.cid);
    expect(messages.map((it) => it.id), ['pending']);
  });

  test('updateChannelStates removes the stored pinned messages sent before the channel was truncated', () async {
    final pinnedAt = truncatedAt.add(const Duration(minutes: 5));
    await client.updateChannelStates([
      ChannelState(
        channel: channel,
        pinnedMessages: [
          _messageAt('before', truncatedAt).copyWith(pinned: true, pinnedAt: pinnedAt),
          _messageAt('after', truncatedAt).copyWith(pinned: true, pinnedAt: pinnedAt),
        ],
      ),
    ]);

    await client.updateChannelStates([
      ChannelState(channel: channel.copyWith(truncatedAt: truncatedAt)),
    ]);

    final pinned = await client.getPinnedMessagesByCid(channel.cid);
    expect(pinned.map((it) => it.id), ['after']);
  });
}

// A message sent a minute before or after [truncatedAt], as its [id] says.
Message _messageAt(String id, DateTime truncatedAt) {
  final offset = const Duration(minutes: 1) * (id == 'before' ? -1 : 1);
  return Message(
    id: id,
    text: id,
    user: User(id: 'other-user'),
    createdAt: truncatedAt.add(offset),
  );
}
