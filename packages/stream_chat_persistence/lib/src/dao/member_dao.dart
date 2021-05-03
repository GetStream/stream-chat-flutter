import 'package:moor/moor.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';

import 'package:stream_chat_persistence/src/entity/members.dart';
import 'package:stream_chat_persistence/src/entity/users.dart';

import 'package:stream_chat_persistence/src/mapper/mapper.dart';

part 'member_dao.g.dart';

/// The Data Access Object for operations in [Members] table.
@UseDao(tables: [Members, Users])
class MemberDao extends DatabaseAccessor<MoorChatDatabase>
    with _$MemberDaoMixin {
  /// Creates a new member dao instance
  MemberDao(MoorChatDatabase db) : super(db);

  /// Get all members where [Members.channelCid] matches [cid]
  Future<List<Member>> getMembersByCid(String cid) async =>
      (select(members).join([
        leftOuterJoin(users, members.userId.equalsExp(users.id)),
      ])
            ..where(members.channelCid.equals(cid))
            ..orderBy([OrderingTerm.asc(members.createdAt)]))
          .map((row) {
        final userEntity = row.readTable(users);
        final memberEntity = row.readTable(members);
        return memberEntity.toMember(user: userEntity.toUser());
      }).get();

  /// Updates all the members using the new [memberList] data
  Future<void> updateMembers(String cid, List<Member> memberList) async =>
      batch(
        (it) => it.insertAll(
          members,
          memberList.map((m) => m.toEntity(cid: cid)).toList(),
          mode: InsertMode.insertOrReplace,
        ),
      );

  /// Deletes all the members whose [Members.channelCid] is present in [cids]
  Future<void> deleteMemberByCids(List<String> cids) async => batch((it) {
        it.deleteWhere<Members, MemberEntity>(
          members,
          (m) => m.channelCid.isIn(cids),
        );
      });
}
