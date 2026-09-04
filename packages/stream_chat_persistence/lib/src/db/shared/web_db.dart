// coverage:ignore-file
import 'package:drift/wasm.dart';
import 'package:logging/logging.dart';
import 'package:web/web.dart' as web;

import '../../stream_chat_persistence_client.dart';
import '../drift_chat_database.dart';
import '../web_options.dart';
import '../web_storage_diagnostics.dart';

/// A Helper class to construct new instances of [DriftChatDatabase]
/// specifically for Web applications.
class SharedDB {
  /// Returns a new instance of [DriftChatDatabase].
  static Future<DriftChatDatabase> constructDatabase(
    String userId, {
    Logger? logger,
    bool logStatements = false, // Ignored on web
    ConnectionMode connectionMode = ConnectionMode.regular, // Ignored on web
    StreamChatPersistenceWebOptions? webOptions,
  }) async {
    final options = webOptions ?? StreamChatPersistenceWebOptions();
    final dbName = 'db_$userId';

    _deleteLegacyStorage(dbName, logger: logger);

    try {
      return await _openVerified(userId, dbName, options, logger: logger);
    } catch (error, stackTrace) {
      // The database is a disposable cache, so a copy that cannot be opened —
      // a file left corrupt by a killed tab, say — is worth discarding rather
      // than failing `connect`, which would leave the user unable to sign in
      // at all. A genuine setup problem such as a missing `sqlite3.wasm` fails
      // the retry the same way, so it is still reported.
      logger?.warning(
        describeDiscardingDatabase(databaseName: dbName),
        error,
        stackTrace,
      );

      await _discardDatabase(dbName, options, logger: logger);

      try {
        return await _openVerified(userId, dbName, options, logger: logger);
      } catch (retryError, retryStackTrace) {
        Error.throwWithStackTrace(
          StateError(
            describeUnopenableDatabase(
              sqlite3Uri: options.sqlite3Uri,
              cause: retryError,
            ),
          ),
          retryStackTrace,
        );
      }
    }
  }

  static Future<DriftChatDatabase> _openVerified(
    String userId,
    String dbName,
    StreamChatPersistenceWebOptions options, {
    Logger? logger,
  }) async {
    final result = await WasmDatabase.open(
      databaseName: dbName,
      sqlite3Uri: options.sqlite3Uri,
      driftWorkerUri: options.driftWorkerUri,
      moveExistingIndexedDbToOpfs: options.moveExistingIndexedDbToOpfs,
    );

    // A worker that fails to load leaves drift on an in-memory database that
    // answers every query and persists nothing, so this is the only point where
    // the cause is still visible.
    final diagnostic = diagnoseWebStorage(
      storage: result.chosenImplementation.name,
      reliability: _reliabilityOf(result.chosenImplementation),
      missingFeatures: result.missingFeatures.map((it) => it.name).toSet(),
      driftWorkerUri: options.driftWorkerUri,
      workerFailed: result.missingFeatures.contains(MissingBrowserFeature.workerError),
    );
    logger?.log(diagnostic.level, diagnostic.message);

    final db = DriftChatDatabase(userId, result.resolvedExecutor);

    // `WasmDatabase.open` resolves before the database is opened: the sqlite3
    // module is only fetched, and migrations only run, once the first statement
    // does — usually inside a worker whose error mentions neither the file nor
    // where it was looked up. Running one statement here moves those failures
    // to `connect`, where they can be reported with both.
    try {
      await db.customSelect('SELECT 1').get();
    } catch (_) {
      await db.close();
      rethrow;
    }

    return db;
  }

  // Deletes the stored database so the next open starts from an empty one.
  //
  // Both storage APIs are addressed by name rather than by filtering
  // `WasmProbeResult.existingDatabases`: drift only reports the databases its
  // worker can enumerate, which varies by storage API and worker version, and a
  // database that fails to be listed is exactly the one that needs discarding.
  // Deleting a database that is not there is harmless.
  static Future<void> _discardDatabase(
    String dbName,
    StreamChatPersistenceWebOptions options, {
    Logger? logger,
  }) async {
    final WasmProbeResult probed;
    try {
      probed = await WasmDatabase.probe(
        sqlite3Uri: options.sqlite3Uri,
        driftWorkerUri: options.driftWorkerUri,
        databaseName: dbName,
      );
    } catch (error, stackTrace) {
      logger?.warning(
        'Could not inspect browser storage to discard the cached chat '
        'database "$dbName".',
        error,
        stackTrace,
      );
      return;
    }

    for (final storage in WebStorageApi.values) {
      try {
        await probed.deleteDatabase((storage, dbName));
      } catch (error) {
        // The database lives under one storage API at most, and not every API
        // is usable in every browser, so a failure here is expected.
        logger?.fine(
          'Could not discard the cached chat database "$dbName" from '
          '${storage.name}: $error',
        );
      }
    }
  }

  static WebStorageReliability _reliabilityOf(WasmStorageImplementation storage) => switch (storage) {
    WasmStorageImplementation.opfsShared => WebStorageReliability.reliable,
    WasmStorageImplementation.opfsLocks => WebStorageReliability.reliable,
    WasmStorageImplementation.sharedIndexedDb => WebStorageReliability.reliable,
    WasmStorageImplementation.unsafeIndexedDb => WebStorageReliability.unsafeAcrossTabs,
    WasmStorageImplementation.inMemory => WebStorageReliability.ephemeral,
  };

  // Storage written by the sql.js based implementation used before v11. Its
  // bytes cannot be migrated, so the keys are only removed to reclaim the space
  // they hold — the cache itself is refilled from the API.
  static void _deleteLegacyStorage(String dbName, {Logger? logger}) {
    try {
      web.window.localStorage
        ..removeItem('moor_db_str_$dbName')
        ..removeItem('moor_db_version_$dbName');
    } catch (error) {
      logger?.fine('Could not remove the legacy sql.js storage for "$dbName": $error');
    }
  }
}
