import 'package:stream_chat/stream_chat.dart';
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

  group('isSameEventAs', () {
    final target = Event(type: EventType.typingStart);

    test('matches on type alone by default', () {
      expect(Event(type: EventType.typingStart, parentId: 'p1'), isSameEventAs(target));
      expect(Event(type: EventType.typingStop), isNot(isSameEventAs(target)));
    });

    test('compares the parent id when asked to', () {
      final matcher = isSameEventAs(target, matchParentId: true);
      expect(Event(type: EventType.typingStart), matcher);
      expect(Event(type: EventType.typingStart, parentId: 'p1'), isNot(matcher));
    });
  });
}
