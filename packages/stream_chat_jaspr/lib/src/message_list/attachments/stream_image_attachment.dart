import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_jaspr/src/theme/stream_chat_jaspr_tokens.dart';

/// Renders one or more image (or GIF) attachments inside a message bubble.
///
/// A single image is displayed full-width (capped at 320 px). Two or more
/// images are laid out in a responsive 2-column grid.
class StreamImageAttachment extends StatelessComponent {
  /// Creates a [StreamImageAttachment] for a list of image [attachments].
  const StreamImageAttachment({
    required this.attachments,
    super.key,
  });

  /// The image attachments to display. Must not be empty.
  final List<Attachment> attachments;

  @override
  Component build(BuildContext context) {
    if (attachments.isEmpty) return const Component.fragment([]);

    if (attachments.length == 1) {
      return _buildSingleImage(attachments.first);
    }

    return _buildGrid(attachments);
  }

  Component _buildSingleImage(Attachment attachment) {
    final src = attachment.imageUrl ?? attachment.thumbUrl ?? attachment.assetUrl;
    if (src == null || src.isEmpty) return const Component.fragment([]);

    final w = attachment.originalWidth;
    final h = attachment.originalHeight;
    final aspectRatio = (w != null && h != null && h > 0) ? '$w / $h' : null;

    return img(
      src: src,
      alt: attachment.title ?? 'Image',
      styles: Styles(
        radius: const BorderRadius.circular(Unit.pixels(StreamRadii.lg)),
        maxWidth: const Unit.pixels(320),
        raw: {
          'display': 'block',
          'object-fit': 'cover',
          'width': '100%',
          if (aspectRatio != null) 'aspect-ratio': aspectRatio,
        },
      ),
    );
  }

  Component _buildGrid(List<Attachment> images) {
    final cells = images.take(4).map((att) {
      final src = att.imageUrl ?? att.thumbUrl ?? att.assetUrl;
      if (src == null || src.isEmpty) return const Component.fragment([]);
      return div(
        styles: const Styles(
          raw: {'overflow': 'hidden', 'aspect-ratio': '1'},
        ),
        [
          img(
            src: src,
            alt: att.title ?? 'Image',
            styles: const Styles(
              width: Unit.percent(100),
              height: Unit.percent(100),
              raw: {'object-fit': 'cover', 'display': 'block'},
            ),
          ),
        ],
      );
    }).toList();

    return div(
      styles: const Styles(
        radius: BorderRadius.circular(Unit.pixels(StreamRadii.lg)),
        raw: {
          'display': 'grid',
          'grid-template-columns': '1fr 1fr',
          'gap': '2px',
          'overflow': 'hidden',
          'max-width': '320px',
        },
      ),
      cells,
    );
  }
}
