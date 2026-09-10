import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

ChannelState Function(ChannelState) _seedChannel() {
  return (_) => createDefaultChannelState(
    channel: createDefaultChannelModel(
      cid: _channelCid,
      config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
      ownCapabilities: const [ChannelCapability.readEvents],
    ),
  );
}

void main() {
  group('`.sendAction`', () {
    channelTest(
      'should work fine',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final message = Message(id: 'test-message-id', text: 'Action Sent');
        const formData = {'key': 'value'};

        tester.mockApi(
          (api) => api.message.sendAction(_channelId, _channelType, message.id, formData),
          result: createDefaultSendActionResponse(),
        );

        final res = await tester.channel.sendAction(message, formData);

        expect(res, isNotNull);

        tester.verifyApi(
          (api) => api.message.sendAction(_channelId, _channelType, message.id, formData),
        );
      },
    );

    channelTest(
      'should emit received message if not null',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final message = Message(id: 'test-message-id', text: 'Action Sent');
        const formData = {'key': 'value'};

        tester.mockApi(
          (api) => api.message.sendAction(_channelId, _channelType, message.id, formData),
          result: createDefaultSendActionResponse(message: message),
        );

        final messagesEmission = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message,
                matchMessageState: true,
              ),
            ],
          ]),
        );

        final res = await tester.channel.sendAction(message, formData);

        expect(res, isNotNull);
        expect(res.message?.id, message.id);

        tester.verifyApi(
          (api) => api.message.sendAction(_channelId, _channelType, message.id, formData),
        );

        await messagesEmission;
      },
    );
  });
}
