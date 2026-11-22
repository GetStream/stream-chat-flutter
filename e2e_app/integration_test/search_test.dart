import 'robots/user_robot.dart';
import 'robots/user_robot_channel_list_asserts.dart';
import 'robots/user_robot_message_list_asserts.dart';
import 'support/step.dart';
import 'support/stream_test_case.dart';

void main() {
  const sampleText = 'Test';

  streamTestWithEnv(
    allureId: '12819',
    description: 'user searches for a message',
    body: (env) async {
      step('GIVEN the user opens the channel list');
      await env.userRobot.login().waitForChannelListToLoad();

      step('AND the participant sends a message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessageInChannelPreview(sampleText, fromCurrentUser: false);

      step('WHEN the user searches for the message on the channel list');
      await env.userRobot.search(sampleText);

      step('THEN the message is shown in the search results');
      await env.userRobot.assertMessageInSearchResults(sampleText);
    },
  );

  streamTestWithEnv(
    allureId: '12820',
    description: 'user opens a message from the search results',
    body: (env) async {
      step('GIVEN the user opens the channel list');
      await env.userRobot.login().waitForChannelListToLoad();

      step('AND the participant sends a message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessageInChannelPreview(sampleText, fromCurrentUser: false);

      step('AND the user searches for the message on the channel list');
      await env.userRobot.search(sampleText).assertMessageInSearchResults(sampleText);

      step('WHEN the user taps the search result');
      await env.userRobot.tapOnSearchResult();

      step('THEN the message list is opened on the message');
      await env.userRobot.waitForMessageListToLoad().assertMessageOnScreen(sampleText);
    },
  );
}
