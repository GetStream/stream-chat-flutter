import 'package:stream_chat/src/core/models/user_group_member.dart';
import 'package:test/test.dart';

void main() {
  group('src/models/user_group_member', () {
    test('should parse json correctly', () {
      final member = UserGroupMember.fromJson(const {
        'group_id': 'g1',
        'user_id': 'user-1',
        'is_admin': true,
        'created_at': '2024-01-03T00:00:00Z',
      });

      expect(member.groupId, 'g1');
      expect(member.userId, 'user-1');
      expect(member.isAdmin, isTrue);
      expect(member.createdAt, DateTime.parse('2024-01-03T00:00:00Z'));
    });
  });
}
