import 'package:stream_chat/src/core/models/own_user.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('src/models/own_user', () {
    test('should parse json correctly', () {
      final ownUser = OwnUser.fromJson(jsonFixture('own_user.json'));
      expect(ownUser.id, 'super-band-9');
      expect(ownUser.role, 'user');

      expect(ownUser.createdAt, DateTime.parse('2020-03-03T16:48:28.853674Z'));
      expect(ownUser.updatedAt, DateTime.parse('2021-05-26T03:22:20.296181Z'));
      expect(
          ownUser.lastActive, DateTime.parse('2021-06-16T11:59:59.003453014Z'));
      expect(ownUser.banned, false);
      expect(ownUser.online, true);
      expect(ownUser.devices.length, 1);
      expect(ownUser.mutes.length, 0);
      expect(ownUser.channelMutes.length, 1);
      expect(ownUser.totalUnreadCount, 0);
      expect(ownUser.unreadChannels, 0);
      expect(ownUser.extraData['image'], 'https://placehold.jp/150x150.png');
      expect(ownUser.extraData['name'], 'Proud darkness');
      expect(ownUser.extraData['username'], 'Rioland');
    });

    test('should initialize a OwnUser from a User correctly', () {
      final user = User.fromJson(jsonFixture('user.json'));
      final ownUser = OwnUser.fromUser(user);

      expect(ownUser.id, user.id);
      expect(ownUser.id, user.id);
      expect(ownUser.role, user.role);
      expect(ownUser.createdAt, user.createdAt);
      expect(ownUser.updatedAt, user.updatedAt);
      expect(ownUser.lastActive, user.lastActive);
      expect(ownUser.online, user.online);
      expect(ownUser.banned, user.banned);
      expect(ownUser.extraData, user.extraData);
    });

    test('copyWith', () {
      final user = OwnUser.fromJson(jsonFixture('own_user.json'));
      var newUser = user.copyWith();

      expect(newUser.id, user.id);
      expect(newUser.role, user.role);
      expect(newUser.name, user.name);

      newUser = user.copyWith(
        id: 'test',
        role: 'test',
        extraData: {
          'name': 'test',
        },
      );

      expect(newUser.id, 'test');
      expect(newUser.role, 'test');
      expect(newUser.name, 'test');
    });

    test('merge', () {
      final user = OwnUser.fromJson(jsonFixture('own_user.json'));
      final newUser = user.merge(OwnUser(
        id: 'test',
        role: 'test',
        extraData: const {
          'name': 'test',
        },
        banned: true,
      ));

      expect(newUser.id, 'test');
      expect(newUser.role, 'test');
      expect(newUser.name, 'test');
      expect(newUser.banned, true);
    });
  });
}
