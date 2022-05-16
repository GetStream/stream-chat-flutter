import 'package:drift/drift.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/src/entity/reads.dart';
import 'package:stream_chat_persistence/src/entity/users.dart';
import 'package:stream_chat_persistence/src/mapper/mapper.dart';

part 'read_dao.g.dart';

/// The Data Access Object for operations in [Reads] table.
@DriftAccessor(tables: [Reads, Users])
class ReadDao extends DatabaseAccessor<DriftChatDatabase> with _$ReadDaoMixin {
  /// Creates a new read dao instance
  ReadDao(super.db);

  /// Get all reads where [Reads.channelCid] matches [cid]
  Future<List<Read>> getReadsByCid(String cid) async => (select(reads).join([
        leftOuterJoin(users, reads.userId.equalsExp(users.id)),
      ])
            ..where(reads.channelCid.equals(cid))
            ..orderBy([
              OrderingTerm.asc(reads.lastRead),
            ]))
          .map((row) {
        final userEntity = row.readTable(users);
        final readEntity = row.readTable(reads);
        return readEntity.toRead(user: userEntity.toUser());
      }).get();

  /// Updates the read data of a particular channel with
  /// the new [readList] data
  Future<void> updateReads(String cid, List<Read> readList) =>
      bulkUpdateReads({cid: readList});

  /// Bulk updates the reads data of multiple channels
  Future<void> bulkUpdateReads(Map<String, List<Read>?> channelWithReads) {
    final entities = channelWithReads.entries
        .map((entry) =>
            entry.value?.map(
              (read) => read.toEntity(cid: entry.key),
            ) ??
            [])
        .expand((it) => it)
        .toList(growable: false);
    return batch((batch) => batch.insertAllOnConflictUpdate(reads, entities));
  }
}
