import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/attachment/handler/stream_attachment_handler.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/file_attachment_thumbnail.dart';
import 'package:stream_chat_flutter/src/components/stream_chat_component_builders.dart';
import 'package:stream_chat_flutter/src/indicators/upload_progress_indicator.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/utils.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

/// A file attachment component with file information and actions.
///
/// [StreamFileAttachment] presents a file attachment, including the file
/// name, size, and appropriate actions based on the message state.
///
/// {@tool snippet}
///
/// Basic usage:
///
/// ```dart
/// StreamFileAttachment(
///   message: message,
///   file: fileAttachment,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamFileAttachmentProps], which configures this widget.
///  * [DefaultStreamFileAttachment], the default implementation.
class StreamFileAttachment extends StatelessWidget {
  /// Creates a [StreamFileAttachment].
  StreamFileAttachment({
    super.key,
    required Message message,
    required Attachment file,
    BoxConstraints? constraints,
    Widget? title,
    Widget? trailing,
  }) : props = .new(
         message: message,
         file: file,
         constraints: constraints,
         title: title,
         trailing: trailing,
       );

  /// The properties that configure this attachment.
  final StreamFileAttachmentProps props;

  @override
  Widget build(BuildContext context) {
    final builder = context.chatComponentBuilder<StreamFileAttachmentProps>();
    if (builder != null) return builder(context, props);
    return DefaultStreamFileAttachment(props: props);
  }
}

/// Properties for configuring a [StreamFileAttachment].
///
/// This class holds all the configuration options for a file attachment,
/// allowing them to be passed through the [StreamComponentFactory].
///
/// See also:
///
///  * [StreamFileAttachment], which uses these properties.
///  * [DefaultStreamFileAttachment], the default implementation.
class StreamFileAttachmentProps {
  /// Creates properties for a file attachment.
  const StreamFileAttachmentProps({
    required this.message,
    required this.file,
    this.title,
    this.trailing,
    this.constraints,
  });

  /// The [Message] that the file is attached to.
  final Message message;

  /// The [Attachment] object containing the file information.
  final Attachment file;

  /// The constraints to use when displaying the file.
  final BoxConstraints? constraints;

  /// Widget for displaying the title of the attachment.
  /// (usually the file name)
  final Widget? title;

  /// Widget for displaying at the end of the attachment.
  /// (such as a download button)
  final Widget? trailing;
}

const _kDefaultConstraints = BoxConstraints(
  minWidth: 256,
  maxWidth: 256,
  minHeight: 64,
);

/// The default implementation of [StreamFileAttachment].
///
/// Renders the file information with download and upload controls.
///
/// See also:
///
///  * [StreamFileAttachment], the public API widget.
///  * [StreamFileAttachmentProps], which configures this widget.
class DefaultStreamFileAttachment extends StatelessWidget {
  /// Creates a default Stream file attachment.
  const DefaultStreamFileAttachment({
    super.key,
    required this.props,
  });

  /// The properties that configure this attachment.
  final StreamFileAttachmentProps props;

  @override
  Widget build(BuildContext context) {
    final file = props.file;

    final spacing = context.streamSpacing;
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;
    final constraints = props.constraints ?? _kDefaultConstraints;

    return ConstrainedBox(
      constraints: constraints,
      child: Padding(
        padding: .all(spacing.sm),
        child: Row(
          spacing: spacing.sm,
          children: [
            SizedBox(
              width: 32,
              height: 40,
              child: _FileTypeImage(file: file),
            ),
            Expanded(
              child: Column(
                spacing: spacing.xxs,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    maxLines: 2,
                    file.title ?? context.translations.fileText,
                    style: textTheme.captionEmphasis.copyWith(color: colorScheme.textPrimary),
                    overflow: TextOverflow.ellipsis,
                  ),
                  _FileAttachmentSubtitle(attachment: file),
                ],
              ),
            ),
            Material(
              type: MaterialType.transparency,
              child: props.trailing ?? _Trailing(attachment: file, message: props.message),
            ),
          ],
        ),
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
        icon: Icon(context.streamIcons.arrowDown20),
        color: theme.colorTheme.textHighEmphasis,
        visualDensity: VisualDensity.compact,
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
          icon: Icon(
            context.streamIcons.xmark20,
            color: theme.colorTheme.barsBg,
          ),
          fillColor: theme.colorTheme.overlayDark,
          onPressed: () => channel.cancelAttachmentUpload(attachmentId),
        ),
      ),
      inProgress: (_, __) => Padding(
        padding: const EdgeInsets.all(8),
        child: _TrailingButton(
          icon: Icon(
            context.streamIcons.xmark20,
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
          child: Icon(
            context.streamIcons.checkmark20,
            color: theme.colorTheme.barsBg,
          ),
        ),
      ),
      failed: (_) => Padding(
        padding: const EdgeInsets.all(8),
        child: _TrailingButton(
          icon: Icon(
            context.streamIcons.retry20,
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
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    final size = attachment.file?.size ?? attachment.extraData['file_size'];
    final textStyle = textTheme.metadataDefault.copyWith(color: colorScheme.textPrimary);
    return attachment.uploadState.when(
      preparing: () => Text(fileSize(size), style: textStyle),
      inProgress: (sent, total) => StreamUploadProgressIndicator(
        uploaded: sent,
        total: total,
        showBackground: false,
        textStyle: textStyle,
        progressIndicatorColor: colorScheme.accentPrimary,
      ),
      success: () => Text(fileSize(size), style: textStyle),
      failed: (_) => Text(context.translations.uploadErrorLabel, style: textStyle),
    );
  }
}
