import 'package:test/test.dart';
import 'package:moor/ffi.dart';
import 'package:moor/isolate.dart';
import 'package:moor/moor.dart' hide isNotNull;
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';

DatabaseConnection _backgroundConnection() =>
    DatabaseConnection.fromExecutor(VmDatabase.memory());

void main() {
  test(
    'default constructor should create a new instance of MoorChatDatabase',
    () async {
      const userId = 'testUserId';
      final executor = VmDatabase.memory();
      final database = MoorChatDatabase(userId, executor);
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
      final isolate = await MoorIsolate.spawn(_backgroundConnection);
      final connection = DatabaseConnection.delayed(isolate.connect());

      final database = MoorChatDatabase.connect(userId, connection);
      expect(database, isNotNull);
      expect(database.userId, userId);

      addTearDown(() async {
        await database.disconnect();
        await isolate.shutdownAll();
      });
    },
  );
}
