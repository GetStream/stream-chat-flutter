import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

// ignore: implementation_imports
import 'package:test_api/src/backend/invoker.dart' show Invoker;

import '../allure/allure.dart';

void streamTest(
  String description,
  Future<void> Function(PatrolIntegrationTester $) callback, {
  String? allureId,
}) {
  patrolTest(description, ($) async {
    Allure.instance.startTest(
      name: description,
      fullName: Invoker.current?.liveTest.test.name ?? description,
      labels: {if (allureId != null) 'AS_ID': allureId},
    );
    try {
      await callback($);
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
