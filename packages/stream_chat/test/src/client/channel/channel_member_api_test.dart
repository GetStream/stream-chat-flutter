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
  channelTest(
    '`.acceptInvite`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: _seedChannel,
    body: (tester) async {
      final message = Message(id: 'test-message-id', text: 'Invite Accepted');

      final channelModel = createDefaultChannelModel(cid: _channelCid);

      tester.mockApi(
        (api) => api.channel.acceptChannelInvite(_channelId, _channelType, message: message),
        result: AcceptInviteResponse()
          ..channel = channelModel
          ..message = message,
      );

      final res = await tester.channel.acceptInvite(message);

      expect(res, isNotNull);
      expect(res.channel.cid, channelModel.cid);
      expect(res.message?.id, message.id);

      tester.verifyApi(
        (api) => api.channel.acceptChannelInvite(_channelId, _channelType, message: message),
      );
    },
  );

  channelTest(
    '`.rejectInvite`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: _seedChannel,
    body: (tester) async {
      final message = Message(id: 'test-message-id', text: 'Invite Rejected');

      final channelModel = createDefaultChannelModel(cid: _channelCid);

      tester.mockApi(
        (api) => api.channel.rejectChannelInvite(_channelId, _channelType, message: message),
        result: RejectInviteResponse()
          ..channel = channelModel
          ..message = message,
      );

      final res = await tester.channel.rejectInvite(message);

      expect(res, isNotNull);
      expect(res.channel.cid, channelModel.cid);
      expect(res.message?.id, message.id);

      tester.verifyApi(
        (api) => api.channel.rejectChannelInvite(_channelId, _channelType, message: message),
      );
    },
  );

  channelTest(
    '`.addMembers`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: _seedChannel,
    body: (tester) async {
      final members = List.generate(
        3,
        (index) => Member(userId: 'test-member-id-$index'),
      );
      final memberIds = members.map((it) => it.userId).whereType<String>().toList(growable: false);
      final message = Message(id: 'test-message-id', text: 'Members Added');

      final channelModel = createDefaultChannelModel(cid: _channelCid);

      tester.mockApi(
        (api) => api.channel.addMembers(_channelId, _channelType, memberIds, message: message),
        result: createDefaultAddMembersResponse(
          channel: channelModel,
          members: members,
          message: message,
        ),
      );

      final res = await tester.channel.addMembers(memberIds, message: message);

      expect(res, isNotNull);
      expect(res.channel.cid, channelModel.cid);
      expect(res.members.length, members.length);
      expect(res.message?.id, message.id);

      tester.verifyApi(
        (api) => api.channel.addMembers(_channelId, _channelType, memberIds, message: message),
      );
    },
  );

  channelTest(
    '`.addMembers` with hideHistoryBefore',
    channelType: _channelType,
    channelId: _channelId,
    setUp: _seedChannel,
    body: (tester) async {
      final members = List.generate(
        3,
        (index) => Member(userId: 'test-member-id-$index'),
      );
      final memberIds = members.map((it) => it.userId).whereType<String>().toList(growable: false);
      final message = Message(id: 'test-message-id', text: 'Members Added');
      final hideHistoryBefore = DateTime.parse('2024-01-01T00:00:00Z');

      final channelModel = createDefaultChannelModel(cid: _channelCid);

      tester.mockApi(
        (api) => api.channel.addMembers(
          _channelId,
          _channelType,
          memberIds,
          message: message,
          hideHistoryBefore: hideHistoryBefore,
        ),
        result: createDefaultAddMembersResponse(
          channel: channelModel,
          members: members,
          message: message,
        ),
      );

      final res = await tester.channel.addMembers(
        memberIds,
        message: message,
        hideHistoryBefore: hideHistoryBefore,
      );

      expect(res, isNotNull);
      expect(res.channel.cid, channelModel.cid);
      expect(res.members.length, members.length);
      expect(res.message?.id, message.id);

      tester.verifyApi(
        (api) => api.channel.addMembers(
          _channelId,
          _channelType,
          memberIds,
          message: message,
          hideHistoryBefore: hideHistoryBefore,
        ),
      );
    },
  );

  channelTest(
    '`.inviteMembers`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: _seedChannel,
    body: (tester) async {
      final members = List.generate(
        3,
        (index) => Member(userId: 'test-member-id-$index'),
      );
      final memberIds = members.map((it) => it.userId).whereType<String>().toList(growable: false);
      final message = Message(id: 'test-message-id', text: 'Members Invited');

      final channelModel = createDefaultChannelModel(cid: _channelCid);

      tester.mockApi(
        (api) => api.channel.inviteChannelMembers(_channelId, _channelType, memberIds, message: message),
        result: InviteMembersResponse()
          ..channel = channelModel
          ..members = members
          ..message = message,
      );

      final res = await tester.channel.inviteMembers(memberIds, message: message);

      expect(res, isNotNull);
      expect(res.channel.cid, channelModel.cid);
      expect(res.members.length, members.length);
      expect(res.message?.id, message.id);

      tester.verifyApi(
        (api) => api.channel.inviteChannelMembers(_channelId, _channelType, memberIds, message: message),
      );
    },
  );

  channelTest(
    '`.removeMembers`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: _seedChannel,
    body: (tester) async {
      final members = List.generate(
        3,
        (index) => Member(userId: 'test-member-id-$index'),
      );
      final memberIds = members.map((it) => it.userId).whereType<String>().toList(growable: false);
      final message = Message(id: 'test-message-id', text: 'Members Removed');

      final channelModel = createDefaultChannelModel(cid: _channelCid);

      tester.mockApi(
        (api) => api.channel.removeMembers(_channelId, _channelType, memberIds, message: message),
        result: RemoveMembersResponse()
          ..channel = channelModel
          ..members = members
          ..message = message,
      );

      final res = await tester.channel.removeMembers(memberIds, message: message);

      expect(res, isNotNull);
      expect(res.channel.cid, channelModel.cid);
      expect(res.members.length, members.length);
      expect(res.message?.id, message.id);

      tester.verifyApi(
        (api) => api.channel.removeMembers(_channelId, _channelType, memberIds, message: message),
      );
    },
  );
}
