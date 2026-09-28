import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/src/core/models/role.dart';
import 'package:stream_chat/src/repository/mapper/roles_mapper.dart';
import 'package:test/test.dart';

void main() {
  test('Role.toModel maps every field of the generated role', () {
    final generated = api.Role(
      name: 'moderator',
      custom: true,
      scopes: const ['.app', 'messaging'],
      createdAt: DateTime.utc(2024, 1, 2),
      updatedAt: DateTime.utc(2024, 3, 4),
    );

    expect(
      generated.toModel(),
      Role(
        name: 'moderator',
        custom: true,
        scopes: const ['.app', 'messaging'],
        createdAt: DateTime.utc(2024, 1, 2),
        updatedAt: DateTime.utc(2024, 3, 4),
      ),
    );
  });

  test('SearchRolesResponse.toModel keeps the duration', () {
    const response = api.SearchRolesResponse(duration: '0.02ms', roles: []);

    expect(response.toModel().duration, '0.02ms');
  });

  test('SearchRolesResponse.toModel maps every role in order', () {
    final response = api.SearchRolesResponse(
      duration: '0.01ms',
      roles: [_role('admin'), _role('moderator'), _role('user')],
    );

    final roles = response.toModel().roles;

    expect(roles.map((it) => it.name), ['admin', 'moderator', 'user']);
  });
}

api.Role _role(String name) {
  return api.Role(
    name: name,
    custom: false,
    scopes: const ['.app'],
    createdAt: DateTime.utc(2024),
    updatedAt: DateTime.utc(2024),
  );
}
