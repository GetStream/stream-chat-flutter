import 'dart:async';
import 'dart:io';

import 'package:alchemist/alchemist.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final isRunningInCi = Platform.environment.containsKey('CI') || Platform.environment.containsKey('GITHUB_ACTIONS');

  return AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      platformGoldensConfig: PlatformGoldensConfig(
        enabled: !isRunningInCi,
      ),
    ),
    run: testMain,
  );
}
