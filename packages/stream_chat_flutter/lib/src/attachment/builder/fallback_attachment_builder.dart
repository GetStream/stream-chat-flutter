part of 'attachment_widget_builder.dart';

/// {@template fallbackAttachmentBuilder}
/// A widget builder for when no other builder can handle the attachments.
///
/// Saves you from getting an error when you have an attachment type that is not
/// supported by the SDK.
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
  Widget build(
    BuildContext context,
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    // Returns an empty widget because this builder will be used as a fallback
    // when no other builder can handle the attachments.
    return const Empty();
  }
}
