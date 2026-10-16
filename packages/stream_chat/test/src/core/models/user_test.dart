// ignore_for_file: avoid_redundant_argument_values, lines_longer_than_80_chars

import 'package:stream_chat/src/core/models/user.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  const id = 'bbb19d9a-ee50-45bc-84e5-0584e79d0c9e';
  const role = 'test-role';
  const name = 'John';
  const image = 'https://getstream.io/random_png/?id=cool-shadow-7&amp;name=Cool+shadow';
  const extraDataStringTest = 'Extra data test';
  const extraDataIntTest = 1;
  const extraDataDoubleTest = 1.1;
  const extraDataBoolTest = true;
  const online = true;
  const banned = true;
  const teams = ['team-1', 'team-2'];
  const teamsRole = {'team-1': 'admin', 'team-2': 'member'};
  const avgResponseTime = 120;
  const createdAtString = '2021-08-03T10:39:21.817646Z';
  const updatedAtString = '2021-08-04T10:39:21.817646Z';
  const lastActiveString = '2021-08-05T10:39:21.817646Z';

  group('src/models/user', () {
    test('should parse json correctly', () {
      final user = User.fromJson(jsonFixture('user.json'));
      expect(user.id, id);
      expect(user.role, role);
      expect(user.name, name);
      expect(user.image, image);
      expect(user.custom, {
        'extraDataStringTest': extraDataStringTest,
        'extraDataIntTest': extraDataIntTest,
        'extraDataDoubleTest': extraDataDoubleTest,
        'extraDataBoolTest': extraDataBoolTest,
      });
      expect(user.online, online);
      expect(user.banned, banned);
      expect(user.teams, teams);
      expect(user.createdAt, DateTime.parse(createdAtString));
      expect(user.updatedAt, DateTime.parse(updatedAtString));
      expect(user.lastActive, DateTime.parse(lastActiveString));
      expect(user.language, 'en');
      expect(user.invisible, false);
      expect(user.teamsRole, teamsRole);
      expect(user.avgResponseTime, avgResponseTime);
      expect(user.deactivatedAt, DateTime.parse('2021-08-06T10:39:21.817646Z'));
      expect(user.deletedAt, DateTime.parse('2021-08-07T10:39:21.817646Z'));
      expect(user.shadowBanned, isTrue);
      expect(user.blockedUserIds, ['blocked-1']);
    });

    test('User writes its fields to JSON and reads them back', () {
      final user = User(
        id: id,
        name: name,
        image: image,
        deactivatedAt: DateTime.utc(2021),
        deletedAt: DateTime.utc(2020),
        shadowBanned: true,
        blockedUserIds: const ['blocked-1'],
        custom: const {'color': 'red'},
      );

      expect(User.fromJson(user.toJson()), user);
    });

    test('User.toJson leaves out custom data named like a field', () {
      final user = User(
        id: id,
        name: name,
        custom: const {'name': 'custom', 'color': 'red'},
      );

      final json = user.toJson();

      expect(json['name'], name);
      expect(json['color'], 'red');
    });

    test('should serialize to json correctly', () {
      final user = User(
        id: id,
        role: role,
        name: name,
        image: image,
        custom: const {
          'extraDataStringTest': extraDataStringTest,
          'extraDataIntTest': extraDataIntTest,
          'extraDataDoubleTest': extraDataDoubleTest,
          'extraDataBoolTest': extraDataBoolTest,
        },
        createdAt: DateTime.parse(createdAtString),
        updatedAt: DateTime.parse(updatedAtString),
        lastActive: DateTime.parse(lastActiveString),
        banned: online,
        online: banned,
        teams: const ['team-1', 'team-2'],
        language: 'fr',
        invisible: true,
        teamsRole: teamsRole,
        avgResponseTime: avgResponseTime,
      );

      expect(user.toJson(), {
        'id': id,
        'role': role,
        'teams': teams,
        'created_at': createdAtString,
        'updated_at': updatedAtString,
        'last_active': lastActiveString,
        'online': online,
        'banned': banned,
        'name': name,
        'image': image,
        'extraDataStringTest': extraDataStringTest,
        'extraDataIntTest': extraDataIntTest,
        'extraDataDoubleTest': extraDataDoubleTest,
        'extraDataBoolTest': extraDataBoolTest,
        'language': 'fr',
        'invisible': true,
        'teams_role': teamsRole,
        'avg_response_time': avgResponseTime,
        'blocked_user_ids': <String>[],
      });
    });

    test('copyWith', () {
      final user = User.fromJson(jsonFixture('user.json'));
      var newUser = user.copyWith();

      expect(newUser.id, user.id);
      expect(newUser.role, user.role);
      expect(newUser.name, user.name);
      expect(newUser.image, user.image);
      expect(newUser.online, user.online);
      expect(newUser.banned, user.banned);
      expect(newUser.teams, user.teams);
      expect(newUser.createdAt, user.createdAt);
      expect(newUser.updatedAt, user.updatedAt);
      expect(newUser.lastActive, user.lastActive);
      expect(newUser.language, user.language);
      expect(newUser.invisible, user.invisible);
      expect(newUser.teamsRole, user.teamsRole);
      expect(newUser.avgResponseTime, user.avgResponseTime);
      expect(newUser.deactivatedAt, user.deactivatedAt);
      expect(newUser.deletedAt, user.deletedAt);
      expect(newUser.shadowBanned, user.shadowBanned);
      expect(newUser.blockedUserIds, user.blockedUserIds);

      newUser = user.copyWith(
        id: 'test',
        role: 'test',
        name: 'test',
        image: 'https://stream.io/new-image',
        online: false,
        banned: false,
        teams: ['new-team1', 'new-team2'],
        createdAt: DateTime.parse('2021-05-03 12:39:21.817646'),
        updatedAt: DateTime.parse('2021-05-04 12:39:21.817646'),
        lastActive: DateTime.parse('2021-05-06 12:39:21.817646'),
        language: 'it',
        invisible: true,
        teamsRole: {'new-team1': 'admin', 'new-team2': 'member'},
        avgResponseTime: 60,
        deactivatedAt: DateTime.utc(2022),
        deletedAt: DateTime.utc(2023),
        shadowBanned: false,
        blockedUserIds: ['blocked-2'],
      );

      expect(newUser.id, 'test');
      expect(newUser.role, 'test');
      expect(newUser.name, 'test');
      expect(newUser.image, 'https://stream.io/new-image');
      expect(newUser.online, false);
      expect(newUser.banned, false);
      expect(newUser.teams, ['new-team1', 'new-team2']);
      expect(newUser.createdAt, DateTime.parse('2021-05-03 12:39:21.817646'));
      expect(newUser.updatedAt, DateTime.parse('2021-05-04 12:39:21.817646'));
      expect(newUser.lastActive, DateTime.parse('2021-05-06 12:39:21.817646'));
      expect(newUser.language, 'it');
      expect(newUser.invisible, true);
      expect(newUser.teamsRole, {'new-team1': 'admin', 'new-team2': 'member'});
      expect(newUser.avgResponseTime, 60);
      expect(newUser.deactivatedAt, DateTime.utc(2022));
      expect(newUser.deletedAt, DateTime.utc(2023));
      expect(newUser.shadowBanned, isFalse);
      expect(newUser.blockedUserIds, ['blocked-2']);
    });

    test('default values, constructor', () {
      final user = User(id: id);

      expect(user.id, id);
      expect(user.role, null);
      expect(user.name, isNull);
      expect(user.image, null);
      expect(user.custom, const {});
      expect(user.online, false);
      expect(user.banned, false);
      expect(user.teams, []);
      expect(user.lastActive, null);
      expect(user.createdAt, null);
      expect(user.updatedAt, null);
      expect(user.teamsRole, null);
      expect(user.avgResponseTime, null);
      expect(user.deactivatedAt, null);
      expect(user.deletedAt, null);
      expect(user.shadowBanned, null);
      expect(user.blockedUserIds, isEmpty);
    });

    test('default values, parse json', () {
      final user = User.fromJson(const {'id': id});

      expect(user.id, id);
      expect(user.role, null);
      expect(user.name, isNull);
      expect(user.image, null);
      expect(user.custom, const {});
      expect(user.online, false);
      expect(user.banned, false);
      expect(user.teams, []);
      expect(user.lastActive, null);
      expect(user.createdAt, null);
      expect(user.updatedAt, null);
      expect(user.teamsRole, null);
      expect(user.avgResponseTime, null);
      expect(user.deactivatedAt, null);
      expect(user.deletedAt, null);
      expect(user.shadowBanned, null);
      expect(user.blockedUserIds, isEmpty);
    });

    group('UserSortField', () {
      test('id orders alphabetically', () {
        expectOrders(
          UserSortField.id,
          createTestUser(id: 'alice'),
          createTestUser(id: 'bob'),
        );
      });

      test('name orders alphabetically, folded', () {
        // Folding is what makes a local sort agree with the server: `Zara`
        // would otherwise sort before `alice`.
        expectOrders(
          UserSortField.name,
          createTestUser(id: 'a', name: 'alice'),
          createTestUser(id: 'z', name: 'Zara'),
        );
      });

      test('name orders nothing for a user with no name', () {
        // Sorting unnamed users by their id would order them among the named
        // ones, where the API sorts them together by an empty `name` column.
        expectOrdersNothing(
          UserSortField.name,
          createTestUser(id: 'alice'),
          createTestUser(id: 'zara'),
        );
      });

      test('role orders alphabetically', () {
        expectOrders(
          UserSortField.role,
          createTestUser(id: 'a', role: 'admin'),
          createTestUser(id: 'u', role: 'user'),
        );
      });

      test('banned orders unbanned users first', () {
        expectOrders(
          UserSortField.banned,
          createTestUser(id: 'a', banned: false),
          createTestUser(id: 'b', banned: true),
        );
      });

      test('lastActive orders less recent users first', () {
        expectOrders(
          UserSortField.lastActive,
          createTestUser(id: 'a', lastActive: DateTime(2023, 6, 10)),
          createTestUser(id: 'b', lastActive: DateTime(2023, 6, 15)),
        );
      });

      test('a custom field orders by the user custom data', () {
        expectOrders(
          UserSortField.custom('score'),
          createTestUser(id: 'a', custom: const {'score': 10}),
          createTestUser(id: 'b', custom: const {'score': 90}),
        );
      });

      test('a custom field the user does not carry orders nothing', () {
        expectOrdersNothing(
          UserSortField.custom('non_existent_key'),
          createTestUser(id: 'plain'),
        );
      });
    });

    test('User.nameOrId returns the name', () {
      final user = User(id: id, name: name);

      expect(user.nameOrId, name);
    });

    test('User.nameOrId returns the id for a user with no name', () {
      final user = User(id: id);

      expect(user.nameOrId, id);
    });

    test('User.nameOrId returns the id for a user with an empty name', () {
      final user = User(id: id, name: '');

      expect(user.nameOrId, id);
    });
  });
}

/// Helper function to create a User for testing
User createTestUser({
  required String id,
  String? name,
  String? role,
  bool? banned,
  DateTime? lastActive,
  Map<String, Object?>? custom,
  Map<String, String>? teamsRole,
  int? avgResponseTime,
}) {
  return User(
    id: id,
    name: name,
    role: role,
    banned: banned ?? false,
    lastActive: lastActive,
    custom: custom ?? {},
    teamsRole: teamsRole,
    avgResponseTime: avgResponseTime,
  );
}
