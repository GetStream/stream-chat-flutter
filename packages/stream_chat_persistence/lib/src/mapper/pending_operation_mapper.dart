import 'package:drift/drift.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';

/// Useful mapping functions for [PendingOperationEntity]
extension PendingOperationEntityX on PendingOperationEntity {
  /// Maps a [PendingOperationEntity] into a [PendingOperation]
  PendingOperation toPendingOperation() => PendingOperation(
    id: id,
    type: type,
    targetMessageId: targetMessageId,
    payload: payload,
  );
}

/// Useful mapping functions for [PendingOperation]
extension PendingOperationX on PendingOperation {
  /// Maps a [PendingOperation] into a [PendingOperationsCompanion].
  PendingOperationsCompanion toCompanion() => PendingOperationsCompanion(
    id: id == null ? const Value.absent() : Value(id!),
    type: Value(type),
    targetMessageId: Value(targetMessageId),
    payload: Value(payload),
  );
}
