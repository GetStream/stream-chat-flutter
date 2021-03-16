import 'dart:math' as math;

import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/dao/dao.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';
import 'package:test/test.dart';

import '../utils/date_matcher.dart';

void main() {
  MemberDao memberDao;
  MoorChatDatabase database;

  setUp(() {
    database = MoorChatDatabase.testable('testUserId');
    memberDao = database.memberDao;
  });

  Future<List<Member>> _prepareTestData(String cid) async {
    final users = List.generate(3, (index) => User(id: 'testUserId$index'));
    final memberList = List.generate(
      3,
      (index) => Member(
        user: users[index],
        banned: math.Random().nextBool(),
        shadowBanned: math.Random().nextBool(),
        createdAt: DateTime.now(),
        isModerator: math.Random().nextBool(),
        invited: math.Random().nextBool(),
        inviteAcceptedAt: DateTime.now(),
        role: 'testRole',
        updatedAt: DateTime.now(),
      ),
    );
    await database.userDao.updateUsers(users);
    await memberDao.updateMembers(cid, memberList);
    return memberList;
  }

  test('getMembersByCid', () async {
    const cid = 'testCid';

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
      expect(fetchedMember.user.id, member.user.id);
      expect(fetchedMember.banned, member.banned);
      expect(fetchedMember.shadowBanned, member.shadowBanned);
      expect(fetchedMember.createdAt, isSameDateAs(member.createdAt));
      expect(fetchedMember.isModerator, member.isModerator);
      expect(fetchedMember.invited, member.invited);
      expect(fetchedMember.role, member.role);
      expect(fetchedMember.updatedAt, isSameDateAs(member.updatedAt));
      expect(
        fetchedMember.inviteAcceptedAt,
        isSameDateAs(member.inviteAcceptedAt),
      );
    }
  });

  test('updateMembers', () async {
    const cid = 'testCid';

    // Preparing test data
    final memberList = await _prepareTestData(cid);

    // Should match the previous test data
    final fetchedMembers = await memberDao.getMembersByCid(cid);
    expect(fetchedMembers.length, memberList.length);
    for (var i = 0; i < fetchedMembers.length; i++) {
      final member = memberList[i];
      final fetchedMember = fetchedMembers[i];
      expect(fetchedMember.user.id, member.user.id);
      expect(fetchedMember.banned, member.banned);
      expect(fetchedMember.shadowBanned, member.shadowBanned);
      expect(fetchedMember.createdAt, isSameDateAs(member.createdAt));
      expect(fetchedMember.isModerator, member.isModerator);
      expect(fetchedMember.invited, member.invited);
      expect(fetchedMember.role, member.role);
      expect(fetchedMember.updatedAt, isSameDateAs(member.updatedAt));
      expect(
        fetchedMember.inviteAcceptedAt,
        isSameDateAs(member.inviteAcceptedAt),
      );
    }

    // Updating the last added member
    final updatedMember = fetchedMembers.last.copyWith(banned: true);
    await memberDao.updateMembers(cid, [updatedMember]);

    // Last member banned field should match the previous updated user
    final newFetchedMembers = await memberDao.getMembersByCid(cid);
    expect(newFetchedMembers.length, fetchedMembers.length);
    final lastMember = newFetchedMembers.last;
    expect(lastMember.banned, true);
  });

  test('deleteMemberByCids', () async {
    const cid = 'testCid';

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
