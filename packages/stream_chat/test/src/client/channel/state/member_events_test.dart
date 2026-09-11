import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

ChannelState Function(ChannelState) _seedChannel() {
  return (_) => createDefaultChannelState(
    channel: createDefaultChannelModel(cid: _channelCid),
  );
}

void main() {
  group('Member Events', () {
    channelTest(
      'should update membership when member is updated and is current user',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final currentUser = tester.currentUser;
        final currentMember = Member(user: currentUser);
        final now = DateTime.utc(2021, 3);

        // Setup initial membership
        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(
            members: [currentMember],
            membership: currentMember,
          ),
        );

        // Verify initial state
        expect(tester.channel.membership, isNotNull);
        expect(tester.channel.membership?.channelRole, isNull);
        expect(tester.channel.membership?.isModerator, false);
        expect(tester.channel.isPinned, isFalse);
        expect(tester.channel.isArchived, isFalse);

        // Create updated member with same userId but updated properties
        final updatedMember = currentMember.copyWith(
          channelRole: 'moderator',
          isModerator: true,
          pinnedAt: now,
          archivedAt: now,
        );

        // Create member updated event
        final memberUpdatedEvent = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.memberUpdated,
          user: currentUser,
          member: updatedMember,
        );

        // Dispatch event
        await tester.emitEvent(memberUpdatedEvent);

        // Verify membership is updated with new properties
        expect(tester.channel.membership, isNotNull);
        expect(tester.channel.membership?.userId, equals(currentUser?.id));
        expect(tester.channel.membership?.channelRole, equals('moderator'));
        expect(tester.channel.membership?.isModerator, isTrue);
        expect(tester.channel.isPinned, isTrue);
        expect(tester.channel.isArchived, isTrue);
      },
    );

    channelTest(
      'should update membership user when any event containing user is updated',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final currentUser = tester.currentUser;
        final currentMember = Member(user: currentUser);

        // Setup initial membership
        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(
            members: [currentMember],
            membership: currentMember,
          ),
        );

        // Verify initial state
        expect(tester.channel.membership, isNotNull);
        expect(tester.channel.membership?.user?.id, equals(currentUser?.id));
        expect(tester.channel.membership?.user?.role, equals(currentUser?.role));

        // Create updated user with same userId but updated properties
        final updatedUser = currentUser?.copyWith(role: 'moderator');

        // Create any event with same updated user as membership.
        final anyEvent = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.any,
          user: updatedUser,
        );

        // Dispatch event
        await tester.emitEvent(anyEvent);

        // Verify membership is updated with new properties
        expect(tester.channel.membership, isNotNull);
        expect(tester.channel.membership?.user?.id, equals(updatedUser?.id));
        expect(tester.channel.membership?.user?.role, equals(updatedUser?.role));
      },
    );

    channelTest(
      '${EventType.memberAdded} appends the member',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.memberAdded,
            member: Member(userId: 'new-member'),
          ),
        );

        expect(tester.channelState!.channelState.members?.map((m) => m.userId), ['new-member']);
      },
    );

    channelTest(
      '${EventType.memberRemoved} removes the member',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        tester.channelState!.updateChannelState(
          tester.channelState!.channelState.copyWith(
            members: [
              Member(userId: 'member-1'),
              Member(userId: 'member-2'),
            ],
          ),
        );

        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.memberRemoved,
            user: User(id: 'member-1'),
          ),
        );

        expect(tester.channelState!.channelState.members?.map((m) => m.userId), ['member-2']);
      },
    );

    channelTest(
      '${EventType.memberUpdated} replaces the member entry',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        tester.channelState!.updateChannelState(
          tester.channelState!.channelState.copyWith(
            members: [Member(userId: 'member-1', channelRole: 'channel_member')],
          ),
        );

        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.memberUpdated,
            member: Member(userId: 'member-1', channelRole: 'channel_moderator'),
          ),
        );

        expect(tester.channelState!.channelState.members?.single.channelRole, 'channel_moderator');
      },
    );

    channelTest(
      'an event user that is not a member is ignored',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        tester.channelState!.updateChannelState(
          tester.channelState!.channelState.copyWith(
            members: [
              Member(
                userId: 'member-1',
                user: User(id: 'member-1', name: 'old-name'),
              ),
            ],
          ),
        );

        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.userUpdated,
            user: User(id: 'stranger', name: 'new-name'),
          ),
        );

        expect(tester.channelState!.channelState.members?.single.user?.name, 'old-name');
      },
    );

    group('user banned/unbanned events', () {
      Future<void> setUpBannedMember(ChannelTester tester) async {
        await tester.watch(modifyResponse: _seedChannel());

        tester.channelState!.updateChannelState(
          tester.channelState!.channelState.copyWith(
            members: [
              Member(
                userId: 'bad-user',
                user: User(id: 'bad-user'),
                channelRole: 'channel_member',
              ),
            ],
          ),
        );

        tester.mockApi(
          (api) => api.general.queryMembers(
            _channelType,
            channelId: _channelId,
            filter: Filter.equal('id', 'bad-user'),
            members: any(named: 'members'),
            sort: any(named: 'sort'),
            pagination: any(named: 'pagination'),
          ),
          result: QueryMembersResponse()..members = [Member(userId: 'bad-user', channelRole: 'channel_banned')],
        );
      }

      channelTest(
        '${EventType.userBanned} refreshes the member from the server',
        channelType: _channelType,
        channelId: _channelId,
        setUp: setUpBannedMember,
        body: (tester) async {
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.userBanned,
              user: User(id: 'bad-user'),
            ),
          );

          expect(tester.channelState!.channelState.members?.single.channelRole, 'channel_banned');
        },
      );

      channelTest(
        '${EventType.userUnbanned} refreshes the member from the server',
        channelType: _channelType,
        channelId: _channelId,
        setUp: setUpBannedMember,
        body: (tester) async {
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.userUnbanned,
              user: User(id: 'bad-user'),
            ),
          );

          expect(tester.channelState!.channelState.members?.single.channelRole, 'channel_banned');
        },
      );

      channelTest(
        'an app-level ban without a cid is ignored',
        channelType: _channelType,
        channelId: _channelId,
        setUp: setUpBannedMember,
        body: (tester) async {
          await tester.emitEvent(
            createDefaultEvent(
              type: EventType.userBanned,
              user: User(id: 'bad-user'),
            ),
          );

          expect(tester.channelState!.channelState.members?.single.channelRole, 'channel_member');
          tester.verifyNeverCalled(
            (api) => api.general.queryMembers(
              any(),
              channelId: any(named: 'channelId'),
              filter: any(named: 'filter'),
              members: any(named: 'members'),
              sort: any(named: 'sort'),
              pagination: any(named: 'pagination'),
            ),
          );
        },
      );
    });
  });
}
