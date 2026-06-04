import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_jaspr/src/components/stream_jaspr_avatar.dart';
import 'package:stream_chat_jaspr/src/message_list/attachments/stream_attachment.dart';
import 'package:stream_chat_jaspr/src/message_list/attachments/stream_image_attachment.dart';
import 'package:stream_chat_jaspr/src/theme/stream_chat_jaspr_tokens.dart';
import 'package:stream_chat_jaspr/src/utils/extensions.dart';

const _avatarSize = 24.0;

/// A component that renders a single chat message with bubble, metadata and
/// any attachments.
///
/// **Layout:**
/// - Own messages appear right-aligned with a light-blue bubble ([StreamColors.ownBubble])
///   and dark text. Metadata (timestamp + read receipt) sits below the bubble.
/// - Received messages appear left-aligned with a light-gray bubble
///   ([StreamColors.otherBubble]). A 24 px avatar anchors to the bottom-left
///   of the last message in each consecutive group.
class StreamMessageListItem extends StatelessComponent {
  /// Creates a [StreamMessageListItem].
  const StreamMessageListItem({
    required this.message,
    required this.currentUserId,
    this.showUserName = false,
    this.showAvatar = true,
    this.showTimestamp = true,
    super.key,
  });

  /// The message to display.
  final Message message;

  /// The ID of the currently logged-in user.
  final String currentUserId;

  /// Whether to show the sender's display name above the bubble.
  ///
  /// Typically true when this message's sender differs from the previous one.
  final bool showUserName;

  /// Whether to show the sender's 24 px avatar (received messages only).
  ///
  /// Typically true for the last message of each consecutive group.
  final bool showAvatar;

  /// Whether to show the metadata row (timestamp, read receipt) below the bubble.
  ///
  /// Typically true for the last message of each consecutive group.
  final bool showTimestamp;

  @override
  Component build(BuildContext context) {
    final isMine = message.user?.id == currentUserId;
    final sender = message.user;
    final senderName = sender?.name ?? '';
    final senderInitials = sender?.initials ?? '?';
    final senderImageUrl = sender?.image;
    final timestamp = message.createdAt.toLocal().toTimeString();
    final text = message.text ?? '';

    // Split attachments: images handled by StreamImageAttachment, others by StreamAttachment.
    final imageAttachments = message.attachments
        .where((att) => att.type == 'image' || att.type == 'giphy' || att.type == 'video')
        .toList();
    final otherAttachments = message.attachments
        .where((att) => att.type != 'image' && att.type != 'giphy' && att.type != 'video')
        .toList();

    final hasContent = text.isNotEmpty || message.attachments.isNotEmpty;

    return div(
      styles: Styles(
        display: Display.flex,
        flexDirection: FlexDirection.row,
        justifyContent: isMine ? JustifyContent.end : JustifyContent.start,
        alignItems: AlignItems.end,
        raw: {
          'padding': '${StreamSpacing.xxxs}px ${StreamSpacing.md}px',
          'gap': '${StreamSpacing.xs}px',
        },
      ),
      [
        // 24 px avatar slot on the left for received messages.
        if (!isMine) _buildAvatarSlot(sender, senderInitials, senderImageUrl),

        // Message column: optional name + bubble + metadata.
        div(
          styles: Styles(
            display: Display.flex,
            flexDirection: FlexDirection.column,
            alignItems: isMine ? AlignItems.end : AlignItems.start,
            raw: {'max-width': '70%', 'gap': '${StreamSpacing.xxxs}px'},
          ),
          [
            // Sender name (received, first of group).
            if (showUserName && !isMine && senderName.isNotEmpty)
              div(
                styles: const Styles(
                  fontSize: Unit.pixels(StreamTypography.sizeBase),
                  fontWeight: FontWeight.w600,
                  color: StreamColors.textTertiary,
                  raw: {'margin-bottom': '2px'},
                ),
                [Component.text(senderName)],
              ),

            // Bubble (only when there is content to show).
            if (hasContent) _buildBubble(isMine, text, imageAttachments, otherAttachments),

            // Metadata row below the bubble.
            if (showTimestamp) _buildMetadata(isMine, timestamp),
          ],
        ),
      ],
    );
  }

  Component _buildAvatarSlot(
    User? sender,
    String initials,
    String? imageUrl,
  ) {
    if (!showAvatar) {
      return const div(
        styles: Styles(
          width: Unit.pixels(_avatarSize),
          raw: {'flex-shrink': '0'},
        ),
        [],
      );
    }

    return StreamJasprAvatar(
      initials: initials,
      imageUrl: imageUrl,
      size: _avatarSize.toInt(),
    );
  }

  Component _buildBubble(
    bool isMine,
    String text,
    List<Attachment> imageAttachments,
    List<Attachment> otherAttachments,
  ) {
    final bgColor = isMine ? StreamColors.ownBubble : StreamColors.otherBubble;

    return div(
      styles: Styles(
        backgroundColor: bgColor,
        radius: const BorderRadius.circular(Unit.pixels(16)),
        padding: const Padding.symmetric(
          horizontal: Unit.pixels(StreamSpacing.sm),
          vertical: Unit.pixels(StreamSpacing.xs),
        ),
        overflow: Overflow.hidden,
        raw: {
          'word-break': 'break-word',
          'gap': '${StreamSpacing.xs}px',
          'display': 'flex',
          'flex-direction': 'column',
        },
      ),
      [
        // Image grid (if any).
        if (imageAttachments.isNotEmpty) StreamImageAttachment(attachments: imageAttachments),

        // Non-image attachments (file cards, link previews).
        ...otherAttachments.map(
          (att) => StreamAttachment(key: ValueKey(att.id), attachment: att),
        ),

        // Message text.
        if (text.isNotEmpty)
          div(
            styles: const Styles(
              fontSize: Unit.pixels(StreamTypography.sizeBase),
              color: StreamColors.textPrimary,
              raw: {'line-height': '1.5'},
            ),
            [Component.text(text)],
          ),
      ],
    );
  }

  Component _buildMetadata(bool isMine, String timestamp) {
    return div(
      styles: Styles(
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: isMine ? JustifyContent.end : JustifyContent.start,
        raw: {'gap': '${StreamSpacing.xxs}px'},
      ),
      [
        // Blue double-check for own messages.
        if (isMine)
          const div(
            styles: Styles(
              fontSize: Unit.pixels(12),
              color: StreamColors.primary,
              raw: {'line-height': '1', 'flex-shrink': '0'},
            ),
            [Component.text('✓✓')],
          ),
        div(
          styles: const Styles(
            fontSize: Unit.pixels(StreamTypography.sizeXxs),
            color: StreamColors.textTertiary,
          ),
          [Component.text(timestamp)],
        ),
      ],
    );
  }
}
