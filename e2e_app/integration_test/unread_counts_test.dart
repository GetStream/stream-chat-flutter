import 'mock_server/data_types.dart';
import 'robots/user_robot.dart';
import 'robots/user_robot_channel_list_asserts.dart';
import 'robots/user_robot_message_list_asserts.dart';
import 'support/step.dart';
import 'support/stream_test_case.dart';

void main() {
  const sampleText = 'Test';
  const participantMessage = 'Participant message';

  streamTestWithEnv(
    allureId: '12830',
    description: 'new message in a muted channel does not increment the unread count',
    body: (env) async {
      step('GIVEN the user is in the channel list');
      await env.userRobot.login().waitForChannelListToLoad();

      step('AND the user has a muted channel');
      await env.backendRobot.muteChannel();

      step('WHEN the participant sends a message to the muted channel');
      await env.participantRobot.sendMessage(participantMessage);
      await env.userRobot.assertMessageInChannelPreview(participantMessage, fromCurrentUser: false);

      step('THEN the unread count is not incremented');
      await env.userRobot.assertChannelUnreadCount(0);
    },
  );

  streamTestWithEnv(
    allureId: '12831',
    description: 'new message from a muted user does not increment the unread count',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant in the channel is muted');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot
          .assertMessage(sampleText)
          .muteMessageAuthor(sampleText)
          .assertMuteMessageAuthorOption(sampleText, isAuthorMuted: true);

      step('AND the user is in the channel list');
      await env.userRobot.tapBackButton();

      step('WHEN the muted participant sends a message to the channel');
      await env.participantRobot.sendMessage(participantMessage);
      await env.userRobot.assertMessageInChannelPreview(participantMessage, fromCurrentUser: false);

      step('THEN the unread count is not incremented');
      await env.userRobot.assertChannelUnreadCount(0);
    },
  );

  streamTestWithEnv(
    allureId: '12832',
    description: 'new system message increments the unread count',
    body: (env) async {
      const systemMessage = 'System message';

      step('GIVEN the user opens a channel and sends a message');
      await env.userRobot.login().openChannel().sendMessage(sampleText);

      step('AND the message is delivered');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.sent);

      step('AND the user moves back to the channel list');
      await env.userRobot.tapBackButton();

      step('WHEN the participant performs an action that posts a system message to the channel');
      await env.participantRobot.sendSystemMessage(systemMessage);

      step('THEN the unread count is incremented');
      await env.userRobot.assertMessageInChannelPreview(systemMessage).assertChannelUnreadCount(1);
    },
  );

  streamTestWithEnv(
    allureId: '12833',
    description: 'new thread reply also sent to the channel increments the unread count',
    body: (env) async {
      step('GIVEN the user opens a channel and sends a message');
      await env.userRobot.login().openChannel().sendMessage(sampleText);

      step('AND the message is delivered');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.sent);

      step('AND the user moves back to the channel list');
      await env.userRobot.tapBackButton();

      step('WHEN the participant sends a thread reply also to the channel');
      await env.participantRobot.sendMessageInThread(participantMessage, alsoSendInChannel: true);

      step('THEN the unread count is incremented');
      await env.userRobot
          .assertMessageInChannelPreview(participantMessage, fromCurrentUser: false)
          .assertChannelUnreadCount(1);
    },
  );

  streamTestWithEnv(
    allureId: '12834',
    description: 'hard delete of an unseen message decrements the unread count',
    body: (env) async {
      step('GIVEN the user opens a channel and sends a message');
      await env.userRobot.login().openChannel().sendMessage(sampleText);

      step('AND the message is delivered');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.sent);

      step('AND the user moves back to the channel list');
      await env.userRobot.tapBackButton();

      step('AND the participant sends a thread reply also to the channel');
      await env.participantRobot.sendMessageInThread(participantMessage, alsoSendInChannel: true);

      step('AND the unread count is incremented');
      await env.userRobot.assertChannelUnreadCount(1);

      step('WHEN the participant hard-deletes the message');
      await env.participantRobot.deleteMessage(hard: true);

      step('THEN the unread count is decremented');
      await env.userRobot.assertChannelUnreadCount(0);
    },
  );
}
