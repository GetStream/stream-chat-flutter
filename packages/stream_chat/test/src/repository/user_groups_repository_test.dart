import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/src/core/models/response/add_user_group_members_response.dart';
import 'package:stream_chat/src/core/models/response/create_user_group_response.dart';
import 'package:stream_chat/src/core/models/response/get_user_group_response.dart';
import 'package:stream_chat/src/core/models/response/list_user_groups_response.dart';
import 'package:stream_chat/src/core/models/response/remove_user_group_members_response.dart';
import 'package:stream_chat/src/core/models/response/search_user_groups_response.dart';
import 'package:stream_chat/src/core/models/response/update_user_group_response.dart';
import 'package:stream_chat/src/core/models/user_group.dart';
import 'package:stream_chat/src/repository/user_groups_repository.dart';
import 'package:stream_core/stream_core.dart';
import 'package:test/test.dart';

import '../mocks.dart';

const _error = StreamClientException(message: 'boom');

void main() {
  setUpAll(() {
    registerFallbackValue(const api.CreateUserGroupRequest(name: 'name'));
    registerFallbackValue(const api.UpdateUserGroupRequest());
    registerFallbackValue(const api.AddUserGroupMembersRequest(memberIds: []));
    registerFallbackValue(const api.RemoveUserGroupMembersRequest(memberIds: []));
  });

  test('UserGroupsRepository.listUserGroups forwards every parameter to the generated client', () async {
    final defaultApi = MockDefaultApi();
    _stubListUserGroups(defaultApi, const Result.success(api.ListUserGroupsResponse(duration: '0ms', userGroups: [])));

    await UserGroupsRepository(defaultApi).listUserGroups(
      limit: 10,
      idGt: 'cursor-id',
      createdAtGt: DateTime.utc(2024, 6, 15, 12),
      teamId: 'team-id',
    );

    verify(
      () => defaultApi.listUserGroups(
        limit: 10,
        idGt: 'cursor-id',
        createdAtGt: '2024-06-15T12:00:00.000Z',
        teamId: 'team-id',
      ),
    ).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('UserGroupsRepository.listUserGroups sends createdAtGt as a UTC timestamp', () async {
    final defaultApi = MockDefaultApi();
    _stubListUserGroups(defaultApi, const Result.success(api.ListUserGroupsResponse(duration: '0ms', userGroups: [])));
    final createdAtGt = DateTime.utc(2024, 6, 15, 12).toLocal();

    await UserGroupsRepository(defaultApi).listUserGroups(createdAtGt: createdAtGt);

    verify(() => defaultApi.listUserGroups(createdAtGt: '2024-06-15T12:00:00.000Z')).called(1);
  });

  test('UserGroupsRepository.listUserGroups returns the mapped response', () async {
    final defaultApi = MockDefaultApi();
    _stubListUserGroups(
      defaultApi,
      Result.success(api.ListUserGroupsResponse(duration: '0.01ms', userGroups: [_generatedGroup('group-id')])),
    );

    final res = await UserGroupsRepository(defaultApi).listUserGroups();

    expect(res.getOrNull(), ListUserGroupsResponse(duration: '0.01ms', userGroups: [_group('group-id')]));
  });

  test('UserGroupsRepository.listUserGroups returns the failure without throwing', () async {
    final defaultApi = MockDefaultApi();
    _stubListUserGroups(defaultApi, const Result.failure(_error));

    final res = await UserGroupsRepository(defaultApi).listUserGroups();

    expect(res.exceptionOrNull(), _error);
  });

  test('UserGroupsRepository.searchUserGroups forwards every parameter to the generated client', () async {
    final defaultApi = MockDefaultApi();
    _stubSearchUserGroups(
      defaultApi,
      const Result.success(api.SearchUserGroupsResponse(duration: '0ms', userGroups: [])),
    );

    await UserGroupsRepository(defaultApi).searchUserGroups(
      'eng',
      limit: 10,
      nameGt: 'engineering',
      idGt: 'cursor-id',
      teamId: 'team-id',
    );

    verify(
      () => defaultApi.searchUserGroups(
        query: 'eng',
        limit: 10,
        nameGt: 'engineering',
        idGt: 'cursor-id',
        teamId: 'team-id',
      ),
    ).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('UserGroupsRepository.searchUserGroups returns the mapped response', () async {
    final defaultApi = MockDefaultApi();
    _stubSearchUserGroups(
      defaultApi,
      Result.success(api.SearchUserGroupsResponse(duration: '0.01ms', userGroups: [_generatedGroup('group-id')])),
    );

    final res = await UserGroupsRepository(defaultApi).searchUserGroups('eng');

    expect(res.getOrNull(), SearchUserGroupsResponse(duration: '0.01ms', userGroups: [_group('group-id')]));
  });

  test('UserGroupsRepository.searchUserGroups returns the failure without throwing', () async {
    final defaultApi = MockDefaultApi();
    _stubSearchUserGroups(defaultApi, const Result.failure(_error));

    final res = await UserGroupsRepository(defaultApi).searchUserGroups('eng');

    expect(res.exceptionOrNull(), _error);
  });

  test('UserGroupsRepository.getUserGroup forwards the id and team', () async {
    final defaultApi = MockDefaultApi();
    _stubGetUserGroup(defaultApi, const Result.success(api.GetUserGroupResponse(duration: '0ms')));

    await UserGroupsRepository(defaultApi).getUserGroup('group-id', teamId: 'team-id');

    verify(() => defaultApi.getUserGroup(id: 'group-id', teamId: 'team-id')).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('UserGroupsRepository.getUserGroup returns the mapped response', () async {
    final defaultApi = MockDefaultApi();
    _stubGetUserGroup(
      defaultApi,
      Result.success(api.GetUserGroupResponse(duration: '0.01ms', userGroup: _generatedGroup('group-id'))),
    );

    final res = await UserGroupsRepository(defaultApi).getUserGroup('group-id');

    expect(res.getOrNull(), GetUserGroupResponse(duration: '0.01ms', userGroup: _group('group-id')));
  });

  test('UserGroupsRepository.getUserGroup returns the failure without throwing', () async {
    final defaultApi = MockDefaultApi();
    _stubGetUserGroup(defaultApi, const Result.failure(_error));

    final res = await UserGroupsRepository(defaultApi).getUserGroup('group-id');

    expect(res.exceptionOrNull(), _error);
  });

  test('UserGroupsRepository.createUserGroup forwards every parameter in the request', () async {
    final defaultApi = MockDefaultApi();
    _stubCreateUserGroup(defaultApi, const Result.success(api.CreateUserGroupResponse(duration: '0ms')));

    await UserGroupsRepository(defaultApi).createUserGroup(
      'Engineering',
      id: 'group-id',
      description: 'The engineers',
      teamId: 'team-id',
      memberIds: ['user-id'],
    );

    verify(
      () => defaultApi.createUserGroup(
        createUserGroupRequest: const api.CreateUserGroupRequest(
          name: 'Engineering',
          id: 'group-id',
          description: 'The engineers',
          teamId: 'team-id',
          memberIds: ['user-id'],
        ),
      ),
    ).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('UserGroupsRepository.createUserGroup returns the mapped response', () async {
    final defaultApi = MockDefaultApi();
    _stubCreateUserGroup(
      defaultApi,
      Result.success(api.CreateUserGroupResponse(duration: '0.01ms', userGroup: _generatedGroup('group-id'))),
    );

    final res = await UserGroupsRepository(defaultApi).createUserGroup('Engineering');

    expect(res.getOrNull(), CreateUserGroupResponse(duration: '0.01ms', userGroup: _group('group-id')));
  });

  test('UserGroupsRepository.createUserGroup returns the failure without throwing', () async {
    final defaultApi = MockDefaultApi();
    _stubCreateUserGroup(defaultApi, const Result.failure(_error));

    final res = await UserGroupsRepository(defaultApi).createUserGroup('Engineering');

    expect(res.exceptionOrNull(), _error);
  });

  test('UserGroupsRepository.updateUserGroup forwards the id and every field in the request', () async {
    final defaultApi = MockDefaultApi();
    _stubUpdateUserGroup(defaultApi, const Result.success(api.UpdateUserGroupResponse(duration: '0ms')));

    await UserGroupsRepository(defaultApi).updateUserGroup(
      'group-id',
      name: 'Engineering',
      description: 'The engineers',
      teamId: 'team-id',
    );

    verify(
      () => defaultApi.updateUserGroup(
        id: 'group-id',
        updateUserGroupRequest: const api.UpdateUserGroupRequest(
          name: 'Engineering',
          description: 'The engineers',
          teamId: 'team-id',
        ),
      ),
    ).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('UserGroupsRepository.updateUserGroup returns the mapped response', () async {
    final defaultApi = MockDefaultApi();
    _stubUpdateUserGroup(
      defaultApi,
      Result.success(api.UpdateUserGroupResponse(duration: '0.01ms', userGroup: _generatedGroup('group-id'))),
    );

    final res = await UserGroupsRepository(defaultApi).updateUserGroup('group-id', name: 'Engineering');

    expect(res.getOrNull(), UpdateUserGroupResponse(duration: '0.01ms', userGroup: _group('group-id')));
  });

  test('UserGroupsRepository.updateUserGroup returns the failure without throwing', () async {
    final defaultApi = MockDefaultApi();
    _stubUpdateUserGroup(defaultApi, const Result.failure(_error));

    final res = await UserGroupsRepository(defaultApi).updateUserGroup('group-id', name: 'Engineering');

    expect(res.exceptionOrNull(), _error);
  });

  test('UserGroupsRepository.deleteUserGroup forwards the id and team', () async {
    final defaultApi = MockDefaultApi();
    _stubDeleteUserGroup(defaultApi, const Result.success(api.DurationResponse(duration: '0ms')));

    await UserGroupsRepository(defaultApi).deleteUserGroup('group-id', teamId: 'team-id');

    verify(() => defaultApi.deleteUserGroup(id: 'group-id', teamId: 'team-id')).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test(
    'UserGroupsRepository.deleteUserGroup returns a success with no value when the server deletes the group',
    () async {
      final defaultApi = MockDefaultApi();
      _stubDeleteUserGroup(defaultApi, const Result.success(api.DurationResponse(duration: '0.01ms')));

      final res = await UserGroupsRepository(defaultApi).deleteUserGroup('group-id');

      expect(res, const Result<void>.success(null));
    },
  );

  test('UserGroupsRepository.deleteUserGroup returns the failure without throwing', () async {
    final defaultApi = MockDefaultApi();
    _stubDeleteUserGroup(defaultApi, const Result.failure(_error));

    final res = await UserGroupsRepository(defaultApi).deleteUserGroup('group-id');

    expect(res.exceptionOrNull(), _error);
  });

  test('UserGroupsRepository.addUserGroupMembers forwards the id and every field in the request', () async {
    final defaultApi = MockDefaultApi();
    _stubAddUserGroupMembers(defaultApi, const Result.success(api.AddUserGroupMembersResponse(duration: '0ms')));

    await UserGroupsRepository(defaultApi).addUserGroupMembers(
      'group-id',
      ['user-id'],
      asAdmin: true,
      teamId: 'team-id',
    );

    verify(
      () => defaultApi.addUserGroupMembers(
        id: 'group-id',
        addUserGroupMembersRequest: const api.AddUserGroupMembersRequest(
          memberIds: ['user-id'],
          asAdmin: true,
          teamId: 'team-id',
        ),
      ),
    ).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('UserGroupsRepository.addUserGroupMembers returns the mapped response', () async {
    final defaultApi = MockDefaultApi();
    _stubAddUserGroupMembers(
      defaultApi,
      Result.success(api.AddUserGroupMembersResponse(duration: '0.01ms', userGroup: _generatedGroup('group-id'))),
    );

    final res = await UserGroupsRepository(defaultApi).addUserGroupMembers('group-id', ['user-id']);

    expect(res.getOrNull(), AddUserGroupMembersResponse(duration: '0.01ms', userGroup: _group('group-id')));
  });

  test('UserGroupsRepository.addUserGroupMembers returns the failure without throwing', () async {
    final defaultApi = MockDefaultApi();
    _stubAddUserGroupMembers(defaultApi, const Result.failure(_error));

    final res = await UserGroupsRepository(defaultApi).addUserGroupMembers('group-id', ['user-id']);

    expect(res.exceptionOrNull(), _error);
  });

  test('UserGroupsRepository.removeUserGroupMembers forwards the id and every field in the request', () async {
    final defaultApi = MockDefaultApi();
    _stubRemoveUserGroupMembers(defaultApi, const Result.success(api.RemoveUserGroupMembersResponse(duration: '0ms')));

    await UserGroupsRepository(defaultApi).removeUserGroupMembers('group-id', ['user-id'], teamId: 'team-id');

    verify(
      () => defaultApi.removeUserGroupMembers(
        id: 'group-id',
        removeUserGroupMembersRequest: const api.RemoveUserGroupMembersRequest(
          memberIds: ['user-id'],
          teamId: 'team-id',
        ),
      ),
    ).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('UserGroupsRepository.removeUserGroupMembers returns the mapped response', () async {
    final defaultApi = MockDefaultApi();
    _stubRemoveUserGroupMembers(
      defaultApi,
      Result.success(api.RemoveUserGroupMembersResponse(duration: '0.01ms', userGroup: _generatedGroup('group-id'))),
    );

    final res = await UserGroupsRepository(defaultApi).removeUserGroupMembers('group-id', ['user-id']);

    expect(res.getOrNull(), RemoveUserGroupMembersResponse(duration: '0.01ms', userGroup: _group('group-id')));
  });

  test('UserGroupsRepository.removeUserGroupMembers returns the failure without throwing', () async {
    final defaultApi = MockDefaultApi();
    _stubRemoveUserGroupMembers(defaultApi, const Result.failure(_error));

    final res = await UserGroupsRepository(defaultApi).removeUserGroupMembers('group-id', ['user-id']);

    expect(res.exceptionOrNull(), _error);
  });
}

void _stubListUserGroups(MockDefaultApi defaultApi, Result<api.ListUserGroupsResponse> result) {
  when(
    () => defaultApi.listUserGroups(
      limit: any(named: 'limit'),
      idGt: any(named: 'idGt'),
      createdAtGt: any(named: 'createdAtGt'),
      teamId: any(named: 'teamId'),
    ),
  ).thenAnswer((_) async => result);
}

void _stubSearchUserGroups(MockDefaultApi defaultApi, Result<api.SearchUserGroupsResponse> result) {
  when(
    () => defaultApi.searchUserGroups(
      query: any(named: 'query'),
      limit: any(named: 'limit'),
      nameGt: any(named: 'nameGt'),
      idGt: any(named: 'idGt'),
      teamId: any(named: 'teamId'),
    ),
  ).thenAnswer((_) async => result);
}

void _stubGetUserGroup(MockDefaultApi defaultApi, Result<api.GetUserGroupResponse> result) {
  when(
    () => defaultApi.getUserGroup(
      id: any(named: 'id'),
      teamId: any(named: 'teamId'),
    ),
  ).thenAnswer((_) async => result);
}

void _stubCreateUserGroup(MockDefaultApi defaultApi, Result<api.CreateUserGroupResponse> result) {
  when(
    () => defaultApi.createUserGroup(createUserGroupRequest: any(named: 'createUserGroupRequest')),
  ).thenAnswer((_) async => result);
}

void _stubUpdateUserGroup(MockDefaultApi defaultApi, Result<api.UpdateUserGroupResponse> result) {
  when(
    () => defaultApi.updateUserGroup(
      id: any(named: 'id'),
      updateUserGroupRequest: any(named: 'updateUserGroupRequest'),
    ),
  ).thenAnswer((_) async => result);
}

void _stubDeleteUserGroup(MockDefaultApi defaultApi, Result<api.DurationResponse> result) {
  when(
    () => defaultApi.deleteUserGroup(
      id: any(named: 'id'),
      teamId: any(named: 'teamId'),
    ),
  ).thenAnswer((_) async => result);
}

void _stubAddUserGroupMembers(MockDefaultApi defaultApi, Result<api.AddUserGroupMembersResponse> result) {
  when(
    () => defaultApi.addUserGroupMembers(
      id: any(named: 'id'),
      addUserGroupMembersRequest: any(named: 'addUserGroupMembersRequest'),
    ),
  ).thenAnswer((_) async => result);
}

void _stubRemoveUserGroupMembers(MockDefaultApi defaultApi, Result<api.RemoveUserGroupMembersResponse> result) {
  when(
    () => defaultApi.removeUserGroupMembers(
      id: any(named: 'id'),
      removeUserGroupMembersRequest: any(named: 'removeUserGroupMembersRequest'),
    ),
  ).thenAnswer((_) async => result);
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
