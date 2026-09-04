import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_persistence/src/db/web_options.dart';

void main() {
  group('StreamChatPersistenceWebOptions', () {
    test('defaults to the file names published in a drift release', () {
      final options = StreamChatPersistenceWebOptions();

      expect(options.sqlite3Uri.path, 'sqlite3.wasm');
      expect(options.driftWorkerUri.path, 'drift_worker.js');
    });

    test('default uris are relative so they resolve against the base href', () {
      final options = StreamChatPersistenceWebOptions();

      // An absolute uri would break every app served from a sub-path.
      expect(options.sqlite3Uri.hasScheme, isFalse);
      expect(options.sqlite3Uri.hasAbsolutePath, isFalse);
      expect(options.driftWorkerUri.hasScheme, isFalse);
      expect(options.driftWorkerUri.hasAbsolutePath, isFalse);
    });

    test('does not move an existing IndexedDB database by default', () {
      expect(StreamChatPersistenceWebOptions().moveExistingIndexedDbToOpfs, isFalse);
    });

    test('explicit uris take precedence over the defaults', () {
      final options = StreamChatPersistenceWebOptions(
        sqlite3Uri: Uri.parse('https://cdn.example.com/sqlite3.wasm'),
        driftWorkerUri: Uri.parse('/assets/drift_worker.js'),
        moveExistingIndexedDbToOpfs: true,
      );

      expect(options.sqlite3Uri, Uri.parse('https://cdn.example.com/sqlite3.wasm'));
      expect(options.driftWorkerUri, Uri.parse('/assets/drift_worker.js'));
      expect(options.moveExistingIndexedDbToOpfs, isTrue);
    });

    test('a single overridden uri leaves the other one at its default', () {
      final options = StreamChatPersistenceWebOptions(
        sqlite3Uri: Uri.parse('/assets/sqlite3.wasm'),
      );

      expect(options.sqlite3Uri, Uri.parse('/assets/sqlite3.wasm'));
      expect(options.driftWorkerUri, StreamChatPersistenceWebOptions.defaultDriftWorkerUri);
    });

    test('toString mentions every option', () {
      final options = StreamChatPersistenceWebOptions(
        sqlite3Uri: Uri.parse('/a.wasm'),
        driftWorkerUri: Uri.parse('/b.js'),
        moveExistingIndexedDbToOpfs: true,
      );

      expect(
        options.toString(),
        'StreamChatPersistenceWebOptions(sqlite3Uri: /a.wasm, driftWorkerUri: /b.js, '
        'moveExistingIndexedDbToOpfs: true)',
      );
    });
  });
}
