import 'robots/user_robot.dart';
import 'robots/user_robot_channel_list_asserts.dart';
import 'support/step.dart';
import 'support/stream_test_case.dart';

void main() {
  const channelName = 'Blue Team';
  const searchQuery = 'Blue';

  streamTestWithEnv(
    description: 'user searches for a channel',
    body: (env) async {
      step('GIVEN channels exist, one with a searchable name');
      await env.backendRobot.generateChannels(channelsCount: 3, channelNames: [channelName]);

      step('AND the user logs in');
      await env.userRobot.login().waitForChannelListToLoad().assertChannelCount(3);

      step('WHEN the user searches for the channel by its name');
      await env.userRobot.selectSearchScope('Channels').search(searchQuery);

      step('THEN only the matching channel is shown');
      await env.userRobot.assertChannelCount(1).assertChannelWithName(channelName);
    },
  );
}
