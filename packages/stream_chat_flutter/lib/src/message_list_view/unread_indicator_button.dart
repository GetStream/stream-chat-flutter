import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/chat.dart' as core;

/// {@template unreadIndicatorButton}
/// A floating "jump to unread" pill.
///
/// By default [UnreadIndicatorButton] listens to the current user's read
/// state and shows itself whenever there are unread messages, hiding again
/// once there are none. Users can tap to navigate to the oldest unread
/// message or dismiss the indicator.
///
/// Pass [unreadCount] to opt out of that and drive the pill from the host
/// instead: the widget then renders unconditionally with the given count and
/// never subscribes to read state, leaving visibility entirely to the caller.
/// [StreamMessageListView] uses this mode so the pill can stay on screen with
/// the count frozen at channel open, rather than tracking the live,
/// ever-shrinking unread count.
///
/// {@tool snippet}
///
/// Typical usage inside a message list:
///
/// ```dart
/// UnreadIndicatorButton(
///   onJumpTap: (lastReadMessageId) async {
///     // scroll to the unread message
///   },
///   onDismissTap: () async {
///     // mark channel as read
///   },
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamMessageListView], which hosts this widget.
/// {@endtemplate}
class UnreadIndicatorButton extends StatelessWidget {
  /// Creates an unread indicator button.
  const UnreadIndicatorButton({
    super.key,
    required this.onJumpTap,
    required this.onDismissTap,
    this.unreadCount,
  });

  /// The unread count to display, when the host owns the pill's visibility.
  ///
  /// When null (the default), the count is read from the current user's read
  /// state and the pill hides itself while there is nothing unread. When set,
  /// the widget renders unconditionally with this count and does not
  /// subscribe to read state at all — the caller decides when to show it.
  final int? unreadCount;

  /// Called when the jump-to-unread area is tapped.
  ///
  /// Receives the ID of the last message the current user has read, which can
  /// be used to scroll to that position. It is `null` when [unreadCount] is
  /// supplied, since the host owns the boundary in that mode and the widget
  /// never reads the channel's read state.
  final Future<void> Function(String? lastReadMessageId) onJumpTap;

  /// Called when the dismiss button is tapped.
  ///
  /// Typically used to mark all messages as read.
  final Future<void> Function() onDismissTap;

  Widget _buildButton(BuildContext context, int count, String? lastReadMessageId) {
    return core.StreamJumpToUnreadButton(
      label: context.translations.unreadCountIndicatorLabel(unreadCount: count),
      onJumpPressed: () => onJumpTap(lastReadMessageId),
      onDismissPressed: onDismissTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (unreadCount case final count?) {
      return _buildButton(context, count, null);
    }

    final channel = StreamChannel.of(context).channel;
    if (channel.state == null) return const Empty();

    return BetterStreamBuilder(
      initialData: channel.state!.currentUserRead,
      stream: channel.state!.currentUserReadStream,
      builder: (context, currentUserRead) {
        final count = currentUserRead.unreadMessages;
        if (count <= 0) return const Empty();
        return _buildButton(context, count, currentUserRead.lastReadMessageId);
      },
    );
  }
}
