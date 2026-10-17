import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'liquid_glass_stream_icons.dart';

/// The iOS system blue, used as the brand accent in light mode.
const liquidGlassBlueLight = Color(0xFF007AFF);

/// The iOS system blue, used as the brand accent in dark mode.
const liquidGlassBlueDark = Color(0xFF0A84FF);

/// A [StreamTheme] with iOS system colors for the liquid glass design.
///
/// The glass itself comes from the component builders; this only aligns the
/// palette and the rounder iOS 26 corners.
StreamTheme liquidGlassStreamTheme({
  required Brightness brightness,
  required StreamSurfaceStyle surfaceStyle,
}) {
  final colorScheme = switch (brightness) {
    .light => StreamColorScheme.light(
      brand: StreamColorSwatch.fromColor(liquidGlassBlueLight),
      accentPrimary: liquidGlassBlueLight,
      accentSuccess: const Color(0xFF34C759),
      accentWarning: const Color(0xFFFF9500),
      accentError: const Color(0xFFFF3B30),
      textLink: liquidGlassBlueLight,
      backgroundApp: const Color(0xFFF2F2F7),
    ),
    .dark => StreamColorScheme.dark(
      brand: StreamColorSwatch.fromColor(liquidGlassBlueDark, brightness: Brightness.dark),
      accentPrimary: liquidGlassBlueDark,
      accentSuccess: const Color(0xFF30D158),
      accentWarning: const Color(0xFFFF9F0A),
      accentError: const Color(0xFFFF453A),
      textLink: liquidGlassBlueDark,
    ),
  };

  return StreamTheme(
    brightness: brightness,
    surfaceStyle: surfaceStyle,
    icons: liquidGlassStreamIcons,
    colorScheme: colorScheme,
  );
}

/// The Material [ThemeData] for the liquid glass design, carrying
/// [liquidGlassStreamTheme] as an extension.
ThemeData liquidGlassMaterialTheme({
  required Brightness brightness,
  required StreamSurfaceStyle surfaceStyle,
}) {
  final accent = brightness == .light ? liquidGlassBlueLight : liquidGlassBlueDark;
  return ThemeData(
    brightness: brightness,
    colorScheme: ColorScheme.fromSeed(seedColor: accent, primary: accent, brightness: brightness),
    extensions: [liquidGlassStreamTheme(brightness: brightness, surfaceStyle: surfaceStyle)],
  );
}
