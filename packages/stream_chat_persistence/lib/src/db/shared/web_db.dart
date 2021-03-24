// coverage:ignore-file
import 'package:moor/moor_web.dart';
import 'package:stream_chat_persistence/src/stream_chat_persistence_client.dart';

import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';

/// A Helper class to construct new instances of [MoorChatDatabase] specifically
/// for Web applications
class SharedDB {
  /// Returns a new instance of [MoorChatDatabase].
  static MoorChatDatabase constructDatabase(
    String userId, {
    bool logStatements = false,
    ConnectionMode connectionMode = ConnectionMode.regular, // Ignored on web
  }) {
    final dbName = 'db_$userId';
    final queryExecutor = WebDatabase(dbName, logStatements: logStatements);
    return MoorChatDatabase(userId, queryExecutor);
  }
}
