import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_widget/poll_message.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template messageCard}
/// The widget containing a quoted message.
///
/// Used in [MessageWidgetContent]. Should not be used elsewhere.
/// {@endtemplate}
class MessageCard extends StatefulWidget {
  /// {@macro messageCard}
  const MessageCard({
    super.key,
    required this.message,
    required this.isFailedState,
    required this.showUserAvatar,
    required this.messageTheme,
    required this.hasQuotedMessage,
    required this.hasUrlAttachments,
    required this.hasNonUrlAttachments,
    required this.hasPoll,
    required this.isOnlyEmoji,
    required this.isGiphy,
    required this.attachmentBuilders,
    required this.attachmentPadding,
    required this.attachmentShape,
    required this.onAttachmentTap,
    required this.onShowMessage,
    required this.onReplyTap,
    required this.attachmentActionsModalBuilder,
    required this.textPadding,
    required this.reverse,
    this.shape,
    this.borderSide,
    this.borderRadiusGeometry,
    this.textBuilder,
    this.quotedMessageBuilder,
    this.onLinkTap,
    this.onMentionTap,
    this.onQuotedMessageTap,
  });

  /// {@macro isFailedState}
  final bool isFailedState;

  /// {@macro showUserAvatar}
  final DisplayWidget showUserAvatar;

  /// {@macro shape}
  final ShapeBorder? shape;

  /// {@macro borderSide}
  final BorderSide? borderSide;

  /// {@macro messageTheme}
  final StreamMessageThemeData messageTheme;

  /// {@macro borderRadiusGeometry}
  final BorderRadiusGeometry? borderRadiusGeometry;

  /// {@macro hasQuotedMessage}
  final bool hasQuotedMessage;

  /// {@macro hasUrlAttachments}
  final bool hasUrlAttachments;

  /// {@macro hasNonUrlAttachments}
  final bool hasNonUrlAttachments;

  /// {@macro hasPoll}
  final bool hasPoll;

  /// {@macro isOnlyEmoji}
  final bool isOnlyEmoji;

  /// {@macro isGiphy}
  final bool isGiphy;

  /// {@macro message}
  final Message message;

  /// {@macro attachmentBuilders}
  final List<StreamAttachmentWidgetBuilder>? attachmentBuilders;

  /// {@macro attachmentPadding}
  final EdgeInsetsGeometry attachmentPadding;

  /// {@macro attachmentShape}
  final ShapeBorder? attachmentShape;

  /// {@macro onAttachmentTap}
  final StreamAttachmentWidgetTapCallback? onAttachmentTap;

  /// {@macro onShowMessage}
  final ShowMessageCallback? onShowMessage;

  /// {@macro onReplyTap}
  final void Function(Message)? onReplyTap;

  /// {@macro attachmentActionsBuilder}
  final AttachmentActionsBuilder? attachmentActionsModalBuilder;

  /// {@macro textPadding}
  final EdgeInsets textPadding;

  /// {@macro textBuilder}
  final Widget Function(BuildContext, Message)? textBuilder;

  /// {@macro quotedMessageBuilder}
  final Widget Function(BuildContext, Message)? quotedMessageBuilder;

  /// {@macro onLinkTap}
  final void Function(String)? onLinkTap;

  /// {@macro onMentionTap}
  final void Function(User)? onMentionTap;

  /// {@macro onQuotedMessageTap}
  final OnQuotedMessageTap? onQuotedMessageTap;

  /// {@macro reverse}
  final bool reverse;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  final attachmentsKey = GlobalKey();
  double? widthLimit;

  bool get hasAttachments {
    return widget.hasUrlAttachments || widget.hasNonUrlAttachments;
  }

  void _updateWidthLimit() {
    final attachmentContext = attachmentsKey.currentContext;
    final renderBox = attachmentContext?.findRenderObject() as RenderBox?;
    final attachmentsWidth = renderBox?.size.width;

    if (attachmentsWidth == null || attachmentsWidth == 0) return;

    if (mounted) {
      setState(() => widthLimit = attachmentsWidth);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // If there is an attachment, we need to wait for the attachment to be
    // rendered to get the width of the attachment and set it as the width
    // limit of the message card.
    if (hasAttachments) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateWidthLimit();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final onQuotedMessageTap = widget.onQuotedMessageTap;
    final quotedMessageBuilder = widget.quotedMessageBuilder;

    return Container(
      constraints: const BoxConstraints().copyWith(maxWidth: widthLimit),
      margin: EdgeInsets.symmetric(
        horizontal: (widget.isFailedState ? 15.0 : 0.0) +
            (widget.showUserAvatar == DisplayWidget.gone ? 0 : 4.0),
      ),
      clipBehavior: Clip.hardEdge,
      decoration: ShapeDecoration(
        color: _getBackgroundColor(),
        shape: widget.shape ??
            RoundedRectangleBorder(
              side: widget.borderSide ??
                  BorderSide(
                    color: widget.messageTheme.messageBorderColor ??
                        Colors.transparent,
                  ),
              borderRadius: widget.borderRadiusGeometry ?? BorderRadius.zero,
            ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.hasQuotedMessage)
            InkWell(
              onTap: !widget.message.quotedMessage!.isDeleted &&
                      onQuotedMessageTap != null
                  ? () => onQuotedMessageTap(widget.message.quotedMessageId)
                  : null,
              child: quotedMessageBuilder?.call(
                    context,
                    widget.message.quotedMessage!,
                  ) ??
                  QuotedMessage(
                    message: widget.message,
                    textBuilder: widget.textBuilder,
                    hasNonUrlAttachments: widget.hasNonUrlAttachments,
                  ),
            ),
          if (hasAttachments)
            ParseAttachments(
              key: attachmentsKey,
              message: widget.message,
              attachmentBuilders: widget.attachmentBuilders,
              attachmentPadding: widget.attachmentPadding,
              attachmentShape: widget.attachmentShape,
              onAttachmentTap: widget.onAttachmentTap,
              onShowMessage: widget.onShowMessage,
              onReplyTap: widget.onReplyTap,
              attachmentActionsModalBuilder:
                  widget.attachmentActionsModalBuilder,
            ),
          if (widget.hasPoll)
            PollMessage(
              message: widget.message,
            ),
          TextBubble(
            messageTheme: widget.messageTheme,
            message: widget.message,
            textPadding: widget.textPadding,
            textBuilder: widget.textBuilder,
            isOnlyEmoji: widget.isOnlyEmoji,
            hasQuotedMessage: widget.hasQuotedMessage,
            hasUrlAttachments: widget.hasUrlAttachments,
            onLinkTap: widget.onLinkTap,
            onMentionTap: widget.onMentionTap,
          ),
        ],
      ),
    );
  }

  Color? _getBackgroundColor() {
    if (widget.hasQuotedMessage) {
      return widget.messageTheme.messageBackgroundColor;
    }

    final containsOnlyUrlAttachment =
        widget.hasUrlAttachments && !widget.hasNonUrlAttachments;

    if (containsOnlyUrlAttachment) {
      return widget.messageTheme.urlAttachmentBackgroundColor;
    }

    if (widget.isOnlyEmoji) {
      return Colors.transparent;
    }

    return widget.messageTheme.messageBackgroundColor;
  }
}
