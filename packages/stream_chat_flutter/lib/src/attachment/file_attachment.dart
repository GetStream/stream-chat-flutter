import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/utils.dart';
import 'package:stream_chat_flutter/src/video_thumbnail_image.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import '../upload_progress_indicator.dart';
import 'attachment_widget.dart';

class FileAttachment extends AttachmentWidget {
  final Widget title;
  final Widget trailing;

  const FileAttachment({
    Key key,
    @required Message message,
    @required Attachment attachment,
    Size size,
    this.title,
    this.trailing,
  }) : super(key: key, message: message, attachment: attachment, size: size);

  bool get isVideoAttachment => attachment.title?.mimeType?.type == 'video';

  bool get isImageAttachment => attachment.title?.mimeType?.type == 'image';

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: size?.width ?? 100,
        height: 56.0,
        decoration: BoxDecoration(
          color: StreamChatTheme.of(context).colorTheme.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: StreamChatTheme.of(context).colorTheme.greyWhisper,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: _getFileTypeImage(context),
              height: 40.0,
              width: 33.33,
              margin: EdgeInsets.all(8.0),
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attachment?.title ?? 'File',
                    style: StreamChatTheme.of(context).textTheme.bodyBold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 3.0),
                  _buildSubtitle(context),
                ],
              ),
            ),
            SizedBox(width: 8.0),
            _buildTrailing(context),
          ],
        ),
      ),
    );
  }

  ShapeBorder _getDefaultShape(BuildContext context) {
    return RoundedRectangleBorder(
      side: BorderSide(width: 0.0, color: Colors.transparent),
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
          local: () => Image.memory(
            attachment.file.bytes,
            fit: BoxFit.cover,
            errorBuilder: (_, obj, trace) {
              return getFileTypeImage(attachment.extraData['other']);
            },
          ),
          network: () => CachedNetworkImage(
            imageUrl: attachment.imageUrl ??
                attachment.assetUrl ??
                attachment.thumbUrl,
            fit: BoxFit.cover,
            errorWidget: (_, obj, trace) {
              return getFileTypeImage(attachment.extraData['other']);
            },
            progressIndicatorBuilder: (context, _, progress) {
              return Center(
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  child: const CircularProgressIndicator(),
                ),
              );
            },
          ),
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
            video: attachment.file.path,
            placeholderBuilder: (_) {
              return Center(
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  child: const CircularProgressIndicator(),
                ),
              );
            },
          ),
          network: () => VideoThumbnailImage(
            video: attachment.assetUrl,
            placeholderBuilder: (_) {
              return Center(
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  child: const CircularProgressIndicator(),
                ),
              );
            },
          ),
        ),
      );
    }
    return getFileTypeImage(attachment.extraData['mime_type']);
  }

  Widget _buildButton({
    Widget icon,
    double iconSize = 24.0,
    VoidCallback onPressed,
    Color fillColor,
  }) {
    return Container(
      height: iconSize,
      width: iconSize,
      child: RawMaterialButton(
        elevation: 0,
        highlightElevation: 0,
        focusElevation: 0,
        disabledElevation: 0,
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
    trailingWidget ??= attachment.uploadState?.when(
          preparing: () => Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildButton(
              icon: StreamSvgIcon.close(color: theme.colorTheme.white),
              fillColor: theme.colorTheme.overlayDark,
              onPressed: () => channel.cancelAttachmentUpload(attachmentId),
            ),
          ),
          inProgress: (_, __) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildButton(
              icon: StreamSvgIcon.close(color: theme.colorTheme.white),
              fillColor: theme.colorTheme.overlayDark,
              onPressed: () => channel.cancelAttachmentUpload(attachmentId),
            ),
          ),
          success: () => Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: theme.colorTheme.accentBlue,
              maxRadius: 12.0,
              child: StreamSvgIcon.check(color: theme.colorTheme.white),
            ),
          ),
          failed: (_) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildButton(
              icon: StreamSvgIcon.retry(color: theme.colorTheme.white),
              fillColor: theme.colorTheme.overlayDark,
              onPressed: () => channel.retryAttachmentUpload(
                message?.id,
                attachmentId,
              ),
            ),
          ),
        ) ??
        IconButton(
          icon: StreamSvgIcon.cloudDownload(color: theme.colorTheme.black),
          padding: const EdgeInsets.all(8),
          visualDensity: VisualDensity.compact,
          splashRadius: 16,
          onPressed: () {
            launchURL(context, attachment.assetUrl);
          },
        );

    if (message.status == null || message.status == MessageSendingStatus.sent) {
      trailingWidget = IconButton(
        icon: StreamSvgIcon.cloudDownload(color: theme.colorTheme.black),
        padding: const EdgeInsets.all(8),
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
    return attachment.uploadState?.when(
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
          success: () => Text('${fileSize(size, 2)}', style: textStyle),
          failed: (_) => Text('UPLOAD ERROR', style: textStyle),
        ) ??
        Text('${fileSize(size)}', style: textStyle);
  }
}
