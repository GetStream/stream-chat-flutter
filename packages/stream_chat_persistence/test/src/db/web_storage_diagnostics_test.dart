import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:stream_chat_persistence/src/db/web_storage_diagnostics.dart';

void main() {
  group('diagnoseWebStorage', () {
    WebStorageDiagnostic diagnose(
      WebStorageReliability reliability, {
      String storage = 'opfsShared',
      Set<String> missingFeatures = const {},
      bool workerFailed = false,
    }) => diagnoseWebStorage(
      storage: storage,
      reliability: reliability,
      missingFeatures: missingFeatures,
      driftWorkerUri: Uri.parse('drift_worker.js'),
      workerFailed: workerFailed,
    );

    test('reports reliable storage at INFO', () {
      final diagnostic = diagnose(WebStorageReliability.reliable);

      expect(diagnostic.level, Level.INFO);
      expect(diagnostic.message, contains('"opfsShared"'));
    });

    test('reports storage that two tabs can corrupt at WARNING', () {
      final diagnostic = diagnose(
        WebStorageReliability.unsafeAcrossTabs,
        storage: 'unsafeIndexedDb',
      );

      expect(diagnostic.level, Level.WARNING);
      expect(diagnostic.message, contains('"unsafeIndexedDb"'));
    });

    test('reports storage that persists nothing at SEVERE', () {
      final diagnostic = diagnose(
        WebStorageReliability.ephemeral,
        storage: 'inMemory',
      );

      expect(diagnostic.level, Level.SEVERE);
      expect(diagnostic.message, contains('nothing is persisted'));
    });

    test('the unsafe message names both headers that fix it', () {
      final diagnostic = diagnose(WebStorageReliability.unsafeAcrossTabs);

      expect(diagnostic.message, contains('Cross-Origin-Opener-Policy: same-origin'));
      expect(diagnostic.message, contains('Cross-Origin-Embedder-Policy: require-corp'));
    });

    test('renders an empty set of missing features as none', () {
      final diagnostic = diagnose(WebStorageReliability.reliable);

      expect(diagnostic.message, contains('Browser features drift could not use: none.'));
    });

    test('sorts missing features so log lines are stable', () {
      final diagnostic = diagnose(
        WebStorageReliability.reliable,
        missingFeatures: {'sharedArrayBuffers', 'dedicatedWorkersInSharedWorkers'},
      );

      expect(
        diagnostic.message,
        contains('Browser features drift could not use: dedicatedWorkersInSharedWorkers, sharedArrayBuffers.'),
      );
    });

    test('names the worker file and its uri when the worker failed to start', () {
      final diagnostic = diagnose(
        WebStorageReliability.ephemeral,
        storage: 'inMemory',
        missingFeatures: {'workerError'},
        workerFailed: true,
      );

      expect(diagnostic.level, Level.SEVERE);
      expect(diagnostic.message, contains('"drift_worker.js" is served at "drift_worker.js"'));
    });

    test('says nothing about the worker when it started', () {
      final diagnostic = diagnose(
        WebStorageReliability.ephemeral,
        storage: 'inMemory',
      );

      expect(diagnostic.message, isNot(contains('drift_worker.js')));
    });

    test('toString prefixes the message with its level', () {
      final diagnostic = diagnose(WebStorageReliability.reliable);

      expect(diagnostic.toString(), startsWith('INFO: '));
    });
  });

  group('describeDiscardingDatabase', () {
    test('names the database being discarded', () {
      final message = describeDiscardingDatabase(databaseName: 'db_testUserId');

      expect(message, contains('"db_testUserId"'));
    });

    test('says the cache is rebuilt rather than lost', () {
      final message = describeDiscardingDatabase(databaseName: 'db_testUserId');

      expect(message, contains('discarded'));
      expect(message, contains('refilled from the API'));
    });
  });

  group('describeUnopenableDatabase', () {
    test('names the sqlite3 module and where it was looked up', () {
      final message = describeUnopenableDatabase(
        sqlite3Uri: Uri.parse('/assets/sqlite3.wasm'),
        cause: 'boom',
      );

      expect(message, contains('"sqlite3.wasm" is served at "/assets/sqlite3.wasm"'));
      expect(message, contains('https://github.com/simolus3/drift/releases'));
    });

    test('points at the option that overrides the location', () {
      final message = describeUnopenableDatabase(
        sqlite3Uri: Uri.parse('sqlite3.wasm'),
        cause: 'boom',
      );

      expect(message, contains('StreamChatPersistenceWebOptions.sqlite3Uri'));
    });

    test('keeps the underlying error so the real cause is not lost', () {
      final message = describeUnopenableDatabase(
        sqlite3Uri: Uri.parse('sqlite3.wasm'),
        cause: StateError('the worker exploded'),
      );

      expect(message, contains('the worker exploded'));
    });
  });
}
