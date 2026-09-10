import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

Future<ChannelState> _seedChannel(ChannelTester tester) => tester.watch(
  modifyResponse: (_) => createDefaultChannelState(
    channel: createDefaultChannelModel(
      cid: _channelCid,
      config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
      ownCapabilities: const [ChannelCapability.readEvents],
    ),
  ),
);

void main() {
  group('`.createDraft`', () {
    final draftMessage = DraftMessage(text: 'Draft message text');

    channelTest(
      'should call client.createDraft',
      channelType: _channelType,
      channelId: _channelId,
      setUp: _seedChannel,
      body: (tester) async {
        tester.mockApi(
          (api) => api.message.createDraft(_channelId, _channelType, draftMessage),
          result: createDefaultCreateDraftResponse(
            draft: createDefaultDraft(channelCid: _channelCid, message: draftMessage),
          ),
        );

        final res = await tester.channel.createDraft(draftMessage);

        expect(res, isNotNull);
        expect(res.draft.message, draftMessage);

        tester.verifyApi(
          (api) => api.message.createDraft(_channelId, _channelType, draftMessage),
        );
      },
    );
  });

  group('`.getDraft`', () {
    final draftMessage = DraftMessage(text: 'Draft message text');

    channelTest(
      'should call client.getDraft',
      channelType: _channelType,
      channelId: _channelId,
      setUp: _seedChannel,
      body: (tester) async {
        tester.mockApi(
          (api) => api.message.getDraft(_channelId, _channelType),
          result: createDefaultGetDraftResponse(
            draft: createDefaultDraft(channelCid: _channelCid, message: draftMessage),
          ),
        );

        final res = await tester.channel.getDraft();

        expect(res, isNotNull);
        expect(res.draft.message, draftMessage);

        tester.verifyApi(
          (api) => api.message.getDraft(_channelId, _channelType),
        );
      },
    );

    channelTest(
      'with parentId should pass parentId to client',
      channelType: _channelType,
      channelId: _channelId,
      setUp: _seedChannel,
      body: (tester) async {
        const parentId = 'parent-123';
        tester.mockApi(
          (api) => api.message.getDraft(_channelId, _channelType, parentId: parentId),
          result: createDefaultGetDraftResponse(
            draft: createDefaultDraft(channelCid: _channelCid, message: draftMessage),
          ),
        );

        final res = await tester.channel.getDraft(parentId: parentId);

        expect(res, isNotNull);
        expect(res.draft.message, draftMessage);

        tester.verifyApi(
          (api) => api.message.getDraft(_channelId, _channelType, parentId: parentId),
        );
      },
    );
  });

  group('`.deleteDraft`', () {
    channelTest(
      'should call client.deleteDraft',
      channelType: _channelType,
      channelId: _channelId,
      setUp: _seedChannel,
      body: (tester) async {
        tester.mockApi(
          (api) => api.message.deleteDraft(_channelId, _channelType),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.channel.deleteDraft();

        expect(res, isNotNull);

        tester.verifyApi(
          (api) => api.message.deleteDraft(_channelId, _channelType),
        );
      },
    );

    channelTest(
      'with parentId should pass parentId to client',
      channelType: _channelType,
      channelId: _channelId,
      setUp: _seedChannel,
      body: (tester) async {
        const parentId = 'parent-123';
        tester.mockApi(
          (api) => api.message.deleteDraft(_channelId, _channelType, parentId: parentId),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.channel.deleteDraft(parentId: parentId);

        expect(res, isNotNull);

        tester.verifyApi(
          (api) => api.message.deleteDraft(_channelId, _channelType, parentId: parentId),
        );
      },
    );
  });
}
