import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stream_chat_flutter/src/attachment/attachment_widget.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/upload_progress_indicator.dart';
import 'package:stream_chat_flutter/src/utils.dart';
import 'package:stream_chat_flutter/src/video_thumbnail_image.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@macro file_attachment}
@Deprecated("Use 'StreamFileAttachment' instead")
typedef FileAttachment = StreamFileAttachment;

/// {@template file_attachment}
/// Widget for displaying file attachments
/// {@endtemplate}
class StreamFileAttachment extends StreamAttachmentWidget {
  /// Constructor for creating a widget when attachment is of type 'file'
  const StreamFileAttachment({
    Key? key,
    required Message message,
    required Attachment attachment,
    Size? size,
    this.title,
    this.trailing,
    this.onAttachmentTap,
  }) : super(
          key: key,
          message: message,
          attachment: attachment,
          size: size,
        );

  /// Title for attachment
  final Widget? title;

  /// Widget for displaying at the end of attachment (such as a download button)
  final Widget? trailing;

  /// Callback called when attachment widget is tapped
  final VoidCallback? onAttachmentTap;

  /// Check if attachment is a video
  bool get isVideoAttachment => attachment.title?.mimeType?.type == 'video';

  /// Check if attachment is an image
  bool get isImageAttachment => attachment.title?.mimeType?.type == 'image';

  @override
  Widget build(BuildContext context) {
    final colorTheme = StreamChatTheme.of(context).colorTheme;
    return Material(
      child: GestureDetector(
        onTap: onAttachmentTap,
        child: Container(
          width: size?.width ?? 100,
          height: 56,
          decoration: BoxDecoration(
            color: colorTheme.barsBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorTheme.borders,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: 33.33,
                margin: const EdgeInsets.all(8),
                child: _getFileTypeImage(context),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attachment.title ?? context.translations.fileText,
                      style: StreamChatTheme.of(context).textTheme.bodyBold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    _buildSubtitle(context),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildTrailing(context),
            ],
          ),
        ),
      ),
    );
  }

  ShapeBorder _getDefaultShape(BuildContext context) => RoundedRectangleBorder(
        side: const BorderSide(width: 0, color: Colors.transparent),
        borderRadius: BorderRadius.circular(8),
      );

  Widget _getFileTypeImage(BuildContext context) {
    if (isImageAttachment) {
      return Material(
        clipBehavior: Clip.hardEdge,
        type: MaterialType.transparency,
        shape: _getDefaultShape(context),
        child: source.when(
          local: () {
            if (attachment.file?.bytes == null) {
              return getFileTypeImage(attachment.extraData['other'] as String?);
            }
            return Image.memory(
              attachment.file!.bytes!,
              fit: BoxFit.cover,
              errorBuilder: (_, obj, trace) =>
                  getFileTypeImage(attachment.extraData['other'] as String?),
            );
          },
          network: () {
            if ((attachment.imageUrl ??
                    attachment.assetUrl ??
                    attachment.thumbUrl) ==
                null) {
              return getFileTypeImage(attachment.extraData['other'] as String?);
            }
            return CachedNetworkImage(
              imageUrl: attachment.imageUrl ??
                  attachment.assetUrl ??
                  attachment.thumbUrl!,
              fit: BoxFit.cover,
              errorWidget: (_, obj, trace) =>
                  getFileTypeImage(attachment.extraData['other'] as String?),
              placeholder: (_, __) {
                final image = Image.asset(
                  'images/placeholder.png',
                  fit: BoxFit.cover,
                  package: 'stream_chat_flutter',
                );

                final colorTheme = StreamChatTheme.of(context).colorTheme;
                return Shimmer.fromColors(
                  baseColor: colorTheme.disabled,
                  highlightColor: colorTheme.inputBg,
                  child: image,
                );
              },
            );
          },
        ),
      );
    }

    if (isVideoAttachment) {
      return Material(
        clipBehavior: Clip.hardEdge,
        type: MaterialType.transparency,
        shape: _getDefaultShape(context),
        child: source.when(
          local: () => StreamVideoThumbnailImage(
            fit: BoxFit.cover,
            video: attachment.file!.path!,
            placeholderBuilder: (_) => const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          network: () => StreamVideoThumbnailImage(
            fit: BoxFit.cover,
            video: attachment.assetUrl!,
            placeholderBuilder: (_) => const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      );
    }
    return getFileTypeImage(attachment.extraData['mime_type'] as String?);
  }

  Widget _buildButton({
    Widget? icon,
    double iconSize = 24.0,
    VoidCallback? onPressed,
    Color? fillColor,
  }) =>
      SizedBox(
        height: iconSize,
        width: iconSize,
        child: RawMaterialButton(
          elevation: 0,
          highlightElevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          onPressed: onPressed,
          fillColor: fillColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: icon,
        ),
      );

  Widget _buildTrailing(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final channel = StreamChannel.of(context).channel;
    final attachmentId = attachment.id;
    var trailingWidget = trailing;
    trailingWidget ??= attachment.uploadState.when(
      preparing: () => Padding(
        padding: const EdgeInsets.all(8),
        child: _buildButton(
          icon: StreamSvgIcon.close(color: theme.colorTheme.barsBg),
          fillColor: theme.colorTheme.overlayDark,
          onPressed: () => channel.cancelAttachmentUpload(attachmentId),
        ),
      ),
      inProgress: (_, __) => Padding(
        padding: const EdgeInsets.all(8),
        child: _buildButton(
          icon: StreamSvgIcon.close(color: theme.colorTheme.barsBg),
          fillColor: theme.colorTheme.overlayDark,
          onPressed: () => channel.cancelAttachmentUpload(attachmentId),
        ),
      ),
      success: () => Padding(
        padding: const EdgeInsets.all(8),
        child: CircleAvatar(
          backgroundColor: theme.colorTheme.accentPrimary,
          maxRadius: 12,
          child: StreamSvgIcon.check(color: theme.colorTheme.barsBg),
        ),
      ),
      failed: (_) => Padding(
        padding: const EdgeInsets.all(8),
        child: _buildButton(
          icon: StreamSvgIcon.retry(color: theme.colorTheme.barsBg),
          fillColor: theme.colorTheme.overlayDark,
          onPressed: () => channel.retryAttachmentUpload(
            message.id,
            attachmentId,
          ),
        ),
      ),
    );

    if (message.status == MessageSendingStatus.sent) {
      trailingWidget = IconButton(
        icon: StreamSvgIcon.cloudDownload(
          color: theme.colorTheme.textHighEmphasis,
        ),
        visualDensity: VisualDensity.compact,
        splashRadius: 16,
        onPressed: () {
          final assetUrl = attachment.assetUrl;
          if (assetUrl != null) launchURL(context, assetUrl);
        },
      );
    }

    return Material(
      type: MaterialType.transparency,
      child: trailingWidget,
    );
  }

  Widget _buildSubtitle(BuildContext context) {
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
        padding: EdgeInsets.zero,
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
