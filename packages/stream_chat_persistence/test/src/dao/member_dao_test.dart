import 'dart:math' as math;

import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/dao/dao.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';
import 'package:test/test.dart';

import '../utils/date_matcher.dart';

void main() {
  late MemberDao memberDao;
  late MoorChatDatabase database;

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
      expect(fetchedMember.user!.id, member.user!.id);
      expect(fetchedMember.banned, member.banned);
      expect(fetchedMember.shadowBanned, member.shadowBanned);
      expect(fetchedMember.createdAt, isSameDateAs(member.createdAt));
      expect(fetchedMember.isModerator, member.isModerator);
      expect(fetchedMember.invited, member.invited);
      expect(fetchedMember.role, member.role);
      expect(fetchedMember.updatedAt, isSameDateAs(member.updatedAt));
      expect(
        fetchedMember.inviteAcceptedAt,
        isSameDateAs(member.inviteAcceptedAt!),
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
      expect(fetchedMember.user!.id, member.user!.id);
      expect(fetchedMember.banned, member.banned);
      expect(fetchedMember.shadowBanned, member.shadowBanned);
      expect(fetchedMember.createdAt, isSameDateAs(member.createdAt));
      expect(fetchedMember.isModerator, member.isModerator);
      expect(fetchedMember.invited, member.invited);
      expect(fetchedMember.role, member.role);
      expect(fetchedMember.updatedAt, isSameDateAs(member.updatedAt));
      expect(
        fetchedMember.inviteAcceptedAt,
        isSameDateAs(member.inviteAcceptedAt!),
      );
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
      role: 'testRole',
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
