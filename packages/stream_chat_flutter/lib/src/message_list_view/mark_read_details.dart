/// The information available when deciding whether to automatically mark a
/// [StreamMessageListView]'s channel as read.
///
/// Passed to a caller-supplied predicate on
/// [StreamMessageListViewConfiguration.shouldMarkRead]. Not intended to be
/// constructed directly.
class StreamMarkReadDetails {
  /// Creates a set of details describing the current mark-read gate state.
  const StreamMarkReadDetails({
    required this.hasSeenLastMessage,
    required this.hasSeenFirstUnreadMessage,
    required this.isMarkedAsUnread,
    required this.unreadCount,
  });

  /// Whether the bottom of the list has been fully visible at some point
  /// since the last successful mark-read — either it's visible right now, or
  /// it was visible earlier and the user has since scrolled away.
  final bool hasSeenLastMessage;

  /// Whether the user has seen (rendered on screen) or scrolled past the
  /// pre-existing unread boundary captured when the channel was opened.
  ///
  /// Always `true` when there was nothing to see in the first place — the
  /// channel opened fully read, or it uses local unread counts with read
  /// events disabled.
  final bool hasSeenFirstUnreadMessage;

  /// Whether the current user has an active manual mark-unread on this
  /// channel that hasn't been read past yet.
  final bool isMarkedAsUnread;

  /// The channel's current unread count.
  final int unreadCount;
}

/// Signature for overriding [StreamMessageListView]'s automatic mark-read
/// gating.
///
/// Return `true` to mark the channel as read, `false` to skip it for now —
/// the list retries on the next relevant scroll or message event.
typedef StreamShouldMarkReadPredicate = bool Function(StreamMarkReadDetails details);
