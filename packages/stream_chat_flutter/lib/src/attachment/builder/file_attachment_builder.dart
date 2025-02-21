part of 'attachment_widget_builder.dart';

/// {@template fileAttachmentBuilder}
/// A widget builder for [AttachmentType.file] attachment type.
/// {@endtemplate}
class FileAttachmentBuilder extends StreamAttachmentWidgetBuilder {
  /// {@macro fileAttachmentBuilder}
  const FileAttachmentBuilder({
    this.shape,
    this.backgroundColor,
    this.constraints = const BoxConstraints(),
    this.padding = const EdgeInsets.all(4),
    this.onAttachmentTap,
  });

  /// The shape of the file attachment.
  final ShapeBorder? shape;

  /// The background color of the file attachment.
  final Color? backgroundColor;

  /// The constraints to apply to the file attachment widget.
  final BoxConstraints constraints;

  /// The padding to apply to the file attachment widget.
  final EdgeInsetsGeometry padding;

  /// The callback to call when the attachment is tapped.
  final StreamAttachmentWidgetTapCallback? onAttachmentTap;

  @override
  bool canHandle(
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    final files = attachments[AttachmentType.file];
    return files != null && files.isNotEmpty;
  }

  @override
  Widget build(
    BuildContext context,
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    assert(debugAssertCanHandle(message, attachments), '');

    final files = attachments[AttachmentType.file]!;

    Widget _buildFileAttachment(Attachment file) {
      VoidCallback? onTap;
      if (onAttachmentTap != null) {
        onTap = () => onAttachmentTap!(message, file);
      }

      return InkWell(
        onTap: onTap,
        child: StreamFileAttachment(
          file: file,
          message: message,
          shape: shape,
          constraints: constraints,
          backgroundColor: backgroundColor,
        ),
      );
    }

    Widget child;
    if (files.length == 1) {
      child = _buildFileAttachment(files.first);
    } else {
      child = Column(
        // Add a small vertical padding between each attachment.
        spacing: padding.vertical / 2,
        children: <Widget>[
          for (final file in files) _buildFileAttachment(file),
        ],
      );
    }

    return Padding(
      padding: padding,
      child: child,
    );
  }
}
