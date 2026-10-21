import 'package:freezed_annotation/freezed_annotation.dart';

part 'unread_counts_thread.freezed.dart';

/// The current user's unread count in one thread.
///
/// See also:
///
///  * [GetUnreadCountResponse.threads], which lists them.
@freezed
class UnreadCountsThread with _$UnreadCountsThread {
  /// Creates a new [UnreadCountsThread].
  const UnreadCountsThread({
    required this.unreadCount,
    required this.lastRead,
    required this.lastReadMessageId,
    required this.parentMessageId,
  });

  /// The number of unread replies in the thread.
  @override
  final int unreadCount;

  /// The time the user last read the thread.
  @override
  final DateTime lastRead;

  /// The id of the last reply the user read in the thread.
  ///
  /// Empty if they have not read one.
  @override
  final String lastReadMessageId;

  /// The id of the message the thread replies to.
  @override
  final String parentMessageId;
}
