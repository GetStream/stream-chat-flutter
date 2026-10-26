import 'mock_server/data_types.dart';
import 'robots/user_robot.dart';
import 'robots/user_robot_channel_list_asserts.dart';
import 'robots/user_robot_message_list_asserts.dart';
import 'support/step.dart';
import 'support/stream_test_case.dart';

void main() {
  streamTestWithEnv(
    allureId: '12695',
    description: 'user observes a Giphy when the user adds it',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user sends a Giphy using the giphy command');
      await env.userRobot.uploadGiphy();

      step('THEN the user observes the Giphy');
      await env.userRobot.assertGiphy(isDisplayed: true);
    },
  );

  streamTestWithEnv(
    allureId: '12696',
    description: 'user observes a Giphy when the participant adds it',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the participant sends a Giphy');
      await env.participantRobot.uploadGiphy();

      step('THEN the user observes the Giphy');
      await env.userRobot.assertGiphy(isDisplayed: true);
    },
  );

  streamTestWithEnv(
    allureId: '12697',
    description: 'user observes a Giphy when the user adds it in a thread',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.userRobot.login().openChannel();

      step('WHEN the user runs the giphy command in a thread');
      await env.userRobot.openThread().uploadGiphy();

      step('THEN the user observes the Giphy in the thread');
      await env.userRobot.assertGiphy(isDisplayed: true);
    },
  );

  streamTestWithEnv(
    allureId: '12698',
    description: 'user observes a Giphy when the participant adds it in a thread',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.userRobot.login().openChannel();

      step('WHEN the participant sends a Giphy in a thread');
      await env.participantRobot.uploadGiphyInThread();

      step('THEN the user observes the Giphy in the thread');
      await env.userRobot.openThreadFromReplies().assertGiphy(isDisplayed: true);
    },
  );

  streamTestWithEnv(
    allureId: '12699',
    description: 'user observes a Giphy after adding it through the composer commands',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user sends a Giphy picked from the command suggestions');
      await env.userRobot.uploadGiphy(useComposerCommand: true);

      step('THEN the user observes the Giphy');
      await env.userRobot.assertGiphy(isDisplayed: true);
    },
  );

  streamTestWithEnv(
    allureId: '12700',
    description: 'message is not sent when the user sends an invalid command',
    body: (env) async {
      const invalidCommand = 'invalid command';

      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the user sends a message');
      await env.userRobot.sendMessage('Test').assertMessageDeliveryStatus(MessageDeliveryStatus.sent);

      step('WHEN the user sends a message with an invalid command');
      await env.userRobot.sendMessage('/$invalidCommand');

      step('THEN the user observes an error message');
      await env.userRobot.assertInvalidCommandMessage(invalidCommand);

      step('AND the previous message shows its timestamp and delivery status');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.sent).assertMessageTimestamps(1);
    },
  );

  streamTestWithEnv(
    allureId: '12701',
    description: 'channel list is not modified when an ephemeral message is shown',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user runs the giphy command');
      await env.userRobot.uploadGiphy(send: false);

      step('AND the user goes back to the channel list');
      await env.userRobot.tapBackButton();

      step('THEN the message is not added to the channel preview');
      await env.userRobot.assertMessageInChannelPreview('No messages yet');
    },
  );

  streamTestWithEnv(
    allureId: '12702',
    description: 'delivery status is hidden when an ephemeral message is shown',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user runs the giphy command');
      await env.userRobot.uploadGiphy(send: false);

      step('THEN the ephemeral message has no delivery status');
      await env.userRobot.assertOnlyVisibleToYou().assertEphemeralMessageDeliveryStatusHidden();
    },
  );

  streamTestWithEnv(
    allureId: '12703',
    description: 'delivery status is hidden when an ephemeral message is shown in a thread',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.userRobot.login().openChannel();

      step('WHEN the user runs the giphy command in a thread');
      await env.userRobot.openThread().uploadGiphy(send: false);

      step('THEN the ephemeral message has no delivery status');
      await env.userRobot.assertOnlyVisibleToYou().assertEphemeralMessageDeliveryStatusHidden();
    },
  );

  streamTestWithEnv(
    allureId: '12704',
    description: 'message is not sent when the user cancels the ephemeral message',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user cancels a Giphy');
      await env.userRobot.uploadGiphy(send: false).tapOnCancelGiphyButton();

      step('THEN the user does not observe the Giphy');
      await env.userRobot.assertGiphy(isDisplayed: false).assertGiphyButtons(areDisplayed: false);
    },
  );

  streamTestWithEnv(
    allureId: '12705',
    description: 'user observes a Giphy after shuffling it',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user shuffles a Giphy');
      await env.userRobot.uploadGiphy(send: false).tapOnShuffleGiphyButton();

      step('THEN the Giphy is shuffled but not sent');
      await env.userRobot.assertGiphy(isDisplayed: true).assertGiphyButtons(areDisplayed: true);

      step('WHEN the user sends the Giphy');
      await env.userRobot.tapOnSendGiphyButton();

      step('THEN the user observes the Giphy');
      await env.userRobot.assertGiphy(isDisplayed: true).assertGiphyButtons(areDisplayed: false);
    },
  );
}
