import 'robots/user_robot.dart';
import 'robots/user_robot_channel_list_asserts.dart';
import 'robots/user_robot_message_list_asserts.dart';
import 'support/step.dart';
import 'support/stream_test_case.dart';

void main() {
  const firstMessage = 'message';
  const draftMessage = 'alright';

  streamTestWithEnv(
    description: 'user updates a channel draft message',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the user sends a message');
      await env.userRobot.sendMessage(firstMessage).assertMessage(firstMessage);

      step('WHEN the user inputs some text in the composer');
      await env.userRobot.typeText(draftMessage);

      step('AND the user leaves the channel');
      await env.userRobot.tapBackButton();

      step('THEN the draft message is in the channel preview');
      await env.userRobot.assertMessageInChannelPreview('Draft: $draftMessage');

      step('WHEN the user comes back to the channel');
      await env.userRobot.openChannel();

      step('THEN the draft message is in the composer');
      await env.userRobot.assertComposerText(draftMessage);

      step('WHEN the user deletes the draft message');
      await env.userRobot.clearComposer();

      step('AND the user leaves the channel');
      await env.userRobot.tapBackButton();

      step('THEN there is no draft message in the channel preview');
      await env.userRobot.assertMessageInChannelPreview(firstMessage, fromCurrentUser: true);

      step('WHEN the user comes back to the channel');
      await env.userRobot.openChannel();

      step('THEN there is no draft message in the composer');
      await env.userRobot.assertComposerText('');
    },
  );

  streamTestWithEnv(
    description: 'user updates a thread draft message',
    body: (env) async {
      step('GIVEN the user opens a thread');
      await env.backendRobot.generateChannels(
        channelsCount: 1,
        messagesCount: 1,
        repliesCount: 1,
        repliesText: firstMessage,
      );
      await env.userRobot.login().openChannel().openThreadFromReplies();

      step('WHEN the user inputs some text in the composer');
      await env.userRobot.typeText(draftMessage);

      step('AND the user leaves the thread and comes back to it');
      await env.userRobot.tapBackButton().openThreadFromReplies();

      step('THEN the draft message is in the composer');
      await env.userRobot.assertComposerText(draftMessage);

      step('WHEN the user deletes the draft message');
      await env.userRobot.clearComposer();

      step('AND the user leaves the thread and comes back to it');
      await env.userRobot.tapBackButton().openThreadFromReplies();

      step('THEN there is no draft message in the composer');
      await env.userRobot.assertComposerText('');
    },
  );

  streamTestWithEnv(
    description: 'user updates a draft message while offline',
    skip: 'https://linear.app/stream/issue/FLU-1086',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the user becomes offline');
      await env.goOffline();

      step('WHEN the user inputs some text in the composer');
      await env.userRobot.typeText(draftMessage);

      step('AND the user leaves the channel');
      await env.userRobot.tapBackButton();

      step('THEN the draft message is in the channel preview');
      await env.userRobot.assertMessageInChannelPreview('Draft: $draftMessage');

      step('WHEN the user comes back to the channel');
      await env.userRobot.openChannel();

      step('THEN the draft message is in the composer');
      await env.userRobot.assertComposerText(draftMessage);
    },
  );
}
