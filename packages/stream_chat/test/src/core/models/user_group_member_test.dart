import 'package:stream_chat/src/core/models/user_group_member.dart';
import 'package:test/test.dart';

void main() {
  test('UserGroupMember.toData writes snake_case keys and an ISO date', () {
    final member = UserGroupMember(createdAt: DateTime.utc(2024, 1, 3), groupId: 'g1', isAdmin: true, userId: 'user-1');

    expect(member.toData(), {
      'created_at': '2024-01-03T00:00:00.000Z',
      'group_id': 'g1',
      'is_admin': true,
      'user_id': 'user-1',
    });
  });

  test('UserGroupMember.fromData reads back the member written by toData', () {
    final member = UserGroupMember(
      createdAt: DateTime.utc(2024, 1, 3),
      groupId: 'g1',
      isAdmin: false,
      userId: 'user-1',
    );

    expect(UserGroupMember.fromData(member.toData()), member);
  });
}
