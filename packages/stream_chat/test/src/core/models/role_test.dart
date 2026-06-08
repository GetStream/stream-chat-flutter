import 'package:stream_chat/src/core/models/role.dart';
import 'package:test/test.dart';

void main() {
  group('src/models/role', () {
    test('should parse json correctly', () {
      final role = Role.fromJson(const {
        'name': 'custom_moderator',
        'custom': true,
        'scopes': ['.app', 'messaging', 'livestream'],
        'created_at': '2024-01-01T00:00:00Z',
        'updated_at': '2024-01-02T00:00:00Z',
      });

      expect(role.name, 'custom_moderator');
      expect(role.custom, isTrue);
      expect(role.scopes, ['.app', 'messaging', 'livestream']);
      expect(role.createdAt, DateTime.parse('2024-01-01T00:00:00Z'));
      expect(role.updatedAt, DateTime.parse('2024-01-02T00:00:00Z'));
    });
  });
}
