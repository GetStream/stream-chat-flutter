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

  // Load the platform emoji font so emoji glyphs render in golden screenshots
  // instead of appearing as boxes. System fonts are not in the asset manifest
  // and therefore not picked up by loadFonts(); they must be loaded explicitly.
  await _loadEmojiFont();

  // Load San Francisco on macOS so Material's iOS typography renders
  // authentically. On Linux CI the file is absent and the obscured-text CI
  // variant replaces every glyph with Ahem regardless, so a missing font
  // there is fine.
  await _loadAppleSystemFont();

  final isRunningInCi = Platform.environment.containsKey('CI') || Platform.environment.containsKey('GITHUB_ACTIONS');

  return AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      goldenTestTheme: GoldenTestTheme(
        backgroundColor: Colors.transparent,
        borderColor: Colors.transparent,
        nameTextStyle: const TextStyle(fontSize: 18),
      ),
      ciGoldensConfig: CiGoldensConfig(enabled: isRunningInCi),
      platformGoldensConfig: PlatformGoldensConfig(enabled: !isRunningInCi),
    ),
    run: testMain,
  );
}

/// Loads the platform's color emoji font into the Flutter test renderer.
///
/// [DefaultStreamEmoji] sets `fontFamilyFallback` to platform emoji font names
/// (e.g. 'Apple Color Emoji'), but the Flutter test renderer only knows about
/// fonts loaded via [FontLoader] — system fonts are invisible to it. Without
/// this, every emoji glyph renders as a tofu box.
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
/// `CupertinoSystemText` (body). On a real device those resolve via the
/// platform; in tests we have to wire them ourselves or text falls back to
/// Ahem. Skipped on non-macOS hosts — the CI variant obscures text anyway.
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
