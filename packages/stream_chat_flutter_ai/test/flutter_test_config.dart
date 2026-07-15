import 'dart:async';
import 'dart:io';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Real monospace font files to try, in order, when registering the
/// `monospace` family for golden tests. Only consulted on macOS, where
/// `platformGoldensConfig` renders real (non-obscured) text — CI goldens
/// obscure all text regardless of font, so this doesn't matter there.
const _kSystemMonospaceFontPaths = [
  '/System/Library/Fonts/SFNSMono.ttf',
  '/System/Library/Fonts/Supplemental/Courier New.ttf',
];

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final isRunningInCi = Platform.environment.containsKey('CI') || Platform.environment.containsKey('GITHUB_ACTIONS');

  TestWidgetsFlutterBinding.ensureInitialized();
  if (!isRunningInCi) await _loadSystemMonospaceFont();

  return AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      ciGoldensConfig: CiGoldensConfig(enabled: isRunningInCi),
      platformGoldensConfig: PlatformGoldensConfig(enabled: !isRunningInCi),
    ),
    run: testMain,
  );
}

/// Registers a real monospace font under the `monospace` family name, which
/// `CodeBlockView` uses via `fontFamily: 'monospace'`.
///
/// Flutter resolves that generic family name to a real font in an actual app
/// run (via the platform's own font fallback), but `flutter test`'s font
/// resolution doesn't perform that same fallback for an unregistered family —
/// so, without this, `monospace` text renders as missing-glyph placeholder
/// boxes in golden tests even though the widget renders correctly on-device.
Future<void> _loadSystemMonospaceFont() async {
  for (final path in _kSystemMonospaceFontPaths) {
    final file = File(path);
    if (!file.existsSync()) continue;
    final bytes = await file.readAsBytes();
    final loader = FontLoader('monospace')..addFont(Future.value(ByteData.view(bytes.buffer)));
    await loader.load();
    return;
  }
}
