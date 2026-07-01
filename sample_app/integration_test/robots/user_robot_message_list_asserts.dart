import 'user_robot.dart';

extension UserRobotMessageListAsserts on UserRobot {
  Future<UserRobot> assertMessage(String text) async {
    await $(text).waitUntilVisible();
    return this;
  }
}
