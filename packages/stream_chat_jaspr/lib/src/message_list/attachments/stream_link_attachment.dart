import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_jaspr/src/theme/stream_chat_jaspr_tokens.dart';

const _cardStyles = Styles(
  radius: BorderRadius.circular(Unit.pixels(StreamRadii.md)),
  border: Border.all(color: StreamColors.borderDefault, width: Unit.pixels(1)),
  overflow: Overflow.hidden,
  raw: {'max-width': '280px', 'text-decoration': 'none', 'display': 'block'},
);

const _thumbnailStyles = Styles(
  width: Unit.percent(100),
  raw: {'display': 'block', 'object-fit': 'cover', 'max-height': '160px'},
);

const _bodyStyles = Styles(
  padding: Padding.all(Unit.pixels(StreamSpacing.xs)),
  raw: {'gap': '${StreamSpacing.xxs}px', 'display': 'flex', 'flex-direction': 'column'},
);

const _titleStyles = Styles(
  fontWeight: FontWeight.w600,
  fontSize: Unit.pixels(StreamTypography.sizeBase),
  color: StreamColors.textPrimary,
  raw: {
    'display': '-webkit-box',
    '-webkit-line-clamp': '2',
    '-webkit-box-orient': 'vertical',
    'overflow': 'hidden',
  },
);

const _descriptionStyles = Styles(
  fontSize: Unit.pixels(StreamTypography.sizeBase),
  color: StreamColors.textSecondary,
  raw: {
    'display': '-webkit-box',
    '-webkit-line-clamp': '2',
    '-webkit-box-orient': 'vertical',
    'overflow': 'hidden',
  },
);

/// Renders a link-preview attachment card.
///
/// Shows an optional thumbnail, bold title and description. Tapping opens
/// the linked URL in a new browser tab.
class StreamLinkAttachment extends StatelessComponent {
  /// Creates a [StreamLinkAttachment].
  const StreamLinkAttachment({
    required this.attachment,
    super.key,
  });

  /// The link attachment to render.
  final Attachment attachment;

  @override
  Component build(BuildContext context) {
    final href = attachment.titleLink ?? attachment.ogScrapeUrl ?? '';
    final thumbnailUrl = attachment.thumbUrl ?? attachment.imageUrl;
    final title = attachment.title ?? '';
    final description = attachment.text ?? '';

    final card = div(styles: _cardStyles, [
      if (thumbnailUrl != null && thumbnailUrl.isNotEmpty)
        img(
          src: thumbnailUrl,
          alt: title,
          styles: _thumbnailStyles,
        ),
      div(styles: _bodyStyles, [
        if (title.isNotEmpty) div(styles: _titleStyles, [Component.text(title)]),
        if (description.isNotEmpty) div(styles: _descriptionStyles, [Component.text(description)]),
      ]),
    ]);

    if (href.isEmpty) return card;

    return a(
      [card],
      href: href,
      target: Target.blank,
      attributes: const {'rel': 'noopener noreferrer'},
    );
  }
}
