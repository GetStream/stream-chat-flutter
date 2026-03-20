import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Flutter tests default to the Ahem font unless real fonts are loaded. This loads
  // Material/Cupertino fonts and every family listed in the merged FontManifest
  // (including transitive packages such as stream_core_flutter's Stream Icons).
  await loadAppFonts();

  return AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      ciGoldensConfig: const CiGoldensConfig(enabled: false),
      platformGoldensConfig: const PlatformGoldensConfig(enabled: true),
    ),
    run: testMain,
  );
}
