import 'robots/user_robot.dart';
import 'robots/user_robot_message_list_asserts.dart';
import 'support/step.dart';
import 'support/stream_test_case.dart';

void main() {
  const parentMessageText = 'Test';
  const replyText = 'Reply';

  streamTestWithEnv(
    allureId: '12827',
    description: 'thread list is empty when the channel has no threads',
    body: (env) async {
      step('GIVEN the user logs in');
      await env.userRobot.login().waitForChannelListToLoad();

      step('WHEN the user opens the thread list');
      await env.userRobot.openThreadList();

      step('THEN the thread list is empty');
      await env.userRobot.assertThreadListIsEmpty();
    },
  );

  streamTestWithEnv(
    allureId: '12828',
    description: 'thread is shown on the thread list',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a message');
      await env.participantRobot.sendMessage(parentMessageText);
      await env.userRobot.assertMessage(parentMessageText);

      step('AND the user replies to the message in the thread');
      await env.userRobot.openThread().sendMessageInThread(replyText).assertThreadReply(replyText);

      step('WHEN the user opens the thread list');
      await env.userRobot.moveToChannelListFromThread().openThreadList();

      step('THEN the thread is shown with one reply');
      await env.userRobot.assertThreadInThreadList(parentMessageText, replies: 1);
    },
  );

  streamTestWithEnv(
    allureId: '12829',
    description: 'user opens a thread from the thread list',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a message');
      await env.participantRobot.sendMessage(parentMessageText);
      await env.userRobot.assertMessage(parentMessageText);

      step('AND the user replies to the message in the thread');
      await env.userRobot.openThread().sendMessageInThread(replyText).assertThreadReply(replyText);

      step('AND the user opens the thread list');
      await env.userRobot.moveToChannelListFromThread().openThreadList().assertThreadInThreadList(
        parentMessageText,
        replies: 1,
      );

      step('WHEN the user taps the thread');
      await env.userRobot.openThreadFromThreadList();

      step('THEN the thread is opened on the reply');
      await env.userRobot.assertThreadReply(replyText);
    },
  );
}
