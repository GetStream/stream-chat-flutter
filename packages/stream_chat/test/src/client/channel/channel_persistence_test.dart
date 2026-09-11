import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

// Builds the channel already initialized from state, so the state attaches
// while a persistence client is set.
Channel _buildInitializedChannel(StreamChatClient client) {
  return Channel.fromState(
    client,
    createDefaultChannelState(
      channel: createDefaultChannelModel(cid: _channelCid),
    ),
  );
}

// Stubs the persistence calls these tests drive (`getChannelThreads`,
// `getChannelStateByCid`, `updateMessages`) plus the ones the real client
// makes on its own: `updateConnectionInfo` on connect and the debounced
// channel state/thread writes.
MockPersistenceClient _createPersistenceClient() {
  registerFallbackValue(createDefaultEvent());
  registerFallbackValue(createDefaultChannelState());
  registerFallbackValue(<Message>[]);
  registerFallbackValue(<String, List<Message>>{});

  final persistenceClient = MockPersistenceClient();
  when(() => persistenceClient.updateConnectionInfo(any())).thenAnswer((_) async {});
  when(() => persistenceClient.getChannelThreads(_channelCid)).thenAnswer((_) async => {});
  when(() => persistenceClient.getChannelStateByCid(_channelCid)).thenAnswer(
    (_) async => createDefaultChannelState(
      channel: createDefaultChannelModel(cid: _channelCid),
    ),
  );
  when(() => persistenceClient.updateMessages(_channelCid, any())).thenAnswer((_) => Future.value());
  when(() => persistenceClient.updateChannelState(any())).thenAnswer((_) async {});
  when(() => persistenceClient.updateChannelThreads(_channelCid, any())).thenAnswer((_) async {});
  return persistenceClient;
}

void main() {
  group('Initialized Channel with Persistence', () {
    final persistenceClient = _createPersistenceClient();
    channelTest(
      'initializes from state and loads channel threads from the persistence client',
      channelType: _channelType,
      channelId: _channelId,
      build: _buildInitializedChannel,
      chatPersistenceClient: persistenceClient,
      body: (tester) async {
        expect(tester.channel.cid, _channelCid);
        expect(tester.channelState, isNotNull);
        await expectLater(tester.channel.initialized, completion(isTrue));

        // Attaching the state loads the channel's threads from the offline
        // storage; the stubbed storage has none, so the state stays empty.
        verify(() => persistenceClient.getChannelThreads(_channelCid)).called(1);
        expect(tester.channelState!.threads, isEmpty);
        expect(tester.channelState!.messages, isEmpty);
      },
    );
  });
}
