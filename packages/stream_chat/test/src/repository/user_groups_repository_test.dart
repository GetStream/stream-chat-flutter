import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
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

  test('UserGroupsRepository.listUserGroups sends createdAtGt as a UTC timestamp', () async {
    final defaultApi = MockDefaultApi();
    _stubListUserGroups(defaultApi, const Result.success(api.ListUserGroupsResponse(duration: '0ms', userGroups: [])));
    final createdAtGt = DateTime.utc(2024, 6, 15, 12).toLocal();

    await UserGroupsRepository(defaultApi).listUserGroups(createdAtGt: createdAtGt);

    verify(() => defaultApi.listUserGroups(createdAtGt: '2024-06-15T12:00:00.000Z')).called(1);
  });

  test('UserGroupsRepository.listUserGroups returns the failure without throwing', () async {
    final defaultApi = MockDefaultApi();
    _stubListUserGroups(defaultApi, const Result.failure(_error));

    final res = await UserGroupsRepository(defaultApi).listUserGroups();

    expect(res.exceptionOrNull(), _error);
  });

  test('UserGroupsRepository.searchUserGroups returns the failure without throwing', () async {
    final defaultApi = MockDefaultApi();
    _stubSearchUserGroups(defaultApi, const Result.failure(_error));

    final res = await UserGroupsRepository(defaultApi).searchUserGroups('eng');

    expect(res.exceptionOrNull(), _error);
  });

  test('UserGroupsRepository.getUserGroup returns the failure without throwing', () async {
    final defaultApi = MockDefaultApi();
    _stubGetUserGroup(defaultApi, const Result.failure(_error));

    final res = await UserGroupsRepository(defaultApi).getUserGroup('group-id');

    expect(res.exceptionOrNull(), _error);
  });

  test('UserGroupsRepository.createUserGroup returns the failure without throwing', () async {
    final defaultApi = MockDefaultApi();
    _stubCreateUserGroup(defaultApi, const Result.failure(_error));

    final res = await UserGroupsRepository(defaultApi).createUserGroup('Engineering');

    expect(res.exceptionOrNull(), _error);
  });

  test('UserGroupsRepository.updateUserGroup returns the failure without throwing', () async {
    final defaultApi = MockDefaultApi();
    _stubUpdateUserGroup(defaultApi, const Result.failure(_error));

    final res = await UserGroupsRepository(defaultApi).updateUserGroup('group-id', name: 'Engineering');

    expect(res.exceptionOrNull(), _error);
  });

  test('UserGroupsRepository.deleteUserGroup returns the failure without throwing', () async {
    final defaultApi = MockDefaultApi();
    _stubDeleteUserGroup(defaultApi, const Result.failure(_error));

    final res = await UserGroupsRepository(defaultApi).deleteUserGroup('group-id');

    expect(res.exceptionOrNull(), _error);
  });

  test('UserGroupsRepository.addUserGroupMembers returns the failure without throwing', () async {
    final defaultApi = MockDefaultApi();
    _stubAddUserGroupMembers(defaultApi, const Result.failure(_error));

    final res = await UserGroupsRepository(defaultApi).addUserGroupMembers('group-id', ['user-id']);

    expect(res.exceptionOrNull(), _error);
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
