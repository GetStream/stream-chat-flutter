import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:xp_dart/xp_dart.dart';

/// The Luna blue used for the title bar, selection, and brand accents.
const xpLunaBlue = Color(0xFF0055E5);

/// The XP selection highlight (list rows, selected items).
const xpSelectionBlue = Color(0xFF316AC5);

/// The red of the XP window close button, used for errors and destructive actions.
const xpCloseRed = Color(0xFFE0412B);

/// The XP "Start" button green, used for success states.
const xpStartGreen = Color(0xFF3C9A2D);

/// The XP UI font, bundled as Wine's Tahoma clone (see `assets/fonts`); the
/// fallbacks only apply to glyphs it doesn't cover.
const xpFontFamily = 'Tahoma';
const xpFontFamilyFallback = ['Verdana', 'Arial', 'Helvetica'];

/// Vertical gradient of the active Luna title bar.
const xpTitleBarGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: XPColors.titleBarGradient,
);

/// A [StreamTheme] that recolors the whole SDK with the Windows XP Luna palette.
///
/// XP had no dark mode, so this is always a light theme.
StreamTheme xpStreamTheme({required StreamSurfaceStyle surfaceStyle}) {
  final colorScheme = StreamColorScheme.light(
    brand: StreamColorSwatch.fromColor(xpLunaBlue),
    chrome: StreamColorSwatch.fromColor(XPColors.surface, chroma: 6),
    // Accent
    accentPrimary: xpLunaBlue,
    accentSuccess: xpStartGreen,
    accentWarning: XPColors.tabHoverTop,
    accentError: xpCloseRed,
    accentNeutral: XPColors.buttonShadow,
    // Text
    textPrimary: XPColors.text,
    textSecondary: const Color(0xFF444444),
    textTertiary: XPColors.textDisabled,
    textDisabled: const Color(0xFFACA899),
    textLink: XPColors.linkBlue,
    textOnAccent: XPColors.buttonHighlight,
    // Background: the beige dialog surface everywhere, white "sunken" fields.
    backgroundApp: XPColors.surface,
    backgroundElevation0: XPColors.surface,
    backgroundElevation1: XPColors.surface,
    backgroundElevation2: const Color(0xFFF1EFE2),
    backgroundElevation3: XPColors.buttonHighlight,
    backgroundSurface: XPColors.buttonHighlight,
    backgroundSurfaceSubtle: const Color(0xFFF5F4EA),
    backgroundSurfaceStrong: XPColors.buttonFace,
    backgroundSurfaceCard: XPColors.buttonHighlight,
    backgroundOnElevation: XPColors.buttonHighlight,
    // The XP tooltip / balloon yellow.
    backgroundHighlight: const Color(0xFFFFFFE1),
    backgroundDisabled: XPColors.buttonFace,
    // Borders
    borderDefault: XPColors.inputBorder,
    borderSubtle: const Color(0xFFACA899),
    borderStrong: XPColors.buttonBorder,
    borderOnSurface: XPColors.inputBorder,
    borderOnElevation: const Color(0xFFACA899),
    borderFocus: xpSelectionBlue,
    borderActive: xpLunaBlue,
    borderSelected: xpSelectionBlue,
    // State
    backgroundHover: xpSelectionBlue.withValues(alpha: 0.12),
    backgroundPressed: xpSelectionBlue.withValues(alpha: 0.24),
    backgroundSelected: const Color(0xFFC1D2EE),
    // Avatars: the classic XP user-picture palette.
    avatarPalette: const [
      StreamAvatarColorPair(backgroundColor: Color(0xFFC1D2EE), foregroundColor: Color(0xFF0A246A)),
      StreamAvatarColorPair(backgroundColor: Color(0xFFCDEBC1), foregroundColor: Color(0xFF1E5A12)),
      StreamAvatarColorPair(backgroundColor: Color(0xFFFFE0B5), foregroundColor: Color(0xFF8A4A00)),
      StreamAvatarColorPair(backgroundColor: Color(0xFFE6D5F0), foregroundColor: Color(0xFF4B1E6E)),
      StreamAvatarColorPair(backgroundColor: Color(0xFFF7D3CC), foregroundColor: Color(0xFF8A1F0E)),
    ],
  );

  return StreamTheme(
    brightness: Brightness.light,
    surfaceStyle: surfaceStyle,
    colorScheme: colorScheme,
    textTheme: StreamTextTheme().apply(
      color: colorScheme.textPrimary,
      fontFamily: xpFontFamily,
      fontFamilyFallback: xpFontFamilyFallback,
    ),
    // XP controls have barely-rounded 3px corners; windows round to 8px.
    radius: const StreamRadius(
      xxs: Radius.circular(2),
      xs: Radius.circular(3),
      sm: Radius.circular(3),
      md: Radius.circular(3),
      lg: Radius.circular(6),
      xl: Radius.circular(8),
      xxl: Radius.circular(8),
      xxxl: Radius.circular(8),
      xxxxl: Radius.circular(8),
    ),
  );
}

/// The Material [ThemeData] for XP mode, carrying [xpStreamTheme] as an extension.
ThemeData xpMaterialTheme({required StreamSurfaceStyle surfaceStyle}) {
  return ThemeData(
    brightness: Brightness.light,
    fontFamily: xpFontFamily,
    fontFamilyFallback: xpFontFamilyFallback,
    scaffoldBackgroundColor: XPColors.surface,
    canvasColor: XPColors.surface,
    colorScheme: ColorScheme.fromSeed(
      seedColor: xpLunaBlue,
      primary: xpLunaBlue,
      surface: XPColors.surface,
      error: xpCloseRed,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: XPColors.text,
      selectionColor: Color(0x66316AC5),
      selectionHandleColor: xpSelectionBlue,
    ),
    extensions: [xpStreamTheme(surfaceStyle: surfaceStyle)],
  );
}
