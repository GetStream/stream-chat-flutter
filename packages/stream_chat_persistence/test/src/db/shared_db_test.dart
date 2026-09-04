import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/src/db/web_options.dart';
import 'package:stream_chat_persistence/src/stream_chat_persistence_client.dart';

// Runs against the native implementation: `shared_db.dart` resolves to
// `native_db.dart` on the Dart VM. The executor is lazy, so constructing a
// database touches no file.
void main() {
  group('SharedDB.constructDatabase', () {
    test('returns a database bound to the given user', () async {
      final db = await SharedDB.constructDatabase('testUserId');
      addTearDown(db.close);

      expect(db, isA<DriftChatDatabase>());
      expect(db.userId, 'testUserId');
    });

    test('accepts and ignores the web-only options', () async {
      final db = await SharedDB.constructDatabase(
        'testUserId',
        connectionMode: ConnectionMode.regular,
        logger: Logger.detached('test'),
        webOptions: StreamChatPersistenceWebOptions(
          sqlite3Uri: Uri.parse('/nowhere/sqlite3.wasm'),
          driftWorkerUri: Uri.parse('/nowhere/drift_worker.js'),
        ),
      );
      addTearDown(db.close);

      expect(db.userId, 'testUserId');
    });
  });
}
