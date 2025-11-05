// ignore_for_file: avoid_redundant_argument_values, lines_longer_than_80_chars

import 'package:stream_chat/src/core/models/user.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  const id = 'bbb19d9a-ee50-45bc-84e5-0584e79d0c9e';
  const role = 'test-role';
  const name = 'John';
  const image =
      'https://getstream.io/random_png/?id=cool-shadow-7&amp;name=Cool+shadow';
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

    group('ComparableFieldProvider', () {
      test('should return ComparableField for user.id', () {
        final user = createTestUser(
          id: 'test-user',
        );

        final field = user.getComparableField(UserSortKey.id);
        expect(field, isNotNull);
        expect(field!.value, equals('test-user'));
      });

      test('should return ComparableField for user.name', () {
        final user = createTestUser(
          id: 'test-user',
          name: 'Test User',
        );

        final field = user.getComparableField(UserSortKey.name);
        expect(field, isNotNull);
        expect(field!.value, equals('Test User'));
      });

      test('should return ComparableField for user.role', () {
        final user = createTestUser(
          id: 'test-user',
          role: 'admin',
        );

        final field = user.getComparableField(UserSortKey.role);
        expect(field, isNotNull);
        expect(field!.value, equals('admin'));
      });

      test('should return ComparableField for user.banned', () {
        final user = createTestUser(
          id: 'test-user',
          banned: true,
        );

        final field = user.getComparableField(UserSortKey.banned);
        expect(field, isNotNull);
        expect(field!.value, isTrue);
      });

      test('should return ComparableField for user.lastActive', () {
        final lastActive = DateTime(2023, 6, 15);
        final user = createTestUser(
          id: 'test-user',
          lastActive: lastActive,
        );

        final field = user.getComparableField(UserSortKey.lastActive);
        expect(field, isNotNull);
        expect(field!.value, equals(lastActive));
      });

      test('should return ComparableField for user.extraData', () {
        final user = createTestUser(
          id: 'test-user',
          extraData: {'score': 42},
        );

        final field = user.getComparableField('score');
        expect(field, isNotNull);
        expect(field!.value, equals(42));
      });

      test('should return null for non-existent extraData keys', () {
        final user = createTestUser(
          id: 'test-user',
        );

        final field = user.getComparableField('non_existent_key');
        expect(field, isNull);
      });

      test('should compare two users correctly using name', () {
        final user1 = createTestUser(
          id: 'user1',
          name: 'Alice',
        );

        final user2 = createTestUser(
          id: 'user2',
          name: 'Bob',
        );

        final field1 = user1.getComparableField(UserSortKey.name);
        final field2 = user2.getComparableField(UserSortKey.name);

        expect(field1!.compareTo(field2!), lessThan(0)); // Alice < Bob
        expect(field2.compareTo(field1), greaterThan(0)); // Bob > Alice
      });

      test('should compare two users correctly using lastActive', () {
        final recentlyActive = createTestUser(
          id: 'recent',
          lastActive: DateTime(2023, 6, 15),
        );

        final lessRecentlyActive = createTestUser(
          id: 'old',
          lastActive: DateTime(2023, 6, 10),
        );

        final field1 =
            recentlyActive.getComparableField(UserSortKey.lastActive);
        final field2 =
            lessRecentlyActive.getComparableField(UserSortKey.lastActive);

        expect(field1!.compareTo(field2!),
            greaterThan(0)); // More recent > Less recent
        expect(
            field2.compareTo(field1), lessThan(0)); // Less recent < More recent
      });

      test('should compare two users correctly using banned status', () {
        final bannedUser = createTestUser(
          id: 'banned',
          banned: true,
        );

        final notBannedUser = createTestUser(
          id: 'not-banned',
          banned: false,
        );

        final field1 = bannedUser.getComparableField(UserSortKey.banned);
        final field2 = notBannedUser.getComparableField(UserSortKey.banned);

        expect(field1!.compareTo(field2!), greaterThan(0)); // true > false
        expect(field2.compareTo(field1), lessThan(0)); // false < true
      });

      test('should fallback to user id when name is null', () {
        // The User implementation fallbacks to id when name is null
        final user = createTestUser(
          id: 'without-name',
          name: null,
        );

        final field = user.getComparableField(UserSortKey.name);
        expect(field, isNotNull);
        expect(field!.value, equals('without-name')); // Fallback to user id
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
