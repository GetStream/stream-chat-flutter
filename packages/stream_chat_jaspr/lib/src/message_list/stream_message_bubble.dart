import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_jaspr/src/components/stream_jaspr_avatar.dart';
import 'package:stream_chat_jaspr/src/utils/extensions.dart';

/// A component that renders a single chat message as a bubble.
///
/// Sent messages (by [currentUserId]) appear right-aligned with a blue bubble.
/// Received messages appear left-aligned with a light gray bubble and an
/// avatar showing the sender's initials.
class StreamMessageBubble extends StatelessComponent {
  /// Creates a [StreamMessageBubble].
  const StreamMessageBubble({
    required this.message,
    required this.currentUserId,
    this.showSenderName = false,
    this.showAvatar = true,
    super.key,
  });

  /// The message to display.
  final Message message;

  /// The ID of the currently logged-in user.
  final String currentUserId;

  /// Whether to show the sender's name above the bubble.
  ///
  /// Typically true when this message's sender differs from the previous one.
  final bool showSenderName;

  /// Whether to show the sender's avatar.
  ///
  /// Typically false for consecutive messages from the same sender, except
  /// for the last one in each group.
  final bool showAvatar;

  @override
  Component build(BuildContext context) {
    final isMine = message.user?.id == currentUserId;
    final sender = message.user;
    final senderName = sender?.name ?? '';
    final initials = _userInitials(senderName);
    final timestamp = message.createdAt.toLocal().toRelativeString();
    final text = message.text ?? '';

    return div(
      styles: Styles(
        display: Display.flex,
        flexDirection: FlexDirection.row,
        justifyContent: isMine ? JustifyContent.end : JustifyContent.start,
        alignItems: AlignItems.end,
        raw: {
          'padding': '2px 16px',
          'gap': '8px',
        },
      ),
      [
        // Avatar slot on the left for received messages.
        if (!isMine) _buildAvatarSlot(sender, initials),

        // Bubble column.
        div(
          styles: const Styles(
            display: Display.flex,
            flexDirection: FlexDirection.column,
            raw: {'max-width': '70%', 'gap': '2px'},
          ),
          [
            if (showSenderName && !isMine && senderName.isNotEmpty)
              div(
                styles: const Styles(
                  fontSize: Unit.pixels(12),
                  fontWeight: FontWeight.w600,
                  color: Color('#72767e'),
                  raw: {'margin-bottom': '2px'},
                ),
                [Component.text(senderName)],
              ),
            _buildBubble(isMine, text, timestamp),
          ],
        ),
      ],
    );
  }

  Component _buildAvatarSlot(User? sender, String initials) {
    if (!showAvatar) {
      return div(
        styles: const Styles(
          width: Unit.pixels(32),
          raw: {'flex-shrink': '0'},
        ),
        [],
      );
    }

    return StreamJasprAvatar(
      initials: initials,
      size: 32,
      colorSeed: sender?.id ?? initials,
    );
  }

  Component _buildBubble(bool isMine, String text, String timestamp) {
    final bgColor = isMine ? const Color('#005FFF') : const Color('#F2F2F2');
    final textColor = isMine ? Colors.white : const Color('#1a1a1a');
    final timestampColor =
        isMine ? const Color('#FFFFFFAA') : const Color('#72767e');

    return div(
      styles: Styles(
        backgroundColor: bgColor,
        radius: BorderRadius.circular(Unit.pixels(16)),
        padding: const Padding.symmetric(
          horizontal: Unit.pixels(12),
          vertical: Unit.pixels(8),
        ),
        raw: {'word-break': 'break-word'},
      ),
      [
        div(
          styles: Styles(
            fontSize: Unit.pixels(14),
            color: textColor,
            raw: {'line-height': '1.4'},
          ),
          [Component.text(text)],
        ),
        div(
          styles: Styles(
            fontSize: Unit.pixels(11),
            color: timestampColor,
            raw: {
              'margin-top': '4px',
              'text-align': isMine ? 'right' : 'left',
            },
          ),
          [Component.text(timestamp)],
        ),
      ],
    );
  }
}

String _userInitials(String name) {
  if (name.isEmpty) return '?';
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.length >= 2) {
    return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
  }
  return parts.first[0].toUpperCase();
}
