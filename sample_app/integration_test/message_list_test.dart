import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import 'robots/user_robot_message_list_asserts.dart';
import 'support/step.dart';
import 'support/stream_test_env.dart';

void main() {
  const sampleText = 'Test';

  patrolTest('message list updates when the user sends a message', ($) async {
    final env = StreamTestEnv();
    await env.setUp($);
    addTearDown(env.tearDown);

    await step('GIVEN the user opens a channel', () async {
      await env.backendRobot.generateChannels(channelsCount: 1);
      await env.userRobot.login();
      await env.userRobot.openChannel();
    });

    await step('WHEN the user sends a message', () async {
      await env.userRobot.sendMessage(sampleText);
    });

    await step('THEN the message is displayed', () async {
      await env.userRobot.assertMessage(sampleText);
    });
  });
}
