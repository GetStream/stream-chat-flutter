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
      expect(member.extraData['some_custom_field'], 'with_custom_data');
    });

    group('ComparableFieldProvider', () {
      test('should return ComparableField for member.createdAt', () {
        final createdAt = DateTime(2023, 6, 15);
        final member = createTestMember(
          userId: 'test-user',
          createdAt: createdAt,
        );

        final field = member.getComparableField(MemberSortKey.createdAt);
        expect(field, isNotNull);
        expect(field!.value, equals(createdAt));
      });

      test('should return ComparableField for member.userId', () {
        final member = createTestMember(
          userId: 'test-user',
        );

        final field = member.getComparableField(MemberSortKey.userId);
        expect(field, isNotNull);
        expect(field!.value, equals('test-user'));
      });

      test('should return ComparableField for member user.name', () {
        final member = createTestMember(
          userId: 'test-user',
          userName: 'Test User',
        );

        final field = member.getComparableField(MemberSortKey.name);
        expect(field, isNotNull);
        expect(field!.value, equals('Test User'));
      });

      test('should return ComparableField for member.channelRole', () {
        final member = createTestMember(
          userId: 'test-user',
          channelRole: 'owner',
        );

        final field = member.getComparableField(MemberSortKey.channelRole);
        expect(field, isNotNull);
        expect(field!.value, equals('owner'));
      });

      test('should return ComparableField for member.extraData', () {
        final member = createTestMember(
          userId: 'test-user',
          extraData: {'activityScore': 75},
        );

        final field = member.getComparableField('activityScore');
        expect(field, isNotNull);
        expect(field!.value, equals(75));
      });

      test('should return null for non-existent extraData keys', () {
        final member = createTestMember(
          userId: 'test-user',
        );

        final field = member.getComparableField('non_existent_key');
        expect(field, isNull);
      });

      test('should return null when user is null for name field', () {
        final member = createTestMember(
          userId: 'test-user',
          includeUser: false,
        );

        final field = member.getComparableField(MemberSortKey.name);
        expect(field, isNull);
      });

      test('should compare two members correctly using createdAt', () {
        final recentMember = createTestMember(
          userId: 'recent',
          createdAt: DateTime(2023, 6, 15),
        );

        final olderMember = createTestMember(
          userId: 'older',
          createdAt: DateTime(2023, 6, 10),
        );

        final field1 = recentMember.getComparableField(MemberSortKey.createdAt);
        final field2 = olderMember.getComparableField(MemberSortKey.createdAt);

        expect(field1!.compareTo(field2!),
            greaterThan(0)); // More recent > Less recent
        expect(
            field2.compareTo(field1), lessThan(0)); // Less recent < More recent
      });

      test('should compare two members correctly using userId', () {
        final member1 = createTestMember(
          userId: 'alice',
        );

        final member2 = createTestMember(
          userId: 'bob',
        );

        final field1 = member1.getComparableField(MemberSortKey.userId);
        final field2 = member2.getComparableField(MemberSortKey.userId);

        expect(field1!.compareTo(field2!), lessThan(0)); // alice < bob
        expect(field2.compareTo(field1), greaterThan(0)); // bob > alice
      });

      test('should compare two members correctly using user name', () {
        final member1 = createTestMember(
          userId: 'user1',
          userName: 'Alice',
        );

        final member2 = createTestMember(
          userId: 'user2',
          userName: 'Bob',
        );

        final field1 = member1.getComparableField(MemberSortKey.name);
        final field2 = member2.getComparableField(MemberSortKey.name);

        expect(field1!.compareTo(field2!), lessThan(0)); // Alice < Bob
        expect(field2.compareTo(field1), greaterThan(0)); // Bob > Alice
      });

      test('should compare two members correctly using channelRole', () {
        final owner = createTestMember(
          userId: 'owner',
          channelRole: 'owner',
        );

        final moderator = createTestMember(
          userId: 'moderator',
          channelRole: 'moderator',
        );

        final field1 = owner.getComparableField(MemberSortKey.channelRole);
        final field2 = moderator.getComparableField(MemberSortKey.channelRole);

        expect(field1!.compareTo(field2!),
            greaterThan(0)); // 'owner' > 'moderator' alphabetically
        expect(field2.compareTo(field1),
            lessThan(0)); // 'moderator' < 'owner' alphabetically
      });

      test('should compare two members correctly using extraData', () {
        final highScore = createTestMember(
          userId: 'high',
          extraData: {'score': 100},
        );

        final lowScore = createTestMember(
          userId: 'low',
          extraData: {'score': 50},
        );

        final field1 = highScore.getComparableField('score');
        final field2 = lowScore.getComparableField('score');

        expect(field1!.compareTo(field2!), greaterThan(0)); // 100 > 50
        expect(field2.compareTo(field1), lessThan(0)); // 50 < 100
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
  bool includeUser = true,
  Map<String, Object?>? extraData,
}) {
  return Member(
    userId: userId,
    user: includeUser
        ? User(
            id: userId,
            name: userName,
          )
        : null,
    channelRole: channelRole,
    createdAt: createdAt ?? DateTime(2023),
    updatedAt: updatedAt ?? DateTime(2023),
    extraData: extraData ?? {},
  );
}
