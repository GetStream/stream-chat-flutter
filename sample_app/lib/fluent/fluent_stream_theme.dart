import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'fluent_stream_icons.dart';

/// The Windows 11 accent blue in light mode.
const fluentAccentLight = Color(0xFF005FB8);

/// The Windows 11 accent blue in dark mode.
const fluentAccentDark = Color(0xFF60CDFF);

/// The Windows 11 UI font; the fallbacks cover platforms without it.
const fluentFontFamily = 'Segoe UI Variable';
const fluentFontFamilyFallback = ['Segoe UI', 'SF Pro Text', 'Roboto'];

/// A [StreamTheme] that recolors the SDK with the Windows 11 Fluent palette:
/// the mica app background, layered card surfaces, hairline strokes and the
/// 4px control / 8px window corners.
StreamTheme fluentStreamTheme({
  required Brightness brightness,
  required StreamSurfaceStyle surfaceStyle,
}) {
  final colorScheme = switch (brightness) {
    .light => StreamColorScheme.light(
      brand: StreamColorSwatch.fromColor(fluentAccentLight),
      accentPrimary: fluentAccentLight,
      accentSuccess: const Color(0xFF0F7B0F),
      accentWarning: const Color(0xFF9D5D00),
      accentError: const Color(0xFFC42B1C),
      textLink: fluentAccentLight,
      textPrimary: const Color(0xE4000000),
      textSecondary: const Color(0x9E000000),
      backgroundApp: const Color(0xFFF3F3F3),
      backgroundElevation0: const Color(0xFFF3F3F3),
      backgroundElevation1: const Color(0xFFFBFBFB),
      backgroundSurfaceCard: const Color(0xFFFFFFFF),
      borderDefault: const Color(0xFFE5E5E5),
      borderSubtle: const Color(0x0F000000),
    ),
    .dark => StreamColorScheme.dark(
      brand: StreamColorSwatch.fromColor(fluentAccentDark, brightness: Brightness.dark),
      accentPrimary: fluentAccentDark,
      accentSuccess: const Color(0xFF6CCB5F),
      accentWarning: const Color(0xFFFCE100),
      accentError: const Color(0xFFFF99A4),
      textLink: fluentAccentDark,
      textOnAccent: Colors.black,
      backgroundApp: const Color(0xFF202020),
      backgroundElevation0: const Color(0xFF202020),
      backgroundElevation1: const Color(0xFF2B2B2B),
      backgroundSurfaceCard: const Color(0xFF2D2D2D),
      borderDefault: const Color(0x12FFFFFF),
      borderSubtle: const Color(0x0FFFFFFF),
    ),
  };

  return StreamTheme(
    brightness: brightness,
    surfaceStyle: surfaceStyle,
    icons: fluentStreamIcons,
    colorScheme: colorScheme,
    textTheme: StreamTextTheme().apply(
      color: colorScheme.textPrimary,
      fontFamily: fluentFontFamily,
      fontFamilyFallback: fluentFontFamilyFallback,
    ),
    radius: const StreamRadius(
      xxs: Radius.circular(2),
      xs: Radius.circular(4),
      sm: Radius.circular(4),
      md: Radius.circular(4),
      lg: Radius.circular(8),
      xl: Radius.circular(8),
      xxl: Radius.circular(8),
      xxxl: Radius.circular(8),
      xxxxl: Radius.circular(8),
    ),
  );
}

/// The Material [ThemeData] for the Fluent design, carrying
/// [fluentStreamTheme] as an extension.
ThemeData fluentMaterialTheme({
  required Brightness brightness,
  required StreamSurfaceStyle surfaceStyle,
}) {
  final accent = brightness == .light ? fluentAccentLight : fluentAccentDark;
  return ThemeData(
    brightness: brightness,
    fontFamily: fluentFontFamily,
    fontFamilyFallback: fluentFontFamilyFallback,
    colorScheme: ColorScheme.fromSeed(seedColor: accent, primary: accent, brightness: brightness),
    extensions: [fluentStreamTheme(brightness: brightness, surfaceStyle: surfaceStyle)],
  );
}

/// The [fluent.FluentThemeData] the `fluent_ui` controls read; it must sit
/// above them in a [fluent.FluentTheme].
fluent.FluentThemeData fluentThemeData(Brightness brightness) {
  return fluent.FluentThemeData(
    brightness: brightness,
    accentColor: fluent.Colors.blue,
    fontFamily: fluentFontFamily,
    visualDensity: VisualDensity.standard,
  );
}
