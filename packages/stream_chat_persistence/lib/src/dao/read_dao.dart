import 'package:moor/moor.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';
import 'package:stream_chat_persistence/src/entity/reads.dart';
import 'package:stream_chat_persistence/src/entity/users.dart';
import '../mapper/mapper.dart';

part 'read_dao.g.dart';

/// The Data Access Object for operations in [Reads] table.
@UseDao(tables: [Reads, Users])
class ReadDao extends DatabaseAccessor<MoorChatDatabase> with _$ReadDaoMixin {
  /// Creates a new read dao instance
  ReadDao(MoorChatDatabase db) : super(db);

  /// Get all reads where [Reads.channelCid] matches [cid]
  Future<List<Read>> getReadsByCid(String cid) async {
    return (select(reads).join([
      leftOuterJoin(users, reads.userId.equalsExp(users.id)),
    ])
          ..where(reads.channelCid.equals(cid))
          ..orderBy([
            OrderingTerm.asc(reads.lastRead),
          ]))
        .map((row) {
      final userEntity = row.readTable(users);
      final readEntity = row.readTable(reads);
      return readEntity.toRead(user: userEntity?.toUser());
    }).get();
  }

  /// Updates the read data of a particular channel with
  /// the new [readList] data
  Future<void> updateReads(String cid, List<Read> readList) {
    return batch(
      (it) => it.insertAll(
        reads,
        readList.map((r) => r.toEntity(cid: cid)).toList(),
        mode: InsertMode.insertOrReplace,
      ),
    );
  }
}
