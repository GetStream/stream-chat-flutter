import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// ignore: implementation_imports
import 'package:test_api/src/backend/invoker.dart' show Invoker;

import '../allure/allure.dart';
import 'stream_test_env.dart';

void streamTest({
  String? allureId,
  required String description,
  required Future<void> Function(WidgetTester tester) body,
}) {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(description, (tester) async {
    Allure.instance.startTest(
      name: description,
      fullName: Invoker.current?.liveTest.test.name ?? description,
      labels: {if (allureId != null) 'AS_ID': allureId},
    );
    try {
      await body(tester);
      Allure.instance.stopTest(status: AllureStatus.passed);
    } on TestFailure catch (e, st) {
      Allure.instance.stopTest(status: AllureStatus.failed, message: e, trace: st);
      rethrow;
    } catch (e, st) {
      Allure.instance.stopTest(status: AllureStatus.broken, message: e, trace: st);
      rethrow;
    }
  });
}

void streamTestWithEnv({
  String? allureId,
  required String description,
  required Future<void> Function(StreamTestEnv env) body,
}) {
  streamTest(
    allureId: allureId,
    description: description,
    body: (tester) async {
      final env = StreamTestEnv();
      await env.setUp(tester);
      addTearDown(env.tearDown);
      await body(env);
    },
  );
}
