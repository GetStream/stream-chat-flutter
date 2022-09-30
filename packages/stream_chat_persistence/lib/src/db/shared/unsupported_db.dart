// coverage:ignore-file
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/stream_chat_persistence.dart';

/// A Helper class to construct new instances of [DriftChatDatabase]
class SharedDB {
  /// Returns a new instance of [DriftChatDatabase].
  static DriftChatDatabase constructDatabase(
    String userId, {
    bool logStatements = false,
    ConnectionMode connectionMode = ConnectionMode.regular,
  }) {
    throw UnsupportedError(
      'No implementation of the constructDatabase api provided',
    );
  }
}
