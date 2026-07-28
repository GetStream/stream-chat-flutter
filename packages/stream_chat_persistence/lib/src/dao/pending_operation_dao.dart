import 'package:drift/drift.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/src/entity/entity.dart';
import 'package:stream_chat_persistence/src/mapper/mapper.dart';

part 'pending_operation_dao.g.dart';

/// The Data Access Object for operations in [PendingOperations] table.
@DriftAccessor(tables: [PendingOperations])
class PendingOperationDao extends DatabaseAccessor<DriftChatDatabase> with _$PendingOperationDaoMixin {
  /// Creates a new pending operation dao instance
  PendingOperationDao(super.db);

  /// Appends [operation] to the queue.
  Future<void> insertPendingOperation(PendingOperation operation) =>
      into(pendingOperations).insert(operation.toCompanion());

  /// Returns all pending operations ordered by insertion (`id` ascending).
  Future<List<PendingOperation>> getPendingOperations() {
    final query = select(pendingOperations)..orderBy([(tbl) => OrderingTerm.asc(tbl.id)]);
    return query.map((row) => row.toPendingOperation()).get();
  }

  /// Deletes the pending operation with the given autoincrement [id].
  Future<void> deletePendingOperation(int id) => (delete(pendingOperations)..where((tbl) => tbl.id.equals(id))).go();
}
