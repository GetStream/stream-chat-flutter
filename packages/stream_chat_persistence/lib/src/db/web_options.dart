/// Configuration for the WebAssembly based database used on Flutter web.
///
/// Running sqlite3 in a browser needs two files that are not part of the
/// compiled application: `sqlite3.wasm` and `drift_worker.js`. Both are
/// published together in every [drift release][drift-releases] and both are
/// looked up relative to the document's base href, so copying them into the
/// application's `web/` folder is enough for the defaults to work.
///
/// Ignored on every platform other than web.
///
/// [drift-releases]: https://github.com/simolus3/drift/releases
class StreamChatPersistenceWebOptions {
  /// Creates a new set of web options.
  StreamChatPersistenceWebOptions({
    Uri? sqlite3Uri,
    Uri? driftWorkerUri,
    this.moveExistingIndexedDbToOpfs = false,
  }) : sqlite3Uri = sqlite3Uri ?? defaultSqlite3Uri,
       driftWorkerUri = driftWorkerUri ?? defaultDriftWorkerUri;

  /// Where `sqlite3.wasm` is looked up when [sqlite3Uri] is not provided.
  ///
  /// Relative, so it resolves against the application's base href.
  static final Uri defaultSqlite3Uri = Uri.parse('sqlite3.wasm');

  /// Where `drift_worker.js` is looked up when [driftWorkerUri] is not
  /// provided.
  ///
  /// Relative, so it resolves against the application's base href.
  static final Uri defaultDriftWorkerUri = Uri.parse('drift_worker.js');

  /// Location of the sqlite3 WebAssembly module.
  ///
  /// Defaults to [defaultSqlite3Uri]. Override it when the file is not served
  /// next to the application's `index.html`.
  final Uri sqlite3Uri;

  /// Location of the drift web worker.
  ///
  /// Defaults to [defaultDriftWorkerUri]. Override it when the file is not
  /// served next to the application's `index.html`.
  final Uri driftWorkerUri;

  /// Whether to copy a database stored in IndexedDB over to the origin private
  /// file system once the browser supports it.
  ///
  /// Relevant when a browser first stored the cache in IndexedDB — because the
  /// application was served without the cross-origin isolation headers, for
  /// example — and a later visit could use the faster and safer file system
  /// instead. The copy deletes the IndexedDB database once it succeeds, so it
  /// is opt-in.
  final bool moveExistingIndexedDbToOpfs;

  @override
  String toString() =>
      'StreamChatPersistenceWebOptions('
      'sqlite3Uri: $sqlite3Uri, '
      'driftWorkerUri: $driftWorkerUri, '
      'moveExistingIndexedDbToOpfs: $moveExistingIndexedDbToOpfs)';
}
