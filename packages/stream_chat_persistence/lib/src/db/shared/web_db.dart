import 'package:moor/moor_web.dart';
import 'package:stream_chat_persistence/src/stream_chat_persistence_client.dart';

import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';

/// A Helper class to construct new instances of [MoorChatDatabase] specifically
/// for Web applications
class SharedDB {
  /// Returns a new instance of [WebDatabase] created using [userId].
  ///
  /// Generally used with [ConnectionMode.regular].
  static Future<WebDatabase> constructDatabase(
    String userId, {
    bool logStatements = false,
  }) async {
    final dbName = 'db_$userId';
    return WebDatabase(dbName, logStatements: logStatements);
  }

  /// Returns a new instance of [MoorChatDatabase] creating using the
  /// default constructor.
  ///
  /// Generally used with [ConnectionMode.background].
  static MoorChatDatabase constructMoorChatDatabase(
    String userId, {
    bool logStatements = false,
  }) {
    final dbName = 'db_$userId';
    return MoorChatDatabase(dbName, logStatements: logStatements);
  }
}
