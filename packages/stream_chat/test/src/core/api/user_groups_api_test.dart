// ignore_for_file: avoid_redundant_argument_values

import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/api/user_groups_api.dart';
import 'package:test/test.dart';

import '../../mocks.dart';

void main() {
  Response successResponse(String path, {Object? data}) => Response(
    data: data,
    requestOptions: RequestOptions(path: path),
    statusCode: 200,
  );

  Map<String, dynamic> userGroupJson({
    String id = 'test-group-id',
    String name = 'test-group-name',
    String? description,
    String? teamId,
    String? createdBy,
    List<Map<String, dynamic>>? members,
  }) => {
    'id': id,
    'name': name,
    if (description != null) 'description': description,
    if (teamId != null) 'team_id': teamId,
    if (createdBy != null) 'created_by': createdBy,
    if (members != null) 'members': members,
    'created_at': '2024-01-01T00:00:00Z',
    'updated_at': '2024-01-02T00:00:00Z',
  };

  Map<String, dynamic> userGroupMemberJson({
    String groupId = 'test-group-id',
    String userId = 'test-user-id',
    bool isAdmin = false,
  }) => {
    'group_id': groupId,
    'user_id': userId,
    'is_admin': isAdmin,
    'created_at': '2024-01-01T00:00:00Z',
  };

  late final client = MockHttpClient();
  late UserGroupsApi userGroupsApi;

  setUp(() {
    userGroupsApi = UserGroupsApi(client);
  });

  group('listUserGroups', () {
    test('should list with no parameters', () async {
      const path = '/usergroups';

      when(() => client.get(path, queryParameters: {})).thenAnswer(
        (_) async => successResponse(path, data: {'user_groups': <Map>[]}),
      );

      final res = await userGroupsApi.listUserGroups();

      expect(res, isNotNull);
      expect(res.userGroups, isEmpty);

      verify(
        () => client.get(path, queryParameters: any(named: 'queryParameters')),
      ).called(1);
      verifyNoMoreInteractions(client);
    });

    test('should list with all parameters', () async {
      const path = '/usergroups';
      const limit = 25;
      const idGt = 'cursor-group-id';
      // Intentionally non-UTC so we exercise `.toUtc().toIso8601String()`.
      final createdAtGt = DateTime.utc(2024, 6, 15, 12).toLocal();
      const teamId = 'test-team-id';

      final expectedQueryParameters = {
        'limit': limit,
        'id_gt': idGt,
        'created_at_gt': createdAtGt.toUtc().toIso8601String(),
        'team_id': teamId,
      };

      when(() => client.get(path, queryParameters: expectedQueryParameters)).thenAnswer(
        (_) async => successResponse(
          path,
          data: {
            'user_groups': [userGroupJson()],
          },
        ),
      );

      final res = await userGroupsApi.listUserGroups(
        limit: limit,
        idGt: idGt,
        createdAtGt: createdAtGt,
        teamId: teamId,
      );

      expect(res, isNotNull);
      expect(res.userGroups, hasLength(1));

      verify(
        () => client.get(path, queryParameters: expectedQueryParameters),
      ).called(1);
      verifyNoMoreInteractions(client);
    });
  });

  group('searchUserGroups', () {
    test('should search with query only', () async {
      const path = '/usergroups/search';
      const query = 'eng';

      when(() => client.get(path, queryParameters: {'query': query})).thenAnswer(
        (_) async => successResponse(path, data: {'user_groups': <Map>[]}),
      );

      final res = await userGroupsApi.searchUserGroups(query);

      expect(res, isNotNull);
      expect(res.userGroups, isEmpty);

      verify(
        () => client.get(path, queryParameters: {'query': query}),
      ).called(1);
      verifyNoMoreInteractions(client);
    });

    test('should search with all parameters', () async {
      const path = '/usergroups/search';
      const query = 'eng';
      const limit = 10;
      const nameGt = 'engineering';
      const idGt = 'cursor-group-id';
      const teamId = 'test-team-id';

      final expectedQueryParameters = {
        'query': query,
        'limit': limit,
        'name_gt': nameGt,
        'id_gt': idGt,
        'team_id': teamId,
      };

      when(() => client.get(path, queryParameters: expectedQueryParameters)).thenAnswer(
        (_) async => successResponse(
          path,
          data: {
            'user_groups': [userGroupJson()],
          },
        ),
      );

      final res = await userGroupsApi.searchUserGroups(
        query,
        limit: limit,
        nameGt: nameGt,
        idGt: idGt,
        teamId: teamId,
      );

      expect(res, isNotNull);
      expect(res.userGroups, hasLength(1));

      verify(
        () => client.get(path, queryParameters: expectedQueryParameters),
      ).called(1);
      verifyNoMoreInteractions(client);
    });
  });

  group('getUserGroup', () {
    test('should get with id only', () async {
      const id = 'test-group-id';
      const path = '/usergroups/$id';

      when(() => client.get(path, queryParameters: {})).thenAnswer(
        (_) async => successResponse(
          path,
          data: {
            'user_group': userGroupJson(
              id: id,
              members: [userGroupMemberJson(groupId: id)],
            ),
          },
        ),
      );

      final res = await userGroupsApi.getUserGroup(id);

      expect(res, isNotNull);
      expect(res.userGroup.id, id);
      expect(res.userGroup.members, isNotNull);
      expect(res.userGroup.members, hasLength(1));

      verify(
        () => client.get(path, queryParameters: any(named: 'queryParameters')),
      ).called(1);
      verifyNoMoreInteractions(client);
    });

    test('should get with teamId', () async {
      const id = 'test-group-id';
      const teamId = 'test-team-id';
      const path = '/usergroups/$id';

      when(() => client.get(path, queryParameters: {'team_id': teamId})).thenAnswer(
        (_) async => successResponse(
          path,
          data: {
            'user_group': userGroupJson(id: id, teamId: teamId),
          },
        ),
      );

      final res = await userGroupsApi.getUserGroup(id, teamId: teamId);

      expect(res, isNotNull);
      expect(res.userGroup.id, id);
      expect(res.userGroup.teamId, teamId);

      verify(
        () => client.get(path, queryParameters: {'team_id': teamId}),
      ).called(1);
      verifyNoMoreInteractions(client);
    });
  });

  group('createUserGroup', () {
    test('should create with name only', () async {
      const path = '/usergroups';
      const name = 'Engineering';

      when(() => client.post(path, data: {'name': name})).thenAnswer(
        (_) async => successResponse(
          path,
          data: {
            'user_group': userGroupJson(name: name),
          },
        ),
      );

      final res = await userGroupsApi.createUserGroup(name);

      expect(res, isNotNull);
      expect(res.userGroup.name, name);

      verify(() => client.post(path, data: {'name': name})).called(1);
      verifyNoMoreInteractions(client);
    });

    test('should create with all parameters', () async {
      const path = '/usergroups';
      const name = 'Engineering';
      const id = 'eng';
      const description = 'Engineering team';
      const teamId = 'test-team-id';
      const memberIds = ['user-1', 'user-2'];

      final expectedData = {
        'name': name,
        'id': id,
        'description': description,
        'team_id': teamId,
        'member_ids': memberIds,
      };

      when(() => client.post(path, data: expectedData)).thenAnswer(
        (_) async => successResponse(
          path,
          data: {
            'user_group': userGroupJson(
              id: id,
              name: name,
              description: description,
              teamId: teamId,
            ),
          },
        ),
      );

      final res = await userGroupsApi.createUserGroup(
        name,
        id: id,
        description: description,
        teamId: teamId,
        memberIds: memberIds,
      );

      expect(res, isNotNull);
      expect(res.userGroup.id, id);
      expect(res.userGroup.description, description);

      verify(() => client.post(path, data: expectedData)).called(1);
      verifyNoMoreInteractions(client);
    });
  });

  group('updateUserGroup', () {
    test('should update with name only', () async {
      const id = 'test-group-id';
      const path = '/usergroups/$id';
      const name = 'New Name';

      when(() => client.put(path, data: {'name': name})).thenAnswer(
        (_) async => successResponse(
          path,
          data: {
            'user_group': userGroupJson(id: id, name: name),
          },
        ),
      );

      final res = await userGroupsApi.updateUserGroup(id, name: name);

      expect(res, isNotNull);
      expect(res.userGroup.name, name);

      verify(() => client.put(path, data: {'name': name})).called(1);
      verifyNoMoreInteractions(client);
    });

    test('should update with all parameters (empty description clears it)', () async {
      const id = 'test-group-id';
      const path = '/usergroups/$id';
      const name = 'New Name';
      // Empty string is forwarded to the server (which uses it to clear the
      // description); null would omit the key entirely.
      const description = '';
      const teamId = 'test-team-id';

      final expectedData = {
        'name': name,
        'description': description,
        'team_id': teamId,
      };

      when(() => client.put(path, data: expectedData)).thenAnswer(
        (_) async => successResponse(
          path,
          data: {
            'user_group': userGroupJson(id: id, name: name, teamId: teamId),
          },
        ),
      );

      final res = await userGroupsApi.updateUserGroup(
        id,
        name: name,
        description: description,
        teamId: teamId,
      );

      expect(res, isNotNull);
      expect(res.userGroup.name, name);

      verify(() => client.put(path, data: expectedData)).called(1);
      verifyNoMoreInteractions(client);
    });
  });

  group('deleteUserGroup', () {
    test('should delete with id only', () async {
      const id = 'test-group-id';
      const path = '/usergroups/$id';

      when(() => client.delete(path, queryParameters: {})).thenAnswer(
        (_) async => successResponse(path, data: <String, dynamic>{}),
      );

      final res = await userGroupsApi.deleteUserGroup(id);

      expect(res, isNotNull);

      verify(
        () => client.delete(path, queryParameters: any(named: 'queryParameters')),
      ).called(1);
      verifyNoMoreInteractions(client);
    });

    test('should delete with teamId', () async {
      const id = 'test-group-id';
      const teamId = 'test-team-id';
      const path = '/usergroups/$id';

      when(() => client.delete(path, queryParameters: {'team_id': teamId})).thenAnswer(
        (_) async => successResponse(path, data: <String, dynamic>{}),
      );

      final res = await userGroupsApi.deleteUserGroup(id, teamId: teamId);

      expect(res, isNotNull);

      verify(
        () => client.delete(path, queryParameters: {'team_id': teamId}),
      ).called(1);
      verifyNoMoreInteractions(client);
    });
  });

  group('addUserGroupMembers', () {
    test('should add members with required arguments only', () async {
      const id = 'test-group-id';
      const path = '/usergroups/$id/members';
      const memberIds = ['user-1', 'user-2'];

      when(() => client.post(path, data: {'member_ids': memberIds})).thenAnswer(
        (_) async => successResponse(
          path,
          data: {
            'user_group': userGroupJson(
              id: id,
              members: memberIds.map((it) => userGroupMemberJson(groupId: id, userId: it)).toList(),
            ),
          },
        ),
      );

      final res = await userGroupsApi.addUserGroupMembers(id, memberIds);

      expect(res, isNotNull);
      expect(res.userGroup.members, hasLength(memberIds.length));

      verify(() => client.post(path, data: {'member_ids': memberIds})).called(1);
      verifyNoMoreInteractions(client);
    });

    test('should add members with asAdmin and teamId', () async {
      const id = 'test-group-id';
      const path = '/usergroups/$id/members';
      const memberIds = ['user-1', 'user-2'];
      const asAdmin = true;
      const teamId = 'test-team-id';

      final expectedData = {
        'member_ids': memberIds,
        'as_admin': asAdmin,
        'team_id': teamId,
      };

      when(() => client.post(path, data: expectedData)).thenAnswer(
        (_) async => successResponse(
          path,
          data: {
            'user_group': userGroupJson(id: id, teamId: teamId),
          },
        ),
      );

      final res = await userGroupsApi.addUserGroupMembers(
        id,
        memberIds,
        asAdmin: asAdmin,
        teamId: teamId,
      );

      expect(res, isNotNull);

      verify(() => client.post(path, data: expectedData)).called(1);
      verifyNoMoreInteractions(client);
    });
  });

  group('removeUserGroupMembers', () {
    test('should remove members with required arguments only', () async {
      const id = 'test-group-id';
      const path = '/usergroups/$id/members/delete';
      const memberIds = ['user-1', 'user-2'];

      when(() => client.post(path, data: {'member_ids': memberIds})).thenAnswer(
        (_) async => successResponse(
          path,
          data: {
            'user_group': userGroupJson(id: id),
          },
        ),
      );

      final res = await userGroupsApi.removeUserGroupMembers(id, memberIds);

      expect(res, isNotNull);

      verify(() => client.post(path, data: {'member_ids': memberIds})).called(1);
      verifyNoMoreInteractions(client);
    });

    test('should remove members with teamId', () async {
      const id = 'test-group-id';
      const path = '/usergroups/$id/members/delete';
      const memberIds = ['user-1', 'user-2'];
      const teamId = 'test-team-id';

      final expectedData = {
        'member_ids': memberIds,
        'team_id': teamId,
      };

      when(() => client.post(path, data: expectedData)).thenAnswer(
        (_) async => successResponse(
          path,
          data: {
            'user_group': userGroupJson(id: id, teamId: teamId),
          },
        ),
      );

      final res = await userGroupsApi.removeUserGroupMembers(
        id,
        memberIds,
        teamId: teamId,
      );

      expect(res, isNotNull);

      verify(() => client.post(path, data: expectedData)).called(1);
      verifyNoMoreInteractions(client);
    });
  });
}
