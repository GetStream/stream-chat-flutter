import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/stream_chat_persistence.dart';

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
    final before = _message('before', createdAt: truncatedAt.subtract(const Duration(minutes: 1)));
    final after = _message('after', createdAt: truncatedAt.add(const Duration(minutes: 1)));
    await client.updateChannelStates([
      ChannelState(channel: channel, messages: [before, after]),
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
          _message('before', createdAt: truncatedAt.subtract(const Duration(minutes: 1))),
          _message('after', createdAt: truncatedAt.add(const Duration(minutes: 1))),
        ].map((it) => it.copyWith(pinned: true, pinnedAt: pinnedAt)).toList(),
      ),
    ]);

    await client.updateChannelStates([
      ChannelState(channel: channel.copyWith(truncatedAt: truncatedAt)),
    ]);

    final pinned = await client.getPinnedMessagesByCid(channel.cid);
    expect(pinned.map((it) => it.id), ['after']);
  });

  test('updateChannelStates keeps the truncation system message', () async {
    final system = _message('system', createdAt: truncatedAt.add(const Duration(microseconds: 1)));
    await client.updateChannelStates([
      ChannelState(
        channel: channel.copyWith(truncatedAt: truncatedAt),
        messages: [system],
      ),
    ]);

    final messages = await client.getMessagesByCid(channel.cid);
    expect(messages.map((it) => it.id), ['system']);
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
