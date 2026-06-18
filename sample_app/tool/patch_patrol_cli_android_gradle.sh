#!/usr/bin/env bash
# Patches patrol_cli so Android e2e builds run assembleDebug and
# assembleDebugAndroidTest in a single Gradle invocation.
#
# Flutter 3.44's shouldConfigureFlutterTask skips registering
# compileFlutterBuildDebug when only assembleDebugAndroidTest is requested,
# which breaks Patrol's two-step Gradle build on CI.
# See: https://github.com/flutter/flutter/issues/109560
set -euo pipefail

PATROL_VERSION="${PATROL_CLI_VERSION:-$(dart pub global list 2>/dev/null | awk '/^patrol_cli / {print $2; exit}')}"
PATROL_VERSION="${PATROL_VERSION:-4.4.0}"
PUB_CACHE="${PUB_CACHE:-${HOME}/.pub-cache}"

TARGET="${PUB_CACHE}/hosted/pub.dev/patrol_cli-${PATROL_VERSION}/lib/src/android/android_test_backend.dart"

if [[ ! -f "${TARGET}" ]]; then
  echo "patrol_cli source not found at ${TARGET}" >&2
  echo "Run: dart pub global activate patrol_cli" >&2
  exit 1
fi

if grep -q 'combinedInvocation' "${TARGET}"; then
  echo "patrol_cli Android Gradle patch already applied"
else
python3 - "${TARGET}" <<'PY'
import sys

path = sys.argv[1]
text = open(path, encoding="utf-8").read()

old = """      // :app:assembleDebug

      process =
          await _processManager.start(
              options.toGradleAssembleInvocation(
                isWindows: _platform.isWindows,
              ),
              runInShell: true,
              workingDirectory: _rootDirectory.childDirectory('android').path,
              environment: switch (javaPath) {
                final String javaPath => {'JAVA_HOME': javaPath},
                _ => {},
              },
            )
            ..disposedBy(scope);
      process.listenStdOut((l) => _logger.detail('\\t: $l')).disposedBy(scope);
      process.listenStdErr((l) => _logger.err('\\t$l')).disposedBy(scope);
      exitCode = await process.exitCode;
      if (exitCode == exitCodeInterrupted) {
        const cause = 'Gradle build interrupted';
        task.fail('Failed to build $subject ($cause)');
        throw Exception(cause);
      } else if (exitCode != 0) {
        final cause = 'Gradle build failed with code $exitCode';
        task.fail('Failed to build $subject ($cause)');
        throw Exception(cause);
      }

      // :app:assembleDebugAndroidTest

      process =
          await _processManager.start(
              options.toGradleAssembleTestInvocation(
                isWindows: _platform.isWindows,
              ),
              runInShell: true,
              workingDirectory: _rootDirectory.childDirectory('android').path,
              environment: switch (javaPath) {
                final String javaPath => {'JAVA_HOME': javaPath},
                _ => {},
              },
            )
            ..disposedBy(scope);
      process.listenStdOut((l) => _logger.detail('\\t: $l')).disposedBy(scope);
      process.listenStdErr((l) => _logger.err('\\t$l')).disposedBy(scope);

      exitCode = await process.exitCode;
      if (exitCode == 0) {
        task.complete('Completed building $subject');
      } else if (exitCode == exitCodeInterrupted) {
        const cause = 'Gradle build interrupted';
        task.fail('Failed to build $subject ($cause)');
        throw Exception(cause);
      } else {
        final cause = 'Gradle build failed with code $exitCode';
        task.fail('Failed to build $subject ($cause)');
        throw Exception(cause);
      }"""

new = """      // :app:assembleDebug + :app:assembleDebugAndroidTest in one invocation
      // so Flutter registers compileFlutterBuildDebug (Flutter 3.44+).
      // Patched by sample_app/tool/patch_patrol_cli_android_gradle.sh

      final assembleInvocation = options.toGradleAssembleInvocation(
        isWindows: _platform.isWindows,
      );
      final testInvocation = options.toGradleAssembleTestInvocation(
        isWindows: _platform.isWindows,
      );
      final combinedInvocation = <String>[
        testInvocation.first,
        assembleInvocation[1],
        testInvocation[1],
        ...testInvocation.skip(2),
      ];

      process =
          await _processManager.start(
              combinedInvocation,
              runInShell: true,
              workingDirectory: _rootDirectory.childDirectory('android').path,
              environment: switch (javaPath) {
                final String javaPath => {'JAVA_HOME': javaPath},
                _ => {},
              },
            )
            ..disposedBy(scope);
      process.listenStdOut((l) => _logger.detail('\\t: $l')).disposedBy(scope);
      process.listenStdErr((l) => _logger.err('\\t$l')).disposedBy(scope);

      exitCode = await process.exitCode;
      if (exitCode == 0) {
        task.complete('Completed building $subject');
      } else if (exitCode == exitCodeInterrupted) {
        const cause = 'Gradle build interrupted';
        task.fail('Failed to build $subject ($cause)');
        throw Exception(cause);
      } else {
        final cause = 'Gradle build failed with code $exitCode';
        task.fail('Failed to build $subject ($cause)');
        throw Exception(cause);
      }"""

if old not in text:
    print("patrol_cli android_test_backend.dart changed; patch no longer applies", file=sys.stderr)
    sys.exit(1)

open(path, "w", encoding="utf-8").write(text.replace(old, new, 1))
print(f"Patched {path}")
PY
fi

# Drop the precompiled snapshot so `patrol` runs from the patched sources.
rm -f "${PUB_CACHE}/global_packages/patrol_cli/bin/"*.snapshot 2>/dev/null || true
