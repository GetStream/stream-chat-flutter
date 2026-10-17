import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:yaru/yaru.dart';

/// Yaru's bundled Ubuntu font.
const yaruFontFamily = 'packages/yaru/Ubuntu';

/// A [StreamTheme] that recolors the SDK with Ubuntu's Yaru palette: the
/// Ubuntu orange accent, warm grey borders and the GTK header bar color.
StreamTheme yaruStreamTheme({
  required Brightness brightness,
  required StreamSurfaceStyle surfaceStyle,
}) {
  final yaruColors = YaruColors.from(brightness);
  final colorScheme = switch (brightness) {
    .light => StreamColorScheme.light(
      brand: StreamColorSwatch.fromColor(YaruColors.orange),
      accentPrimary: YaruColors.orange,
      accentSuccess: yaruColors.success,
      accentWarning: yaruColors.warning,
      accentError: yaruColors.error,
      textLink: yaruColors.link,
      textPrimary: YaruColors.jet,
      backgroundApp: YaruColors.porcelain,
      backgroundElevation0: YaruColors.porcelain,
      borderDefault: const Color(0xFFDEDEDE),
      borderSubtle: const Color(0xFFEBEBEB),
    ),
    .dark => StreamColorScheme.dark(
      brand: StreamColorSwatch.fromColor(YaruColors.orange, brightness: Brightness.dark),
      accentPrimary: YaruColors.orange,
      accentSuccess: yaruColors.success,
      accentWarning: yaruColors.warning,
      accentError: yaruColors.error,
      textLink: yaruColors.link,
      backgroundApp: YaruColors.jet,
      backgroundElevation0: YaruColors.jet,
      backgroundElevation1: const Color(0xFF2B2B2B),
      borderDefault: const Color(0xFF444444),
      borderSubtle: const Color(0xFF363636),
    ),
  };

  return StreamTheme(
    brightness: brightness,
    surfaceStyle: surfaceStyle,
    colorScheme: colorScheme,
    textTheme: StreamTextTheme().apply(color: colorScheme.textPrimary, fontFamily: yaruFontFamily),
    // Yaru controls round to 6px and cards / dialogs to 8-12px.
    radius: const StreamRadius(
      xxs: Radius.circular(4),
      xs: Radius.circular(6),
      sm: Radius.circular(6),
      md: Radius.circular(6),
      lg: Radius.circular(8),
      xl: Radius.circular(12),
      xxl: Radius.circular(12),
      xxxl: Radius.circular(12),
      xxxxl: Radius.circular(12),
    ),
    // The GTK header bar.
    appBarTheme: StreamAppBarThemeData(
      style: StreamAppBarStyle(
        backgroundColor: brightness == .light ? const Color(0xFFEBEBEB) : const Color(0xFF303030),
      ),
    ),
  );
}

/// The Material [ThemeData] for the Yaru design: Yaru's own Material theme
/// (which styles the Material buttons and text fields the component builders
/// use), carrying [yaruStreamTheme] as an extension.
ThemeData yaruMaterialTheme({
  required Brightness brightness,
  required StreamSurfaceStyle surfaceStyle,
}) {
  final base = brightness == .light ? yaruLight : yaruDark;
  return base.copyWith(
    extensions: [yaruStreamTheme(brightness: brightness, surfaceStyle: surfaceStyle)],
  );
}
