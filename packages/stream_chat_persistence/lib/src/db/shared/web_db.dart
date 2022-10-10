// coverage:ignore-file
import 'package:drift/web.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/src/stream_chat_persistence_client.dart';

/// A Helper class to construct new instances of [DriftChatDatabase]
/// specifically for Web applications.
class SharedDB {
  /// Returns a new instance of [DriftChatDatabase].
  static Future<DriftChatDatabase> constructDatabase(
    String userId, {
    bool logStatements = false,
    ConnectionMode connectionMode = ConnectionMode.regular, // Ignored on web
    bool webUseIndexedDbIfSupported = false,
  }) async {
    final dbName = 'db_$userId';
    final queryExecutor = await _getQueryExecutor(
      dbName,
      useIndexedDbIfSupported: webUseIndexedDbIfSupported,
      logStatements: logStatements,
    );
    return DriftChatDatabase(userId, queryExecutor);
  }

  static Future<WebDatabase> _getQueryExecutor(
    String dbName, {
    required bool useIndexedDbIfSupported,
    required bool logStatements,
  }) async {
    if (useIndexedDbIfSupported) {
      return WebDatabase.withStorage(
        await DriftWebStorage.indexedDbIfSupported(dbName),
        logStatements: logStatements,
      );
    }
    return WebDatabase(dbName, logStatements: logStatements);
  }
}
