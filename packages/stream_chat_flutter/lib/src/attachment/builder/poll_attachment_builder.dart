part of 'attachment_widget_builder.dart';

const _kDefaultPollMessageConstraints = BoxConstraints(
  maxWidth: 270,
);

/// {@template pollAttachmentBuilder}
/// A widget builder for Poll attachment type.
///
/// This builder is used when a message contains a poll.
/// {@endtemplate}
class PollAttachmentBuilder extends StreamAttachmentWidgetBuilder {
  /// {@macro urlAttachmentBuilder}
  const PollAttachmentBuilder({
    this.shape,
    this.padding = const EdgeInsets.all(8),
    this.constraints = _kDefaultPollMessageConstraints,
  });

  /// The shape of the poll attachment.
  final ShapeBorder? shape;

  /// The constraints to apply to the poll attachment widget.
  final BoxConstraints constraints;

  /// The padding to apply to the poll attachment widget.
  final EdgeInsetsGeometry padding;

  @override
  bool canHandle(
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    final poll = message.poll;
    return poll != null;
  }

  @override
  Widget build(
    BuildContext context,
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    assert(debugAssertCanHandle(message, attachments), '');

    return Padding(
      padding: padding,
      child: PollAttachment(
        message: message,
        shape: shape,
        constraints: constraints,
      ),
    );
  }
}
