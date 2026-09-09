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
      expect(user.extraData['image'], image);
      expect(user.extraData['extraDataStringTest'], extraDataStringTest);
      expect(user.extraData['extraDataIntTest'], extraDataIntTest);
      expect(user.extraData['extraDataDoubleTest'], extraDataDoubleTest);
      expect(user.extraData['extraDataBoolTest'], extraDataBoolTest);
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
    });

    test('should serialize to json correctly', () {
      final user = User(
        id: id,
        role: role,
        name: name,
        image: image,
        extraData: const {
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
      );

      expect(newUser.id, 'test');
      expect(newUser.role, 'test');
      expect(newUser.name, 'test');
      expect(newUser.image, 'https://stream.io/new-image');
      expect(newUser.extraData['image'], 'https://stream.io/new-image');
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
    });

    test('name property and extraData manipulation', () {
      final user = User(id: id, name: name);

      expect(user.name, name);
      expect(user.extraData['name'], name);

      const nameOne = 'Name One';
      var newUser = user.copyWith(
        extraData: {'name': nameOne},
      );

      expect(newUser.extraData['name'], nameOne);
      expect(newUser.name, nameOne);

      const nameTwo = 'Name Two';
      newUser = user.copyWith(
        name: nameTwo,
      );

      expect(newUser.extraData['name'], nameTwo);
      expect(newUser.name, nameTwo);

      const nameThree = 'Name Three';
      newUser = user.copyWith(
        name: nameThree,
        extraData: {'name': nameThree},
      );

      expect(newUser.extraData['name'], nameThree);
      expect(newUser.name, nameThree);
    });

    test('image property and extraData manipulation', () {
      final user = User(id: id, image: image);

      expect(user.image, image);
      expect(user.extraData['image'], image);

      const imageURLOne = 'https://stream.io/image-one';
      var newUser = user.copyWith(
        extraData: {'image': imageURLOne},
      );

      expect(newUser.extraData['image'], imageURLOne);
      expect(newUser.image, imageURLOne);

      const imageURLTwo = 'https://stream.io/image-two';
      newUser = user.copyWith(
        image: imageURLTwo,
      );

      expect(newUser.extraData['image'], imageURLTwo);
      expect(newUser.image, imageURLTwo);

      const imageURLThree = 'https://stream.io/image-three';
      newUser = user.copyWith(
        image: imageURLThree,
        extraData: {'image': imageURLThree},
      );

      expect(newUser.extraData['image'], imageURLThree);
      expect(newUser.image, imageURLThree);
    });

    test('default values, constructor', () {
      final user = User(id: id);

      expect(user.id, id);
      expect(user.role, null);
      expect(user.name, id, reason: 'if a name is not supplied, default to id');
      expect(user.image, null);
      expect(user.extraData, const {});
      expect(user.online, false);
      expect(user.banned, false);
      expect(user.teams, []);
      expect(user.lastActive, null);
      expect(user.createdAt, null);
      expect(user.updatedAt, null);
      expect(user.teamsRole, null);
      expect(user.avgResponseTime, null);
    });

    test('default values, parse json', () {
      final user = User.fromJson(const {'id': id});

      expect(user.id, id);
      expect(user.role, null);
      expect(user.name, id, reason: 'if a name is not supplied, default to id');
      expect(user.image, null);
      expect(user.extraData, const {});
      expect(user.online, false);
      expect(user.banned, false);
      expect(user.teams, []);
      expect(user.lastActive, null);
      expect(user.createdAt, null);
      expect(user.updatedAt, null);
      expect(user.teamsRole, null);
      expect(user.avgResponseTime, null);
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

      test('a custom field orders by the user extra data', () {
        expectOrders(
          UserSortField.custom('score'),
          createTestUser(id: 'a', extraData: const {'score': 10}),
          createTestUser(id: 'b', extraData: const {'score': 90}),
        );
      });

      test('a custom field the user does not carry orders nothing', () {
        expectOrdersNothing(
          UserSortField.custom('non_existent_key'),
          createTestUser(id: 'plain'),
        );
      });
    });

    test('.name should fetch from extraData if available', () {
      final user = User(
        id: 'test-user',
        extraData: const {'name': 'Test User'},
      );

      expect(user.name, 'Test User');
    });

    test('.name should return id if extraData value is empty', () {
      final user = User(
        id: 'test-user',
        extraData: const {'name': ''},
      );

      expect(user.name, 'test-user');
    });

    test('.name should return id if not available in extraData', () {
      final user = User(
        id: 'test-user',
        extraData: const {},
      );

      expect(user.name, 'test-user');
    });

    test('.name should return id if extraData value is not String', () {
      final user = User(
        id: 'test-user',
        extraData: const {'name': true},
      );

      expect(user.name, 'test-user');
    });

    test('.image should fetch from extraData if available', () {
      final user = User(
        id: 'test-user',
        extraData: const {'image': 'https://example.com/image.png'},
      );

      expect(user.image, 'https://example.com/image.png');
    });

    test('.image should return null if not available in extraData', () {
      final user = User(
        id: 'test-user',
        extraData: const {},
      );

      expect(user.image, isNull);
    });

    test('.image should return null if extraData value is not String', () {
      final user = User(
        id: 'test-user',
        extraData: const {'image': true},
      );

      expect(user.image, isNull);
    });

    test('.image should return null if extraData value is empty', () {
      final user = User(
        id: 'test-user',
        extraData: const {'image': ''},
      );

      expect(user.image, isNull);
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
  Map<String, Object?>? extraData,
  Map<String, String>? teamsRole,
  int? avgResponseTime,
}) {
  return User(
    id: id,
    name: name,
    role: role,
    banned: banned ?? false,
    lastActive: lastActive,
    extraData: extraData ?? {},
    teamsRole: teamsRole,
    avgResponseTime: avgResponseTime,
  );
}
