import 'package:stream_chat/src/core/models/user_group.dart';
import 'package:stream_chat/src/core/models/user_group_member.dart';
import 'package:test/test.dart';

void main() {
  test('UserGroup.toData writes snake_case keys, ISO dates and nested members', () {
    final group = UserGroup(
      createdAt: DateTime.utc(2024, 1, 1),
      createdBy: 'creator-id',
      description: 'Engineering team',
      id: 'g1',
      members: [UserGroupMember(createdAt: DateTime.utc(2024, 1, 3), groupId: 'g1', isAdmin: true, userId: 'user-1')],
      name: 'Group 1',
      teamId: 'team-1',
      updatedAt: DateTime.utc(2024, 1, 2),
    );

    expect(group.toData(), {
      'created_at': '2024-01-01T00:00:00.000Z',
      'created_by': 'creator-id',
      'description': 'Engineering team',
      'id': 'g1',
      'members': [
        {'created_at': '2024-01-03T00:00:00.000Z', 'group_id': 'g1', 'is_admin': true, 'user_id': 'user-1'},
      ],
      'name': 'Group 1',
      'team_id': 'team-1',
      'updated_at': '2024-01-02T00:00:00.000Z',
    });
  });

  test('UserGroup.toData leaves out the fields that are null', () {
    final group = UserGroup(createdAt: DateTime.utc(2024), id: 'g1', name: 'Group 1', updatedAt: DateTime.utc(2024));

    expect(group.toData().keys, unorderedEquals(['created_at', 'id', 'name', 'updated_at']));
  });

  test('UserGroup.toData keeps an empty member list', () {
    final group = UserGroup(
      createdAt: DateTime.utc(2024),
      id: 'g1',
      members: const [],
      name: 'Group 1',
      updatedAt: DateTime.utc(2024),
    );

    expect(group.toData()['members'], isEmpty);
  });

  test('UserGroup.fromData reads back the group written by toData', () {
    final group = UserGroup(
      createdAt: DateTime.utc(2024, 1, 1),
      createdBy: 'creator-id',
      description: 'Engineering team',
      id: 'g1',
      members: [UserGroupMember(createdAt: DateTime.utc(2024, 1, 3), groupId: 'g1', isAdmin: true, userId: 'user-1')],
      name: 'Group 1',
      teamId: 'team-1',
      updatedAt: DateTime.utc(2024, 1, 2),
    );

    expect(UserGroup.fromData(group.toData()), group);
  });

  test('UserGroup.fromData reads a group stored without members as having no member list', () {
    final group = UserGroup.fromData(const {
      'created_at': '2024-01-01T00:00:00.000Z',
      'id': 'g1',
      'name': 'Group 1',
      'updated_at': '2024-01-02T00:00:00.000Z',
    });

    expect(group.members, isNull);
  });
}
