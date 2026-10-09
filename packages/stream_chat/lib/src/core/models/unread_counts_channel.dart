import 'package:freezed_annotation/freezed_annotation.dart';

part 'unread_counts_channel.freezed.dart';

/// The current user's unread count in one channel.
///
/// Listed in [GetUnreadCountResponse.channels].
@freezed
class UnreadCountsChannel with _$UnreadCountsChannel {
  /// Creates a new [UnreadCountsChannel].
  const UnreadCountsChannel({
    required this.channelId,
    required this.unreadCount,
    required this.lastRead,
  });

  /// The channel's cid, in the form `type:id` (for example `messaging:general`).
  @override
  final String channelId;

  /// The number of unread messages in the channel.
  @override
  final int unreadCount;

  /// The time the user last read the channel, or when they joined it if they never have.
  @override
  final DateTime lastRead;
}
