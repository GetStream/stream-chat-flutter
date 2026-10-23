import 'robots/user_robot.dart';
import 'robots/user_robot_channel_list_asserts.dart';
import 'support/predefined_users.dart';
import 'support/step.dart';
import 'support/stream_test_case.dart';

void main() {
  streamTestWithEnv(
    description: 'channel actions sheet is shown when the user long-presses the channel',
    body: (env) async {
      step('GIVEN the user logs in');
      await env.userRobot.login().waitForChannelListToLoad();

      step('WHEN the user long-presses the channel');
      await env.userRobot.openChannelMenu();

      step('THEN the channel actions sheet is shown');
      await env.userRobot.assertChannelActionsSheetForGroupChannel();
    },
  );

  streamTestWithEnv(
    description: 'channel actions sheet is shown when the user swipes the channel',
    body: (env) async {
      step('GIVEN the user logs in');
      await env.userRobot.login().waitForChannelListToLoad();

      step('WHEN the user swipes the channel and taps the more action');
      await env.userRobot.swipeChannel().tapOnMoreSwipeAction();

      step('THEN the channel actions sheet is shown');
      await env.userRobot.assertChannelActionsSheetForGroupChannel();
    },
  );

  streamTestWithEnv(
    description: 'user opens the channel info from the channel actions sheet',
    body: (env) async {
      step('GIVEN the user logs in');
      await env.userRobot.login().waitForChannelListToLoad();

      step('AND the user long-presses the channel');
      await env.userRobot.openChannelMenu();

      step('WHEN the user taps the view info option');
      await env.userRobot.tapOnViewChannelInfo();

      step('THEN the group channel info screen is shown');
      await env.userRobot.assertGroupChannelInfoScreen();
    },
  );

  streamTestWithEnv(
    description: 'user leaves a group channel',
    body: (env) async {
      step('GIVEN the user logs in');
      await env.userRobot.login().waitForChannelListToLoad();

      step('AND the user long-presses the channel');
      await env.userRobot.openChannelMenu();

      step('WHEN the user leaves the group');
      await env.userRobot.tapOnLeaveGroup().confirmChannelAction();

      step('THEN the channel is gone from the channel list');
      await env.userRobot.assertChannelListIsEmpty();
    },
  );

  streamTestWithEnv(
    description: 'user deletes a group channel',
    body: (env) async {
      step('GIVEN the user logs in');
      await env.userRobot.login().waitForChannelListToLoad();

      step('AND the user long-presses the channel');
      await env.userRobot.openChannelMenu();

      step('WHEN the user deletes the group');
      await env.userRobot.tapOnDeleteGroup().confirmChannelAction();

      step('THEN the channel is gone from the channel list');
      await env.userRobot.assertChannelListIsEmpty();
    },
  );

  streamTestWithEnv(
    description: 'user mutes a channel from the swipe action',
    body: (env) async {
      step('GIVEN the user logs in');
      await env.userRobot.login().waitForChannelListToLoad();

      step('WHEN the user swipes the channel and taps the mute action');
      await env.userRobot.swipeChannel().tapOnMuteSwipeAction();

      step('THEN the channel shows the muted icon');
      await env.userRobot.assertChannelIsMuted(isMuted: true);
    },
  );

  streamTestWithEnv(
    description: 'user unmutes a channel from the swipe action',
    body: (env) async {
      step('GIVEN the user logs in');
      await env.userRobot.login().waitForChannelListToLoad();

      step('AND the user mutes the channel from the swipe action');
      await env.userRobot.swipeChannel().tapOnMuteSwipeAction().assertChannelIsMuted(isMuted: true);

      step('WHEN the user swipes the channel and taps the unmute action');
      await env.userRobot.swipeChannel().tapOnUnmuteSwipeAction();

      step('THEN the channel shows no muted icon');
      await env.userRobot.assertChannelIsMuted(isMuted: false);
    },
  );

  streamTestWithEnv(
    description: 'app does not crash when the user goes back after being removed from the open channel',
    skip: 'https://linear.app/stream/issue/FLU-1085',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the user is removed from the channel while it is open');
      await env.backendRobot.removeMember(PredefinedUsers.mockServerUser.id);
      await env.userRobot.waitForMessageListToLoad();

      step('WHEN the user goes back to the channel list');
      await env.userRobot.tapBackButton();

      step('THEN the channel is gone from the channel list');
      await env.userRobot.assertChannelListIsEmpty();
    },
  );
}
