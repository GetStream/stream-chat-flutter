import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/components/stream_chat_component_builders.dart';
import 'package:stream_chat_flutter/src/utils/utils.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/chat.dart';

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
            StreamFileTypeIcon.fromMimeType(
              size: .lg,
              mimeType: file.title?.mediaType?.mimeType,
            ),
            Expanded(
              child: Column(
                spacing: spacing.xxs,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle.merge(
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: textTheme.captionEmphasis.copyWith(color: colorScheme.textPrimary),
                    child: Text(file.title ?? context.translations.fileText),
                  ),
                  DefaultTextStyle.merge(
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: textTheme.metadataDefault.copyWith(color: colorScheme.textPrimary),
                    child: _FileAttachmentSubtitle(attachment: file),
                  ),
                ],
              ),
            ),
          ],
        ),
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
    final icons = context.streamIcons;
    final spacing = context.streamSpacing;

    final colorScheme = context.streamColorScheme;

    final attachmentSize = attachment.file?.size ?? attachment.extraData['file_size'];

    return attachment.uploadState.when(
      success: () => Text(fileSize(attachmentSize)),
      preparing: () => Text(fileSize(attachmentSize)),
      inProgress: (sent, total) {
        // Fall back to an indeterminate spinner when the total size is unknown
        // (e.g. `total` reported as `-1` or `0`) instead of rendering a fake 0%.
        final progress = total > 0 ? sent / total : null;

        return Row(
          mainAxisSize: .min,
          spacing: spacing.xxs,
          children: [
            StreamLoadingSpinner(value: progress, size: .xs),
            Text('${fileSize(sent)} / ${fileSize(total)}'),
          ],
        );
      },
      failed: (_) => Row(
        mainAxisSize: .min,
        spacing: spacing.xxs,
        children: [
          Icon(icons.exclamationTriangleFill, size: 16, color: colorScheme.accentError),
          Text(context.translations.uploadErrorLabel),
        ],
      ),
    );
  }
}
