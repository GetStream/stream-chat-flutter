import 'dart:async';

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

void streamTest({
  String? allureId,
  required String description,
  required Future<void> Function(WidgetTester tester) body,
  String? skip,
}) {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(description, skip: skip != null, (tester) async {
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
}) {
  streamTest(
    allureId: allureId,
    description: description,
    skip: skip,
    body: (tester) async {
      final env = StreamTestEnv();
      // Registered before setUp so cleanup also runs when setup fails partway
      // (e.g. the mock server started but the app failed to boot).
      addTearDown(env.tearDown);
      await env.setUp(tester);
      await body(env);
    },
  );
}
