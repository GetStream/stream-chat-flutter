// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_operation_dao.dart';

// ignore_for_file: type=lint
mixin _$PendingOperationDaoMixin on DatabaseAccessor<DriftChatDatabase> {
  $PendingOperationsTable get pendingOperations =>
      attachedDatabase.pendingOperations;
  PendingOperationDaoManager get managers => PendingOperationDaoManager(this);
}

class PendingOperationDaoManager {
  final _$PendingOperationDaoMixin _db;
  PendingOperationDaoManager(this._db);
  $$PendingOperationsTableTableManager get pendingOperations =>
      $$PendingOperationsTableTableManager(
        _db.attachedDatabase,
        _db.pendingOperations,
      );
}
