import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:stream_chat_jaspr/src/theme/stream_chat_jaspr_tokens.dart';

/// A circular avatar showing a photo or initials fallback.
///
/// When [imageUrl] is provided and non-empty, displays the photo. Otherwise
/// shows the first letter(s) of [initials] on a light-blue background.
///
/// Set [isOnline] to show a green online-indicator dot in the top-right corner.
class StreamJasprAvatar extends StatelessComponent {
  /// Creates a [StreamJasprAvatar].
  const StreamJasprAvatar({
    required this.initials,
    this.imageUrl,
    this.size = 40,
    this.isOnline = false,
    this.backgroundColor,
    super.key,
  });

  /// The initials shown when no [imageUrl] is available.
  final String initials;

  /// Optional URL for the user or channel photo.
  ///
  /// When null or empty the [initials] fallback is rendered instead.
  final String? imageUrl;

  /// Diameter of the avatar in pixels. Defaults to 40.
  final int size;

  /// Whether to show a green online-indicator dot. Defaults to false.
  final bool isOnline;

  /// Explicit background color for the initials fallback.
  ///
  /// Overrides the default [StreamColors.avatarFallbackBg] when provided.
  final Color? backgroundColor;

  @override
  Component build(BuildContext context) {
    final sizeD = size.toDouble();
    final fontSize = (sizeD * 0.4).clamp(10.0, 18.0);
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return div(
      styles: Styles(
        width: Unit.pixels(sizeD),
        height: Unit.pixels(sizeD),
        position: const Position.relative(),
        raw: {'flex-shrink': '0', 'display': 'inline-flex'},
      ),
      [
        // Photo or initials circle.
        if (hasImage)
          img(
            src: imageUrl!,
            alt: initials,
            styles: Styles(
              width: Unit.pixels(sizeD),
              height: Unit.pixels(sizeD),
              radius: BorderRadius.circular(Unit.pixels(sizeD / 2)),
              raw: {'object-fit': 'cover', 'display': 'block'},
            ),
          )
        else
          div(
            styles: Styles(
              width: Unit.pixels(sizeD),
              height: Unit.pixels(sizeD),
              radius: BorderRadius.circular(Unit.pixels(sizeD / 2)),
              backgroundColor: backgroundColor ?? StreamColors.avatarFallbackBg,
              display: Display.flex,
              alignItems: AlignItems.center,
              justifyContent: JustifyContent.center,
              color: StreamColors.avatarFallbackText,
              fontWeight: FontWeight.w600,
              fontSize: Unit.pixels(fontSize),
              raw: {'user-select': 'none'},
            ),
            [Component.text(initials)],
          ),

        // Online indicator dot.
        if (isOnline)
          const div(
            styles: Styles(
              width: Unit.pixels(14),
              height: Unit.pixels(14),
              radius: BorderRadius.circular(Unit.pixels(7)),
              backgroundColor: StreamColors.online,
              border: Border.all(color: StreamColors.white, width: Unit.pixels(2)),
              position: Position.absolute(top: Unit.pixels(-2), right: Unit.pixels(-2)),
              raw: {'flex-shrink': '0'},
            ),
            [],
          ),
      ],
    );
  }
}
