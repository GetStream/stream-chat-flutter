import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_input/clear_input_item_button.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

typedef _Builders = Map<String, QuotedMessageAttachmentThumbnailBuilder>;

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
    this.textBuilder,
    this.attachmentThumbnailBuilders,
    this.padding = const EdgeInsets.all(8),
    this.onQuotedMessageClear,
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
  final _Builders? attachmentThumbnailBuilders;

  /// Padding around the widget
  final EdgeInsetsGeometry padding;

  /// Callback for clearing quoted messages.
  final VoidCallback? onQuotedMessageClear;

  /// {@macro textBuilder}
  final Widget Function(BuildContext, Message)? textBuilder;

  @override
  Widget build(BuildContext context) {
    final children = [
      Flexible(
        child: _QuotedMessage(
          message: message,
          textLimit: textLimit,
          messageTheme: messageTheme,
          showBorder: showBorder,
          reverse: reverse,
          textBuilder: textBuilder,
          onQuotedMessageClear: onQuotedMessageClear,
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
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: reverse ? children.reversed.toList() : children,
      ),
    );
  }
}

class _QuotedMessage extends StatelessWidget {
  const _QuotedMessage({
    required this.message,
    required this.textLimit,
    required this.messageTheme,
    required this.showBorder,
    required this.reverse,
    this.textBuilder,
    this.onQuotedMessageClear,
    this.attachmentThumbnailBuilders,
  });

  final Message message;
  final int textLimit;
  final VoidCallback? onQuotedMessageClear;
  final StreamMessageThemeData messageTheme;
  final bool showBorder;
  final bool reverse;
  final Widget Function(BuildContext, Message)? textBuilder;

  final _Builders? attachmentThumbnailBuilders;

  bool get _hasAttachments => message.attachments.isNotEmpty;

  bool get _containsText => message.text?.isNotEmpty == true;

  bool get _containsLinkAttachment =>
      message.attachments.any((it) => it.type == AttachmentType.urlPreview);

  bool get _isGiphy => message.attachments
      .any((element) => element.type == AttachmentType.giphy);

  bool get _isDeleted => message.isDeleted || message.deletedAt != null;

  @override
  Widget build(BuildContext context) {
    final isOnlyEmoji = message.text!.isOnlyEmoji;
    var msg = _hasAttachments && !_containsText
        ? message.copyWith(text: message.attachments.last.title ?? '')
        : message;
    if (msg.text!.length > textLimit) {
      msg = msg.copyWith(text: '${msg.text!.substring(0, textLimit - 3)}...');
    }

    List<Widget> children;
    if (_isDeleted) {
      // Show deleted message text
      children = [
        Text(
          context.translations.messageDeletedLabel,
          style: messageTheme.messageTextStyle?.copyWith(
            fontStyle: FontStyle.italic,
            color: messageTheme.createdAtStyle?.color,
          ),
        ),
      ];
    } else {
      // Show quoted message
      children = [
        if (_hasAttachments)
          _ParseAttachments(
            message: message,
            messageTheme: messageTheme,
            attachmentThumbnailBuilders: attachmentThumbnailBuilders,
          ),
        if (msg.text!.isNotEmpty && !_isGiphy)
          Flexible(
            child: textBuilder?.call(context, msg) ??
                StreamMessageText(
                  message: msg,
                  messageTheme: isOnlyEmoji && _containsText
                      ? messageTheme.copyWith(
                          messageTextStyle:
                              messageTheme.messageTextStyle?.copyWith(
                            fontSize: 32,
                          ),
                        )
                      : messageTheme.copyWith(
                          messageTextStyle:
                              messageTheme.messageTextStyle?.copyWith(
                            fontSize: 12,
                          ),
                        ),
                ),
          ),
      ];
    }

    // Add clear button if needed.
    if (isDesktopDeviceOrWeb && onQuotedMessageClear != null) {
      children.insert(
        0,
        ClearInputItemButton(onTap: onQuotedMessageClear),
      );
    }

    // Add some spacing between the children.
    children = children.insertBetween(const SizedBox(width: 8));

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
    if (_containsLinkAttachment && !_isDeleted) {
      return messageTheme.urlAttachmentBackgroundColor;
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
  final _Builders? attachmentThumbnailBuilders;

  @override
  Widget build(BuildContext context) {
    final attachment = message.attachments.first;

    var attachmentBuilders = attachmentThumbnailBuilders;
    attachmentBuilders ??= _createDefaultAttachmentBuilders();

    // Build the attachment widget using the builder for the attachment type.
    final attachmentWidget = attachmentBuilders[attachment.type]?.call(
      context,
      attachment,
    );

    // Return empty container if no attachment widget is returned.
    if (attachmentWidget == null) return const SizedBox.shrink();

    final colorTheme = StreamChatTheme.of(context).colorTheme;

    var clipBehavior = Clip.none;
    ShapeDecoration? decoration;
    if (attachment.type != AttachmentType.file) {
      clipBehavior = Clip.hardEdge;
      decoration = ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: colorTheme.borders,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }

    return Container(
      key: Key(attachment.id),
      clipBehavior: clipBehavior,
      decoration: decoration,
      constraints: const BoxConstraints.tightFor(width: 36, height: 36),
      child: AbsorbPointer(child: attachmentWidget),
    );
  }

  _Builders _createDefaultAttachmentBuilders() {
    Widget _createMediaThumbnail(BuildContext context, Attachment media) {
      return StreamImageAttachmentThumbnail(
        image: media,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    }

    Widget _createUrlThumbnail(BuildContext context, Attachment media) {
      return StreamImageAttachmentThumbnail(
        image: media,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    }

    Widget _createFileThumbnail(BuildContext context, Attachment file) {
      Widget thumbnail = StreamFileAttachmentThumbnail(
        file: file,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );

      final mediaType = file.title?.mediaType;
      final isImage = mediaType?.type == AttachmentType.image;
      final isVideo = mediaType?.type == AttachmentType.video;
      if (isImage || isVideo) {
        final colorTheme = StreamChatTheme.of(context).colorTheme;
        thumbnail = Container(
          clipBehavior: Clip.hardEdge,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: colorTheme.borders,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: thumbnail,
        );
      }

      return thumbnail;
    }

    return {
      AttachmentType.image: _createMediaThumbnail,
      AttachmentType.giphy: _createMediaThumbnail,
      AttachmentType.video: _createMediaThumbnail,
      AttachmentType.urlPreview: _createUrlThumbnail,
      AttachmentType.file: _createFileThumbnail,
    };
  }
}
