import 'package:flutter_test/flutter_test.dart';

import 'robots/user_robot_message_list_asserts.dart';
import 'support/step.dart';
import 'support/stream_test_case.dart';

void main() {
  const sampleText = 'Test';

  streamTestWithEnv(
    allureId: '11188',
    description: 'message list updates when the user sends a message',
    body: (env) async {
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
    },
  );
}
