import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Sample-app helpers around `currentUser.mutes` and
/// `currentUser.blockedUserIds` — wrap the verbose
/// `currentUserStream.map(...).distinct()` pattern so the call sites stay
/// readable.
extension ClientUserStateExtensions on StreamChatClient {
  /// Whether the current user has muted the user with the given [userId].
  bool isUserMuted(String userId) => state.currentUser?.mutes.any((m) => m.target.id == userId) ?? false;

  /// Reactive variant of [isUserMuted] — emits `true`/`false` as the current
  /// user's mute list changes.
  Stream<bool> userMutedStream(String userId) {
    return state.currentUserStream.map((u) => u?.mutes.any((m) => m.target.id == userId) ?? false).distinct();
  }

  /// Whether the current user has blocked the user with the given [userId].
  bool isUserBlocked(String userId) => state.currentUser?.blockedUserIds.contains(userId) ?? false;

  /// Reactive variant of [isUserBlocked] — emits `true`/`false` as the
  /// current user's blocked list changes.
  Stream<bool> userBlockedStream(String userId) {
    return state.currentUserStream.map((u) => u?.blockedUserIds.contains(userId) ?? false).distinct();
  }
}
