// coverage:ignore-file
import '../../../stream_chat_persistence.dart';
import '../drift_chat_database.dart';

/// A Helper class to construct new instances of [DriftChatDatabase]
class SharedDB {
  /// Returns a new instance of [DriftChatDatabase].
  static Future<DriftChatDatabase> constructDatabase(
    String userId, {
    bool logStatements = false,
    ConnectionMode connectionMode = ConnectionMode.regular,
    bool webUseIndexedDbIfSupported = false,
    String databaseNamePrefix = '',
  }) {
    throw UnsupportedError(
      'No implementation of the constructDatabase api provided',
    );
  }
}
