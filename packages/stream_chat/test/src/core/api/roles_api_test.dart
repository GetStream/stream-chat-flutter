// ignore_for_file: avoid_redundant_argument_values

import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/api/roles_api.dart';
import 'package:stream_chat/src/core/models/role.dart';
import 'package:test/test.dart';

import '../../mocks.dart';

void main() {
  Response successResponse(String path, {Object? data}) => Response(
    data: data,
    requestOptions: RequestOptions(path: path),
    statusCode: 200,
  );

  Map<String, dynamic> roleJson({
    String name = 'admin',
    bool custom = false,
    List<String> scopes = const ['.app'],
  }) => {
    'name': name,
    'custom': custom,
    'scopes': scopes,
    'created_at': '2024-01-01T00:00:00Z',
    'updated_at': '2024-01-02T00:00:00Z',
  };

  late final client = MockHttpClient();
  late RolesApi rolesApi;

  setUp(() {
    rolesApi = RolesApi(client);
  });

  group('searchRoles', () {
    test('should search with query only', () async {
      const path = '/roles/search';
      const query = 'admin';

      when(() => client.get(path, queryParameters: {'query': query})).thenAnswer(
        (_) async => successResponse(path, data: {'roles': <Map>[]}),
      );

      final res = await rolesApi.searchRoles(query);

      expect(res, isNotNull);
      expect(res.roles, isEmpty);

      verify(() => client.get(path, queryParameters: {'query': query})).called(1);
      verifyNoMoreInteractions(client);
    });

    test('should search with all parameters', () async {
      const path = '/roles/search';
      const query = 'adm';
      const limit = 10;
      const nameGt = 'admin';
      const roleType = RoleType.user;
      const includeGlobalRoles = true;

      final expectedQueryParameters = {
        'query': query,
        'limit': limit,
        'name_gt': nameGt,
        'role_type': roleType,
        'include_global_roles': includeGlobalRoles,
      };

      when(() => client.get(path, queryParameters: expectedQueryParameters)).thenAnswer(
        (_) async => successResponse(
          path,
          data: {
            'roles': [
              roleJson(name: 'admin', custom: true, scopes: const ['.app', 'messaging']),
            ],
          },
        ),
      );

      final res = await rolesApi.searchRoles(
        query,
        limit: limit,
        nameGt: nameGt,
        roleType: roleType,
        includeGlobalRoles: includeGlobalRoles,
      );

      expect(res, isNotNull);
      expect(res.roles, hasLength(1));
      expect(res.roles.first.name, 'admin');
      expect(res.roles.first.custom, isTrue);
      expect(res.roles.first.scopes, ['.app', 'messaging']);

      verify(() => client.get(path, queryParameters: expectedQueryParameters)).called(1);
      verifyNoMoreInteractions(client);
    });
  });
}
