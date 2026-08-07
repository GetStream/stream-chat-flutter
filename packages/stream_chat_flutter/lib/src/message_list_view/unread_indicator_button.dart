import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_core_flutter/chat.dart' as core;

/// {@template unreadIndicatorButton}
/// A floating "jump to unread" pill showing a fixed unread count.
///
/// [UnreadIndicatorButton] is purely presentational: the host
/// [StreamMessageListView] decides when it should be visible (only while the
/// pre-existing unread boundary sits above the viewport) and supplies the
/// frozen [unreadCount]. Users can tap to navigate to the first unread
/// message or dismiss the indicator.
///
/// {@tool snippet}
///
/// Typical usage inside a message list:
///
/// ```dart
/// UnreadIndicatorButton(
///   unreadCount: 5,
///   onJumpTap: () async {
///     // scroll to the first unread message
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
///  * [StreamMessageListView], which hosts this widget and owns its
///    visibility.
/// {@endtemplate}
class UnreadIndicatorButton extends StatelessWidget {
  /// Creates an unread indicator button.
  const UnreadIndicatorButton({
    super.key,
    required this.unreadCount,
    required this.onJumpTap,
    required this.onDismissTap,
  });

  /// The fixed unread count to display.
  ///
  /// This is the pre-existing unread boundary's count, captured when the
  /// channel was opened — it does not change for the lifetime of the
  /// session.
  final int unreadCount;

  /// Called when the jump-to-unread area is tapped.
  final Future<void> Function() onJumpTap;

  /// Called when the dismiss button is tapped.
  ///
  /// Typically used to mark all messages as read.
  final Future<void> Function() onDismissTap;

  @override
  Widget build(BuildContext context) {
    return core.StreamJumpToUnreadButton(
      label: context.translations.unreadCountIndicatorLabel(unreadCount: unreadCount),
      onJumpPressed: onJumpTap,
      onDismissPressed: onDismissTap,
    );
  }
}
