import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

void main() {
  group('`.sync`', () {
    chatClientTest(
      'should work fine',
      body: (tester) async {
        const cids = ['test-cid-1', 'test-cid-2', 'test-cid-3'];
        final lastSyncAt = DateTime.utc(2021, 3);

        tester.mockApi(
          (api) => api.general.sync(cids, lastSyncAt),
          result: createDefaultSyncResponse(
            events: [
              Event(
                isLocal: false,
                type: EventType.healthCheck,
                connectionId: 'test-connection-id',
                me: OwnUser.fromUser(tester.user),
              ),
              Event(
                isLocal: false,
                type: EventType.messageDeleted,
                message: Message(id: 'test-message-id'),
              ),
            ],
          ),
        );

        await tester.client.sync(cids: cids, lastSyncAt: lastSyncAt);

        tester.verifyApi((api) => api.general.sync(cids, lastSyncAt));
      },
    );

    chatClientTest(
      'should return if `cids` is not available',
      body: (tester) async {
        expect(tester.client.sync, returnsNormally);
        tester.verifyNeverCalled((api) => api.general.sync(any(), any()));
      },
    );

    chatClientTest(
      'should return if `lastSyncAt` is not available',
      body: (tester) async {
        expect(() => tester.client.sync(cids: ['test-cid-1']), returnsNormally);
        tester.verifyNeverCalled((api) => api.general.sync(any(), any()));
      },
    );
  });
}
