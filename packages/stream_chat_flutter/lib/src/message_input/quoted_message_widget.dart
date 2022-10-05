import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/platform_widget_builder/platform_widget_builder.dart';
import 'package:stream_chat_flutter/src/message_input/clear_input_item_button.dart';
import 'package:stream_chat_flutter/src/video/video_thumbnail_image.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:video_player/video_player.dart';

/// {@template streamQuotedMessage}
/// Widget for the quoted message.
/// {@endtemplate}
class StreamQuotedMessageWidget extends StatelessWidget {
  /// {@macro streamQuotedMessage}
  const StreamQuotedMessageWidget({
    super.key,
    required this.message,
    required this.messageTheme,
    this.reverse = false,
    this.showBorder = false,
    this.textLimit = 170,
    this.attachmentThumbnailBuilders,
    this.padding = const EdgeInsets.all(8),
    this.onTap,
    this.onQuotedMessageClear,
    this.composing = true,
  });

  /// The message
  final Message message;

  /// The message theme
  final StreamMessageThemeData messageTheme;

  /// If true the widget will be mirrored
  final bool reverse;

  /// If true the message will show a grey border
  final bool showBorder;

  /// limit of the text message shown
  final int textLimit;

  /// Map that defines a thumbnail builder for an attachment type
  final Map<String, QuotedMessageAttachmentThumbnailBuilder>?
      attachmentThumbnailBuilders;

  /// Padding around the widget
  final EdgeInsetsGeometry padding;

  /// Callback for tap on widget
  final GestureTapCallback? onTap;

  /// Callback for clearing quoted messages.
  final VoidCallback? onQuotedMessageClear;

  /// True if the message is being composed
  final bool composing;

  @override
  Widget build(BuildContext context) {
    final children = [
      Flexible(
        child: _QuotedMessage(
          message: message,
          textLimit: textLimit,
          composing: composing,
          onQuotedMessageClear: onQuotedMessageClear,
          messageTheme: messageTheme,
          showBorder: showBorder,
          reverse: reverse,
          attachmentThumbnailBuilders: attachmentThumbnailBuilders,
        ),
      ),
      const SizedBox(width: 8),
      if (message.user != null)
        StreamUserAvatar(
          user: message.user!,
          constraints: const BoxConstraints.tightFor(
            height: 24,
            width: 24,
          ),
          showOnlineStatus: false,
        ),
    ];
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: padding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: reverse ? children.reversed.toList() : children,
          ),
        ),
      ),
    );
  }
}

class _QuotedMessage extends StatelessWidget {
  const _QuotedMessage({
    required this.message,
    required this.textLimit,
    required this.composing,
    required this.onQuotedMessageClear,
    required this.messageTheme,
    required this.showBorder,
    required this.reverse,
    this.attachmentThumbnailBuilders,
  });

  final Message message;
  final int textLimit;
  final bool composing;
  final VoidCallback? onQuotedMessageClear;
  final StreamMessageThemeData messageTheme;
  final bool showBorder;
  final bool reverse;

  /// Map that defines a thumbnail builder for an attachment type
  final Map<String, QuotedMessageAttachmentThumbnailBuilder>?
      attachmentThumbnailBuilders;

  bool get _hasAttachments => message.attachments.isNotEmpty;

  bool get _containsText => message.text?.isNotEmpty == true;

  bool get _containsLinkAttachment =>
      message.attachments.any((element) => element.titleLink != null);

  bool get _isGiphy =>
      message.attachments.any((element) => element.type == 'giphy');

  @override
  Widget build(BuildContext context) {
    final isOnlyEmoji = message.text!.isOnlyEmoji;
    var msg = _hasAttachments && !_containsText
        ? message.copyWith(text: message.attachments.last.title ?? '')
        : message;
    if (msg.text!.length > textLimit) {
      msg = msg.copyWith(text: '${msg.text!.substring(0, textLimit - 3)}...');
    }

    final children = [
      if (composing)
        PlatformWidgetBuilder(
          web: (context, child) => child,
          desktop: (context, child) => child,
          child: ClearInputItemButton(
            onTap: onQuotedMessageClear,
          ),
        ),
      if (_hasAttachments)
        _ParseAttachments(
          message: message,
          messageTheme: messageTheme,
          attachmentThumbnailBuilders: attachmentThumbnailBuilders,
        ),
      if (msg.text!.isNotEmpty && !_isGiphy)
        Flexible(
          child: StreamMessageText(
            message: msg,
            messageTheme: isOnlyEmoji && _containsText
                ? messageTheme.copyWith(
                    messageTextStyle: messageTheme.messageTextStyle?.copyWith(
                      fontSize: 32,
                    ),
                  )
                : messageTheme.copyWith(
                    messageTextStyle: messageTheme.messageTextStyle?.copyWith(
                      fontSize: 12,
                    ),
                  ),
          ),
        ),
    ].insertBetween(const SizedBox(width: 8));

    return Container(
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        border: showBorder
            ? Border.all(
                color: StreamChatTheme.of(context).colorTheme.disabled,
              )
            : null,
        borderRadius: BorderRadius.only(
          topRight: const Radius.circular(12),
          topLeft: const Radius.circular(12),
          bottomRight: reverse ? const Radius.circular(12) : Radius.zero,
          bottomLeft: reverse ? Radius.zero : const Radius.circular(12),
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            reverse ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: reverse ? children.reversed.toList() : children,
      ),
    );
  }

  Color? _getBackgroundColor(BuildContext context) {
    if (_containsLinkAttachment) {
      return messageTheme.linkBackgroundColor;
    }
    return messageTheme.messageBackgroundColor;
  }
}

class _ParseAttachments extends StatelessWidget {
  const _ParseAttachments({
    required this.message,
    required this.messageTheme,
    this.attachmentThumbnailBuilders,
  });

  final Message message;
  final StreamMessageThemeData messageTheme;
  final Map<String, QuotedMessageAttachmentThumbnailBuilder>?
      attachmentThumbnailBuilders;

  bool get _containsLinkAttachment =>
      message.attachments.any((element) => element.titleLink != null);

  @override
  Widget build(BuildContext context) {
    Widget child;
    Attachment attachment;
    if (_containsLinkAttachment) {
      attachment = message.attachments.firstWhere(
        (element) => element.ogScrapeUrl != null || element.titleLink != null,
      );
      child = _UrlAttachment(attachment: attachment);
    } else {
      QuotedMessageAttachmentThumbnailBuilder? attachmentBuilder;
      attachment = message.attachments.last;
      if (attachmentThumbnailBuilders?.containsKey(attachment.type) == true) {
        attachmentBuilder = attachmentThumbnailBuilders![attachment.type];
      }
      attachmentBuilder = _defaultAttachmentBuilder[attachment.type];
      if (attachmentBuilder == null) {
        child = const Offstage();
      } else {
        child = attachmentBuilder(context, attachment);
      }
    }
    child = AbsorbPointer(child: child);
    return Material(
      clipBehavior: Clip.hardEdge,
      type: MaterialType.transparency,
      shape: attachment.type == 'file'
          ? null
          : RoundedRectangleBorder(
              side: const BorderSide(width: 0, color: Colors.transparent),
              borderRadius: BorderRadius.circular(8),
            ),
      child: child,
    );
  }

  Map<String, QuotedMessageAttachmentThumbnailBuilder>
      get _defaultAttachmentBuilder {
    return {
      'image': (_, attachment) {
        return StreamImageAttachment(
          attachment: attachment,
          message: message,
          messageTheme: messageTheme,
          constraints: BoxConstraints.loose(const Size(32, 32)),
        );
      },
      'video': (_, attachment) {
        return StreamVideoThumbnailImage(
          key: ValueKey(attachment.assetUrl),
          video: attachment.file?.path ?? attachment.assetUrl!,
          constraints: BoxConstraints.loose(const Size(32, 32)),
          fit: BoxFit.cover,
          errorBuilder: (_, __) => AttachmentError(
            constraints: BoxConstraints.loose(const Size(32, 32)),
          ),
        );
      },
      'giphy': (_, attachment) {
        const size = Size(32, 32);
        return CachedNetworkImage(
          height: size.height,
          width: size.width,
          placeholder: (_, __) {
            return SizedBox(
              width: size.width,
              height: size.height,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
          imageUrl: attachment.thumbUrl ??
              attachment.imageUrl ??
              attachment.assetUrl!,
          errorWidget: (context, url, error) =>
              AttachmentError(constraints: BoxConstraints.loose(size)),
          fit: BoxFit.cover,
        );
      },
      'file': (_, attachment) {
        return SizedBox(
          height: 32,
          width: 32,
          child: getFileTypeImage(
            attachment.extraData['mime_type'] as String?,
          ),
        );
      },
    };
  }
}

class _UrlAttachment extends StatelessWidget {
  const _UrlAttachment({
    required this.attachment,
  });

  final Attachment attachment;

  @override
  Widget build(BuildContext context) {
    const size = Size(32, 32);
    if (attachment.thumbUrl != null) {
      return Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(
              attachment.thumbUrl!,
            ),
          ),
        ),
      );
    }
    return AttachmentError(constraints: BoxConstraints.loose(size));
  }
}

class _VideoAttachmentThumbnail extends StatefulWidget {
  const _VideoAttachmentThumbnail({
    required this.attachment,
  });

  final Attachment attachment;

  @override
  _VideoAttachmentThumbnailState createState() =>
      _VideoAttachmentThumbnailState();
}

class _VideoAttachmentThumbnailState extends State<_VideoAttachmentThumbnail> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.attachment.assetUrl!)
      ..initialize().then((_) {
        // ignore: no-empty-block
        setState(() {}); //when your thumbnail will show.
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      width: 32,
      child: _controller.value.isInitialized
          ? VideoPlayer(_controller)
          : const CircularProgressIndicator(),
    );
  }
}
