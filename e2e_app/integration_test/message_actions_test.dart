import 'package:flutter/services.dart';

import 'robots/user_robot.dart';
import 'robots/user_robot_message_list_asserts.dart';
import 'support/step.dart';
import 'support/stream_test_case.dart';

void main() {
  const sampleText = 'Test';

  streamTestWithEnv(
    allureId: '12715',
    description: 'user copies a message',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the participant sends a message');
      await env.participantRobot.sendMessage(sampleText);

      step('AND the user copies the message');
      // The clipboard outlives the test, so a stale 'Test' would pass the assert.
      await Clipboard.setData(const ClipboardData(text: ''));
      await env.userRobot.assertMessage(sampleText).copyMessage();

      step('THEN the message text is in the clipboard');
      await env.userRobot.assertMessageCopied(sampleText);
    },
  );
}
