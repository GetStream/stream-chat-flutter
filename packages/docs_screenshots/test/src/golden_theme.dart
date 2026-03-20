import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Material theme for documentation goldens.
///
/// Subtitle previews use [DefaultTextStyle] + [Text.rich]; stream design tokens
/// often omit [TextStyle.fontFamily]. For reliable glyphs, [loadAppFonts] must
/// match a concrete family — M3 + explicit [fontFamily] pins **Roboto**.
ThemeData docsScreenshotsTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    extensions: [StreamTheme.light()],
  );
}
