import 'package:flutter/material.dart';

/// Theme that holds colors
class ColorTheme {
  /// Initialise with light theme
  ColorTheme.light({
    this.textHighEmphasis = const Color(0xff000000),
    this.textLowEmphasis = const Color(0xff7a7a7a),
    this.disabled = const Color(0xffdbdbdb),
    this.borders = const Color(0xffecebeb),
    this.inputBg = const Color(0xfff2f2f2),
    this.appBg = const Color(0xfffcfcfc),
    this.barsBg = const Color(0xffffffff),
    this.linkBg = const Color(0xffe9f2ff),
    this.accentPrimary = const Color(0xff005FFF),
    this.accentError = const Color(0xffFF3842),
    this.accentInfo = const Color(0xff20E070),
    this.highlight = const Color(0xfffbf4dd),
    this.overlay = const Color.fromRGBO(0, 0, 0, 0.2),
    this.overlayDark = const Color.fromRGBO(0, 0, 0, 0.6),
    this.bgGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xfff7f7f7), Color(0xfffcfcfc)],
      stops: [0, 1],
    ),
    this.borderTop = const Effect(
      sigmaX: 0,
      sigmaY: -1,
      color: Color(0xff000000),
      blur: 0,
      alpha: 0.08,
    ),
    this.borderBottom = const Effect(
      sigmaX: 0,
      sigmaY: 1,
      color: Color(0xff000000),
      blur: 0,
      alpha: 0.08,
    ),
    this.shadowIconButton = const Effect(
      sigmaX: 0,
      sigmaY: 2,
      color: Color(0xff000000),
      alpha: 0.5,
      blur: 4,
    ),
    this.modalShadow = const Effect(
      sigmaX: 0,
      sigmaY: 0,
      color: Color(0xff000000),
      alpha: 1,
      blur: 8,
    ),
  }) : brightness = Brightness.light;

  /// Initialise with dark theme
  ColorTheme.dark({
    this.textHighEmphasis = const Color(0xffffffff),
    this.textLowEmphasis = const Color(0xff7a7a7a),
    this.disabled = const Color(0xff2d2f2f),
    this.borders = const Color(0xff1c1e22),
    this.inputBg = const Color(0xff13151b),
    this.appBg = const Color(0xff070A0D),
    this.barsBg = const Color(0xff101418),
    this.linkBg = const Color(0xff00193D),
    this.accentPrimary = const Color(0xff005FFF),
    this.accentError = const Color(0xffFF3742),
    this.accentInfo = const Color(0xff20E070),
    this.borderTop = const Effect(
      sigmaX: 0,
      sigmaY: -1,
      color: Color(0xff141924),
      blur: 0,
    ),
    this.borderBottom = const Effect(
      sigmaX: 0,
      sigmaY: 1,
      color: Color(0xff141924),
      blur: 0,
      alpha: 1,
    ),
    this.shadowIconButton = const Effect(
      sigmaX: 0,
      sigmaY: 2,
      color: Color(0xff000000),
      alpha: 0.5,
      blur: 4,
    ),
    this.modalShadow = const Effect(
      sigmaX: 0,
      sigmaY: 0,
      color: Color(0xff000000),
      alpha: 1,
      blur: 8,
    ),
    this.highlight = const Color(0xff302d22),
    this.overlay = const Color.fromRGBO(0, 0, 0, 0.4),
    this.overlayDark = const Color.fromRGBO(255, 255, 255, 0.6),
    this.bgGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xff101214),
        Color(0xff070a0d),
      ],
      stops: [0, 1],
    ),
  }) : brightness = Brightness.dark;

  ///
  final Color textHighEmphasis;

  ///
  final Color textLowEmphasis;

  ///
  final Color disabled;

  ///
  final Color borders;

  ///
  final Color inputBg;

  ///
  final Color appBg;

  ///
  final Color barsBg;

  ///
  final Color linkBg;

  ///
  final Color accentPrimary;

  ///
  final Color accentError;

  ///
  final Color accentInfo;

  ///
  final Effect borderTop;

  ///
  final Effect borderBottom;

  ///
  final Effect shadowIconButton;

  ///
  final Effect modalShadow;

  ///
  final Color highlight;

  ///
  final Color overlay;

  ///
  final Color overlayDark;

  ///
  final Gradient bgGradient;

  ///
  final Brightness brightness;

  /// Copy with theme
  ColorTheme copyWith({
    Brightness brightness = Brightness.light,
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
    Effect? borderTop,
    Effect? borderBottom,
    Effect? shadowIconButton,
    Effect? modalShadow,
    Color? highlight,
    Color? overlay,
    Color? overlayDark,
    Gradient? bgGradient,
  }) =>
      brightness == Brightness.light
          ? ColorTheme.light(
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
              borderTop: borderTop ?? this.borderTop,
              borderBottom: borderBottom ?? this.borderBottom,
              shadowIconButton: shadowIconButton ?? this.shadowIconButton,
              modalShadow: modalShadow ?? this.modalShadow,
              highlight: highlight ?? this.highlight,
              overlay: overlay ?? this.overlay,
              overlayDark: overlayDark ?? this.overlayDark,
              bgGradient: bgGradient ?? this.bgGradient,
            )
          : ColorTheme.dark(
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
              borderTop: borderTop ?? this.borderTop,
              borderBottom: borderBottom ?? this.borderBottom,
              shadowIconButton: shadowIconButton ?? this.shadowIconButton,
              modalShadow: modalShadow ?? this.modalShadow,
              highlight: highlight ?? this.highlight,
              overlay: overlay ?? this.overlay,
              overlayDark: overlayDark ?? this.overlayDark,
              bgGradient: bgGradient ?? this.bgGradient,
            );

  /// Merge color theme
  ColorTheme merge(ColorTheme? other) {
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

/// Effect store
class Effect {
  /// Constructor for creating [Effect]
  const Effect({
    this.sigmaX,
    this.sigmaY,
    this.color,
    this.alpha,
    this.blur,
  });

  ///
  final double? sigmaX;

  ///
  final double? sigmaY;

  ///
  final Color? color;

  ///
  final double? alpha;

  ///
  final double? blur;

  /// Copy with new effect
  Effect copyWith({
    double? sigmaX,
    double? sigmaY,
    Color? color,
    double? alpha,
    double? blur,
  }) =>
      Effect(
        sigmaX: sigmaX ?? this.sigmaX,
        sigmaY: sigmaY ?? this.sigmaY,
        color: color ?? this.color,
        alpha: color as double? ?? this.alpha,
        blur: blur ?? this.blur,
      );
}
