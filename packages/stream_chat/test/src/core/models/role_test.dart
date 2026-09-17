import 'package:stream_chat/open_api/models.dart';
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

    test('should parse epoch nanosecond timestamps', () {
      final role = Role.fromJson(const {
        'name': 'admin',
        'custom': false,
        'scopes': ['.app'],
        'created_at': 1704067200000000000,
        'updated_at': 1704153600000000000,
      });

      expect(role.createdAt, DateTime.parse('2024-01-01T00:00:00Z'));
      expect(role.updatedAt, DateTime.parse('2024-01-02T00:00:00Z'));
    });

    test('should serialize to json correctly', () {
      final role = Role(
        name: 'custom_moderator',
        custom: true,
        scopes: const ['.app', 'messaging'],
        createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
        updatedAt: DateTime.parse('2024-01-02T00:00:00Z'),
      );

      expect(role.toJson(), {
        'name': 'custom_moderator',
        'custom': true,
        'scopes': ['.app', 'messaging'],
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-02T00:00:00.000Z',
      });
    });
  });
}
