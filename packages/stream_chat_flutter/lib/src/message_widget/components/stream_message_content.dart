import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:stream_chat_flutter/src/attachment/builder/attachment_widget_builder.dart';
import 'package:stream_chat_flutter/src/channel/stream_message_preview_text.dart';
import 'package:stream_chat_flutter/src/message_widget/components/stream_message_deleted.dart';
import 'package:stream_chat_flutter/src/message_widget/components/stream_message_reactions.dart';
import 'package:stream_chat_flutter/src/message_widget/components/stream_message_text.dart';
import 'package:stream_chat_flutter/src/message_widget/parse_attachments.dart';
import 'package:stream_chat_flutter/src/utils/typedefs.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

/// Composes the main message content including the bubble, attachments, text,
/// and reactions.
///
/// For deleted messages a [StreamMessageDeleted] placeholder is shown.
/// Otherwise the content displays attachments, message text, and reactions.
///
/// The [annotation], [metadata], and [replies] slots are passed in from
/// [DefaultStreamMessage] and rendered in the appropriate positions via the
/// core [core.StreamMessageContent] layout.
///
/// When the message consists of three or fewer emoji-only characters, the
/// bubble background is hidden so the emoji appear at a larger visual size.
///
/// See also:
///
///  * [StreamMessageReactions], which renders reactions around the bubble.
///  * [StreamMessageText], which renders the markdown message text.
///  * [DefaultStreamMessage], which hosts this widget.
class StreamMessageContent extends StatefulWidget {
  /// Creates a message content widget for the given [message].
  const StreamMessageContent({
    super.key,
    required this.message,
    this.annotation,
    this.errorBadge,
    this.metadata,
    this.replies,
    this.attachmentBuilders,
    this.onLinkTap,
    this.onMentionTap,
    this.onReactionsTap,
    this.onQuotedMessageTap,
    this.reactionSorting,
    this.onShowMessage,
    this.onReplyTap,
    this.attachmentActionsModalBuilder,
  });

  /// The message to display.
  final Message message;

  /// Optional annotation widget displayed above the message content column.
  ///
  /// Typically a [StreamMessageAnnotations] containing pinned, reminder,
  /// or show-in-channel annotations.
  final Widget? annotation;

  /// Optional error badge widget overlaid on the message bubble.
  ///
  /// When non-null, the badge is positioned at the top-end corner of the
  /// bubble using a [Stack] with [PositionedDirectional].
  final Widget? errorBadge;

  /// Optional metadata widget displayed below the message content column.
  ///
  /// Typically a [StreamMessageMetadata] containing the author name, timestamp,
  /// and sending status.
  final Widget? metadata;

  /// Optional replies indicator widget displayed below the bubble.
  ///
  /// Typically a [core.StreamMessageReplies] showing reply count and
  /// participant avatars.
  final Widget? replies;

  /// Custom attachment builders for rendering message attachments.
  ///
  /// When non-null, these builders are passed to [ParseAttachments] and
  /// take priority over the default builders.
  final List<StreamAttachmentWidgetBuilder>? attachmentBuilders;

  /// Called when a link is tapped in the rendered message text.
  ///
  /// If null, tapping a link has no effect.
  final MarkdownTapLinkCallback? onLinkTap;

  /// Called when a `@mention` is tapped in the rendered message text.
  ///
  /// If null, tapping a mention has no effect.
  final core.MarkdownTapMentionCallback? onMentionTap;

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

  /// Called when the "show in chat" action is tapped in the full-screen
  /// media gallery.
  final ShowMessageCallback? onShowMessage;

  /// Called when the reply action is tapped in the full-screen media gallery.
  final void Function(Message)? onReplyTap;

  /// Widget builder for the attachment actions modal in the full-screen
  /// media gallery.
  final AttachmentActionsBuilder? attachmentActionsModalBuilder;

  @override
  State<StreamMessageContent> createState() => _StreamMessageContentState();
}

class _StreamMessageContentState extends State<StreamMessageContent> {
  // Tracks the rendered width of the attachments to constrain the bubble.
  double? widthLimit;
  late final attachmentsKey = GlobalKey(debugLabel: 'ParseAttachments');

  // Measures the attachment width after layout and constrains the bubble.
  void _updateWidthLimit() {
    final attachmentContext = attachmentsKey.currentContext;
    final renderBox = attachmentContext?.findRenderObject() as RenderBox?;
    final attachmentsWidth = renderBox?.size.width;

    if (attachmentsWidth == null || attachmentsWidth == 0) return;
    if (mounted) setState(() => widthLimit = attachmentsWidth);
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
      header: widget.annotation,
      footer: widget.metadata,
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
                    spacing: spacing.xxs,
                    mainAxisSize: .min,
                    crossAxisAlignment: .start,
                    children: [
                      if (widget.message.quotedMessage case final quotedMessage?)
                        // TODO: Refactor this with attachments
                        ConstrainedBox(
                          constraints: const .tightFor(width: 272),
                          child: GestureDetector(
                            onTap: !quotedMessage.isDeleted && widget.onQuotedMessageTap != null
                                ? () => widget.onQuotedMessageTap!(quotedMessage)
                                : null,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: core.StreamMessageTheme(
                                data: core.StreamMessageThemeData(
                                  incoming: core.StreamMessageStyle(
                                    backgroundColor: context.streamColorScheme.backgroundSurfaceStrong,
                                  ),
                                  outgoing: core.StreamMessageStyle(
                                    backgroundColor: context.streamColorScheme.brand.shade150,
                                  ),
                                ),
                                child: core.MessageComposerReplyAttachment(
                                  title: Text(quotedMessage.user?.name ?? ''),
                                  subtitle: StreamMessagePreviewText(message: quotedMessage),
                                  style: switch (core.StreamMessageLayout.messageAlignmentOf(context)) {
                                    core.StreamMessageAlignment.start => .incoming,
                                    core.StreamMessageAlignment.end => .outgoing,
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ParseAttachments(
                        key: attachmentsKey,
                        message: widget.message,
                        attachmentBuilders: widget.attachmentBuilders,
                        onShowMessage: widget.onShowMessage,
                        onReplyTap: widget.onReplyTap,
                        attachmentActionsModalBuilder: widget.attachmentActionsModalBuilder,
                      ),
                      if (widget.message.text case final text? when text.isNotEmpty)
                        StreamMessageText(
                          message: widget.message,
                          onLinkTap: widget.onLinkTap,
                          onMentionTap: widget.onMentionTap,
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
