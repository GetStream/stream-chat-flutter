import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/stream_chat_persistence.dart';

import 'stream_chat_persistence_client_test.dart' show testDatabaseProvider;

void main() {
  late StreamChatPersistenceClient client;
  final channel = ChannelModel(type: 'messaging', id: 'interrupted');

  setUp(() async {
    client = StreamChatPersistenceClient();
    await client.connect('test-user', databaseProvider: testDatabaseProvider);
  });

  tearDown(() => client.disconnect());

  Future<MessageState> settleStored(MessageState state) async {
    await client.updateChannelStates([
      ChannelState(
        channel: channel,
        messages: [_message(state: state)],
      ),
    ]);

    await client.settleInterruptedRequests();

    final messages = await client.getMessagesByCid(channel.cid);
    return messages.single.state;
  }

  test('marks a stored message left sending as failed to send with its options', () async {
    final state = await settleStored(MessageState.sending(skipPush: true, skipEnrichUrl: true));

    expect(state, MessageState.sendingFailed(skipPush: true, skipEnrichUrl: true));
  });

  test('marks a stored message left updating as failed to update with its options', () async {
    final state = await settleStored(MessageState.updating(skipPush: true, skipEnrichUrl: true));

    expect(state, MessageState.updatingFailed(skipPush: true, skipEnrichUrl: true));
  });

  test('marks a stored message left partially updating as failed with its changes', () async {
    final state = await settleStored(
      MessageState.partialUpdating(set: {'pinned': true}, unset: ['pin_expires'], skipEnrichUrl: true),
    );

    expect(
      state,
      MessageState.partialUpdatingFailed(set: {'pinned': true}, unset: ['pin_expires'], skipEnrichUrl: true),
    );
  });

  test('marks a stored message left deleting as failed to delete for the same scope', () async {
    final state = await settleStored(MessageState.deleting(scope: const .deleteForMe()));

    expect(state, MessageState.deletingFailed(scope: const .deleteForMe()));
  });

  test('keeps a stored message with no request in progress', () async {
    final state = await settleStored(MessageState.sent);

    expect(state, MessageState.sent);
  });

  test('marks a stored thread reply left sending as failed to send', () async {
    final reply = _message(id: 'reply', state: MessageState.sending()).copyWith(parentId: 'parent');
    await client.updateChannelStates([
      ChannelState(
        channel: channel,
        messages: [_message(id: 'parent')],
      ),
    ]);
    await client.updateChannelThreads(channel.cid, {
      'parent': [reply],
    });

    await client.settleInterruptedRequests();

    final threads = await client.getChannelThreads(channel.cid);
    expect(threads['parent']?.single.state, MessageState.sendingFailed(skipPush: false, skipEnrichUrl: false));
  });

  test('marks a stored pinned message left updating as failed to update', () async {
    final pinned = _message(state: MessageState.updating()).copyWith(pinned: true, pinnedAt: DateTime.utc(2026));
    await client.updateChannelStates([
      ChannelState(channel: channel, pinnedMessages: [pinned]),
    ]);

    await client.settleInterruptedRequests();

    final pinnedMessages = await client.getPinnedMessagesByCid(channel.cid);
    expect(pinnedMessages.single.state, MessageState.updatingFailed(skipPush: false, skipEnrichUrl: false));
  });
}

Message _message({String id = 'message', MessageState state = MessageState.sent}) {
  return Message(
    id: id,
    text: id,
    user: User(id: 'test-user'),
    createdAt: DateTime.utc(2026, 11, 3, 12),
    state: state,
  );
}
