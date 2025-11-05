// ignore_for_file: avoid_redundant_argument_values

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../utils.dart';

class MockMute extends Mock implements Mute {}

class ChannelMockMute extends Mock implements ChannelMute {}

class MockDevice extends Mock implements Device {}

void main() {
  final devices = [MockDevice(), MockDevice()];
  final mutes = [MockMute(), MockMute()];
  final channelMutes = [ChannelMockMute()];
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

    test(
      'fromUser should not override name with id if not available in extraData',
      () {
        final user = User(id: 'test-id');
        expect(user.id, 'test-id');
        expect(user.name, 'test-id');

        final encodedUser = user.toJson();
        expect(encodedUser['id'], 'test-id');
        expect(encodedUser['name'], null);

        final ownUser = OwnUser.fromUser(user);
        expect(user.id, 'test-id');
        expect(user.name, 'test-id');

        final encodedOwnUser = ownUser.toJson();
        expect(encodedOwnUser['id'], 'test-id');
        expect(encodedOwnUser['name'], null);
      },
    );

    test('should parse json with privacy settings correctly', () {
      final json = {
        'id': 'test-user',
        'role': 'user',
        'privacy_settings': {
          'typing_indicators': {'enabled': false},
          'read_receipts': {'enabled': false},
        },
      };

      final ownUser = OwnUser.fromJson(json);

      expect(ownUser.id, 'test-user');
      expect(ownUser.privacySettings, isNotNull);
      expect(ownUser.privacySettings?.typingIndicators?.enabled, false);
      expect(ownUser.privacySettings?.readReceipts?.enabled, false);
    });

    test('copyWith should handle privacy settings', () {
      final user = OwnUser(id: 'test-user');

      expect(user.privacySettings, isNull);

      final updatedUser = user.copyWith(
        privacySettings: const PrivacySettings(
          typingIndicators: TypingIndicatorPrivacySettings(enabled: false),
          readReceipts: ReadReceiptsPrivacySettings(enabled: false),
        ),
      );

      expect(updatedUser.privacySettings, isNotNull);
      expect(updatedUser.privacySettings?.typingIndicators?.enabled, false);
      expect(updatedUser.privacySettings?.readReceipts?.enabled, false);
    });

    test('merge should handle privacy settings', () {
      final user = OwnUser(id: 'test-user');

      expect(user.privacySettings, isNull);

      final updatedUser = user.merge(
        OwnUser(
          id: 'test-user',
          privacySettings: const PrivacySettings(
            typingIndicators: TypingIndicatorPrivacySettings(enabled: false),
            readReceipts: ReadReceiptsPrivacySettings(enabled: false),
          ),
        ),
      );

      expect(updatedUser.privacySettings, isNotNull);
      expect(updatedUser.privacySettings?.typingIndicators?.enabled, false);
      expect(updatedUser.privacySettings?.readReceipts?.enabled, false);
    });

    test('fromUser should extract privacy settings from extraData', () {
      // Create user from JSON to properly deserialize privacy_settings
      final userJson = {
        'id': 'test-user',
        'privacy_settings': {
          'typing_indicators': {'enabled': false},
          'read_receipts': {'enabled': true},
        },
      };

      final user = User.fromJson(userJson);
      final ownUser = OwnUser.fromUser(user);

      expect(ownUser.privacySettings, isNotNull);
      expect(ownUser.privacySettings?.typingIndicators?.enabled, false);
      expect(ownUser.privacySettings?.readReceipts?.enabled, true);
    });
  });

  group('PrivacySettingsExtension', () {
    test('isTypingIndicatorsEnabled should return true when null', () {
      final user = OwnUser(id: 'test-user');

      expect(user.isTypingIndicatorsEnabled, true);
    });

    test('isTypingIndicatorsEnabled should return true when enabled', () {
      final user = OwnUser(
        id: 'test-user',
        privacySettings: const PrivacySettings(
          typingIndicators: TypingIndicatorPrivacySettings(enabled: true),
        ),
      );

      expect(user.isTypingIndicatorsEnabled, true);
    });

    test('isTypingIndicatorsEnabled should return false when disabled', () {
      final user = OwnUser(
        id: 'test-user',
        privacySettings: const PrivacySettings(
          typingIndicators: TypingIndicatorPrivacySettings(enabled: false),
        ),
      );

      expect(user.isTypingIndicatorsEnabled, false);
    });

    test(
      'isTypingIndicatorsEnabled should return true when privacy settings exists but typing indicators is null',
      () {
        final user = OwnUser(
          id: 'test-user',
          privacySettings: const PrivacySettings(
            readReceipts: ReadReceiptsPrivacySettings(enabled: false),
          ),
        );

        expect(user.isTypingIndicatorsEnabled, true);
      },
    );

    test('isReadReceiptsEnabled should return true when null', () {
      final user = OwnUser(id: 'test-user');

      expect(user.isReadReceiptsEnabled, true);
    });

    test('isReadReceiptsEnabled should return true when enabled', () {
      final user = OwnUser(
        id: 'test-user',
        privacySettings: const PrivacySettings(
          readReceipts: ReadReceiptsPrivacySettings(enabled: true),
        ),
      );

      expect(user.isReadReceiptsEnabled, true);
    });

    test('isReadReceiptsEnabled should return false when disabled', () {
      final user = OwnUser(
        id: 'test-user',
        privacySettings: const PrivacySettings(
          readReceipts: ReadReceiptsPrivacySettings(enabled: false),
        ),
      );

      expect(user.isReadReceiptsEnabled, false);
    });

    test(
      'isReadReceiptsEnabled should return true when privacy settings exists but read receipts is null',
      () {
        final user = OwnUser(
          id: 'test-user',
          privacySettings: const PrivacySettings(
            typingIndicators: TypingIndicatorPrivacySettings(enabled: false),
          ),
        );

        expect(user.isReadReceiptsEnabled, true);
      },
    );
  });
}
