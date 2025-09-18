import 'dart:async';
import 'dart:io';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final isRunningInCi = Platform.environment.containsKey('CI') ||
      Platform.environment.containsKey('GITHUB_ACTIONS');

  return AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      platformGoldensConfig: PlatformGoldensConfig(
        enabled: !isRunningInCi,
      ),
      goldenTestTheme: GoldenTestTheme(
        backgroundColor: const Color(0xFFF8F9FA), // Light neutral background
        borderColor: const Color(0xFFE9ECEF), // Subtle border
        nameTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF343A40), // Dark text for good contrast
        ),
        padding: const EdgeInsets.all(16), // More generous padding
      ),
    ),
    run: testMain,
  );
}
