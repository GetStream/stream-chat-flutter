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
