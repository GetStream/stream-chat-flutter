// ignore_for_file: avoid_redundant_argument_values

import 'package:stream_chat/src/core/models/banned_user.dart';
import 'package:stream_chat/src/core/models/channel_model.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('src/models/banned_user', () {
    group('BannedUserSortField', () {
      test('createdAt orders older bans first', () {
        expectOrders(
          BannedUserSortField.createdAt,
          createTestBannedUser(userId: 'older-ban', createdAt: DateTime(2023, 6, 10)),
          createTestBannedUser(userId: 'recent-ban', createdAt: DateTime(2023, 6, 15)),
        );
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
