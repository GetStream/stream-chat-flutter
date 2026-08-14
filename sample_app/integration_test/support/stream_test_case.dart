import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// ignore: implementation_imports
import 'package:test_api/src/backend/invoker.dart' show Invoker;

import '../allure/allure.dart';
import 'failure_artifacts.dart';
import 'stream_test_env.dart';

/// The test file currently running, injected by the Fastlane lane
/// (`--dart-define=E2E_TARGET=...`). Lets the lane attach that file's host-side
/// video recording to its failed tests. Empty when run ad-hoc.
const _e2eTarget = String.fromEnvironment('E2E_TARGET');

/// The platforms the e2e suite runs on.
///
/// Tests are declared inside the app process, so the running platform is known
/// when [streamTest] decides whether to skip.
enum E2ePlatform {
  android,
  ios;

  /// The platform the suite is currently running on, or `null` when it is
  /// neither Android nor iOS (e.g. a host-side run).
  static E2ePlatform? get current => switch (defaultTargetPlatform) {
    TargetPlatform.android => android,
    TargetPlatform.iOS => ios,
    _ => null,
  };
}

/// Whether a test carrying [skip] should be skipped on the running platform.
///
/// [skipPlatforms] narrows a skip to the platforms where the issue reproduces;
/// `null` (the default) skips everywhere.
bool skipsHere(String? skip, Set<E2ePlatform>? skipPlatforms) =>
    skip != null && (skipPlatforms == null || skipPlatforms.contains(E2ePlatform.current));

void streamTest({
  String? allureId,
  required String description,
  required Future<void> Function(WidgetTester tester) body,
  String? skip,
  Set<E2ePlatform>? skipPlatforms,
}) {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(description, skip: skipsHere(skip, skipPlatforms), (tester) async {
    Allure.instance.startTest(
      name: description,
      fullName: Invoker.current?.liveTest.test.name ?? description,
      labels: {
        if (allureId != null) 'AS_ID': allureId,
        if (_e2eTarget.isNotEmpty) 'testFile': _e2eTarget,
      },
    );

    // Capture the test body's output so it can be attached on failure, while
    // still forwarding each line to stdout. Result/attachment markers are
    // printed outside this zone (in stopTest / captureFailureArtifacts), so
    // they never end up in the captured log.
    final previousOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      debugPrint('[flutter-error] $details');
      previousOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = previousOnError);

    final log = StringBuffer();
    Future<void> runBody() => runZoned(
      () async {
        await body(tester);
        final pendingException = tester.binding.takeException();
        if (pendingException != null) throw pendingException;
      },
      zoneSpecification: ZoneSpecification(
        print: (self, parent, zone, line) {
          log.writeln(line);
          parent.print(zone, line);
        },
      ),
    );

    try {
      await runBody();
      Allure.instance.stopTest(status: AllureStatus.passed);
    } on TestFailure catch (e, st) {
      await captureFailureArtifacts(tester, log.toString());
      Allure.instance.stopTest(status: AllureStatus.failed, message: e, trace: st);
      rethrow;
    } catch (e, st) {
      await captureFailureArtifacts(tester, log.toString());
      Allure.instance.stopTest(status: AllureStatus.broken, message: e, trace: st);
      rethrow;
    }
  });
}

void streamTestWithEnv({
  String? allureId,
  required String description,
  required Future<void> Function(StreamTestEnv env) body,
  String? skip,
  Set<E2ePlatform>? skipPlatforms,
  bool persistence = false,
}) {
  streamTest(
    allureId: allureId,
    description: description,
    skip: skip,
    skipPlatforms: skipPlatforms,
    body: (tester) async {
      final env = StreamTestEnv();
      // Registered before setUp so cleanup also runs when setup fails partway
      // (e.g. the mock server started but the app failed to boot).
      addTearDown(env.tearDown);
      await env.setUp(tester, persistence: persistence);
      await body(env);
    },
  );
}
