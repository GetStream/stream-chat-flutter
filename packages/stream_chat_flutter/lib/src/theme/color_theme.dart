import 'package:flutter/material.dart';

/// Defines a color theme for the Stream Chat UI,
/// including core surfaces, text colors, accents, and visual effects.
///
/// This theme provides two variants:
/// - `StreamColorTheme.light`: for light mode
/// - `StreamColorTheme.dark`: for dark mode
class StreamColorTheme {
  /// Creates a light mode [StreamColorTheme] using design system values.
  const StreamColorTheme.light({
    this.textHighEmphasis = const Color(0xff000000),
    this.textLowEmphasis = const Color(0xff72767e),
    this.disabled = const Color(0xffb4b7bb),
    this.borders = const Color(0xffdbdde1),
    this.inputBg = const Color(0xffe9eaed),
    this.appBg = const Color(0xffffffff),
    this.barsBg = const Color(0xffffffff),
    this.linkBg = const Color(0xffe9f2ff),
    this.accentPrimary = const Color(0xff005fff),
    this.accentError = const Color(0xffff3742),
    this.accentInfo = const Color(0xff20e070),
    this.highlight = const Color(0xfffbf4dd),
    this.overlay = const Color.fromRGBO(0, 0, 0, 0.2),
    this.overlayDark = const Color.fromRGBO(0, 0, 0, 0.6),
    this.bgGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xfff7f7f8), Color(0xffe9eaed)],
      stops: [0, 1],
    ),
    this.borderTop = const Effect(
      sigmaX: 0,
      sigmaY: -1,
      color: Color(0xffdbdde1),
      blur: 0,
      alpha: 1,
    ),
    this.borderBottom = const Effect(
      sigmaX: 0,
      sigmaY: 1,
      color: Color(0xffdbdde1),
      blur: 0,
      alpha: 1,
    ),
    this.shadowIconButton = const Effect(
      sigmaX: 0,
      sigmaY: 2,
      color: Color(0xff000000),
      blur: 4,
      alpha: 0.25,
    ),
    this.modalShadow = const Effect(
      sigmaX: 0,
      sigmaY: 0,
      color: Color(0xff000000),
      blur: 4,
      alpha: 0.6,
    ),
  }) : brightness = Brightness.light;

  /// Creates a dark mode [StreamColorTheme] using design system values.
  const StreamColorTheme.dark({
    this.textHighEmphasis = const Color(0xffffffff),
    this.textLowEmphasis = const Color(0xff72767e),
    this.disabled = const Color(0xff4c525c),
    this.borders = const Color(0xff272a30),
    this.inputBg = const Color(0xff1c1e22),
    this.appBg = const Color(0xff000000),
    this.barsBg = const Color(0xff121416),
    this.linkBg = const Color(0xff00193d),
    this.accentPrimary = const Color(0xff337eff),
    this.accentError = const Color(0xffff3742),
    this.accentInfo = const Color(0xff20e070),
    this.highlight = const Color(0xff302d22),
    this.overlay = const Color.fromRGBO(0, 0, 0, 0.4),
    this.overlayDark = const Color.fromRGBO(255, 255, 255, 0.6),
    this.bgGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xff101214), Color(0xff070a0d)],
      stops: [0, 1],
    ),
    this.borderTop = const Effect(
      sigmaX: 0,
      sigmaY: -1,
      color: Color(0xff272a30),
      blur: 0,
      alpha: 1,
    ),
    this.borderBottom = const Effect(
      sigmaX: 0,
      sigmaY: 1,
      color: Color(0xff272a30),
      blur: 0,
      alpha: 1,
    ),
    this.shadowIconButton = const Effect(
      sigmaX: 0,
      sigmaY: 2,
      color: Color(0xff000000),
      blur: 4,
      alpha: 0.5,
    ),
    this.modalShadow = const Effect(
      sigmaX: 0,
      sigmaY: 0,
      color: Color(0xff000000),
      blur: 8,
      alpha: 1,
    ),
  }) : brightness = Brightness.dark;

  /// Main body text or primary icons.
  final Color textHighEmphasis;

  /// Secondary or less prominent text/icons.
  final Color textLowEmphasis;

  /// Disabled UI elements (icons, inputs).
  final Color disabled;

  /// Standard UI borders and dividers.
  final Color borders;

  /// Background for input fields.
  final Color inputBg;

  /// Main app background.
  final Color appBg;

  /// Bars: headers, footers, and toolbars.
  final Color barsBg;

  /// Background for links and link cards.
  final Color linkBg;

  /// Primary action color (buttons, active states).
  final Color accentPrimary;

  /// Error color (alerts, badges).
  final Color accentError;

  /// Informational highlights (e.g., status).
  final Color accentInfo;

  /// Highlighted rows, pinned messages.
  final Color highlight;

  /// General translucent overlay for modals, sheets.
  final Color overlay;

  /// Overlay for dark mode interactions or highlight effects.
  final Color overlayDark;

  /// Background gradient for section headers.
  final Gradient bgGradient;

  /// Theme brightness indicator.
  final Brightness brightness;

  /// Top border effect (for elevation).
  final Effect borderTop;

  /// Bottom border effect.
  final Effect borderBottom;

  /// Icon button drop shadow effect.
  final Effect shadowIconButton;

  /// Modal shadow effect.
  final Effect modalShadow;

  /// Returns a new [StreamColorTheme] by overriding selected fields.
  StreamColorTheme copyWith({
    Brightness? brightness,
    Color? textHighEmphasis,
    Color? textLowEmphasis,
    Color? disabled,
    Color? borders,
    Color? inputBg,
    Color? appBg,
    Color? barsBg,
    Color? linkBg,
    Color? accentPrimary,
    Color? accentError,
    Color? accentInfo,
    Color? highlight,
    Color? overlay,
    Color? overlayDark,
    Gradient? bgGradient,
    Effect? borderTop,
    Effect? borderBottom,
    Effect? shadowIconButton,
    Effect? modalShadow,
  }) {
    return (brightness ?? this.brightness) == Brightness.light
        ? StreamColorTheme.light(
            textHighEmphasis: textHighEmphasis ?? this.textHighEmphasis,
            textLowEmphasis: textLowEmphasis ?? this.textLowEmphasis,
            disabled: disabled ?? this.disabled,
            borders: borders ?? this.borders,
            inputBg: inputBg ?? this.inputBg,
            appBg: appBg ?? this.appBg,
            barsBg: barsBg ?? this.barsBg,
            linkBg: linkBg ?? this.linkBg,
            accentPrimary: accentPrimary ?? this.accentPrimary,
            accentError: accentError ?? this.accentError,
            accentInfo: accentInfo ?? this.accentInfo,
            highlight: highlight ?? this.highlight,
            overlay: overlay ?? this.overlay,
            overlayDark: overlayDark ?? this.overlayDark,
            bgGradient: bgGradient ?? this.bgGradient,
            borderTop: borderTop ?? this.borderTop,
            borderBottom: borderBottom ?? this.borderBottom,
            shadowIconButton: shadowIconButton ?? this.shadowIconButton,
            modalShadow: modalShadow ?? this.modalShadow,
          )
        : StreamColorTheme.dark(
            textHighEmphasis: textHighEmphasis ?? this.textHighEmphasis,
            textLowEmphasis: textLowEmphasis ?? this.textLowEmphasis,
            disabled: disabled ?? this.disabled,
            borders: borders ?? this.borders,
            inputBg: inputBg ?? this.inputBg,
            appBg: appBg ?? this.appBg,
            barsBg: barsBg ?? this.barsBg,
            linkBg: linkBg ?? this.linkBg,
            accentPrimary: accentPrimary ?? this.accentPrimary,
            accentError: accentError ?? this.accentError,
            accentInfo: accentInfo ?? this.accentInfo,
            highlight: highlight ?? this.highlight,
            overlay: overlay ?? this.overlay,
            overlayDark: overlayDark ?? this.overlayDark,
            bgGradient: bgGradient ?? this.bgGradient,
            borderTop: borderTop ?? this.borderTop,
            borderBottom: borderBottom ?? this.borderBottom,
            shadowIconButton: shadowIconButton ?? this.shadowIconButton,
            modalShadow: modalShadow ?? this.modalShadow,
          );
  }

  /// Merges this theme with [other], replacing any fields that [other] defines.
  StreamColorTheme merge(StreamColorTheme? other) {
    if (other == null) return this;
    return copyWith(
      textHighEmphasis: other.textHighEmphasis,
      textLowEmphasis: other.textLowEmphasis,
      disabled: other.disabled,
      borders: other.borders,
      inputBg: other.inputBg,
      appBg: other.appBg,
      barsBg: other.barsBg,
      linkBg: other.linkBg,
      accentPrimary: other.accentPrimary,
      accentError: other.accentError,
      accentInfo: other.accentInfo,
      highlight: other.highlight,
      overlay: other.overlay,
      overlayDark: other.overlayDark,
      bgGradient: other.bgGradient,
      borderTop: other.borderTop,
      borderBottom: other.borderBottom,
      shadowIconButton: other.shadowIconButton,
      modalShadow: other.modalShadow,
    );
  }
}

/// Visual effect such as blur or shadow used by the theme.
class Effect {
  /// Creates an [Effect] instance.
  const Effect({
    this.sigmaX,
    this.sigmaY,
    this.color,
    this.alpha,
    this.blur,
  });

  /// Horizontal shadow offset.
  final double? sigmaX;

  /// Vertical shadow offset.
  final double? sigmaY;

  /// Color of the shadow or border.
  final Color? color;

  /// Opacity (0–1) of the effect.
  final double? alpha;

  /// Blur radius.
  final double? blur;

  /// Returns a copy with updated fields.
  Effect copyWith({
    double? sigmaX,
    double? sigmaY,
    Color? color,
    double? alpha,
    double? blur,
  }) {
    return Effect(
      sigmaX: sigmaX ?? this.sigmaX,
      sigmaY: sigmaY ?? this.sigmaY,
      color: color ?? this.color,
      alpha: alpha ?? this.alpha,
      blur: blur ?? this.blur,
    );
  }
}
