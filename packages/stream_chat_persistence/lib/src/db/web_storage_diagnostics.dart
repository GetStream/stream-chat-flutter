import 'package:logging/logging.dart';

/// How reliably the browser hosting the application can persist the chat
/// database.
enum WebStorageReliability {
  /// The database survives a reload and several tabs can use it at once.
  reliable,

  /// The database survives a reload, but two tabs writing at the same time can
  /// corrupt it.
  unsafeAcrossTabs,

  /// The database is not persisted at all: its contents are lost as soon as the
  /// tab is closed.
  ephemeral,
}

/// A single log record describing how the chat database is stored on the web.
class WebStorageDiagnostic {
  /// Creates a diagnostic that should be logged at [level] with [message].
  const WebStorageDiagnostic(this.level, this.message);

  /// Level [message] should be logged at.
  final Level level;

  /// Actionable description of the storage that was chosen.
  final String message;

  @override
  String toString() => '${level.name}: $message';
}

/// Builds the log record for a chat database that was opened on the web.
///
/// [storage] names the storage implementation drift chose, [reliability]
/// classifies it, and [missingFeatures] names the browser features whose
/// absence led to that choice.
///
/// Set [workerFailed] when drift reported that it could not start its worker.
/// drift reports that the same way whether the browser forbids workers or the
/// worker script is simply not being served, so the message names
/// [driftWorkerUri] to make the second case checkable.
WebStorageDiagnostic diagnoseWebStorage({
  required String storage,
  required WebStorageReliability reliability,
  required Set<String> missingFeatures,
  required Uri driftWorkerUri,
  bool workerFailed = false,
}) {
  final missing = missingFeatures.isEmpty ? 'none' : (missingFeatures.toList()..sort()).join(', ');
  final features = 'Browser features drift could not use: $missing.';

  final workerHint = workerFailed
      ? ' drift could not start its worker: make sure "drift_worker.js" is served at "$driftWorkerUri".'
      : '';

  return switch (reliability) {
    WebStorageReliability.reliable => WebStorageDiagnostic(
      Level.INFO,
      'Opened the chat database with the "$storage" storage implementation. $features',
    ),
    WebStorageReliability.unsafeAcrossTabs => WebStorageDiagnostic(
      Level.WARNING,
      'Opened the chat database with the "$storage" storage implementation, which cannot keep two tabs of this '
      'app from writing at the same time. Serve the app with the "Cross-Origin-Opener-Policy: same-origin" and '
      '"Cross-Origin-Embedder-Policy: require-corp" headers to let this browser store the cache in the origin '
      'private file system instead. $features$workerHint',
    ),
    WebStorageReliability.ephemeral => WebStorageDiagnostic(
      Level.SEVERE,
      'Opened the chat database with the "$storage" storage implementation: nothing is persisted and the offline '
      'cache is rebuilt on every reload.$workerHint $features',
    ),
  };
}

/// Builds the message logged when a cached database cannot be opened and is
/// being discarded so the next attempt can start from an empty one.
///
/// [databaseName] is the drift database that is about to be deleted.
String describeDiscardingDatabase({required String databaseName}) =>
    'Could not open the cached chat database "$databaseName", so it is being discarded and rebuilt from an empty '
    'one. Cached messages will be refilled from the API on the next sync.';

/// Builds the error message for a web database that could not be opened.
///
/// The sqlite3 module is only fetched once the first statement runs, and on
/// most setups that happens inside a worker where [cause] no longer mentions
/// which file was missing. [sqlite3Uri] is where it was looked up.
String describeUnopenableDatabase({
  required Uri sqlite3Uri,
  required Object cause,
}) =>
    'stream_chat_persistence could not open its database in this browser. Make sure "sqlite3.wasm" is served at '
    '"$sqlite3Uri" — copy it, together with "drift_worker.js", from the drift release matching your `drift` '
    'version (https://github.com/simolus3/drift/releases) into your app\'s "web/" folder, or point '
    'StreamChatPersistenceWebOptions.sqlite3Uri at wherever you host it.\nThe underlying error was: $cause';
