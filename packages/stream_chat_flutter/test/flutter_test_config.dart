import 'dart:async';
import 'dart:io';

import 'package:alchemist/alchemist.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final isRunningInCi = const bool.fromEnvironment('CI') ||
      Platform.environment.containsKey('CI') ||
      Platform.environment.containsKey('GITHUB_ACTIONS');

  print('Running in CI: $isRunningInCi');

  return AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      platformGoldensConfig: PlatformGoldensConfig(
        // ignore: avoid_redundant_argument_values
        enabled: !isRunningInCi,
      ),
    ),
    run: testMain,
  );
}
