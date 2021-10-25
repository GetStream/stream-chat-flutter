import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/isolate.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';

DatabaseConnection _backgroundConnection() =>
    DatabaseConnection.fromExecutor(NativeDatabase.memory());

void main() {
  test(
    'default constructor should create a new instance of MoorChatDatabase',
    () async {
      const userId = 'testUserId';
      final executor = NativeDatabase.memory();
      final database = DriftChatDatabase(userId, executor);
      expect(database, isNotNull);
      expect(database.userId, userId);

      addTearDown(() async {
        await database.disconnect();
      });
    },
  );

  test(
    'connect constructor should create a new instance of MoorChatDatabase',
    () async {
      const userId = 'testUserId';
      final isolate = await DriftIsolate.spawn(_backgroundConnection);
      final connection = DatabaseConnection.delayed(isolate.connect());

      final database = DriftChatDatabase.connect(userId, connection);
      expect(database, isNotNull);
      expect(database.userId, userId);

      addTearDown(() async {
        await database.disconnect();
        await isolate.shutdownAll();
      });
    },
  );
}
