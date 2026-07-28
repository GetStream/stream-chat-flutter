import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/dao/pending_operation_dao.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';

import '../../stream_chat_persistence_client_test.dart';

void main() {
  late PendingOperationDao dao;
  late DriftChatDatabase database;

  setUp(() {
    database = testDatabaseProvider('testUserId');
    dao = database.pendingOperationDao;
  });

  tearDown(() async {
    await database.close();
  });

  PendingOperation operation({
    String messageId = 'm1',
    String type = 'reaction.add',
    Map<String, dynamic>? payload,
  }) => PendingOperation(
    type: type,
    targetMessageId: messageId,
    payload: payload ?? const {'reaction': 'like', 'enforce_unique': true},
  );

  test('round-trips an operation, preserving identity + payload', () async {
    await dao.insertPendingOperation(operation());

    final operations = await dao.getPendingOperations();
    expect(operations, hasLength(1));

    final op = operations.single;
    expect(op.type, 'reaction.add');
    expect(op.targetMessageId, 'm1');
    expect(op.payload, {'reaction': 'like', 'enforce_unique': true});
    expect(op.id, isNotNull);
  });

  test('insert appends — the same target queues as two distinct rows', () async {
    await dao.insertPendingOperation(operation());
    await dao.insertPendingOperation(operation());

    final operations = await dao.getPendingOperations();
    expect(operations, hasLength(2));
    expect(operations[0].id, isNot(operations[1].id));
  });

  test('getPendingOperations is ordered by insertion id', () async {
    await dao.insertPendingOperation(operation(messageId: 'm1'));
    await dao.insertPendingOperation(operation(messageId: 'm2'));
    await dao.insertPendingOperation(operation(messageId: 'm3'));

    final operations = await dao.getPendingOperations();
    expect(
      operations.map((o) => o.targetMessageId).toList(),
      ['m1', 'm2', 'm3'],
    );
  });

  test('deletePendingOperation removes by id', () async {
    await dao.insertPendingOperation(operation());
    final stored = await dao.getPendingOperations();
    expect(stored, hasLength(1));

    await dao.deletePendingOperation(stored.single.id!);
    expect(await dao.getPendingOperations(), isEmpty);
  });
}
