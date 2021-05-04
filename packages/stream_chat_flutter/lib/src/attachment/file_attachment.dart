import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/utils.dart';
import 'package:stream_chat_flutter/src/video_thumbnail_image.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import '../upload_progress_indicator.dart';
import 'attachment_widget.dart';

class FileAttachment extends AttachmentWidget {
  final Widget? title;
  final Widget? trailing;
  final VoidCallback? onAttachmentTap;

  const FileAttachment({
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

  bool get isVideoAttachment => attachment.title?.mimeType?.type == 'video';

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
            color: colorTheme.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorTheme.greyWhisper,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: 33.33,
                margin: EdgeInsets.all(8),
                child: _getFileTypeImage(context),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attachment.title ?? 'File',
                      style: StreamChatTheme.of(context).textTheme.bodyBold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 3),
                    _buildSubtitle(context),
                  ],
                ),
              ),
              SizedBox(width: 8),
              _buildTrailing(context),
            ],
          ),
        ),
      ),
    );
  }

  ShapeBorder _getDefaultShape(BuildContext context) {
    return RoundedRectangleBorder(
      side: BorderSide(width: 0, color: Colors.transparent),
      borderRadius: BorderRadius.circular(8),
    );
  }

  Widget _getFileTypeImage(BuildContext context) {
    if (isImageAttachment) {
      return Material(
        clipBehavior: Clip.antiAlias,
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
              errorBuilder: (_, obj, trace) {
                return getFileTypeImage(
                    attachment.extraData['other'] as String?);
              },
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
              errorWidget: (_, obj, trace) {
                return getFileTypeImage(
                    attachment.extraData['other'] as String?);
              },
              placeholder: (_, __) {
                final image = Image.asset(
                  'images/placeholder.png',
                  fit: BoxFit.cover,
                  package: 'stream_chat_flutter',
                );

                final colorTheme = StreamChatTheme.of(context).colorTheme;
                return Shimmer.fromColors(
                  baseColor: colorTheme.greyGainsboro,
                  highlightColor: colorTheme.whiteSmoke,
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
        clipBehavior: Clip.antiAlias,
        type: MaterialType.transparency,
        shape: _getDefaultShape(context),
        child: source.when(
          local: () => VideoThumbnailImage(
            video: attachment.file!.path!,
            placeholderBuilder: (_) {
              return Center(
                child: Container(
                  width: 20,
                  height: 20,
                  child: const CircularProgressIndicator(),
                ),
              );
            },
          ),
          network: () => VideoThumbnailImage(
            video: attachment.assetUrl!,
            placeholderBuilder: (_) {
              return Center(
                child: Container(
                  width: 20,
                  height: 20,
                  child: const CircularProgressIndicator(),
                ),
              );
            },
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
  }) {
    return Container(
      height: iconSize,
      width: iconSize,
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

  Widget _buildTrailing(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final channel = StreamChannel.of(context).channel;
    final attachmentId = attachment.id;
    var trailingWidget = trailing;
    trailingWidget ??= attachment.uploadState.when(
          preparing: () => Padding(
            padding: const EdgeInsets.all(8),
            child: _buildButton(
              icon: StreamSvgIcon.close(color: theme.colorTheme.white),
              fillColor: theme.colorTheme.overlayDark,
              onPressed: () => channel.cancelAttachmentUpload(attachmentId),
            ),
          ),
          inProgress: (_, __) => Padding(
            padding: const EdgeInsets.all(8),
            child: _buildButton(
              icon: StreamSvgIcon.close(color: theme.colorTheme.white),
              fillColor: theme.colorTheme.overlayDark,
              onPressed: () => channel.cancelAttachmentUpload(attachmentId),
            ),
          ),
          success: () => Padding(
            padding: const EdgeInsets.all(8),
            child: CircleAvatar(
              backgroundColor: theme.colorTheme.accentBlue,
              maxRadius: 12,
              child: StreamSvgIcon.check(color: theme.colorTheme.white),
            ),
          ),
          failed: (_) => Padding(
            padding: const EdgeInsets.all(8),
            child: _buildButton(
              icon: StreamSvgIcon.retry(color: theme.colorTheme.white),
              fillColor: theme.colorTheme.overlayDark,
              onPressed: () => channel.retryAttachmentUpload(
                message.id,
                attachmentId,
              ),
            ),
          ),
        ) ??
        IconButton(
          icon: StreamSvgIcon.cloudDownload(color: theme.colorTheme.black),
          visualDensity: VisualDensity.compact,
          splashRadius: 16,
          onPressed: () {
            launchURL(context, attachment.assetUrl);
          },
        );

    if (message.status == MessageSendingStatus.sent) {
      trailingWidget = IconButton(
        icon: StreamSvgIcon.cloudDownload(color: theme.colorTheme.black),
        visualDensity: VisualDensity.compact,
        splashRadius: 16,
        onPressed: () {
          launchURL(context, attachment.assetUrl);
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
      color: theme.colorTheme.grey,
    );
    return attachment.uploadState.when(
          preparing: () {
            return UploadProgressIndicator(
              uploaded: 0,
              total: double.maxFinite.toInt(),
              showBackground: false,
              padding: EdgeInsets.zero,
              textStyle: textStyle,
              progressIndicatorColor: theme.colorTheme.accentBlue,
            );
          },
          inProgress: (sent, total) {
            return UploadProgressIndicator(
              uploaded: sent,
              total: total,
              showBackground: false,
              padding: EdgeInsets.zero,
              textStyle: textStyle,
              progressIndicatorColor: theme.colorTheme.accentBlue,
            );
          },
          success: () => Text(fileSize(size), style: textStyle),
          failed: (_) => Text('UPLOAD ERROR', style: textStyle),
        ) ??
        Text(fileSize(size), style: textStyle);
  }
}
