import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

final _seededCreatedAt = DateTime.utc(2021, 3);

ChannelState _seedChannel(ChannelState _) => createDefaultChannelState(
  channel: createDefaultChannelModel(cid: _channelCid),
);

// Stubs every persistence call the harness makes on the way to a truncation:
// `updateConnectionInfo` on connect, `getChannelThreads` when the channel
// state initializes, and `deleteMessageByCid` from the truncation handler.
MockPersistenceClient _createPersistenceClient() {
  registerFallbackValue(createDefaultEvent());
  final persistenceClient = MockPersistenceClient();
  when(() => persistenceClient.updateConnectionInfo(any())).thenAnswer((_) async {});
  when(() => persistenceClient.getChannelThreads(_channelCid)).thenAnswer((_) async => {});
  when(() => persistenceClient.deleteMessageByCid(_channelCid)).thenAnswer((_) async {});
  return persistenceClient;
}

Message _seedMessage(ChannelTester tester, String id, {DateTime? createdAt}) {
  final message = Message(
    id: id,
    user: User(id: 'other-user'),
    text: 'to be truncated',
    createdAt: createdAt ?? _seededCreatedAt,
  );
  tester.channelState!.updateMessage(message);
  return message;
}

void main() {
  group('Channel truncated events', () {
    final truncatedPersistence = _createPersistenceClient();
    channelTest(
      '${EventType.channelTruncated} clears messages and wipes persistence',
      channelType: _channelType,
      channelId: _channelId,
      chatPersistenceClient: truncatedPersistence,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        _seedMessage(tester, 'truncated-message-1');
        _seedMessage(tester, 'truncated-message-2', createdAt: _seededCreatedAt.add(const Duration(seconds: 1)));
        expect(tester.channelState!.messages, hasLength(2));

        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.channelTruncated,
            channel: createDefaultChannelModel(cid: _channelCid),
          ),
        );

        expect(tester.channelState!.messages, isEmpty);
        verify(() => truncatedPersistence.deleteMessageByCid(tester.channel.cid!)).called(1);
      },
    );

    final notifiedPersistence = _createPersistenceClient();
    channelTest(
      '${EventType.notificationChannelTruncated} keeps the event system message',
      channelType: _channelType,
      channelId: _channelId,
      chatPersistenceClient: notifiedPersistence,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        _seedMessage(tester, 'truncated-message-1');

        final systemMessage = Message(
          id: 'system-message-id',
          type: MessageType.system,
          text: 'Channel truncated',
          createdAt: _seededCreatedAt.add(const Duration(seconds: 1)),
        );
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.notificationChannelTruncated,
            channel: createDefaultChannelModel(cid: _channelCid),
            message: systemMessage,
          ),
        );

        expect(tester.channelState!.messages.map((m) => m.id), ['system-message-id']);
      },
    );
  });
}
