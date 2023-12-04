part of 'attachment_widget_builder.dart';

const _kDefaultVideoConstraints = BoxConstraints.tightFor(
  width: 256,
  height: 195,
);

/// {@template videoAttachmentBuilder}
/// A widget builder for [AttachmentType.video] attachment type.
///
/// This builder is used when a message contains only a single video attachment.
/// {@endtemplate}
class VideoAttachmentBuilder extends StreamAttachmentWidgetBuilder {
  /// {@macro videoAttachmentBuilder}
  const VideoAttachmentBuilder({
    this.shape,
    this.padding = const EdgeInsets.all(2),
    this.constraints = _kDefaultVideoConstraints,
    this.onAttachmentTap,
  });

  /// The shape of the video attachment.
  final ShapeBorder? shape;

  /// The constraints to apply to the video attachment widget.
  final BoxConstraints constraints;

  /// The padding to apply to the video attachment widget.
  final EdgeInsetsGeometry padding;

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
  Widget build(
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

    return Padding(
      padding: padding,
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
