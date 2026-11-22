import 'package:stream_chat/stream_chat.dart';
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
      expect(member.custom['some_custom_field'], 'with_custom_data');
      expect(member.notificationsMuted, isTrue);
      expect(member.status, 'member');
      expect(member.banFromFutureChannels, isTrue);
      expect(member.futureChannelBanExpires, DateTime.parse('2020-02-28T22:17:30.95443Z'));
      expect(member.deletedAt, DateTime.parse('2020-01-29T22:17:30.95443Z'));
    });

    test('Member.toJson leaves out custom data named like a field', () {
      final member = Member(
        userId: 'user',
        channelRole: 'channel_member',
        custom: const {'channel_role': 'custom', 'color': 'red'},
      );

      expect(member.toJson()['channel_role'], 'channel_member');
      expect(member.toJson()['color'], 'red');
    });

    test('Member.toJson leaves out the fields only fromJson reads', () {
      final member = Member(
        userId: 'user',
        notificationsMuted: true,
        status: 'member',
        banFromFutureChannels: true,
        futureChannelBanExpires: DateTime.utc(2021),
        deletedAt: DateTime.utc(2020),
      );

      expect(
        member.toJson().keys,
        isNot(
          anyOf(
            contains('notifications_muted'),
            contains('status'),
            contains('ban_from_future_channels'),
            contains('future_channel_ban_expires'),
            contains('deleted_at'),
          ),
        ),
      );
    });

    test('Member.copyWith replaces the fields it is given', () {
      final member = Member(
        userId: 'user',
        notificationsMuted: false,
        status: 'pending',
        banFromFutureChannels: false,
        futureChannelBanExpires: DateTime.utc(2021),
        deletedAt: DateTime.utc(2020),
      );

      final newMember = member.copyWith(
        notificationsMuted: true,
        status: 'member',
        banFromFutureChannels: true,
        futureChannelBanExpires: DateTime.utc(2022),
        deletedAt: DateTime.utc(2023),
      );

      expect(newMember.notificationsMuted, isTrue);
      expect(newMember.status, 'member');
      expect(newMember.banFromFutureChannels, isTrue);
      expect(newMember.futureChannelBanExpires, DateTime.utc(2022));
      expect(newMember.deletedAt, DateTime.utc(2023));
    });

    test('Member equality includes notificationsMuted, status, the future channel ban and deletedAt', () {
      final createdAt = DateTime.utc(2020);
      Member member({
        bool? notificationsMuted,
        String? status,
        bool? banFromFutureChannels,
        DateTime? expires,
        DateTime? deletedAt,
      }) => Member(
        userId: 'user',
        createdAt: createdAt,
        updatedAt: createdAt,
        notificationsMuted: notificationsMuted,
        status: status,
        banFromFutureChannels: banFromFutureChannels,
        futureChannelBanExpires: expires,
        deletedAt: deletedAt,
      );

      expect(member(notificationsMuted: true), isNot(member(notificationsMuted: false)));
      expect(member(status: 'member'), isNot(member(status: 'pending')));
      expect(member(banFromFutureChannels: true), isNot(member(banFromFutureChannels: false)));
      expect(member(expires: DateTime.utc(2021)), isNot(member(expires: DateTime.utc(2022))));
      expect(member(deletedAt: DateTime.utc(2021)), isNot(member(deletedAt: DateTime.utc(2022))));
    });

    test('Member.copyWith keeps the fields it is not given', () {
      final member = Member(
        userId: 'user',
        notificationsMuted: true,
        status: 'member',
        banFromFutureChannels: true,
        futureChannelBanExpires: DateTime.utc(2021),
        deletedAt: DateTime.utc(2020),
      );

      final newMember = member.copyWith(custom: const {'color': 'red'});

      expect(newMember.notificationsMuted, isTrue);
      expect(newMember.status, 'member');
      expect(newMember.banFromFutureChannels, isTrue);
      expect(newMember.futureChannelBanExpires, DateTime.utc(2021));
      expect(newMember.deletedAt, DateTime.utc(2020));
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
        // Sorting by `User.nameOrId` would order unnamed members among the
        // named ones, where the API sorts them together by an empty `name`
        // column.
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

      test('a custom field orders by the member custom data', () {
        expectOrders(
          MemberSortField.custom('activityScore'),
          createTestMember(userId: 'a', custom: const {'activityScore': 10}),
          createTestMember(userId: 'b', custom: const {'activityScore': 75}),
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
  Map<String, Object?>? custom,
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
    custom: custom ?? {},
  );
}
