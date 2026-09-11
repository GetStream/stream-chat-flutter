import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

void main() {
  // A client test: connects a real StreamChatClient through the mocked
  // WebSocket transport, stubs a REST call, and verifies the request.
  chatClientTest(
    'stubs and verifies API calls with exact arguments',
    body: (tester) async {
      final message = createDefaultMessage(id: 'message-id');
      tester.mockApi(
        (api) => api.message.getMessage('message-id'),
        result: createDefaultGetMessageResponse(message: message),
      );

      final response = await tester.client.getMessage('message-id');

      expect(response.message.id, 'message-id');
      tester.verifyApi((api) => api.message.getMessage('message-id'));
    },
  );

  // A channel test: seeds the channel with an initial state, then drives it
  // through the real event pipeline by emitting a server-side event.
  channelTest(
    'adds a new message on message.new event',
    setUp: (tester) => tester.watch(),
    body: (tester) async {
      await tester.emitEvent(
        createDefaultEvent(
          type: EventType.messageNew,
          cid: tester.channel.cid,
          message: createDefaultMessage(id: 'new-message'),
        ),
      );

      final messageIds = tester.channelState?.messages.map((message) => message.id);
      expect(messageIds, contains('new-message'));
    },
  );
}
