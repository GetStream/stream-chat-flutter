// coverage:ignore-file
import 'package:logging/logging.dart';

import '../../stream_chat_persistence_client.dart';
import '../drift_chat_database.dart';
import '../web_options.dart';

/// A Helper class to construct new instances of [DriftChatDatabase]
class SharedDB {
  /// Returns a new instance of [DriftChatDatabase].
  static Future<DriftChatDatabase> constructDatabase(
    String userId, {
    Logger? logger,
    bool logStatements = false,
    ConnectionMode connectionMode = ConnectionMode.regular,
    StreamChatPersistenceWebOptions? webOptions,
  }) {
    throw UnsupportedError(
      'No implementation of the constructDatabase api provided',
    );
  }
}
