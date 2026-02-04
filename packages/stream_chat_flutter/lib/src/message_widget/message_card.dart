import 'package:flutter/material.dart';
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

  /// {@macro onAttachmentWidgetTap}
  final OnAttachmentWidgetTap? onAttachmentTap;

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateWidthLimit();
    });
  }

  @override
  Widget build(BuildContext context) {
    final onQuotedMessageTap = widget.onQuotedMessageTap;
    final quotedMessageBuilder = widget.quotedMessageBuilder;

    return Container(
      constraints: const BoxConstraints().copyWith(maxWidth: widthLimit),
      margin: EdgeInsetsDirectional.only(
        end: widget.reverse && widget.isFailedState ? 12.0 : 0.0,
        start: !widget.reverse && widget.isFailedState ? 12.0 : 0.0,
      ),
      clipBehavior: Clip.hardEdge,
      decoration: _buildDecoration(widget.messageTheme),
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
          ParseAttachments(
            key: attachmentsKey,
            message: widget.message,
            attachmentBuilders: widget.attachmentBuilders,
            attachmentPadding: widget.attachmentPadding,
            attachmentShape: widget.attachmentShape,
            onAttachmentTap: widget.onAttachmentTap,
            onShowMessage: widget.onShowMessage,
            onLinkTap: widget.onLinkTap,
            onReplyTap: widget.onReplyTap,
            attachmentActionsModalBuilder: widget.attachmentActionsModalBuilder,
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

  ShapeDecoration _buildDecoration(StreamMessageThemeData theme) {
    final gradient = _getBackgroundGradient(theme);
    final color = gradient == null ? _getBackgroundColor(theme) : null;

    final borderColor = theme.messageBorderColor ?? Colors.transparent;
    final borderRadius = widget.borderRadiusGeometry ?? BorderRadius.zero;

    return ShapeDecoration(
      color: color,
      gradient: gradient,
      shape: switch (widget.shape) {
        final shape? => shape,
        _ => RoundedRectangleBorder(
            borderRadius: borderRadius,
            side: switch (widget.borderSide) {
              final side? => side,
              _ => BorderSide(color: borderColor),
            },
          ),
      },
    );
  }

  Color? _getBackgroundColor(StreamMessageThemeData theme) {
    if (widget.hasQuotedMessage) {
      return theme.messageBackgroundColor;
    }

    final containsOnlyUrlAttachment =
        widget.hasUrlAttachments && !widget.hasNonUrlAttachments;

    if (containsOnlyUrlAttachment) {
      return theme.urlAttachmentBackgroundColor;
    }

    if (widget.isOnlyEmoji) return null;

    return theme.messageBackgroundColor;
  }

  Gradient? _getBackgroundGradient(StreamMessageThemeData theme) {
    if (widget.isOnlyEmoji) return null;

    return theme.messageBackgroundGradient;
  }
}
