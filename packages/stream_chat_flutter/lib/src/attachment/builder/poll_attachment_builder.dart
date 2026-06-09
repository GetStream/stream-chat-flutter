part of 'attachment_widget_builder.dart';

/// {@template pollAttachmentBuilder}
/// A widget builder for Poll attachment type.
///
/// This builder is used when a message contains a poll.
/// {@endtemplate}
class PollAttachmentBuilder extends StreamAttachmentWidgetBuilder {
  /// {@macro pollAttachmentBuilder}
  const PollAttachmentBuilder({
    this.style,
    this.constraints,
  });

  /// The style of the poll attachment container.
  ///
  /// When null, a default style with a rounded rectangle shape and border
  /// is used.
  final StreamMessageAttachmentStyle? style;

  /// The constraints to apply to the poll attachment widget.
  final BoxConstraints? constraints;

  @override
  bool canHandle(
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    final poll = message.poll;
    return poll != null;
  }

  @override
  Widget? build(
    BuildContext context,
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    assert(debugAssertCanHandle(message, attachments), '');

    final effectiveStyle = StreamMessageAttachmentStyle.from(
      backgroundColor: StreamColors.transparent,
    ).merge(style);

    return StreamMessageAttachment(
      style: effectiveStyle,
      child: StreamPollAttachment(
        message: message,
        constraints: constraints,
      ),
    );
  }
}
