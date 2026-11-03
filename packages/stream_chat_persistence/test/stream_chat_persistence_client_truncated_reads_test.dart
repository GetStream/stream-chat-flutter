import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/stream_chat_persistence.dart';

import 'stream_chat_persistence_client_test.dart' show testDatabaseProvider;

void main() {
  late StreamChatPersistenceClient client;
  final truncatedAt = DateTime.utc(2026, 1, 15, 12);
  final channel = ChannelModel(type: 'messaging', id: 'truncated');

  final before = _message('before', createdAt: truncatedAt.subtract(const Duration(minutes: 1)));
  final system = _message('system', createdAt: truncatedAt.add(const Duration(microseconds: 1)));
  final after = _message('after', createdAt: truncatedAt.add(const Duration(minutes: 1)));

  setUp(() async {
    client = StreamChatPersistenceClient();
    await client.connect('test-user', databaseProvider: testDatabaseProvider);
  });

  tearDown(() => client.disconnect());

  test('getMessagesByCid leaves out the messages sent before the channel was truncated', () async {
    final pending = Message(
      id: 'pending',
      text: 'pending',
      user: User(id: 'test-user'),
      localCreatedAt: truncatedAt.add(const Duration(minutes: 2)),
      state: MessageState.sending,
    );
    await client.updateChannelStates([
      ChannelState(
        channel: channel.copyWith(truncatedAt: truncatedAt),
        messages: [before, system, after, pending],
      ),
    ]);

    final messages = await client.getMessagesByCid(channel.cid);

    expect(messages.map((it) => it.id), ['system', 'after', 'pending']);
  });

  test('getMessagesByCid returns every message of a channel that was not truncated', () async {
    final other = ChannelModel(type: 'messaging', id: 'other');
    await client.updateChannelStates([
      ChannelState(channel: channel.copyWith(truncatedAt: truncatedAt)),
      ChannelState(channel: other, messages: [before, after]),
    ]);

    final messages = await client.getMessagesByCid(other.cid);

    expect(messages.map((it) => it.id), ['before', 'after']);
  });

  test('getPinnedMessagesByCid leaves out the messages sent before the channel was truncated', () async {
    final pinnedAt = truncatedAt.add(const Duration(minutes: 5));
    await client.updateChannelStates([
      ChannelState(
        channel: channel.copyWith(truncatedAt: truncatedAt),
        pinnedMessages: [
          before.copyWith(pinned: true, pinnedAt: pinnedAt),
          after.copyWith(pinned: true, pinnedAt: pinnedAt),
        ],
      ),
    ]);

    final pinned = await client.getPinnedMessagesByCid(channel.cid);

    expect(pinned.map((it) => it.id), ['after']);
  });

  test('getReplies leaves out the replies sent before the channel was truncated', () async {
    await client.updateChannelStates([
      ChannelState(
        channel: channel.copyWith(truncatedAt: truncatedAt),
        messages: [after],
      ),
    ]);
    await client.updateMessages(channel.cid, [
      before.copyWith(id: 'old-reply', parentId: after.id),
      after.copyWith(id: 'new-reply', parentId: after.id),
    ]);

    final replies = await client.getReplies(after.id);

    expect(replies.map((it) => it.id), ['new-reply']);
  });

  test('getChannelThreads leaves out the replies sent before the channel was truncated', () async {
    await client.updateChannelStates([
      ChannelState(
        channel: channel.copyWith(truncatedAt: truncatedAt),
        messages: [after],
      ),
    ]);
    await client.updateMessages(channel.cid, [
      before.copyWith(id: 'old-reply', parentId: after.id),
      after.copyWith(id: 'new-reply', parentId: after.id),
    ]);

    final threads = await client.getChannelThreads(channel.cid);

    expect(threads[after.id]?.map((it) => it.id), ['new-reply']);
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
