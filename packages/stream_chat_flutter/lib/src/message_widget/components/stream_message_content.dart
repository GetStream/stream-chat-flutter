import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:stream_chat_flutter/src/attachment/builder/attachment_widget_builder.dart';
import 'package:stream_chat_flutter/src/message_widget/components/stream_message_deleted.dart';
import 'package:stream_chat_flutter/src/message_widget/components/stream_message_reactions.dart';
import 'package:stream_chat_flutter/src/message_widget/components/stream_message_text.dart';
import 'package:stream_chat_flutter/src/message_widget/stream_message_attachments.dart';
import 'package:stream_chat_flutter/src/message_widget/stream_quoted_message.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/chat.dart' as core;

/// Composes the main message content including the bubble, attachments, text,
/// and reactions.
///
/// For deleted messages a [StreamMessageDeleted] placeholder is shown.
/// Otherwise the content displays attachments, message text, and reactions.
///
/// The [header], [footer], and [replies] slots are passed in from
/// [DefaultStreamMessageItem] and rendered in the appropriate positions via
/// the core [core.StreamMessageContent] layout.
///
/// When the message consists of three or fewer emoji-only characters, the
/// bubble background is hidden so the emoji appear at a larger visual size.
///
/// See also:
///
///  * [StreamMessageReactions], which renders reactions around the bubble.
///  * [StreamMessageText], which renders the markdown message text.
///  * [DefaultStreamMessageItem], which hosts this widget.
class StreamMessageContent extends StatefulWidget {
  /// Creates a message content widget for the given [message].
  const StreamMessageContent({
    super.key,
    required this.message,
    this.header,
    this.errorBadge,
    this.footer,
    this.replies,
    this.attachmentBuilders,
    this.onLinkTap,
    this.onMentionTap,
    this.onAnyMentionTap,
    this.onReactionsTap,
    this.onQuotedMessageTap,
    this.reactionSorting,
  });

  /// The message to display.
  final Message message;

  /// Optional header widget displayed above the message content column.
  ///
  /// Typically a [StreamMessageHeader] containing pinned, reminder,
  /// or show-in-channel annotations.
  final Widget? header;

  /// Optional error badge widget overlaid on the message bubble.
  ///
  /// When non-null, the badge is positioned at the top-end corner of the
  /// bubble using a [Stack] with [PositionedDirectional].
  final Widget? errorBadge;

  /// Optional footer widget displayed below the message content column.
  ///
  /// Typically a [StreamMessageFooter] containing the author name, timestamp,
  /// and sending status.
  final Widget? footer;

  /// Optional replies indicator widget displayed below the bubble.
  ///
  /// Typically a [core.StreamMessageReplies] showing reply count and
  /// participant avatars.
  final Widget? replies;

  /// Custom attachment builders for rendering message attachments.
  ///
  /// When non-null, these builders are passed to [StreamMessageAttachments]
  /// and take priority over the default builders.
  final List<StreamAttachmentWidgetBuilder>? attachmentBuilders;

  /// Called when a link is tapped in the rendered message text.
  ///
  /// If null, tapping a link has no effect.
  final MarkdownTapLinkCallback? onLinkTap;

  /// Called when a user-type `@mention` is tapped in the rendered message
  /// text.
  ///
  /// Only fires for user mentions; to handle every mention kind in one
  /// callback, use [onAnyMentionTap] instead. When both are set,
  /// [onAnyMentionTap] takes precedence.
  ///
  /// If null, tapping a user mention has no effect.
  final core.MarkdownTapMentionCallback? onMentionTap;

  /// Called when a mention of any kind is tapped in the rendered message
  /// text.
  ///
  /// Receives the [core.MentionType] decoded from the URL scheme along with
  /// the display text and the URL-decoded id payload. Takes precedence over
  /// [onMentionTap] when both are set.
  ///
  /// If null, the renderer falls back to [onMentionTap] for user mentions
  /// only.
  final core.MarkdownTapAnyMentionCallback? onAnyMentionTap;

  /// Called when the reactions area is tapped.
  ///
  /// If null, tapping reactions has no effect.
  final VoidCallback? onReactionsTap;

  /// Called when the quoted message is tapped.
  ///
  /// If null, tapping the quoted message has no effect.
  final void Function(Message quotedMessage)? onQuotedMessageTap;

  /// Controls how reaction groups are sorted when displayed.
  ///
  /// Passed through to [StreamMessageReactions.sorting].
  final Comparator<ReactionGroup>? reactionSorting;

  @override
  State<StreamMessageContent> createState() => _StreamMessageContentState();
}

class _StreamMessageContentState extends State<StreamMessageContent> {
  // Tracks the rendered width of the attachments to constrain the bubble.
  double? widthLimit;
  late final attachmentsKey = GlobalKey(debugLabel: 'StreamMessageAttachments');

  // Measures the attachment width after layout and constrains the bubble.
  void _updateWidthLimit() {
    if (!mounted) return;

    final attachmentContext = attachmentsKey.currentContext;
    final renderBox = attachmentContext?.findRenderObject() as RenderBox?;
    // The attachments subtree may have been detached between scheduling this
    // post-frame callback and it firing. Reading [RenderBox.size] without
    // checking [RenderBox.hasSize] throws `RenderBox was not laid out`.
    if (renderBox == null || !renderBox.hasSize) return;
    final attachmentsWidth = renderBox.size.width;

    if (attachmentsWidth == 0) return;
    if (widthLimit == attachmentsWidth) return;
    setState(() => widthLimit = attachmentsWidth);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateWidthLimit());
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final crossAxisAlignment = core.StreamMessageLayout.crossAxisAlignmentOf(context);

    if (widget.message.isDeleted) return const StreamMessageDeleted();

    return core.StreamMessageContent(
      header: widget.header,
      footer: widget.footer,
      child: core.StreamColumn(
        mainAxisSize: .min,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          StreamMessageReactions(
            message: widget.message,
            sorting: widget.reactionSorting,
            onPressed: widget.onReactionsTap,
            child: Builder(
              builder: (context) {
                final bubbleContent = ConstrainedBox(
                  constraints: const BoxConstraints().copyWith(maxWidth: widthLimit),
                  child: core.StreamColumn(
                    mainAxisSize: .min,
                    spacing: spacing.xs,
                    crossAxisAlignment: .start,
                    children: [
                      if (widget.message.quotedMessage case final quotedMessage?)
                        StreamQuotedMessage(
                          quotedMessage: quotedMessage,
                          onTap: switch (widget.onQuotedMessageTap) {
                            final onTap? => () => onTap(quotedMessage),
                            _ => null,
                          },
                        ),
                      StreamMessageAttachments(
                        key: attachmentsKey,
                        message: widget.message,
                        attachmentBuilders: widget.attachmentBuilders,
                      ),
                      if (widget.message.text case final text? when text.isNotEmpty)
                        StreamMessageText(
                          message: widget.message,
                          onLinkTap: widget.onLinkTap,
                          onMentionTap: widget.onMentionTap,
                          onAnyMentionTap: widget.onAnyMentionTap,
                        ),
                    ],
                  ),
                );

                final bubble = core.StreamMessageBubble(child: bubbleContent);

                if (widget.errorBadge case final errorBadge?) {
                  return Stack(
                    clipBehavior: .none,
                    children: [
                      bubble,
                      PositionedDirectional(top: 8, end: -12, child: errorBadge),
                    ],
                  );
                }

                return bubble;
              },
            ),
          ),
          if (widget.replies case final replies?) replies,
        ],
      ),
    );
  }
}
