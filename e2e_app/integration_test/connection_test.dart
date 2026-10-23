import 'mock_server/data_types.dart';
import 'robots/user_robot.dart';
import 'robots/user_robot_channel_list_asserts.dart';
import 'robots/user_robot_message_list_asserts.dart';
import 'support/predefined_users.dart';
import 'support/step.dart';
import 'support/stream_test_case.dart';

void main() {
  streamTestWithEnv(
    allureId: '12689',
    description: 'channel list is shown when the user logs out and logs back in',
    body: (env) async {
      step('GIVEN the user logs in');
      await env.userRobot.login().waitForChannelListToLoad();

      step('WHEN the user logs out');
      await env.userRobot.logout();

      step('THEN the start page is shown');
      await env.userRobot.assertStartPageIsShown();

      step('WHEN the user logs back in');
      await env.userRobot.login();

      step('THEN the channel list is shown again');
      await env.assertConnected();
      await env.userRobot.waitForChannelListToLoad();
    },
  );

  streamTestWithEnv(
    allureId: '12690',
    description: 'channel list is shown when the user logs out while it is loading and logs back in',
    body: (env) async {
      step('GIVEN the user logs in');
      // Long enough to outlast the bounded settle that follows the login tap.
      await env.backendRobot.delayChannelList(seconds: 10);
      await env.userRobot.login();

      step('AND the user logs out while the channel list is loading');
      await env.userRobot.assertChannelListIsLoading().logout();

      step('THEN the start page is shown');
      await env.userRobot.assertStartPageIsShown();

      step('WHEN the user logs in');
      await env.userRobot.login();

      step('THEN the user observes the channel list');
      await env.userRobot.waitForChannelListToLoad();
    },
  );

  streamTestWithEnv(
    allureId: '12691',
    description: 'user logs in as another user after logging out',
    body: (env) async {
      const firstUserMessage = 'message from the first user';
      const secondUserMessage = 'message from the second user';
      const unreadCount = 2;

      step('GIVEN the user logs in and sends a message');
      await env.userRobot.login().openChannel().sendMessage(firstUserMessage).assertMessage(firstUserMessage);
      await env.userRobot.tapBackButton();

      step('AND the user logs out');
      await env.userRobot.logout().assertStartPageIsShown();

      step('WHEN the user logs in as another user');
      await env.backendRobot.setAppUser(id: PredefinedUsers.qaTest2.id, name: PredefinedUsers.qaTest2.name);
      await env.userRobot.login(PredefinedUsers.qaTest2);

      step('THEN the user observes the channel list');
      await env.userRobot.waitForChannelListToLoad();

      step("AND the previous user's message is shown as someone else's");
      // The mock server answered the first login as its own fixture user, which
      // is what the native test asserts too.
      await env.userRobot.openChannel().assertMessageAuthor(
        firstUserMessage,
        authorName: PredefinedUsers.mockServerUser.name,
      );

      step('AND the user can send a message');
      await env.userRobot.sendMessage(secondUserMessage).assertMessageDeliveryStatus(MessageDeliveryStatus.sent);

      step('AND the unread count updates as expected');
      await env.userRobot.tapBackButton();
      await env.participantRobot.sendMultipleMessages('New', count: unreadCount);
      await env.userRobot.assertChannelUnreadCount(unreadCount);
    },
  );
}
