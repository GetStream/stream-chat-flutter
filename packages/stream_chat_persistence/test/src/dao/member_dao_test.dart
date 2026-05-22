import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/dao/dao.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';

import '../../stream_chat_persistence_client_test.dart';
import '../utils/date_matcher.dart';

void main() {
  late MemberDao memberDao;
  late DriftChatDatabase database;

  setUp(() {
    database = testDatabaseProvider('testUserId');
    memberDao = database.memberDao;
  });

  Future<List<Member>> _prepareTestData(String cid) async {
    final channels = [ChannelModel(cid: cid)];
    final users = List.generate(3, (index) => User(id: 'testUserId$index'));
    final memberList = List.generate(
      3,
      (index) => Member(
        user: users[index],
        banned: math.Random().nextBool(),
        shadowBanned: math.Random().nextBool(),
        createdAt: DateTime.now(),
        pinnedAt: DateTime.now(),
        archivedAt: DateTime.now(),
        isModerator: math.Random().nextBool(),
        invited: math.Random().nextBool(),
        inviteAcceptedAt: DateTime.now(),
        channelRole: 'testRole',
        updatedAt: DateTime.now(),
        extraData: const {'extra_test_field': 'extraTestData'},
      ),
    );
    await database.userDao.updateUsers(users);
    await database.channelDao.updateChannels(channels);
    await memberDao.updateMembers(cid, memberList);
    return memberList;
  }

  test('getMembersByCid', () async {
    const cid = 'test:Cid';

    // Should be empty initially
    final members = await memberDao.getMembersByCid(cid);
    expect(members, isEmpty);

    // Preparing test data
    final memberList = await _prepareTestData(cid);

    // Should match the previous test data
    final fetchedMembers = await memberDao.getMembersByCid(cid);
    expect(fetchedMembers.length, memberList.length);
    for (var i = 0; i < fetchedMembers.length; i++) {
      final member = memberList[i];
      final fetchedMember = fetchedMembers[i];
      expect(fetchedMember.user!.id, member.user!.id);
      expect(fetchedMember.banned, member.banned);
      expect(fetchedMember.shadowBanned, member.shadowBanned);
      expect(fetchedMember.createdAt, isSameDateAs(member.createdAt));
      expect(fetchedMember.pinnedAt, isSameDateAs(member.pinnedAt));
      expect(fetchedMember.archivedAt, isSameDateAs(member.archivedAt));
      expect(fetchedMember.isModerator, member.isModerator);
      expect(fetchedMember.invited, member.invited);
      expect(fetchedMember.channelRole, member.channelRole);
      expect(fetchedMember.updatedAt, isSameDateAs(member.updatedAt));
      expect(
        fetchedMember.inviteAcceptedAt,
        isSameDateAs(member.inviteAcceptedAt),
      );
      expect(fetchedMember.extraData, member.extraData);
    }
  });

  test('getMembershipsForChannels', () async {
    const cid1 = 'test:Cid1';
    const cid2 = 'test:Cid2';
    const cid3 = 'test:Cid3';
    const targetUserId = 'targetUserId';

    // Should be empty when cids list is empty
    final emptyResult = await memberDao.getMembershipsForChannels(
      [],
      targetUserId,
    );
    expect(emptyResult, isEmpty);

    // Should be empty when there is no data
    final noDataResult = await memberDao.getMembershipsForChannels(
      [cid1, cid2, cid3],
      targetUserId,
    );
    expect(noDataResult, isEmpty);

    // Preparing test data: target user is a member of cid1 and cid2,
    // but not cid3.
    final targetUser = User(id: targetUserId);
    final otherUser = User(id: 'otherUserId');
    Member memberFor(User user) => Member(
          user: user,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
    await database.userDao.updateUsers([targetUser, otherUser]);
    await database.channelDao.updateChannels([
      ChannelModel(cid: cid1),
      ChannelModel(cid: cid2),
      ChannelModel(cid: cid3),
    ]);
    await memberDao.updateMembers(cid1, [memberFor(targetUser)]);
    await memberDao.updateMembers(cid2, [memberFor(targetUser)]);
    await memberDao.updateMembers(cid3, [memberFor(otherUser)]);

    // Should return memberships only for channels where target user
    // is a member, keyed by channelCid.
    final memberships = await memberDao.getMembershipsForChannels(
      [cid1, cid2, cid3],
      targetUserId,
    );
    expect(memberships.length, 2);
    expect(memberships.keys, containsAll([cid1, cid2]));
    expect(memberships.containsKey(cid3), isFalse);

    expect(memberships[cid1]!.user!.id, targetUserId);
    expect(memberships[cid2]!.user!.id, targetUserId);
  });

  test('updateMembers', () async {
    const cid = 'test:Cid';

    // Preparing test data
    final memberList = await _prepareTestData(cid);

    // Should match the previous test data
    final fetchedMembers = await memberDao.getMembersByCid(cid);
    expect(fetchedMembers.length, memberList.length);
    for (var i = 0; i < fetchedMembers.length; i++) {
      final member = memberList[i];
      final fetchedMember = fetchedMembers[i];
      expect(fetchedMember.user!.id, member.user!.id);
      expect(fetchedMember.banned, member.banned);
      expect(fetchedMember.shadowBanned, member.shadowBanned);
      expect(fetchedMember.createdAt, isSameDateAs(member.createdAt));
      expect(fetchedMember.pinnedAt, isSameDateAs(member.pinnedAt));
      expect(fetchedMember.archivedAt, isSameDateAs(member.archivedAt));
      expect(fetchedMember.isModerator, member.isModerator);
      expect(fetchedMember.invited, member.invited);
      expect(fetchedMember.channelRole, member.channelRole);
      expect(fetchedMember.updatedAt, isSameDateAs(member.updatedAt));
      expect(
        fetchedMember.inviteAcceptedAt,
        isSameDateAs(member.inviteAcceptedAt),
      );
      expect(fetchedMember.extraData, member.extraData);
    }

    // Modifying one of the member and also adding one new
    final copyMember = fetchedMembers.first.copyWith(banned: true);
    final newUser = User(id: 'testUserId3');
    final newMember = Member(
      user: newUser,
      banned: math.Random().nextBool(),
      shadowBanned: math.Random().nextBool(),
      createdAt: DateTime.now(),
      isModerator: math.Random().nextBool(),
      invited: math.Random().nextBool(),
      inviteAcceptedAt: DateTime.now(),
      channelRole: 'testRole',
      updatedAt: DateTime.now(),
    );
    await database.userDao.updateUsers([newUser]);
    await memberDao.updateMembers(cid, [copyMember, newMember]);

    // Fetched member length should be one more than inserted members.
    // copyMember `banned` modified field should be true.
    // Fetched members should contain the newMember.
    final newFetchedMembers = await memberDao.getMembersByCid(cid);
    expect(newFetchedMembers.length, fetchedMembers.length + 1);
    expect(
      newFetchedMembers
          .firstWhere((it) => it.user!.id == copyMember.user!.id)
          .banned,
      true,
    );
    expect(
      newFetchedMembers
          .where((it) => it.user!.id == newMember.user!.id)
          .isNotEmpty,
      true,
    );
  });

  test('deleteMemberByCids', () async {
    const cid = 'test:Cid';

    // Preparing test data
    final members = await _prepareTestData(cid);
    final fetchedMembers = await memberDao.getMembersByCid(cid);
    expect(members.length, fetchedMembers.length);

    // Deleting all the members
    await memberDao.deleteMemberByCids([cid]);

    // Fetched member list should be empty
    final newFetchedMembers = await memberDao.getMembersByCid(cid);
    expect(newFetchedMembers, isEmpty);
  });

  tearDown(() async {
    await database.disconnect();
  });
}
