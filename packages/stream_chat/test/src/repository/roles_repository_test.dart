// ignore_for_file: avoid_redundant_argument_values

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/src/core/models/role_type.dart';
import 'package:stream_chat/src/repository/roles_repository.dart';
import 'package:stream_core/stream_core.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  test('RolesRepository.searchRoles forwards only the query when nothing else is passed', () async {
    final defaultApi = MockDefaultApi();
    when(() => defaultApi.searchRoles(query: 'adm')).thenAnswer(
      (_) async => const Result.success(api.SearchRolesResponse(duration: '0.01ms', roles: [])),
    );

    await RolesRepository(defaultApi).searchRoles('adm');

    verify(() => defaultApi.searchRoles(query: 'adm')).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('RolesRepository.searchRoles forwards every parameter to the generated client', () async {
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.searchRoles(
        query: 'adm',
        limit: 10,
        nameGt: 'admin',
        roleType: RoleType.user,
        includeGlobalRoles: true,
      ),
    ).thenAnswer(
      (_) async => const Result.success(api.SearchRolesResponse(duration: '0.01ms', roles: [])),
    );

    await RolesRepository(defaultApi).searchRoles(
      'adm',
      limit: 10,
      nameGt: 'admin',
      roleType: RoleType.user,
      includeGlobalRoles: true,
    );

    verify(
      () => defaultApi.searchRoles(
        query: 'adm',
        limit: 10,
        nameGt: 'admin',
        roleType: RoleType.user,
        includeGlobalRoles: true,
      ),
    ).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('RolesRepository.searchRoles returns the mapped response', () async {
    final defaultApi = MockDefaultApi();
    when(() => defaultApi.searchRoles(query: 'mod')).thenAnswer(
      (_) async => const Result.success(api.SearchRolesResponse(duration: '0.02ms', roles: [])),
    );

    final res = await RolesRepository(defaultApi).searchRoles('mod');

    expect(res.getOrNull()?.duration, '0.02ms');
  });

  test('RolesRepository.searchRoles returns the failure without throwing', () async {
    final defaultApi = MockDefaultApi();
    const error = StreamClientException(message: 'boom');
    when(() => defaultApi.searchRoles(query: 'adm')).thenAnswer((_) async => const Result.failure(error));

    final res = await RolesRepository(defaultApi).searchRoles('adm');

    expect(res.exceptionOrNull(), error);
  });
}
