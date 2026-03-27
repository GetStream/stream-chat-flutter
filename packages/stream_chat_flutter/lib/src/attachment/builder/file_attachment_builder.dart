part of 'attachment_widget_builder.dart';

/// {@template fileAttachmentBuilder}
/// A widget builder for [AttachmentType.file] attachment type.
/// {@endtemplate}
class FileAttachmentBuilder extends StreamAttachmentWidgetBuilder {
  /// {@macro fileAttachmentBuilder}
  const FileAttachmentBuilder({
    this.style,
    this.constraints,
    this.onAttachmentTap,
  });

  /// The style of the file attachment container.
  ///
  /// When null, a default style with placement-aware background color and
  /// a superellipse shape is used.
  final StreamMessageAttachmentStyle? style;

  /// The constraints to apply to the file attachment widget.
  final BoxConstraints? constraints;

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
  Widget? build(
    BuildContext context,
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    assert(debugAssertCanHandle(message, attachments), '');

    final spacing = context.streamSpacing;

    final files = attachments[AttachmentType.file]!;

    Widget _buildFileAttachment(Attachment file) {
      final onTap = switch (onAttachmentTap) {
        final onTap? => () => onTap(message, file),
        _ => null,
      };

      return StreamMessageAttachment(
        style: style,
        child: InkWell(
          onTap: onTap,
          child: StreamFileAttachment(
            file: file,
            message: message,
            constraints: constraints,
          ),
        ),
      );
    }

    if (files.length == 1) {
      return _buildFileAttachment(files.first);
    }

    return Column(
      spacing: spacing.xs,
      children: <Widget>[
        for (final file in files) _buildFileAttachment(file),
      ],
    );
  }
}
