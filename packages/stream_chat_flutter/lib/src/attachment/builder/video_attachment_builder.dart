part of 'attachment_widget_builder.dart';

/// {@template videoAttachmentBuilder}
/// A widget builder for [AttachmentType.video] attachment type.
///
/// This builder is used when a message contains only a single video attachment.
/// {@endtemplate}
class VideoAttachmentBuilder extends StreamAttachmentWidgetBuilder {
  /// {@macro videoAttachmentBuilder}
  const VideoAttachmentBuilder({
    this.style,
    this.constraints,
    this.onAttachmentTap,
  });

  /// The style of the video attachment container.
  ///
  /// When null, a default style with a rounded rectangle shape and border
  /// is used.
  final StreamMessageAttachmentStyle? style;

  /// The constraints to apply to the video attachment widget.
  final BoxConstraints? constraints;

  /// The callback to call when the attachment is tapped.
  final StreamAttachmentWidgetTapCallback? onAttachmentTap;

  @override
  bool canHandle(
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    final videos = attachments[AttachmentType.video];
    if (videos != null && videos.length == 1) return true;

    return false;
  }

  @override
  Widget? build(
    BuildContext context,
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    assert(debugAssertCanHandle(message, attachments), '');

    final video = attachments[AttachmentType.video]!.first;

    VoidCallback? onTap;
    if (onAttachmentTap != null) {
      onTap = () => onAttachmentTap!(message, video);
    }

    return StreamMessageAttachment(
      style: style,
      child: InkWell(
        onTap: onTap,
        child: StreamVideoAttachment(
          message: message,
          constraints: constraints,
          video: video,
        ),
      ),
    );
  }
}
