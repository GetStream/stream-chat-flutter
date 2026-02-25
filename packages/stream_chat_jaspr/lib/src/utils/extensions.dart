import 'package:intl/intl.dart';
import 'package:stream_chat/stream_chat.dart';

/// Extensions on [Channel] for common UI operations.
extension ChannelX on Channel {
  /// Resolves a display name for the channel.
  ///
  /// Returns the channel name if set, otherwise generates one from the
  /// other members' names (excluding [currentUser]).
  String resolveChannelName(User currentUser) {
    if (name != null && name!.isNotEmpty) return name!;

    final members = state?.members ?? [];
    final otherMembers =
        members.where((m) => m.userId != currentUser.id).toList();

    if (otherMembers.isEmpty) return 'No title';

    if (otherMembers.length == 1) {
      return otherMembers.first.user?.name ?? 'No title';
    }

    final names = otherMembers
        .map((m) => m.user?.name)
        .where((n) => n != null && n.isNotEmpty)
        .take(3)
        .toList();

    final remaining = otherMembers.length - names.length;
    final joined = names.join(', ');
    if (remaining > 0) return '$joined + $remaining';
    return joined;
  }

  /// Returns a preview string for the last message in the channel.
  ///
  /// Filters out shadowed, deleted, error, and ephemeral messages.
  String resolveLastMessageText() {
    final messages = state?.messages ?? [];
    final lastMessage = messages.lastWhereOrNull(_isVisibleMessage);
    if (lastMessage == null) return 'No messages yet';
    return _messagePreviewText(lastMessage);
  }

  /// Returns the initials for the channel avatar.
  ///
  /// For 1:1 channels returns the other user's initials, otherwise
  /// returns the first letter of the channel name.
  String resolveInitials(User currentUser) {
    final members = state?.members ?? [];
    final otherMembers =
        members.where((m) => m.userId != currentUser.id).toList();

    if (otherMembers.length == 1) {
      final user = otherMembers.first.user;
      if (user != null) return _userInitials(user);
    }

    final channelName = name;
    if (channelName != null && channelName.isNotEmpty) {
      return channelName[0].toUpperCase();
    }

    return '#';
  }
}

/// Extensions on [DateTime] for display formatting.
extension DateTimeX on DateTime {
  /// Returns a human-readable relative timestamp.
  ///
  /// - "Just now" if less than a minute ago
  /// - "Xm" if less than an hour ago
  /// - "Xh" if less than a day ago
  /// - "Mon", "Tue" etc. if within the last week
  /// - "MMM d" if within the same year
  /// - "MM/dd/yy" otherwise
  String toRelativeString() {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return DateFormat.E().format(toLocal());
    if (year == now.year) return DateFormat.MMMd().format(toLocal());
    return DateFormat.yMd().format(toLocal());
  }
}

bool _isVisibleMessage(Message message) {
  if (message.isShadowed) return false;
  if (message.isDeleted) return false;
  if (message.isError) return false;
  if (message.isEphemeral) return false;
  return true;
}

String _messagePreviewText(Message message) {
  if (message.text != null && message.text!.isNotEmpty) {
    return message.text!;
  }

  if (message.attachments.isNotEmpty) {
    final count = message.attachments.length;
    return count == 1 ? '📎 Attachment' : '📎 $count attachments';
  }

  return '';
}

String _userInitials(User user) {
  final name = user.name;
  if (name.isEmpty) return '?';

  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.length >= 2) {
    return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
  }
  return parts.first[0].toUpperCase();
}

extension _IterableX<T> on Iterable<T> {
  T? lastWhereOrNull(bool Function(T) test) {
    T? result;
    for (final element in this) {
      if (test(element)) result = element;
    }
    return result;
  }
}
