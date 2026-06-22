import 'package:stream_chat/src/core/models/user_group.dart';
import 'package:stream_chat/src/core/models/user_group_member.dart';
import 'package:test/test.dart';

void main() {
  group('src/models/user_group', () {
    test('should parse json correctly', () {
      final group = UserGroup.fromJson(const {
        'id': 'g1',
        'name': 'Group 1',
        'description': 'Engineering team',
        'team_id': 'team-1',
        'created_by': 'creator-id',
        'members': [
          {
            'group_id': 'g1',
            'user_id': 'user-1',
            'is_admin': true,
            'created_at': '2024-01-03T00:00:00Z',
          },
          {
            'group_id': 'g1',
            'user_id': 'user-2',
            'is_admin': false,
            'created_at': '2024-01-04T00:00:00Z',
          },
        ],
        'created_at': '2024-01-01T00:00:00Z',
        'updated_at': '2024-01-02T00:00:00Z',
      });

      expect(group.id, 'g1');
      expect(group.name, 'Group 1');
      expect(group.description, 'Engineering team');
      expect(group.teamId, 'team-1');
      expect(group.createdBy, 'creator-id');
      expect(group.createdAt, DateTime.parse('2024-01-01T00:00:00Z'));
      expect(group.updatedAt, DateTime.parse('2024-01-02T00:00:00Z'));

      expect(group.members, isA<List<UserGroupMember>>());
      expect(group.members, hasLength(2));
      expect(group.members!.first.userId, 'user-1');
      expect(group.members!.first.isAdmin, isTrue);
      expect(group.members!.last.userId, 'user-2');
      expect(group.members!.last.isAdmin, isFalse);
    });
  });
}
