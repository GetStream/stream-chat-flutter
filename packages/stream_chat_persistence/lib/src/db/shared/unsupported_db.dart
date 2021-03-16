import 'package:moor/backends.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';
import 'package:stream_chat_persistence/stream_chat_persistence.dart';

/// A Helper class to construct new instances of [MoorChatDatabase]
class SharedDB {
  /// Returns a new instance of database.
  ///
  /// Generally used with [ConnectionMode.regular].
  static Future<DelegatedDatabase> constructDatabase(
    String userId, {
    bool logStatements = false,
    bool persistOnDisk = true,
  }) {
    throw UnsupportedError(
        'No implementation of the constructDatabase api provided');
  }

  /// Return a new instance of moor chat database.
  ///
  /// Generally used with [ConnectionMode.background].
  static MoorChatDatabase constructMoorChatDatabase(
    String userId, {
    bool logStatements = false,
  }) {
    throw UnsupportedError(
        'No implementation of the constructMoorChatDatabase api provided');
  }
}
