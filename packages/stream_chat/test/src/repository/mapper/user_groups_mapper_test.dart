import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/src/core/models/add_user_group_members_response.dart';
import 'package:stream_chat/src/core/models/create_user_group_response.dart';
import 'package:stream_chat/src/core/models/get_user_group_response.dart';
import 'package:stream_chat/src/core/models/list_user_groups_response.dart';
import 'package:stream_chat/src/core/models/remove_user_group_members_response.dart';
import 'package:stream_chat/src/core/models/search_user_groups_response.dart';
import 'package:stream_chat/src/core/models/update_user_group_response.dart';
import 'package:stream_chat/src/core/models/user_group.dart';
import 'package:stream_chat/src/core/models/user_group_member.dart';
import 'package:stream_chat/src/repository/mapper/user_groups_mapper.dart';
import 'package:test/test.dart';

void main() {
  test('UserGroupResponse.toModel maps every field of a fully populated response', () {
    final response = api.UserGroupResponse(
      createdAt: DateTime.utc(2024, 1, 2),
      createdBy: 'user-id',
      description: 'Everyone on call this week',
      id: 'group-id',
      members: [
        _generatedMember(userId: 'user-1', isAdmin: true),
        _generatedMember(userId: 'user-2', isAdmin: false),
      ],
      name: 'on-call',
      teamId: 'team-id',
      updatedAt: DateTime.utc(2024, 3, 4),
    );

    expect(
      response.toModel(),
      UserGroup(
        createdAt: DateTime.utc(2024, 1, 2),
        createdBy: 'user-id',
        description: 'Everyone on call this week',
        id: 'group-id',
        members: [
          _member(userId: 'user-1', isAdmin: true),
          _member(userId: 'user-2', isAdmin: false),
        ],
        name: 'on-call',
        teamId: 'team-id',
        updatedAt: DateTime.utc(2024, 3, 4),
      ),
    );
  });

  test('UserGroupResponse.toModel keeps members null when the response leaves them out', () {
    final response = _generatedGroupWithMembers(null);

    expect(response.toModel().members, isNull);
  });

  test('UserGroupResponse.toModel keeps an empty member list empty', () {
    final response = _generatedGroupWithMembers(const []);

    expect(response.toModel().members, isEmpty);
  });

  test('UserGroupMember.toModel maps every field except the app id', () {
    final member = api.UserGroupMember(
      appPk: 42,
      createdAt: DateTime.utc(2024, 5, 6),
      groupId: 'group-id',
      isAdmin: true,
      userId: 'user-id',
    );

    expect(
      member.toModel(),
      UserGroupMember(
        createdAt: DateTime.utc(2024, 5, 6),
        groupId: 'group-id',
        isAdmin: true,
        userId: 'user-id',
      ),
    );
  });

  test('ListUserGroupsResponse.toModel maps the duration and every group in order', () {
    final response = api.ListUserGroupsResponse(
      duration: '0.01ms',
      userGroups: [_generatedGroup('group-1'), _generatedGroup('group-2')],
    );

    expect(
      response.toModel(),
      ListUserGroupsResponse(duration: '0.01ms', userGroups: [_group('group-1'), _group('group-2')]),
    );
  });

  test('SearchUserGroupsResponse.toModel maps the duration and every group in order', () {
    final response = api.SearchUserGroupsResponse(
      duration: '0.01ms',
      userGroups: [_generatedGroup('group-1'), _generatedGroup('group-2')],
    );

    expect(
      response.toModel(),
      SearchUserGroupsResponse(duration: '0.01ms', userGroups: [_group('group-1'), _group('group-2')]),
    );
  });

  test('GetUserGroupResponse.toModel maps the duration and the group', () {
    final response = api.GetUserGroupResponse(duration: '0.01ms', userGroup: _generatedGroup('group-id'));

    expect(response.toModel(), GetUserGroupResponse(duration: '0.01ms', userGroup: _group('group-id')));
  });

  test('GetUserGroupResponse.toModel keeps a missing group null', () {
    const response = api.GetUserGroupResponse(duration: '0.01ms');

    expect(response.toModel().userGroup, isNull);
  });

  test('CreateUserGroupResponse.toModel maps the duration and the group', () {
    final response = api.CreateUserGroupResponse(duration: '0.01ms', userGroup: _generatedGroup('group-id'));

    expect(response.toModel(), CreateUserGroupResponse(duration: '0.01ms', userGroup: _group('group-id')));
  });

  test('CreateUserGroupResponse.toModel keeps a missing group null', () {
    const response = api.CreateUserGroupResponse(duration: '0.01ms');

    expect(response.toModel().userGroup, isNull);
  });

  test('UpdateUserGroupResponse.toModel maps the duration and the group', () {
    final response = api.UpdateUserGroupResponse(duration: '0.01ms', userGroup: _generatedGroup('group-id'));

    expect(response.toModel(), UpdateUserGroupResponse(duration: '0.01ms', userGroup: _group('group-id')));
  });

  test('UpdateUserGroupResponse.toModel keeps a missing group null', () {
    const response = api.UpdateUserGroupResponse(duration: '0.01ms');

    expect(response.toModel().userGroup, isNull);
  });

  test('AddUserGroupMembersResponse.toModel maps the duration and the group', () {
    final response = api.AddUserGroupMembersResponse(duration: '0.01ms', userGroup: _generatedGroup('group-id'));

    expect(response.toModel(), AddUserGroupMembersResponse(duration: '0.01ms', userGroup: _group('group-id')));
  });

  test('AddUserGroupMembersResponse.toModel keeps a missing group null', () {
    const response = api.AddUserGroupMembersResponse(duration: '0.01ms');

    expect(response.toModel().userGroup, isNull);
  });

  test('RemoveUserGroupMembersResponse.toModel maps the duration and the group', () {
    final response = api.RemoveUserGroupMembersResponse(duration: '0.01ms', userGroup: _generatedGroup('group-id'));

    expect(response.toModel(), RemoveUserGroupMembersResponse(duration: '0.01ms', userGroup: _group('group-id')));
  });

  test('RemoveUserGroupMembersResponse.toModel keeps a missing group null', () {
    const response = api.RemoveUserGroupMembersResponse(duration: '0.01ms');

    expect(response.toModel().userGroup, isNull);
  });
}

api.UserGroupResponse _generatedGroup(String id) {
  return api.UserGroupResponse(
    createdAt: DateTime.utc(2024),
    id: id,
    name: 'name-$id',
    updatedAt: DateTime.utc(2024),
  );
}

UserGroup _group(String id) {
  return UserGroup(
    createdAt: DateTime.utc(2024),
    id: id,
    name: 'name-$id',
    updatedAt: DateTime.utc(2024),
  );
}

api.UserGroupResponse _generatedGroupWithMembers(List<api.UserGroupMember>? members) {
  return api.UserGroupResponse(
    createdAt: DateTime.utc(2024),
    id: 'group-id',
    members: members,
    name: 'on-call',
    updatedAt: DateTime.utc(2024),
  );
}

api.UserGroupMember _generatedMember({required String userId, required bool isAdmin}) {
  return api.UserGroupMember(
    appPk: 1,
    createdAt: DateTime.utc(2024),
    groupId: 'group-id',
    isAdmin: isAdmin,
    userId: userId,
  );
}

UserGroupMember _member({required String userId, required bool isAdmin}) {
  return UserGroupMember(
    createdAt: DateTime.utc(2024),
    groupId: 'group-id',
    isAdmin: isAdmin,
    userId: userId,
  );
}
