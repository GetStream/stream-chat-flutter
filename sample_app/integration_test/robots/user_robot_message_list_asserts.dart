import 'package:flutter_test/flutter_test.dart';

import '../mock_server/data_types.dart';
import '../support/widget_test_extensions.dart';
import 'user_robot.dart';

extension UserRobotMessageListAsserts on UserRobot {
  Future<UserRobot> assertMessage(String text) async {
    await tester.waitUntilVisible(find.text(text));
    return this;
  }

  Future<UserRobot> assertReaction({
    required ReactionType type,
    required bool isDisplayed,
  }) async {
    // Reaction display chips carry no keys, so they're located by emoji glyph.
    final reaction = find.text(type.emoji);
    if (isDisplayed) {
      await tester.waitUntilVisible(reaction);
    } else {
      await tester.waitUntilNotVisible(reaction);
    }
    return this;
  }
}

/// Chainable counterparts to [UserRobotMessageListAsserts], so an assertion can
/// follow a fluent action chain (`userRobot.addReaction(x).assertReaction(...)`).
extension UserRobotMessageListAssertsChain on Future<UserRobot> {
  Future<UserRobot> assertMessage(String text) async => (await this).assertMessage(text);

  Future<UserRobot> assertReaction({
    required ReactionType type,
    required bool isDisplayed,
  }) async => (await this).assertReaction(type: type, isDisplayed: isDisplayed);
}
