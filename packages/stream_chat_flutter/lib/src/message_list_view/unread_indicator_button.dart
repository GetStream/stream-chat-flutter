import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

/// {@template unreadIndicatorButton}
/// A button that displays the number of unread messages in a channel.
///
/// [UnreadIndicatorButton] listens to the current user's read state and shows
/// a jump-to-unread button when there are unread messages. Users can tap to
/// navigate to the oldest unread message or dismiss the indicator.
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
  });

  /// Called when the jump-to-unread area is tapped.
  ///
  /// Receives the ID of the last message the current user has read,
  /// which can be used to scroll to that position.
  final Future<void> Function(String? lastReadMessageId) onJumpTap;

  /// Called when the dismiss button is tapped.
  ///
  /// Typically used to mark all messages as read.
  final Future<void> Function() onDismissTap;

  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    if (channel.state == null) return const Empty();

    return BetterStreamBuilder(
      initialData: channel.state!.currentUserRead,
      stream: channel.state!.currentUserReadStream,
      builder: (context, currentUserRead) {
        final unreadCount = currentUserRead.unreadMessages;
        if (unreadCount <= 0) return const Empty();

        return core.StreamJumpToUnreadButton(
          label: context.translations.unreadCountIndicatorLabel(unreadCount: unreadCount),
          onJumpPressed: () => onJumpTap(currentUserRead.lastReadMessageId),
          onDismissPressed: onDismissTap,
        );
      },
    );
  }
}
