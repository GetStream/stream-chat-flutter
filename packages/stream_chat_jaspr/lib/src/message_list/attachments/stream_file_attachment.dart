import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_jaspr/src/theme/stream_chat_jaspr_tokens.dart';
import 'package:stream_chat_jaspr/src/utils/extensions.dart';

const _cardStyles = Styles(
  display: Display.flex,
  alignItems: AlignItems.center,
  radius: BorderRadius.circular(Unit.pixels(StreamRadii.md)),
  border: Border.all(color: StreamColors.borderDefault, width: Unit.pixels(1)),
  padding: Padding.all(Unit.pixels(StreamSpacing.xs)),
  raw: {'gap': '${StreamSpacing.xs}px', 'text-decoration': 'none', 'max-width': '280px'},
);

const _iconStyles = Styles(
  fontSize: Unit.pixels(20),
  raw: {'flex-shrink': '0', 'line-height': '1'},
);

const _infoStyles = Styles(
  flex: Flex(grow: 1),
  minWidth: Unit.zero,
  raw: {'gap': '2px', 'display': 'flex', 'flex-direction': 'column'},
);

const _nameStyles = Styles(
  fontSize: Unit.pixels(StreamTypography.sizeBase),
  fontWeight: FontWeight.w600,
  color: StreamColors.textPrimary,
  raw: {
    'white-space': 'nowrap',
    'overflow': 'hidden',
    'text-overflow': 'ellipsis',
  },
);

const _sizeStyles = Styles(
  fontSize: Unit.pixels(StreamTypography.sizeXxs),
  color: StreamColors.textTertiary,
);

/// Renders a file attachment as a downloadable card.
///
/// Displays the file icon, name and size. Tapping the card opens the
/// file in a new browser tab.
class StreamFileAttachment extends StatelessComponent {
  /// Creates a [StreamFileAttachment].
  const StreamFileAttachment({
    required this.attachment,
    super.key,
  });

  /// The file attachment to render.
  final Attachment attachment;

  @override
  Component build(BuildContext context) {
    final downloadUrl = attachment.assetUrl ?? '';
    final fileName = attachment.title ?? 'File';
    final rawSize = attachment.extraData['file_size'];
    final sizeLabel = rawSize is num ? formatBytes(rawSize) : null;

    final card = div(styles: _cardStyles, [
      const div(styles: _iconStyles, [Component.text('📄')]),
      div(styles: _infoStyles, [
        div(styles: _nameStyles, [Component.text(fileName)]),
        if (sizeLabel != null) div(styles: _sizeStyles, [Component.text(sizeLabel)]),
      ]),
    ]);

    if (downloadUrl.isEmpty) return card;

    return a(
      [card],
      href: downloadUrl,
      target: Target.blank,
      attributes: const {'rel': 'noopener noreferrer'},
    );
  }
}
