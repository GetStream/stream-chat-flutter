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
      expect(ownUser.lastActive, DateTime.parse('2021-06-16T11:59:59.003453014Z'));
      expect(ownUser.banned, false);
      expect(ownUser.online, true);
      expect(ownUser.devices, hasLength(1));
      final device = ownUser.devices.single;
      expect(device.id, startsWith('cRS8elU4Q-qqdCAvHR2kSa:'));
      expect(device.pushProvider, 'firebase');
      expect(ownUser.mutes.length, 0);
      expect(ownUser.channelMutes.length, 1);
      expect(ownUser.totalUnreadCount, 0);
      expect(ownUser.unreadChannels, 0);
      expect(ownUser.image, 'https://placehold.jp/150x150.png');
      expect(ownUser.name, 'Proud darkness');
      expect(ownUser.custom, {'username': 'Rioland'});
    });

    test('OwnUser.toJson writes each device under its id and push_provider keys', () {
      final ownUser = OwnUser(
        id: 'user-id',
        devices: const [
          Device(id: 'device-1', pushProvider: PushProvider.firebase),
          Device(id: 'device-2', pushProvider: PushProvider.apn),
        ],
      );

      final json = ownUser.toJson();

      expect(json['devices'], [
        {'id': 'device-1', 'push_provider': 'firebase'},
        {'id': 'device-2', 'push_provider': 'apn'},
      ]);
    });

    test('OwnUser.fromJson reads back the devices OwnUser.toJson wrote', () {
      final json = OwnUser(
        id: 'user-id',
        devices: const [Device(id: 'device-1', pushProvider: PushProvider.firebase)],
      ).toJson();

      final decoded = OwnUser.fromJson(json);

      expect(decoded.devices.map((it) => (it.id, it.pushProvider)), [('device-1', 'firebase')]);
    });

    test('OwnUser.fromJson fails on a device missing its id or push provider', () {
      final json = jsonFixture('own_user.json');
      final device = Map<String, dynamic>.from((json['devices']! as List).single as Map);

      for (final field in ['id', 'push_provider']) {
        final incomplete = Map<String, dynamic>.from(device)..remove(field);

        expect(
          () => OwnUser.fromJson({
            ...json,
            'devices': [incomplete],
          }),
          throwsA(isA<TypeError>()),
          reason: 'a device without $field should not decode',
        );
      }
    });

    test('should initialize a OwnUser from a User correctly', () {
      final user = User.fromJson(jsonFixture('user.json'));
      final ownUser = OwnUser.fromUser(user);

      expect(ownUser.id, user.id);
      expect(ownUser.role, user.role);
      expect(ownUser.name, user.name);
      expect(ownUser.image, user.image);
      expect(ownUser.createdAt, user.createdAt);
      expect(ownUser.updatedAt, user.updatedAt);
      expect(ownUser.lastActive, user.lastActive);
      expect(ownUser.online, user.online);
      expect(ownUser.banned, user.banned);
      expect(ownUser.banExpires, user.banExpires);
      expect(ownUser.teams, user.teams);
      expect(ownUser.language, user.language);
      expect(ownUser.invisible, user.invisible);
      expect(ownUser.teamsRole, user.teamsRole);
      expect(ownUser.avgResponseTime, user.avgResponseTime);
      expect(ownUser.custom, user.custom);
      expect(ownUser.deactivatedAt, user.deactivatedAt);
      expect(ownUser.deletedAt, user.deletedAt);
      expect(ownUser.shadowBanned, user.shadowBanned);
      expect(ownUser.blockedUserIds, user.blockedUserIds);
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
      expect(newUser.custom, user.custom);
      expect(newUser.banned, user.banned);
      expect(newUser.teams, user.teams);
      expect(newUser.language, user.language);
      expect(newUser.image, user.image);

      newUser = user.copyWith(
        id: 'test',
        role: 'test',
        name: 'test',
        image: 'https://getstream.io/image-new',
        custom: {
          'color': 'red',
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
        deactivatedAt: DateTime.utc(2022),
        deletedAt: DateTime.utc(2023),
        shadowBanned: true,
      );

      expect(newUser.id, 'test');
      expect(newUser.role, 'test');
      expect(newUser.name, 'test');
      expect(newUser.image, 'https://getstream.io/image-new');
      expect(newUser.custom, {'color': 'red'});
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
      expect(newUser.deactivatedAt, DateTime.utc(2022));
      expect(newUser.deletedAt, DateTime.utc(2023));
      expect(newUser.shadowBanned, isTrue);
    });

    test('merge', () {
      final user = OwnUser.fromJson(jsonFixture('own_user.json'));
      final newUser = user.merge(
        OwnUser(
          id: 'test',
          role: 'test',
          name: 'test',
          custom: const {
            'color': 'red',
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
          deactivatedAt: DateTime.utc(2022),
          deletedAt: DateTime.utc(2023),
          shadowBanned: true,
        ),
      );

      expect(newUser.id, 'test');
      expect(newUser.role, 'test');
      expect(newUser.name, 'test');
      expect(newUser.image, 'https://getstream.io/image-new');
      expect(newUser.custom, {'color': 'red'});
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
      expect(newUser.deactivatedAt, DateTime.utc(2022));
      expect(newUser.deletedAt, DateTime.utc(2023));
      expect(newUser.shadowBanned, isTrue);
    });

    test('OwnUser.fromUser keeps a user with no name nameless', () {
      final ownUser = OwnUser.fromUser(User(id: 'test-id'));

      expect(ownUser.name, isNull);
      expect(ownUser.toJson().containsKey('name'), isFalse);
    });

    test('merge clears the values the other user leaves out', () {
      final user = OwnUser(
        id: 'test-user',
        deactivatedAt: DateTime.utc(2020),
        deletedAt: DateTime.utc(2021),
        shadowBanned: true,
      );

      final merged = user.merge(OwnUser(id: 'test-user'));

      expect(merged.deactivatedAt, isNull);
      expect(merged.deletedAt, isNull);
      expect(merged.shadowBanned, isNull);
    });

    test('merge keeps the values the other user leaves out', () {
      final user = OwnUser(
        id: 'test-user',
        role: 'admin',
        name: 'Jane',
        image: 'https://example.com/jane.png',
        createdAt: createdAt,
        updatedAt: updatedAt,
        lastActive: lastActive,
        banExpires: DateTime.utc(2030),
        language: 'fr',
        invisible: true,
        teamsRole: const {'team-a': 'admin'},
        avgResponseTime: 12,
        pushPreferences: const PushPreference(chatLevel: ChatLevel.mentions),
        privacySettings: const PrivacySettings(typingIndicators: TypingIndicators(enabled: false)),
      );

      final merged = user.merge(OwnUser(id: 'test-user'));

      expect(merged.role, 'admin');
      expect(merged.name, 'Jane');
      expect(merged.image, 'https://example.com/jane.png');
      expect(merged.createdAt, createdAt);
      expect(merged.updatedAt, updatedAt);
      expect(merged.lastActive, lastActive);
      expect(merged.banExpires, DateTime.utc(2030));
      expect(merged.language, 'fr');
      expect(merged.invisible, isTrue);
      expect(merged.teamsRole, {'team-a': 'admin'});
      expect(merged.avgResponseTime, 12);
      expect(merged.pushPreferences, const PushPreference(chatLevel: ChatLevel.mentions));
      expect(merged.privacySettings, const PrivacySettings(typingIndicators: TypingIndicators(enabled: false)));
    });

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
          typingIndicators: TypingIndicators(enabled: false),
          readReceipts: ReadReceipts(enabled: false),
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
            typingIndicators: TypingIndicators(enabled: false),
            readReceipts: ReadReceipts(enabled: false),
          ),
        ),
      );

      expect(updatedUser.privacySettings, isNotNull);
      expect(updatedUser.privacySettings?.typingIndicators?.enabled, false);
      expect(updatedUser.privacySettings?.readReceipts?.enabled, false);
    });

    test('fromUser should copy the blocked user ids', () {
      final userJson = {
        'id': 'test-user',
        'blocked_user_ids': ['blocked-1', 'blocked-2', 'blocked-3'],
      };

      final user = User.fromJson(userJson);
      final ownUser = OwnUser.fromUser(user);

      expect(ownUser.blockedUserIds, hasLength(3));
      expect(ownUser.blockedUserIds, contains('blocked-1'));
      expect(ownUser.blockedUserIds, contains('blocked-2'));
      expect(ownUser.blockedUserIds, contains('blocked-3'));
    });

    test('fromUser should handle missing OwnUser-specific fields', () {
      final userJson = {
        'id': 'test-user',
        'name': 'Test User',
      };

      final user = User.fromJson(userJson);
      final ownUser = OwnUser.fromUser(user);

      expect(ownUser.devices, isEmpty);
      expect(ownUser.mutes, isEmpty);
      expect(ownUser.channelMutes, isEmpty);
      expect(ownUser.totalUnreadCount, 0);
      expect(ownUser.unreadChannels, 0);
      expect(ownUser.unreadThreads, 0);
      expect(ownUser.blockedUserIds, isEmpty);
      expect(ownUser.pushPreferences, isNull);
      expect(ownUser.privacySettings, isNull);
    });

    test('fromUser should work with OwnUser as input', () {
      final originalOwnUser = OwnUser(
        id: 'test-user',
        name: 'Test User',
        role: 'admin',
        image: 'https://example.com/avatar.png',
        custom: const {
          'company': 'Stream',
          'department': 'Engineering',
          'custom_field': 'custom_value',
        },
        devices: const [
          Device(
            id: 'device-1',
            pushProvider: PushProvider.firebase,
          ),
        ],
        totalUnreadCount: 10,
        unreadChannels: 2,
        unreadThreads: 1,
        blockedUserIds: const ['blocked-1', 'blocked-2'],
        pushPreferences: const PushPreference(
          callLevel: CallLevel.all,
          chatLevel: ChatLevel.mentions,
        ),
        privacySettings: const PrivacySettings(
          typingIndicators: TypingIndicators(enabled: false),
          readReceipts: ReadReceipts(enabled: true),
        ),
      );

      final convertedOwnUser = OwnUser.fromUser(originalOwnUser);

      // Verify all fields are preserved
      expect(convertedOwnUser.id, originalOwnUser.id);
      expect(convertedOwnUser.name, originalOwnUser.name);
      expect(convertedOwnUser.role, originalOwnUser.role);
      expect(convertedOwnUser.image, originalOwnUser.image);
      expect(convertedOwnUser.custom['company'], 'Stream');
      expect(convertedOwnUser.custom['department'], 'Engineering');
      expect(convertedOwnUser.custom['custom_field'], 'custom_value');
      expect(convertedOwnUser.devices.length, 1);
      expect(convertedOwnUser.devices.first.id, 'device-1');
      expect(convertedOwnUser.devices.first.pushProvider, 'firebase');
      expect(convertedOwnUser.totalUnreadCount, 10);
      expect(convertedOwnUser.unreadChannels, 2);
      expect(convertedOwnUser.unreadThreads, 1);
      expect(convertedOwnUser.blockedUserIds, ['blocked-1', 'blocked-2']);
      final pushPreferences = convertedOwnUser.pushPreferences;
      expect(pushPreferences?.callLevel, CallLevel.all);
      expect(pushPreferences?.chatLevel, ChatLevel.mentions);
      final privacySettings = convertedOwnUser.privacySettings;
      expect(privacySettings?.typingIndicators?.enabled, false);
      expect(privacySettings?.readReceipts?.enabled, true);
    });

    test(
      'OwnUser.fromJson reads back what OwnUser.toJson wrote',
      () {
        final originalOwnUser = OwnUser(
          id: 'test-user',
          name: 'Test User',
          role: 'moderator',
          image: 'https://example.com/profile.jpg',
          custom: const {
            'title': 'Senior Developer',
            'location': 'Amsterdam',
            'is_verified': true,
          },
          devices: const [
            Device(
              id: 'device-1',
              pushProvider: PushProvider.firebase,
            ),
            Device(
              id: 'device-2',
              pushProvider: PushProvider.apn,
            ),
          ],
          totalUnreadCount: 25,
          unreadChannels: 5,
          unreadThreads: 3,
          blockedUserIds: const ['blocked-1', 'blocked-2', 'blocked-3'],
          pushPreferences: const PushPreference(
            callLevel: CallLevel.none,
            chatLevel: ChatLevel.all,
            disabledUntil: null,
          ),
          privacySettings: const PrivacySettings(
            typingIndicators: TypingIndicators(enabled: true),
            readReceipts: ReadReceipts(enabled: false),
          ),
        );

        final reconstructedOwnUser = OwnUser.fromJson(originalOwnUser.toJson());

        // Verify all fields are preserved through the round-trip
        expect(reconstructedOwnUser.id, originalOwnUser.id);
        expect(reconstructedOwnUser.name, originalOwnUser.name);
        expect(reconstructedOwnUser.role, originalOwnUser.role);
        expect(reconstructedOwnUser.image, originalOwnUser.image);

        // Verify custom data
        expect(reconstructedOwnUser.custom['title'], 'Senior Developer');
        expect(reconstructedOwnUser.custom['location'], 'Amsterdam');
        expect(reconstructedOwnUser.custom['is_verified'], true);

        // Verify OwnUser-specific fields
        expect(reconstructedOwnUser.devices.length, 2);
        expect(reconstructedOwnUser.devices[0].id, 'device-1');
        expect(reconstructedOwnUser.devices[0].pushProvider, 'firebase');
        expect(reconstructedOwnUser.devices[1].id, 'device-2');
        expect(reconstructedOwnUser.devices[1].pushProvider, 'apn');

        expect(reconstructedOwnUser.totalUnreadCount, 25);
        expect(reconstructedOwnUser.unreadChannels, 5);
        expect(reconstructedOwnUser.unreadThreads, 3);
        expect(reconstructedOwnUser.blockedUserIds.length, 3);
        expect(reconstructedOwnUser.blockedUserIds, contains('blocked-1'));
        expect(reconstructedOwnUser.blockedUserIds, contains('blocked-2'));
        expect(reconstructedOwnUser.blockedUserIds, contains('blocked-3'));

        // Verify push preferences
        final pushPrefs = reconstructedOwnUser.pushPreferences;
        expect(pushPrefs, isNotNull);
        expect(pushPrefs?.callLevel, CallLevel.none);
        expect(pushPrefs?.chatLevel, ChatLevel.all);
        expect(pushPrefs?.disabledUntil, isNull);

        // Verify privacy settings
        final privacySettings = reconstructedOwnUser.privacySettings;
        expect(privacySettings, isNotNull);
        expect(privacySettings?.typingIndicators?.enabled, true);
        expect(privacySettings?.readReceipts?.enabled, false);
      },
    );
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
          typingIndicators: TypingIndicators(enabled: true),
        ),
      );

      expect(user.isTypingIndicatorsEnabled, true);
    });

    test('isTypingIndicatorsEnabled should return false when disabled', () {
      final user = OwnUser(
        id: 'test-user',
        privacySettings: const PrivacySettings(
          typingIndicators: TypingIndicators(enabled: false),
        ),
      );

      expect(user.isTypingIndicatorsEnabled, false);
    });

    test(
      'isTypingIndicatorsEnabled should return true when privacy settings '
      'exists but typing indicators is null',
      () {
        final user = OwnUser(
          id: 'test-user',
          privacySettings: const PrivacySettings(
            readReceipts: ReadReceipts(enabled: false),
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
          readReceipts: ReadReceipts(enabled: true),
        ),
      );

      expect(user.isReadReceiptsEnabled, true);
    });

    test('isReadReceiptsEnabled should return false when disabled', () {
      final user = OwnUser(
        id: 'test-user',
        privacySettings: const PrivacySettings(
          readReceipts: ReadReceipts(enabled: false),
        ),
      );

      expect(user.isReadReceiptsEnabled, false);
    });

    test(
      'isReadReceiptsEnabled should return true when privacy settings exists '
      'but read receipts is null',
      () {
        final user = OwnUser(
          id: 'test-user',
          privacySettings: const PrivacySettings(
            typingIndicators: TypingIndicators(enabled: false),
          ),
        );

        expect(user.isReadReceiptsEnabled, true);
      },
    );

    test('isDeliveryReceiptsEnabled should return true when null', () {
      final user = OwnUser(id: 'test-user');

      expect(user.isDeliveryReceiptsEnabled, true);
    });

    test('isDeliveryReceiptsEnabled should return true when enabled', () {
      final user = OwnUser(
        id: 'test-user',
        privacySettings: const PrivacySettings(
          deliveryReceipts: DeliveryReceipts(enabled: true),
        ),
      );

      expect(user.isDeliveryReceiptsEnabled, true);
    });

    test('isDeliveryReceiptsEnabled should return false when disabled', () {
      final user = OwnUser(
        id: 'test-user',
        privacySettings: const PrivacySettings(
          deliveryReceipts: DeliveryReceipts(enabled: false),
        ),
      );

      expect(user.isDeliveryReceiptsEnabled, false);
    });

    test(
      'isDeliveryReceiptsEnabled should return true when privacy settings '
      'exists but delivery receipts is null',
      () {
        final user = OwnUser(
          id: 'test-user',
          privacySettings: const PrivacySettings(
            typingIndicators: TypingIndicators(enabled: false),
          ),
        );

        expect(user.isDeliveryReceiptsEnabled, true);
      },
    );
  });
}
