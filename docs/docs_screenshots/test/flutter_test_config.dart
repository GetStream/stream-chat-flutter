import 'dart:async';
import 'dart:io';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Flutter tests default to the Ahem font unless real fonts are loaded. This loads
  // Material/Cupertino fonts and every family listed in the merged FontManifest
  // (including transitive packages such as stream_core_flutter's Stream Icons).
  await loadFonts();

  // Register host system fonts that loadFonts() can't see because they live
  // outside the asset manifest — currently the platform emoji font (so emoji
  // glyphs render instead of tofu) and macOS's San Francisco (so Material's
  // iOS typography aliases resolve to authentic SF). On hosts where a file is
  // missing the loader is a no-op; CI's obscured-text variant replaces every
  // glyph with Ahem anyway.
  await _loadHostSystemFonts();

  return AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      goldenTestTheme: GoldenTestTheme(
        backgroundColor: Colors.transparent,
        borderColor: Colors.transparent,
        nameTextStyle: const TextStyle(fontSize: 18),
      ),
      // Docs snapshots only ever commit the platform variant (see .gitignore:
      // `!**/goldens/macos/*`). The CI/obscured variant is never inspected
      // and never compared against, so don't waste compute on it — generate
      // platform goldens locally and in CI alike.
      ciGoldensConfig: const CiGoldensConfig(enabled: false),
      platformGoldensConfig: const PlatformGoldensConfig(enabled: true),
    ),
    run: testMain,
  );
}

/// Registers host system fonts that aren't part of any asset manifest.
///
/// Loads the platform color emoji font (so [DefaultStreamEmoji] and inline
/// emoji glyphs can render via the `fontFamilyFallback` chain) and, on macOS
/// only, San Francisco under the family aliases Material's iOS typography
/// expects (`CupertinoSystemDisplay` / `CupertinoSystemText`). Hosts where a
/// font file is missing simply skip that loader.
Future<void> _loadHostSystemFonts() async {
  await _loadEmojiFont();
  await _loadAppleSystemFont();
}

/// Loads the platform's color emoji font into the Flutter test renderer.
Future<void> _loadEmojiFont() async {
  // Each entry: (FontLoader family name, candidate file paths).
  final candidates = [
    (
      'Apple Color Emoji',
      ['/System/Library/Fonts/Apple Color Emoji.ttc'],
    ),
    (
      'Noto Color Emoji',
      [
        '/usr/share/fonts/truetype/noto/NotoColorEmoji.ttf',
        '/usr/share/fonts/noto/NotoColorEmoji.ttf',
      ],
    ),
  ];

  for (final (family, paths) in candidates) {
    for (final path in paths) {
      final file = File(path);
      if (!file.existsSync()) continue;
      final loader = FontLoader(family)..addFont(file.readAsBytes().then(ByteData.sublistView));
      await loader.load();
      return; // Stop after the first font successfully loaded.
    }
  }
}

/// Registers macOS's San Francisco font under the family aliases Material's
/// iOS typography expects: `CupertinoSystemDisplay` (headlines/titles) and
/// `CupertinoSystemText` (body).
Future<void> _loadAppleSystemFont() async {
  if (!Platform.isMacOS) return;
  const path = '/System/Library/Fonts/SFNS.ttf';
  final file = File(path);
  if (!file.existsSync()) return;
  final bytes = await file.readAsBytes();
  for (final family in const ['CupertinoSystemDisplay', 'CupertinoSystemText']) {
    final loader = FontLoader(family)..addFont(Future.value(ByteData.sublistView(bytes)));
    await loader.load();
  }
}
