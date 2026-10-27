import 'robots/user_robot.dart';
import 'robots/user_robot_message_list_asserts.dart';
import 'support/step.dart';
import 'support/stream_test_case.dart';

void main() {
  streamTestWithEnv(
    allureId: '12715',
    description: 'user copies a message',
    body: (env) async {
      // Unique, so a stale value left on the device clipboard can't pass the assert.
      final sampleText = 'Test ${DateTime.now().microsecondsSinceEpoch}';

      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the participant sends a message');
      await env.participantRobot.sendMessage(sampleText);

      step('AND the user copies the message');
      await env.userRobot.assertMessage(sampleText).copyMessage();

      step('THEN the message text is in the clipboard');
      await env.userRobot.assertMessageCopied(sampleText);
    },
  );
}
