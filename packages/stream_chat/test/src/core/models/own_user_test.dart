import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/models/own_user.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../utils.dart';

class MockMute extends Mock implements Mute {}

class MockDevice extends Mock implements Device {}

void main() {
  final devices = [MockDevice(), MockDevice()];
  final mutes = [MockMute(), MockMute()];
  final channelMutes = [MockMute()];
  final createdAt = DateTime.parse('2021-05-03 12:39:21.817646');
  final updatedAt = DateTime.parse('2021-04-03 12:39:21.817646');
  final lastActive = DateTime.parse('2021-03-03 12:39:21.817646');

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
      expect(ownUser.image, 'https://placehold.jp/150x150.png');
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
      expect(ownUser.image, user.image);
    });

    test('copyWith', () {
      final user = OwnUser.fromJson(jsonFixture('own_user.json'));
      var newUser = user.copyWith();

      expect(newUser.id, user.id);
      expect(newUser.role, user.role);
      expect(newUser.name, user.name);
      expect(newUser.devices, user.devices);
      expect(newUser.mutes, user.mutes);
      expect(newUser.totalUnreadCount, user.totalUnreadCount);
      expect(newUser.channelMutes, user.channelMutes);
      expect(newUser.createdAt, user.createdAt);
      expect(newUser.updatedAt, user.updatedAt);
      expect(newUser.lastActive, user.lastActive);
      expect(newUser.online, user.online);
      expect(newUser.extraData, user.extraData);
      expect(newUser.banned, user.banned);
      expect(newUser.teams, user.teams);
      expect(newUser.language, user.language);
      expect(newUser.image, user.image);

      newUser = user.copyWith(
        id: 'test',
        role: 'test',
        image: 'https://getstream.io/image-new',
        extraData: {
          'name': 'test',
        },
        devices: devices,
        mutes: mutes,
        totalUnreadCount: 10,
        unreadChannels: 5,
        channelMutes: channelMutes,
        createdAt: createdAt,
        updatedAt: updatedAt,
        lastActive: lastActive,
        online: true,
        banned: true,
        teams: ['team1', 'team2'],
        language: 'fr',
      );

      expect(newUser.id, 'test');
      expect(newUser.role, 'test');
      expect(newUser.name, 'test');
      expect(newUser.image, 'https://getstream.io/image-new');
      expect(
        newUser.extraData,
        {
          'name': 'test',
          'image': 'https://getstream.io/image-new',
        },
        reason: 'Should get image from user.image',
      );
      expect(newUser.devices, devices);
      expect(newUser.mutes, mutes);
      expect(newUser.totalUnreadCount, 10);
      expect(newUser.unreadChannels, 5);
      expect(newUser.channelMutes, channelMutes);
      expect(newUser.createdAt, createdAt);
      expect(newUser.updatedAt, updatedAt);
      expect(newUser.createdAt, createdAt);
      expect(newUser.online, true);
      expect(newUser.banned, true);
      expect(newUser.teams, ['team1', 'team2']);
      expect(newUser.language, 'fr');
    });

    test('merge', () {
      final user = OwnUser.fromJson(jsonFixture('own_user.json'));
      final newUser = user.merge(
        OwnUser(
          id: 'test',
          role: 'test',
          extraData: const {
            'name': 'test',
          },
          image: 'https://getstream.io/image-new',
          devices: devices,
          mutes: mutes,
          totalUnreadCount: 10,
          unreadChannels: 5,
          channelMutes: channelMutes,
          createdAt: createdAt,
          updatedAt: updatedAt,
          lastActive: lastActive,
          online: true,
          banned: true,
          teams: const ['team1', 'team2'],
          language: 'fr',
        ),
      );

      expect(newUser.id, 'test');
      expect(newUser.role, 'test');
      expect(newUser.name, 'test');
      expect(newUser.image, 'https://getstream.io/image-new');
      expect(
        newUser.extraData,
        {
          'name': 'test',
          'image': 'https://getstream.io/image-new',
        },
        reason: 'Should get image from user.image',
      );
      expect(newUser.devices, devices);
      expect(newUser.mutes, mutes);
      expect(newUser.totalUnreadCount, 10);
      expect(newUser.unreadChannels, 5);
      expect(newUser.channelMutes, channelMutes);
      expect(newUser.createdAt, createdAt);
      expect(newUser.updatedAt, updatedAt);
      expect(newUser.createdAt, createdAt);
      expect(newUser.online, true);
      expect(newUser.banned, true);
      expect(newUser.teams, ['team1', 'team2']);
      expect(newUser.language, 'fr');
    });
  });
}
