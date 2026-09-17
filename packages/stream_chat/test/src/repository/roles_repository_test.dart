// ignore_for_file: avoid_redundant_argument_values

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart';
import 'package:stream_chat/src/repository/roles_repository.dart';
import 'package:stream_core/stream_core.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  late MockDefaultApi api;
  late RolesRepository repository;

  Role role(String name) => Role(
    name: name,
    custom: false,
    scopes: const ['.app'],
    createdAt: DateTime.utc(2024),
    updatedAt: DateTime.utc(2024),
  );

  setUp(() {
    api = MockDefaultApi();
    repository = RolesRepository(api);
  });

  test('should forward only the query when nothing else is passed', () async {
    when(() => api.searchRoles(query: 'adm')).thenAnswer(
      (_) async => const Result.success(SearchRolesResponse(duration: '0.01ms', roles: [])),
    );

    final res = await repository.searchRoles('adm');

    expect(res.getOrNull()?.roles, isEmpty);
    verify(() => api.searchRoles(query: 'adm')).called(1);
    verifyNoMoreInteractions(api);
  });

  test('should forward every parameter to the generated client', () async {
    when(
      () => api.searchRoles(
        query: 'adm',
        limit: 10,
        nameGt: 'admin',
        roleType: 'user',
        includeGlobalRoles: true,
      ),
    ).thenAnswer(
      (_) async => Result.success(SearchRolesResponse(duration: '0.01ms', roles: [role('admin')])),
    );

    final res = await repository.searchRoles(
      'adm',
      limit: 10,
      nameGt: 'admin',
      roleType: 'user',
      includeGlobalRoles: true,
    );

    expect(res.getOrNull()?.roles.single.name, 'admin');
    verify(
      () => api.searchRoles(
        query: 'adm',
        limit: 10,
        nameGt: 'admin',
        roleType: 'user',
        includeGlobalRoles: true,
      ),
    ).called(1);
    verifyNoMoreInteractions(api);
  });

  test('should return the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    when(() => api.searchRoles(query: 'adm')).thenAnswer((_) async => const Result.failure(error));

    final res = await repository.searchRoles('adm');

    expect(res.isFailure, isTrue);
    expect(res.exceptionOrNull(), error);
  });
}
