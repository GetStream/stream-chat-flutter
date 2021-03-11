import 'package:stream_chat_persistence/stream_chat_persistence.dart';

/// A Helper class to construct new instances of [MoorChatDatabase]
class SharedDB {
  /// Returns a new instance of database.
  ///
  /// Generally used with [ConnectionMode.regular].
  static dynamic constructDatabase(
    String userId, {
    bool logStatements = false,
    bool persistOnDisk = true,
  }) {
    throw 'Unsupported Platform';
  }

  /// Return a new instance of moor chat database.
  ///
  /// Generally used with [ConnectionMode.background].
  static dynamic constructMoorChatDatabase(
    String userId, {
    bool logStatements = false,
  }) {
    throw 'Unsupported Platform';
  }
}
