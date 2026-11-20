import 'package:freezed_annotation/freezed_annotation.dart';

part 'unread_counts_channel.freezed.dart';

/// The current user's unread count in one channel.
///
/// See also:
///
///  * [GetUnreadCountResponse.channels], which lists them.
@freezed
class UnreadCountsChannel with _$UnreadCountsChannel {
  /// Creates a new [UnreadCountsChannel].
  const UnreadCountsChannel({
    required this.channelId,
    required this.unreadCount,
    required this.lastRead,
  });

  /// The channel's cid, such as `messaging:general`.
  @override
  final String channelId;

  /// The number of unread messages in the channel.
  @override
  final int unreadCount;

  /// The time the user last read the channel.
  @override
  final DateTime lastRead;
}
