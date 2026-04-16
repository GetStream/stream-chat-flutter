part of 'attachment_widget_builder.dart';

/// {@template fallbackAttachmentBuilder}
/// A silent catch-all builder that prevents errors when no other
/// [StreamAttachmentWidgetBuilder] can handle the attachments.
///
/// Returns `null` (no widget), ensuring the attachment area is simply empty
/// rather than throwing. This builder should always be the **last** entry in
/// the builder list.
///
/// See also:
///
///  * [UnsupportedAttachmentBuilder], which renders a visible placeholder for
///    unrecognised content types.
///  * [StreamAttachmentWidgetBuilder.defaultBuilders], which places this
///    builder at the end of the default list.
/// {@endtemplate}
class FallbackAttachmentBuilder extends StreamAttachmentWidgetBuilder {
  /// {@macro fallbackAttachmentBuilder}
  const FallbackAttachmentBuilder();

  @override
  bool canHandle(
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    // Always returns True because this builder will be used as a fallback when
    // no other builder can handle the attachments.
    return true;
  }

  @override
  Widget? build(
    BuildContext context,
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    // No visual representation for unsupported attachment types.
    return null;
  }
}
