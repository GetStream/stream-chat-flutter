part of 'attachment_widget_builder.dart';

/// {@template unsupportedAttachmentBuilder}
/// A builder that renders a [StreamUnsupportedAttachment] for messages
/// containing SDK-known content that no prior builder could handle.
///
/// Checks for typed attachments, polls, and shared locations. Custom builders
/// registered by the app are always prepended and take priority.
///
/// {@tool snippet}
///
/// Override the style of the unsupported attachment container:
///
/// ```dart
/// UnsupportedAttachmentBuilder(
///   style: StreamMessageAttachmentStyle.from(
///     backgroundColor: Colors.grey.shade200,
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamUnsupportedAttachment], the widget rendered by this builder.
///  * [FallbackAttachmentBuilder], the silent catch-all placed after this.
///  * [StreamAttachmentWidgetBuilder.defaultBuilders], which includes this
///    builder in the default list.
/// {@endtemplate}
class UnsupportedAttachmentBuilder extends StreamAttachmentWidgetBuilder {
  /// {@macro unsupportedAttachmentBuilder}
  const UnsupportedAttachmentBuilder({
    this.style,
    this.constraints,
  });

  /// The style of the attachment container.
  ///
  /// When null, the default [StreamMessageAttachment] styling is used.
  final StreamMessageAttachmentStyle? style;

  /// The constraints to apply to the unsupported attachment widget.
  final BoxConstraints? constraints;

  @override
  bool canHandle(
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    // Typed attachments that no built-in builder recognised.
    if (attachments.isNotEmpty) return true;

    // Message-level features that no prior builder handled.
    if (message.poll != null) return true;
    if (message.sharedLocation != null) return true;

    return false;
  }

  @override
  Widget build(
    BuildContext context,
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    assert(debugAssertCanHandle(message, attachments), '');

    return StreamMessageAttachment(
      style: style,
      child: StreamUnsupportedAttachment(
        message: message,
        constraints: constraints,
      ),
    );
  }
}
