// coverage:ignore-file
import 'package:drift/web.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/src/stream_chat_persistence_client.dart';

/// A Helper class to construct new instances of [DriftChatDatabase]
/// specifically for Web applications.
class SharedDB {
  /// Returns a new instance of [DriftChatDatabase].
  static DriftChatDatabase constructDatabase(
    String userId, {
    bool logStatements = false,
    ConnectionMode connectionMode = ConnectionMode.regular, // Ignored on web
  }) {
    final dbName = 'db_$userId';
    final queryExecutor = WebDatabase(dbName, logStatements: logStatements);
    return DriftChatDatabase(userId, queryExecutor);
  }
}
