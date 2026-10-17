import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'shadcn_stream_icons.dart';

/// shadcn's bundled Geist font.
const shadcnFontFamily = 'packages/shadcn_ui/Geist';

/// The shadcn zinc color scheme for [brightness].
ShadColorScheme shadcnColorScheme(Brightness brightness) {
  return switch (brightness) {
    .light => const ShadZincColorScheme.light(),
    .dark => const ShadZincColorScheme.dark(),
  };
}

/// The [ShadThemeData] the `shadcn_ui` controls read; it must sit above them
/// in a [ShadTheme].
ShadThemeData shadcnThemeData(Brightness brightness) {
  return ShadThemeData(brightness: brightness, colorScheme: shadcnColorScheme(brightness));
}

/// A [StreamTheme] that recolors the SDK with shadcn's monochrome zinc
/// palette: near-black accents, hairline zinc borders, the Geist font and
/// 6px corners.
StreamTheme shadcnStreamTheme({
  required Brightness brightness,
  required StreamSurfaceStyle surfaceStyle,
}) {
  final shad = shadcnColorScheme(brightness);
  final colorScheme = switch (brightness) {
    .light => StreamColorScheme.light(
      brand: StreamColorSwatch.fromColor(shad.primary, chroma: 0),
      chrome: StreamColorSwatch.fromColor(shad.mutedForeground, chroma: 2),
      accentPrimary: shad.primary,
      accentError: shad.destructive,
      textPrimary: shad.foreground,
      textSecondary: shad.mutedForeground,
      textOnAccent: shad.primaryForeground,
      textLink: shad.foreground,
      backgroundApp: shad.background,
      backgroundElevation0: shad.background,
      backgroundElevation1: shad.card,
      backgroundSurfaceSubtle: shad.muted,
      backgroundSurfaceCard: shad.card,
      borderDefault: shad.border,
      borderSubtle: shad.border,
      borderFocus: shad.ring,
    ),
    .dark => StreamColorScheme.dark(
      brand: StreamColorSwatch.fromColor(shad.primary, brightness: Brightness.dark, chroma: 0),
      chrome: StreamColorSwatch.fromColor(shad.mutedForeground, brightness: Brightness.dark, chroma: 2),
      accentPrimary: shad.primary,
      accentError: shad.destructive,
      textPrimary: shad.foreground,
      textSecondary: shad.mutedForeground,
      textOnAccent: shad.primaryForeground,
      textLink: shad.foreground,
      backgroundApp: shad.background,
      backgroundElevation0: shad.background,
      backgroundElevation1: shad.card,
      backgroundSurfaceSubtle: shad.muted,
      backgroundSurfaceCard: shad.card,
      borderDefault: shad.border,
      borderSubtle: shad.border,
      borderFocus: shad.ring,
    ),
  };

  return StreamTheme(
    brightness: brightness,
    surfaceStyle: surfaceStyle,
    icons: shadcnStreamIcons,
    colorScheme: colorScheme,
    textTheme: StreamTextTheme().apply(color: colorScheme.textPrimary, fontFamily: shadcnFontFamily),
    radius: const StreamRadius(
      xxs: Radius.circular(4),
      xs: Radius.circular(6),
      sm: Radius.circular(6),
      md: Radius.circular(6),
      lg: Radius.circular(8),
      xl: Radius.circular(10),
      xxl: Radius.circular(12),
      xxxl: Radius.circular(12),
      xxxxl: Radius.circular(12),
    ),
  );
}

/// The Material [ThemeData] for the shadcn design, carrying
/// [shadcnStreamTheme] as an extension.
ThemeData shadcnMaterialTheme({
  required Brightness brightness,
  required StreamSurfaceStyle surfaceStyle,
}) {
  final shad = shadcnColorScheme(brightness);
  return ThemeData(
    brightness: brightness,
    fontFamily: shadcnFontFamily,
    scaffoldBackgroundColor: shad.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: shad.primary,
      brightness: brightness,
      primary: shad.primary,
      onPrimary: shad.primaryForeground,
      surface: shad.background,
      error: shad.destructive,
    ),
    extensions: [shadcnStreamTheme(brightness: brightness, surfaceStyle: surfaceStyle)],
  );
}
