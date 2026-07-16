import 'package:flutter_test/flutter_test.dart';

import '../support/widget_test_extensions.dart';
import 'user_robot.dart';

extension UserRobotMessageListAsserts on UserRobot {
  Future<UserRobot> assertMessage(String text) async {
    await tester.waitUntilVisible(find.text(text));
    return this;
  }
}
