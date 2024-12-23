import 'dart:async';
import 'dart:io';

import 'package:alchemist/alchemist.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final env = Platform.environment..forEach((k, v) => print('Key=$k Value=$v'));

  const isRunningInCi = bool.fromEnvironment('GITHUB_ACTIONS');

  print('Running in CI: $isRunningInCi');

  return AlchemistConfig.runWithConfig(
    config: const AlchemistConfig(
      platformGoldensConfig: PlatformGoldensConfig(
        // ignore: avoid_redundant_argument_values
        enabled: !isRunningInCi,
      ),
    ),
    run: testMain,
  );
}
