import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/attachment/handler/stream_attachment_handler.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/file_attachment_thumbnail.dart';
import 'package:stream_chat_flutter/src/icons/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/indicators/upload_progress_indicator.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/utils.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@template streamFileAttachment}
/// Displays file attachments that have been sent in a chat.
///
/// Used in [MessageWidget].
/// {@endtemplate}
class StreamFileAttachment extends StatelessWidget {
  /// {@macro streamFileAttachment}
  const StreamFileAttachment({
    super.key,
    required this.message,
    required this.file,
    this.title,
    this.trailing,
    this.shape,
    this.backgroundColor,
    this.constraints = const BoxConstraints(),
  });

  /// The [Message] that the file is attached to.
  final Message message;

  /// The [Attachment] object containing the file information.
  final Attachment file;

  /// The shape of the attachment.
  ///
  /// Defaults to [RoundedRectangleBorder] with a radius of 12.
  final ShapeBorder? shape;

  /// The background color of the attachment.
  ///
  /// Defaults to [StreamChatTheme.colorTheme.barsBg].
  final Color? backgroundColor;

  /// The constraints to use when displaying the file.
  final BoxConstraints constraints;

  /// Widget for displaying the title of the attachment.
  /// (usually the file name)
  final Widget? title;

  /// Widget for displaying at the end of the attachment.
  /// (such as a download button)
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final chatTheme = StreamChatTheme.of(context);
    final textTheme = chatTheme.textTheme;
    final colorTheme = chatTheme.colorTheme;

    final backgroundColor = this.backgroundColor ?? colorTheme.barsBg;
    final shape = this.shape ??
        RoundedRectangleBorder(
          side: BorderSide(
            color: colorTheme.borders,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
          borderRadius: BorderRadius.circular(12),
        );

    return Container(
      constraints: constraints,
      clipBehavior: Clip.hardEdge,
      decoration: ShapeDecoration(
        shape: shape,
        color: backgroundColor,
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 40,
            margin: const EdgeInsets.all(8),
            child: _FileTypeImage(file: file),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.title ?? context.translations.fileText,
                  maxLines: 1,
                  style: textTheme.bodyBold,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                _FileAttachmentSubtitle(attachment: file),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Material(
            type: MaterialType.transparency,
            child: trailing ??
                _Trailing(
                  attachment: file,
                  message: message,
                ),
          ),
        ],
      ),
    );
  }
}

class _FileTypeImage extends StatelessWidget {
  const _FileTypeImage({required this.file});

  final Attachment file;

  // TODO: Improve image memory.
  // This is using the full image instead of a smaller version (thumbnail)
  @override
  Widget build(BuildContext context) {
    Widget child = StreamFileAttachmentThumbnail(
      file: file,
      width: double.infinity,
      height: double.infinity,
    );

    final mediaType = file.title?.mediaType;
    final isImage = mediaType?.type == AttachmentType.image;
    final isVideo = mediaType?.type == AttachmentType.video;
    if (isImage || isVideo) {
      final colorTheme = StreamChatTheme.of(context).colorTheme;
      child = Container(
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
        child: child,
      );
    }

    return child;
  }
}

class _Trailing extends StatelessWidget {
  const _Trailing({
    required this.attachment,
    required this.message,
  });

  final Attachment attachment;
  final Message message;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final channel = StreamChannel.of(context).channel;
    final attachmentId = attachment.id;

    if (message.state.isCompleted) {
      return IconButton(
        icon: StreamSvgIcon(
          icon: StreamSvgIcons.cloudDownload,
          color: theme.colorTheme.textHighEmphasis,
        ),
        visualDensity: VisualDensity.compact,
        splashRadius: 16,
        onPressed: () async {
          final assetUrl = attachment.assetUrl;
          if (assetUrl != null) {
            if (isMobileDeviceOrWeb) {
              launchURL(context, assetUrl);
            } else {
              StreamAttachmentHandler.instance.downloadAttachment(attachment);
            }
          }
        },
      );
    }

    return attachment.uploadState.when(
      preparing: () => Padding(
        padding: const EdgeInsets.all(8),
        child: _TrailingButton(
          icon: StreamSvgIcon(
            icon: StreamSvgIcons.close,
            color: theme.colorTheme.barsBg,
          ),
          fillColor: theme.colorTheme.overlayDark,
          onPressed: () => channel.cancelAttachmentUpload(attachmentId),
        ),
      ),
      inProgress: (_, __) => Padding(
        padding: const EdgeInsets.all(8),
        child: _TrailingButton(
          icon: StreamSvgIcon(
            icon: StreamSvgIcons.close,
            color: theme.colorTheme.barsBg,
          ),
          fillColor: theme.colorTheme.overlayDark,
          onPressed: () => channel.cancelAttachmentUpload(attachmentId),
        ),
      ),
      success: () => Padding(
        padding: const EdgeInsets.all(8),
        child: CircleAvatar(
          backgroundColor: theme.colorTheme.accentPrimary,
          maxRadius: 12,
          child: StreamSvgIcon(
            icon: StreamSvgIcons.check,
            color: theme.colorTheme.barsBg,
          ),
        ),
      ),
      failed: (_) => Padding(
        padding: const EdgeInsets.all(8),
        child: _TrailingButton(
          icon: StreamSvgIcon(
            icon: StreamSvgIcons.retry,
            color: theme.colorTheme.barsBg,
          ),
          fillColor: theme.colorTheme.overlayDark,
          onPressed: () => channel.retryAttachmentUpload(
            message.id,
            attachmentId,
          ),
        ),
      ),
    );
  }
}

class _TrailingButton extends StatelessWidget {
  const _TrailingButton({
    this.onPressed,
    this.fillColor,
    this.icon,
  });

  final VoidCallback? onPressed;
  final Color? fillColor;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 24,
      child: RawMaterialButton(
        elevation: 0,
        highlightElevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        onPressed: onPressed,
        fillColor: fillColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: icon,
      ),
    );
  }
}

class _FileAttachmentSubtitle extends StatelessWidget {
  const _FileAttachmentSubtitle({
    required this.attachment,
  });

  final Attachment attachment;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final size = attachment.file?.size ?? attachment.extraData['file_size'];
    final textStyle = theme.textTheme.footnote.copyWith(
      color: theme.colorTheme.textLowEmphasis,
    );
    return attachment.uploadState.when(
      preparing: () => Text(fileSize(size), style: textStyle),
      inProgress: (sent, total) => StreamUploadProgressIndicator(
        uploaded: sent,
        total: total,
        showBackground: false,
        textStyle: textStyle,
        progressIndicatorColor: theme.colorTheme.accentPrimary,
      ),
      success: () => Text(fileSize(size), style: textStyle),
      failed: (_) => Text(
        context.translations.uploadErrorLabel,
        style: textStyle,
      ),
    );
  }
}
