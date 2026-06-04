import 'package:jaspr/jaspr.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_jaspr/src/message_list/attachments/stream_file_attachment.dart';
import 'package:stream_chat_jaspr/src/message_list/attachments/stream_link_attachment.dart';

/// Dispatches a single [attachment] to the appropriate renderer component.
///
/// Image and GIF attachments are not handled here — collect them separately
/// and pass to [StreamImageAttachment]. This component handles file and link
/// attachments only.
///
/// Returns an empty [Component.fragment] for unrecognised attachment types.
class StreamAttachment extends StatelessComponent {
  /// Creates a [StreamAttachment] dispatcher.
  const StreamAttachment({
    required this.attachment,
    super.key,
  });

  /// The attachment to render.
  final Attachment attachment;

  @override
  Component build(BuildContext context) {
    final type = attachment.type;

    if (type == 'file') {
      return StreamFileAttachment(attachment: attachment);
    }

    // Treat any attachment with a link URL as a link preview.
    if (attachment.titleLink != null || attachment.ogScrapeUrl != null) {
      return StreamLinkAttachment(attachment: attachment);
    }

    return const Component.fragment([]);
  }
}
