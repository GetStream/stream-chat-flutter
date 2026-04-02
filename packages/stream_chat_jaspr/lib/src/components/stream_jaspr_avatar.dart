import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

const _avatarColors = [
  Color('#005FFF'),
  Color('#00B2FF'),
  Color('#00DDB5'),
  Color('#A95EDB'),
  Color('#FF5733'),
  Color('#FF8C00'),
  Color('#FF3B7A'),
];

/// Returns a deterministic avatar background color for the given [seed] string.
Color avatarColorForSeed(String seed) {
  final index = seed.hashCode.abs() % _avatarColors.length;
  return _avatarColors[index];
}

/// A circular avatar that shows [initials] on a colored background.
///
/// The background color is chosen deterministically from a palette based on
/// [colorSeed]. If [backgroundColor] is provided it overrides the palette.
class StreamJasprAvatar extends StatelessComponent {
  /// Creates a [StreamJasprAvatar].
  const StreamJasprAvatar({
    required this.initials,
    this.size = 40,
    this.backgroundColor,
    this.colorSeed,
    super.key,
  });

  /// The initials to display.
  final String initials;

  /// The diameter of the avatar in pixels. Defaults to 40.
  final int size;

  /// Explicit background color. If null, derived from [colorSeed].
  final Color? backgroundColor;

  /// Seed string for deriving a deterministic color. Falls back to [initials].
  final String? colorSeed;

  @override
  Component build(BuildContext context) {
    final seed = colorSeed ?? initials;
    final bg = backgroundColor ?? avatarColorForSeed(seed);
    final sizeD = size.toDouble();
    final fontSize = (size * 0.4).toDouble();

    return div(
      styles: Styles(
        width: Unit.pixels(sizeD),
        height: Unit.pixels(sizeD),
        radius: BorderRadius.circular(Unit.pixels(sizeD / 2)),
        backgroundColor: bg,
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: Unit.pixels(fontSize),
        raw: {'flex-shrink': '0', 'user-select': 'none'},
      ),
      [Component.text(initials)],
    );
  }
}
