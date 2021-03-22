import 'dart:math' as math;

import 'package:test/test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';
import 'package:stream_chat_persistence/src/mapper/member_mapper.dart';

import '../utils/date_matcher.dart';

void main() {
  test('toMember should map entity into Member', () {
    final user = User(id: 'testUserId');
    final entity = MemberEntity(
      userId: user.id,
      channelCid: 'testCid',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      role: 'testRole',
      inviteAcceptedAt: DateTime.now(),
      inviteRejectedAt: DateTime.now(),
      invited: math.Random().nextBool(),
      banned: math.Random().nextBool(),
      shadowBanned: math.Random().nextBool(),
      isModerator: math.Random().nextBool(),
    );
    final member = entity.toMember(user: user);
    expect(member, isA<Member>());
    expect(member.user.id, entity.userId);
    expect(member.createdAt, isSameDateAs(entity.createdAt));
    expect(member.updatedAt, isSameDateAs(entity.updatedAt));
    expect(member.role, entity.role);
    expect(member.inviteAcceptedAt, isSameDateAs(entity.inviteAcceptedAt));
    expect(member.inviteRejectedAt, isSameDateAs(entity.inviteRejectedAt));
    expect(member.invited, entity.invited);
    expect(member.banned, entity.banned);
    expect(member.shadowBanned, entity.shadowBanned);
    expect(member.isModerator, entity.isModerator);
  });

  test('toEntity show map member into MemberEntity', () {
    const cid = 'testCid';
    final user = User(id: 'testUserId');
    final member = Member(
      user: user,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      role: 'testRole',
      inviteAcceptedAt: DateTime.now(),
      inviteRejectedAt: DateTime.now(),
      invited: math.Random().nextBool(),
      banned: math.Random().nextBool(),
      shadowBanned: math.Random().nextBool(),
      isModerator: math.Random().nextBool(),
    );
    final entity = member.toEntity(cid: cid);
    expect(entity, isA<MemberEntity>());
    expect(entity.channelCid, cid);
    expect(entity.userId, member.user.id);
    expect(entity.createdAt, isSameDateAs(member.createdAt));
    expect(entity.updatedAt, isSameDateAs(member.updatedAt));
    expect(entity.role, member.role);
    expect(entity.inviteAcceptedAt, isSameDateAs(member.inviteAcceptedAt));
    expect(entity.inviteRejectedAt, isSameDateAs(member.inviteRejectedAt));
    expect(entity.invited, member.invited);
    expect(entity.banned, member.banned);
    expect(entity.shadowBanned, member.shadowBanned);
    expect(entity.isModerator, member.isModerator);
  });
}
