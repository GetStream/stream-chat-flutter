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
  const createdAtString = '2021-08-03 12:39:21.817646';
  const updatedAtString = '2021-08-04 12:39:21.817646';
  const lastActiveString = '2021-08-05 12:39:21.817646';

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
    });

    test('should serialize to json correctly', () {
      final user = User(
        id: id,
        role: role,
        image: image,
        extraData: const {
          'name': name,
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
      );

      expect(user.toJson(), {
        'id': id,
        'name': name,
        'image': image,
        'extraDataStringTest': extraDataStringTest,
        'extraDataIntTest': extraDataIntTest,
        'extraDataDoubleTest': extraDataDoubleTest,
        'extraDataBoolTest': extraDataBoolTest,
        'language': 'fr',
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

      newUser = user.copyWith(
        id: 'test',
        role: 'test',
        extraData: {
          'name': 'test',
        },
        image: 'https://stream.io/new-image',
        online: false,
        banned: false,
        teams: ['new-team1', 'new-team2'],
        createdAt: DateTime.parse('2021-05-03 12:39:21.817646'),
        updatedAt: DateTime.parse('2021-05-04 12:39:21.817646'),
        lastActive: DateTime.parse('2021-05-06 12:39:21.817646'),
        language: 'it',
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
    });

    test('image property and extraData manipulation', () {
      final user = User(id: id, image: image);

      expect(user.image, image);
      expect(user.extraData['image'], image);
      expect(user.toJson(), {'id': id, 'image': image});
      expect(User.fromJson(user.toJson()).toJson(), {'id': id, 'image': image});

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
      expect(user.createdAt, isNotNull);
      expect(user.updatedAt, isNotNull);
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
      expect(user.createdAt, isNotNull);
      expect(user.updatedAt, isNotNull);
    });
  });
}
