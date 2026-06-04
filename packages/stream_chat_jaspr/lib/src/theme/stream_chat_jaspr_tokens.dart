import 'package:jaspr/dom.dart';

/// Color tokens for the Stream Chat Jaspr design system.
///
/// All values are sourced from the Chat SDK Design System Figma file.
abstract final class StreamColors {
  /// Primary text — dark navy, used for names and body copy.
  static const textPrimary = Color('#1A1B25');

  /// Secondary text — used for message preview body.
  static const textSecondary = Color('#414552');

  /// Tertiary text — used for timestamps, sender prefixes and placeholders.
  static const textTertiary = Color('#687385');

  /// Brand primary blue — used for unread badges and read receipts.
  static const primary = Color('#005FFF');

  /// Own-message bubble background (light blue).
  static const ownBubble = Color('#E3EDFF');

  /// Other-message bubble background (light gray).
  static const otherBubble = Color('#EBEEF1');

  /// Online presence indicator dot color.
  static const online = Color('#00A46E');

  /// Avatar fallback background.
  static const avatarFallbackBg = Color('#C3D9FF');

  /// Avatar fallback initials text color.
  static const avatarFallbackText = Color('#091A3B');

  /// Subtle border — used for dividers and tile bottom borders.
  static const borderSubtle = Color('#EBEEF1');

  /// Default border — used for inputs and cards.
  static const borderDefault = Color('#D5DBE1');

  /// White convenience alias.
  static const white = Color('#FFFFFF');

  /// Selection overlay color — semi-transparent dark tint.
  static const selectionOverlay = Color.rgba(26, 27, 37, 0.06);
}

/// Spacing tokens in logical pixels.
abstract final class StreamSpacing {
  /// 2 px — used for very tight gaps (e.g. badge–timestamp).
  static const double xxxs = 2;

  /// 4 px — used for small padding (e.g. badge horizontal).
  static const double xxs = 4;

  /// 8 px — base gap between flex children.
  static const double xs = 8;

  /// 12 px — standard gap between avatar and content.
  static const double sm = 12;

  /// 16 px — standard horizontal padding.
  static const double md = 16;
}

/// Border-radius tokens in logical pixels.
abstract final class StreamRadii {
  /// 8 px — cards and small components.
  static const double md = 8;

  /// 12 px — channel tile selection overlay.
  static const double lg = 12;

  /// 16 px — message bubbles.
  static const double bubble = 16;

  /// 9999 px — fully circular / pill shapes.
  static const double pill = 9999;
}

/// Typography tokens.
abstract final class StreamTypography {
  /// Extra-extra-small font size (10 px) — badge labels.
  static const double sizeXxs = 10;

  /// Base font size (14 px).
  static const double sizeBase = 14;

  /// Header font size (16 px) — channel header title.
  static const double sizeHeader = 16;

  /// System sans-serif font family stack.
  static const fontFamily = FontFamily.list([
    FontFamily('-apple-system'),
    FontFamily('BlinkMacSystemFont'),
    FontFamily('Segoe UI'),
    FontFamily('Roboto'),
    FontFamilies.sansSerif,
  ]);
}
