import 'package:stream_chat/src/core/models/member.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('src/models/member', () {
    test('should parse json correctly', () {
      final member = Member.fromJson(jsonFixture('member.json'));
      expect(member.user, isA<User>());
      expect(member.channelRole, 'channel_member');
      expect(member.createdAt, DateTime.parse('2020-01-28T22:17:30.95443Z'));
      expect(member.updatedAt, DateTime.parse('2020-01-28T22:17:30.95443Z'));
      expect(member.deletedMessages, ['msg-1', 'msg-2', 'msg-3']);
      expect(member.extraData['some_custom_field'], 'with_custom_data');
      expect(member.notificationsMuted, isTrue);
      expect(member.status, 'member');
      expect(member.banFromFutureChannels, isTrue);
      expect(member.futureChannelBanExpires, DateTime.parse('2020-02-28T22:17:30.95443Z'));
      expect(member.deletedAt, DateTime.parse('2020-01-29T22:17:30.95443Z'));
    });

    test(
      'Member keeps notificationsMuted, status, banFromFutureChannels, futureChannelBanExpires and deletedAt in extraData',
      () {
        final member = Member(
          userId: 'user',
          notificationsMuted: true,
          status: 'member',
          banFromFutureChannels: true,
          futureChannelBanExpires: DateTime.utc(2021),
          deletedAt: DateTime.utc(2020),
          extraData: const {'color': 'red'},
        );

        expect(member.extraData, {
          'color': 'red',
          'notifications_muted': true,
          'status': 'member',
          'ban_from_future_channels': true,
          'future_channel_ban_expires': DateTime.utc(2021).toIso8601String(),
          'deleted_at': DateTime.utc(2020).toIso8601String(),
        });
      },
    );

    test('Member.deletedAt returns null for an extraData value that is not a date', () {
      final member = Member(userId: 'user', extraData: const {'deleted_at': 'yesterday'});

      expect(member.deletedAt, isNull);
    });

    test('Member.futureChannelBanExpires returns null for an empty extraData value', () {
      final member = Member(userId: 'user', extraData: const {'future_channel_ban_expires': ''});

      expect(member.futureChannelBanExpires, isNull);
    });

    group('MemberSortField', () {
      test('createdAt orders older memberships first', () {
        expectOrders(
          MemberSortField.createdAt,
          createTestMember(userId: 'older', createdAt: DateTime(2023, 6, 10)),
          createTestMember(userId: 'newer', createdAt: DateTime(2023, 6, 15)),
        );
      });

      test('updatedAt orders older memberships first', () {
        expectOrders(
          MemberSortField.updatedAt,
          createTestMember(userId: 'older', updatedAt: DateTime(2023, 6, 10)),
          createTestMember(userId: 'newer', updatedAt: DateTime(2023, 6, 15)),
        );
      });

      test('userId orders alphabetically', () {
        expectOrders(
          MemberSortField.userId,
          createTestMember(userId: 'alice'),
          createTestMember(userId: 'bob'),
        );
      });

      test('name orders by the user name, folded', () {
        // Folding is what makes a local sort agree with the server: `Zara`
        // would otherwise sort before `alice`.
        expectOrders(
          MemberSortField.name,
          createTestMember(userId: 'a', userName: 'alice'),
          createTestMember(userId: 'z', userName: 'Zara'),
        );
      });

      test('name orders nothing for a member with no user', () {
        expectOrdersNothing(
          MemberSortField.name,
          createTestMember(userId: 'no-user', includeUser: false),
        );
      });

      test('name orders nothing for a member whose user has no name', () {
        // `User.name` answers the id when a user has no name. Sorting by that
        // would order unnamed members among the named ones, where the API
        // sorts them together by an empty `name` column.
        expectOrdersNothing(
          MemberSortField.name,
          createTestMember(userId: 'alice'),
          createTestMember(userId: 'zara'),
        );
      });

      test('channelRole orders alphabetically', () {
        expectOrders(
          MemberSortField.channelRole,
          createTestMember(userId: 'a', channelRole: 'channel_member'),
          createTestMember(userId: 'b', channelRole: 'owner'),
        );
      });

      test('a custom field orders by the member extra data', () {
        expectOrders(
          MemberSortField.custom('activityScore'),
          createTestMember(userId: 'a', extraData: const {'activityScore': 10}),
          createTestMember(userId: 'b', extraData: const {'activityScore': 75}),
        );
      });

      test('a custom field the member does not carry orders nothing', () {
        expectOrdersNothing(
          MemberSortField.custom('non_existent_key'),
          createTestMember(userId: 'plain'),
        );
      });
    });
  });
}

/// Helper function to create a Member for testing
Member createTestMember({
  required String userId,
  String? userName,
  String? channelRole,
  DateTime? createdAt,
  DateTime? updatedAt,
  DateTime? userLastActive,
  bool includeUser = true,
  Map<String, Object?>? extraData,
}) {
  return Member(
    userId: userId,
    user: includeUser
        ? User(
            id: userId,
            name: userName,
            lastActive: userLastActive,
          )
        : null,
    channelRole: channelRole,
    createdAt: createdAt ?? DateTime(2023),
    updatedAt: updatedAt ?? DateTime(2023),
    extraData: extraData ?? {},
  );
}
