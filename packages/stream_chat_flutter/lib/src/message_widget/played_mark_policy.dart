import 'package:meta/meta.dart';

import '../../stream_chat_flutter.dart';

/// Played-mark checks for the current user on a [Channel].
@internal
extension PlayedMarkPolicy on Channel {
  /// Whether the current user should mark [message] played.
  ///
  /// True when the channel allows played marks, the current user didn't send
  /// [message], and hasn't played it before.
  bool shouldMarkPlayed(Message message) {
    if (!canSendMessageMark) return false;

    final currentUserId = client.state.currentUser?.id;
    if (message.user?.id == currentUserId) return false;

    final ownMarks = message.ownMarks ?? const [];
    return !ownMarks.any((it) => it.type == MessageMarkType.played);
  }
}
