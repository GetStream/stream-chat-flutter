// ignore_for_file: avoid_redundant_argument_values

import 'package:stream_chat/src/core/models/banned_user.dart';
import 'package:stream_chat/src/core/models/channel_model.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:test/test.dart';

void main() {
  group('src/models/banned_user', () {
    group('ComparableFieldProvider', () {
      test('should return ComparableField for banned_user.createdAt', () {
        final createdAt = DateTime(2023, 6, 15);
        final bannedUser = createTestBannedUser(
          userId: 'banned-user-id',
          createdAt: createdAt,
        );

        final field = bannedUser.getComparableField(
          BannedUserSortKey.createdAt,
        );

        expect(field, isNotNull);
        expect(field!.value, equals(createdAt));
      });

      test('should return null for non-existent field keys', () {
        final bannedUser = createTestBannedUser(
          userId: 'banned-user-id',
        );

        final field = bannedUser.getComparableField('non_existent_key');
        expect(field, isNull);
      });

      test('should compare two banned users correctly using createdAt', () {
        final recentBan = createTestBannedUser(
          userId: 'recent-ban',
          createdAt: DateTime(2023, 6, 15),
        );

        final olderBan = createTestBannedUser(
          userId: 'older-ban',
          createdAt: DateTime(2023, 6, 10),
        );

        final field1 = recentBan.getComparableField(
          BannedUserSortKey.createdAt,
        );

        final field2 = olderBan.getComparableField(
          BannedUserSortKey.createdAt,
        );

        // More recent > Less recent
        expect(field1!.compareTo(field2!), greaterThan(0));
        // Less recent < More recent
        expect(field2.compareTo(field1), lessThan(0));
      });
    });
  });
}

/// Helper function to create a BannedUser for testing
BannedUser createTestBannedUser({
  required String userId,
  DateTime? createdAt,
  DateTime? expires,
  String? reason,
  bool shadow = false,
  String? channelId,
  String? channelType,
}) {
  return BannedUser(
    user: User(id: userId),
    bannedBy: User(id: 'moderator-user'),
    channel: channelId != null && channelType != null
        ? ChannelModel(
            id: channelId,
            type: channelType,
          )
        : null,
    createdAt: createdAt,
    expires: expires,
    shadow: shadow,
    reason: reason,
  );
}
