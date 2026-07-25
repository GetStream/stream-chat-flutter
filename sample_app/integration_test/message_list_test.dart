import 'robots/user_robot.dart';
import 'robots/user_robot_message_list_asserts.dart';
import 'support/step.dart';
import 'support/stream_test_case.dart';

void main() {
  const sampleText = 'Test';

  streamTestWithEnv(
    allureId: '11188',
    description: 'message list updates when the user sends a message',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the participant sends a message');
      await env.participantRobot.sendMessage(sampleText);

      step('THEN the message is displayed');
      await env.userRobot.assertMessage(sampleText);
    },
  );
}
