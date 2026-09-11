import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';
const _channelData = {'name': 'test-channel-name'};

void main() {
  group('`.channel`', () {
    chatClientTest(
      'should return back a new channel instance',
      body: (tester) {
        final channel = tester.client.channel(
          _channelType,
          id: _channelId,
          extraData: _channelData,
        );

        expect(channel, isNotNull);
        expect(channel.type, _channelType);
        expect(channel.id, _channelId);
        expect(channel.cid, _channelCid);
        expect(channel.extraData, _channelData);
      },
    );

    chatClientTest(
      'should return back in memory channel instance if available',
      body: (tester) async {
        final channel = tester.client.channel(
          _channelType,
          id: _channelId,
          extraData: _channelData,
        );

        final channelState = createDefaultChannelState(
          channel: createDefaultChannelModel(cid: _channelCid),
        );

        tester.mockApi(
          (api) => api.channel.queryChannel(
            _channelType,
            channelId: _channelId,
            channelData: _channelData,
            state: true,
            watch: true,
            presence: false,
          ),
          result: channelState,
        );

        final channelsEmission = expectLater(
          tester.clientState.channelsStream.skip(1),
          emitsInOrder([
            {_channelCid: isCorrectChannelFor(channelState)},
          ]),
        );

        await channel.watch();
        await channelsEmission;

        final newChannel = tester.client.channel(_channelType, id: _channelId);
        expect(newChannel, channel);

        tester.verifyApi(
          (api) => api.channel.queryChannel(
            _channelType,
            channelId: _channelId,
            channelData: _channelData,
            state: true,
            watch: true,
            presence: false,
          ),
        );
      },
    );
  });

  chatClientTest(
    '`.createChannel`',
    body: (tester) async {
      final channelState = createDefaultChannelState(
        channel: createDefaultChannelModel(cid: _channelCid, extraData: _channelData),
      );

      tester.mockApi(
        (api) => api.channel.queryChannel(
          _channelType,
          channelId: _channelId,
          channelData: _channelData,
          state: false,
        ),
        result: channelState,
      );

      final res = await tester.client.createChannel(
        _channelType,
        channelId: _channelId,
        channelData: _channelData,
      );

      expect(res, isNotNull);
      expect(res.channel, isNotNull);
      final channel = res.channel!;
      expect(channel.type, _channelType);
      expect(channel.id, _channelId);
      expect(channel.cid, _channelCid);
      expect(channel.extraData, _channelData);

      tester
        ..verifyApi(
          (api) => api.channel.queryChannel(
            _channelType,
            channelId: _channelId,
            channelData: _channelData,
            state: false,
          ),
        )
        ..verifyNoMoreApiInteractions((api) => api.channel);
    },
  );

  chatClientTest(
    '`.watchChannel`',
    body: (tester) async {
      final channelState = createDefaultChannelState(
        channel: createDefaultChannelModel(cid: _channelCid, extraData: _channelData),
      );

      tester.mockApi(
        (api) => api.channel.queryChannel(
          _channelType,
          channelId: _channelId,
          channelData: _channelData,
          watch: true,
        ),
        result: channelState,
      );

      final res = await tester.client.watchChannel(
        _channelType,
        channelId: _channelId,
        channelData: _channelData,
      );

      expect(res, isNotNull);
      expect(res.channel, isNotNull);
      final channel = res.channel!;
      expect(channel.type, _channelType);
      expect(channel.id, _channelId);
      expect(channel.cid, _channelCid);
      expect(channel.extraData, _channelData);

      tester
        ..verifyApi(
          (api) => api.channel.queryChannel(
            _channelType,
            channelId: _channelId,
            channelData: _channelData,
            watch: true,
          ),
        )
        ..verifyNoMoreApiInteractions((api) => api.channel);
    },
  );

  chatClientTest(
    '`.queryChannel`',
    body: (tester) async {
      final channelState = createDefaultChannelState(
        channel: createDefaultChannelModel(cid: _channelCid, extraData: _channelData),
      );

      tester.mockApi(
        (api) => api.channel.queryChannel(
          _channelType,
          channelId: _channelId,
          channelData: _channelData,
        ),
        result: channelState,
      );

      final res = await tester.client.queryChannel(
        _channelType,
        channelId: _channelId,
        channelData: _channelData,
      );

      expect(res, isNotNull);
      expect(res.channel, isNotNull);
      final channel = res.channel!;
      expect(channel.type, _channelType);
      expect(channel.id, _channelId);
      expect(channel.cid, _channelCid);
      expect(channel.extraData, _channelData);

      tester
        ..verifyApi(
          (api) => api.channel.queryChannel(
            _channelType,
            channelId: _channelId,
            channelData: _channelData,
          ),
        )
        ..verifyNoMoreApiInteractions((api) => api.channel);
    },
  );

  chatClientTest(
    '`.queryMembers`',
    body: (tester) async {
      final members = List.generate(
        3,
        (index) => Member(userId: 'test-user-id-$index'),
      );

      tester.mockApi(
        (api) => api.general.queryMembers(_channelType),
        result: QueryMembersResponse()..members = members,
      );

      final res = await tester.client.queryMembers(_channelType);
      expect(res, isNotNull);
      expect(res.members.length, members.length);

      tester
        ..verifyApi((api) => api.general.queryMembers(_channelType))
        ..verifyApi((api) => api.general.getAppSettings())
        ..verifyNoMoreApiInteractions((api) => api.general);
    },
  );

  chatClientTest(
    '`.hideChannel`',
    body: (tester) async {
      tester.mockApi(
        (api) => api.channel.hideChannel(_channelId, _channelType),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.hideChannel(_channelId, _channelType);

      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.channel.hideChannel(_channelId, _channelType))
        ..verifyNoMoreApiInteractions((api) => api.channel);
    },
  );

  chatClientTest(
    '`.showChannel`',
    body: (tester) async {
      tester.mockApi(
        (api) => api.channel.showChannel(_channelId, _channelType),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.showChannel(_channelId, _channelType);

      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.channel.showChannel(_channelId, _channelType))
        ..verifyNoMoreApiInteractions((api) => api.channel);
    },
  );

  chatClientTest(
    '`.deleteChannel`',
    body: (tester) async {
      tester.mockApi(
        (api) => api.channel.deleteChannel(_channelId, _channelType),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.deleteChannel(_channelId, _channelType);

      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.channel.deleteChannel(_channelId, _channelType))
        ..verifyNoMoreApiInteractions((api) => api.channel);
    },
  );

  chatClientTest(
    '`.truncateChannel`',
    body: (tester) async {
      tester.mockApi(
        (api) => api.channel.truncateChannel(_channelId, _channelType),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.truncateChannel(_channelId, _channelType);

      expect(res, isNotNull);

      tester
        ..verifyApi(
          (api) => api.channel.truncateChannel(_channelId, _channelType),
        )
        ..verifyNoMoreApiInteractions((api) => api.channel);
    },
  );

  chatClientTest(
    '`.muteChannel`',
    body: (tester) async {
      tester.mockApi(
        (api) => api.moderation.muteChannel(_channelCid),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.muteChannel(_channelCid);

      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.moderation.muteChannel(_channelCid))
        ..verifyNoMoreApiInteractions((api) => api.moderation);
    },
  );

  chatClientTest(
    '`.unmuteChannel`',
    body: (tester) async {
      tester.mockApi(
        (api) => api.moderation.unmuteChannel(_channelCid),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.unmuteChannel(_channelCid);

      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.moderation.unmuteChannel(_channelCid))
        ..verifyNoMoreApiInteractions((api) => api.moderation);
    },
  );

  chatClientTest(
    '`.partialMemberUpdate with userId`',
    body: (tester) async {
      const otherUserId = 'test-other-user-id';
      const set = {'pinned': true};
      const unset = ['pinned'];

      tester.mockApi(
        (api) => api.channel.updateMemberPartial(
          channelId: _channelId,
          channelType: _channelType,
          set: set,
          unset: unset,
        ),
        result: createDefaultPartialUpdateMemberResponse(
          channelMember: Member(userId: otherUserId),
        ),
      );

      final res = await tester.client.partialMemberUpdate(
        channelId: _channelId,
        channelType: _channelType,
        set: set,
        unset: unset,
      );

      expect(res, isNotNull);
      expect(res.channelMember.userId, otherUserId);

      tester
        ..verifyApi(
          (api) => api.channel.updateMemberPartial(
            channelId: _channelId,
            channelType: _channelType,
            set: set,
            unset: unset,
          ),
        )
        ..verifyNoMoreApiInteractions((api) => api.channel);
    },
  );

  chatClientTest(
    '`.partialMemberUpdate with current user`',
    body: (tester) async {
      const set = {'pinned': true};
      const unset = ['pinned'];

      tester.mockApi(
        (api) => api.channel.updateMemberPartial(
          channelId: _channelId,
          channelType: _channelType,
          set: set,
          unset: unset,
        ),
        result: createDefaultPartialUpdateMemberResponse(
          channelMember: Member(userId: tester.user.id),
        ),
      );

      final res = await tester.client.partialMemberUpdate(
        channelId: _channelId,
        channelType: _channelType,
        set: set,
        unset: unset,
      );

      expect(res, isNotNull);
      expect(res.channelMember.userId, tester.user.id);
      tester
        ..verifyApi(
          (api) => api.channel.updateMemberPartial(
            channelId: _channelId,
            channelType: _channelType,
            set: set,
            unset: unset,
          ),
        )
        ..verifyNoMoreApiInteractions((api) => api.channel);
    },
  );

  chatClientTest(
    '`.pinChannel`',
    body: (tester) async {
      tester.mockApi(
        (api) => api.channel.updateMemberPartial(
          channelId: _channelId,
          channelType: _channelType,
          set: const MemberUpdatePayload(pinned: true).toJson(),
        ),
        result: createDefaultPartialUpdateMemberResponse(
          channelMember: Member(userId: tester.user.id, pinnedAt: DateTime.utc(2021, 3)),
        ),
      );

      final res = await tester.client.pinChannel(
        channelId: _channelId,
        channelType: _channelType,
      );

      expect(res, isNotNull);

      tester
        ..verifyApi(
          (api) => api.channel.updateMemberPartial(
            channelId: _channelId,
            channelType: _channelType,
            set: const MemberUpdatePayload(pinned: true).toJson(),
          ),
        )
        ..verifyNoMoreApiInteractions((api) => api.channel);
    },
  );

  chatClientTest(
    '`.unpinChannel`',
    body: (tester) async {
      tester.mockApi(
        (api) => api.channel.updateMemberPartial(
          channelId: _channelId,
          channelType: _channelType,
          unset: [MemberUpdateType.pinned.name],
        ),
        result: createDefaultPartialUpdateMemberResponse(
          channelMember: Member(userId: tester.user.id, pinnedAt: DateTime.utc(2021, 3)),
        ),
      );

      final res = await tester.client.unpinChannel(
        channelId: _channelId,
        channelType: _channelType,
      );

      expect(res, isNotNull);

      tester
        ..verifyApi(
          (api) => api.channel.updateMemberPartial(
            channelId: _channelId,
            channelType: _channelType,
            unset: [MemberUpdateType.pinned.name],
          ),
        )
        ..verifyNoMoreApiInteractions((api) => api.channel);
    },
  );

  chatClientTest(
    '`.archiveChannel`',
    body: (tester) async {
      tester.mockApi(
        (api) => api.channel.updateMemberPartial(
          channelId: _channelId,
          channelType: _channelType,
          set: const MemberUpdatePayload(archived: true).toJson(),
        ),
        result: createDefaultPartialUpdateMemberResponse(
          channelMember: Member(userId: tester.user.id, archivedAt: DateTime.utc(2021, 3)),
        ),
      );

      final res = await tester.client.archiveChannel(
        channelId: _channelId,
        channelType: _channelType,
      );

      expect(res, isNotNull);

      tester
        ..verifyApi(
          (api) => api.channel.updateMemberPartial(
            channelId: _channelId,
            channelType: _channelType,
            set: const MemberUpdatePayload(archived: true).toJson(),
          ),
        )
        ..verifyNoMoreApiInteractions((api) => api.channel);
    },
  );

  chatClientTest(
    '`.unarchiveChannel`',
    body: (tester) async {
      tester.mockApi(
        (api) => api.channel.updateMemberPartial(
          channelId: _channelId,
          channelType: _channelType,
          unset: [MemberUpdateType.archived.name],
        ),
        result: createDefaultPartialUpdateMemberResponse(
          channelMember: Member(userId: tester.user.id, pinnedAt: DateTime.utc(2021, 3)),
        ),
      );

      final res = await tester.client.unarchiveChannel(
        channelId: _channelId,
        channelType: _channelType,
      );

      expect(res, isNotNull);

      tester
        ..verifyApi(
          (api) => api.channel.updateMemberPartial(
            channelId: _channelId,
            channelType: _channelType,
            unset: [MemberUpdateType.archived.name],
          ),
        )
        ..verifyNoMoreApiInteractions((api) => api.channel);
    },
  );

  chatClientTest(
    '`.acceptChannelInvite`',
    body: (tester) async {
      tester.mockApi(
        (api) => api.channel.acceptChannelInvite(_channelId, _channelType),
        result: AcceptInviteResponse()..channel = createDefaultChannelModel(cid: _channelCid),
      );

      final res = await tester.client.acceptChannelInvite(_channelId, _channelType);
      expect(res, isNotNull);
      expect(res.channel.cid, _channelCid);

      tester
        ..verifyApi((api) => api.channel.acceptChannelInvite(_channelId, _channelType))
        ..verifyNoMoreApiInteractions((api) => api.channel);
    },
  );

  chatClientTest(
    '`.rejectChannelInvite`',
    body: (tester) async {
      tester.mockApi(
        (api) => api.channel.rejectChannelInvite(_channelId, _channelType),
        result: RejectInviteResponse()..channel = createDefaultChannelModel(cid: _channelCid),
      );

      final res = await tester.client.rejectChannelInvite(_channelId, _channelType);
      expect(res, isNotNull);
      expect(res.channel.cid, _channelCid);

      tester
        ..verifyApi((api) => api.channel.rejectChannelInvite(_channelId, _channelType))
        ..verifyNoMoreApiInteractions((api) => api.channel);
    },
  );

  chatClientTest(
    '`.addChannelMembers`',
    body: (tester) async {
      final members = List.generate(
        3,
        (index) => Member(userId: 'test-user-id-$index'),
      );

      final memberIds = members.map((e) => e.userId!).toList(growable: false);

      tester.mockApi(
        (api) => api.channel.addMembers(_channelId, _channelType, memberIds),
        result: createDefaultAddMembersResponse(
          channel: createDefaultChannelModel(cid: _channelCid),
          members: members,
        ),
      );

      final res = await tester.client.addChannelMembers(
        _channelId,
        _channelType,
        memberIds,
      );

      expect(res, isNotNull);
      expect(res.channel.cid, _channelCid);
      expect(res.members.length, memberIds.length);

      tester
        ..verifyApi(
          (api) => api.channel.addMembers(_channelId, _channelType, memberIds),
        )
        ..verifyNoMoreApiInteractions((api) => api.channel);
    },
  );

  chatClientTest(
    '`.addChannelMembers` with hideHistoryBefore',
    body: (tester) async {
      final members = List.generate(
        3,
        (index) => Member(userId: 'test-user-id-$index'),
      );

      final memberIds = members.map((e) => e.userId!).toList(growable: false);
      final hideHistoryBefore = DateTime.parse('2024-01-01T00:00:00Z');

      tester.mockApi(
        (api) => api.channel.addMembers(
          _channelId,
          _channelType,
          memberIds,
          hideHistoryBefore: hideHistoryBefore,
        ),
        result: createDefaultAddMembersResponse(
          channel: createDefaultChannelModel(cid: _channelCid),
          members: members,
        ),
      );

      final res = await tester.client.addChannelMembers(
        _channelId,
        _channelType,
        memberIds,
        hideHistoryBefore: hideHistoryBefore,
      );

      expect(res, isNotNull);
      expect(res.channel.cid, _channelCid);
      expect(res.members.length, memberIds.length);

      tester
        ..verifyApi(
          (api) => api.channel.addMembers(
            _channelId,
            _channelType,
            memberIds,
            hideHistoryBefore: hideHistoryBefore,
          ),
        )
        ..verifyNoMoreApiInteractions((api) => api.channel);
    },
  );

  chatClientTest(
    '`.removeChannelMembers`',
    body: (tester) async {
      final members = List.generate(
        3,
        (index) => Member(userId: 'test-user-id-$index'),
      );

      final memberIds = members.map((e) => e.userId!).toList(growable: false);

      tester.mockApi(
        (api) => api.channel.removeMembers(_channelId, _channelType, memberIds),
        result: RemoveMembersResponse()
          ..channel = createDefaultChannelModel(cid: _channelCid)
          ..members = members,
      );

      final res = await tester.client.removeChannelMembers(
        _channelId,
        _channelType,
        memberIds,
      );

      expect(res, isNotNull);
      expect(res.channel.cid, _channelCid);
      expect(res.members.length, memberIds.length);

      tester
        ..verifyApi(
          (api) => api.channel.removeMembers(_channelId, _channelType, memberIds),
        )
        ..verifyNoMoreApiInteractions((api) => api.channel);
    },
  );

  chatClientTest(
    '`.inviteChannelMembers`',
    body: (tester) async {
      final members = List.generate(
        3,
        (index) => Member(userId: 'test-user-id-$index'),
      );

      final memberIds = members.map((e) => e.userId!).toList(growable: false);

      tester.mockApi(
        (api) => api.channel.inviteChannelMembers(_channelId, _channelType, memberIds),
        result: InviteMembersResponse()
          ..channel = createDefaultChannelModel(cid: _channelCid)
          ..members = members,
      );

      final res = await tester.client.inviteChannelMembers(
        _channelId,
        _channelType,
        memberIds,
      );

      expect(res, isNotNull);
      expect(res.channel.cid, _channelCid);
      expect(res.members.length, memberIds.length);

      tester
        ..verifyApi((api) => api.channel.inviteChannelMembers(_channelId, _channelType, memberIds))
        ..verifyNoMoreApiInteractions((api) => api.channel);
    },
  );

  chatClientTest(
    '`.stopChannelWatching`',
    body: (tester) async {
      tester.mockApi(
        (api) => api.channel.stopWatching(_channelId, _channelType),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.stopChannelWatching(_channelId, _channelType);
      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.channel.stopWatching(_channelId, _channelType))
        ..verifyNoMoreApiInteractions((api) => api.channel);
    },
  );

  chatClientTest(
    '`.sendAction`',
    body: (tester) async {
      const messageId = 'test-message-id';
      const formData = {'key': 'value'};

      tester.mockApi(
        (api) => api.message.sendAction(_channelId, _channelType, messageId, formData),
        result: createDefaultSendActionResponse(),
      );

      final res = await tester.client.sendAction(
        _channelId,
        _channelType,
        messageId,
        formData,
      );

      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.message.sendAction(_channelId, _channelType, messageId, formData))
        ..verifyNoMoreApiInteractions((api) => api.message);
    },
  );

  chatClientTest(
    '`.markChannelRead`',
    body: (tester) async {
      tester.mockApi(
        (api) => api.channel.markRead(_channelId, _channelType),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.markChannelRead(_channelId, _channelType);

      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.channel.markRead(_channelId, _channelType))
        ..verifyNoMoreApiInteractions((api) => api.channel);
    },
  );

  chatClientTest(
    '`.markChannelUnread`',
    body: (tester) async {
      const messageId = 'test-message-id';

      tester.mockApi(
        (api) => api.channel.markUnread(_channelId, _channelType, messageId),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.markChannelUnread(
        _channelId,
        _channelType,
        messageId,
      );

      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.channel.markUnread(_channelId, _channelType, messageId))
        ..verifyNoMoreApiInteractions((api) => api.channel);
    },
  );

  chatClientTest(
    '`.markChannelUnreadByTimestamp`',
    body: (tester) async {
      final timestamp = DateTime.parse('2024-01-01T00:00:00Z');

      tester.mockApi(
        (api) => api.channel.markUnreadByTimestamp(
          _channelId,
          _channelType,
          timestamp,
        ),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.markChannelUnreadByTimestamp(
        _channelId,
        _channelType,
        timestamp,
      );

      expect(res, isNotNull);

      tester
        ..verifyApi(
          (api) => api.channel.markUnreadByTimestamp(
            _channelId,
            _channelType,
            timestamp,
          ),
        )
        ..verifyNoMoreApiInteractions((api) => api.channel);
    },
  );
}
