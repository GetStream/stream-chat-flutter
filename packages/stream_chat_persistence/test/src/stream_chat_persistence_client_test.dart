import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';
import 'package:stream_chat_persistence/src/stream_chat_persistence_client.dart';
import 'package:test/test.dart';

void main() {
  group('connect', () {
    test('throws exception because already connected', () {
      final streamChatPersistenceClient = StreamChatPersistenceClient(
        connectionMode: ConnectionMode.background,
        logLevel: Level.INFO,
      )..db = MoorChatDatabase(
          'test',
          persistOnDisk: false,
        );

      expect(
        () => streamChatPersistenceClient.connect('test'),
        throwsA(allOf(isException, predicate((e) {
          return e.message ==
              'An instance of StreamChatDatabase is already connected.\n'
                  'disconnect the previous instance before connecting again.';
        }))),
      );
    });
  });
}
