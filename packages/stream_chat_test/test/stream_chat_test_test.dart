import 'package:stream_chat_test/stream_chat_test.dart';

void main() {
  group('stream_chat_test', () {
    test('re-exports package:test and package:mocktail', () {
      // `expect`, `group` and `test` come from the package:test re-export;
      // `Mock` comes from the package:mocktail re-export.
      expect(Mock, isNotNull);
    });

    test('provides canonical fixtures with deterministic defaults', () {
      final user = createDefaultUser();
      expect(user.id, 'luke_skywalker');
      expect(user.createdAt, testCreatedAt);
      expect(user.updatedAt, testUpdatedAt);

      final token = createTestToken(user.id);
      expect(token.userId, user.id);
    });
  });
}
