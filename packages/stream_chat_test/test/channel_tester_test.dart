import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

void main() {
  group('seeding', () {
    channelTest(
      'watch seeds the channel with the canonical state',
      setUp: (tester) => tester.watch(),
      body: (tester) async {
        expect(tester.channel.cid, 'messaging:test-channel');
        expect(tester.channelState, isNotNull);
        expect(tester.channelState?.messages, hasLength(3));
        expect(tester.channelState?.members, isEmpty);
      },
      verify: (tester) => tester.verifyApi(
        (api) => api.channel.queryChannel(
          'messaging',
          channelId: 'test-channel',
          channelData: const {},
          state: true,
          watch: true,
          presence: false,
        ),
      ),
    );

    channelTest(
      'watch applies the modifyResponse transformer',
      setUp: (tester) => tester.watch(
        modifyResponse: (state) => state.copyWith(
          messages: [createDefaultMessage(id: 'only-message')],
        ),
      ),
      body: (tester) async {
        final messageIds = tester.channelState?.messages.map((message) => message.id);
        expect(messageIds, ['only-message']);
      },
    );
  });

  group('events', () {
    channelTest(
      'adds a new message on message.new event',
      setUp: (tester) => tester.watch(),
      body: (tester) async {
        final message = createDefaultMessage(id: 'new-message', text: 'A new message');

        await tester.emitEvent(
          createDefaultEvent(
            type: EventType.messageNew,
            cid: tester.channel.cid,
            message: message,
          ),
        );

        final messageIds = tester.channelState?.messages.map((message) => message.id);
        expect(messageIds, contains('new-message'));
      },
    );
  });
}
