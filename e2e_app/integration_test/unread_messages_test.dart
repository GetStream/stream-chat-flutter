import 'mock_server/data_types.dart';
import 'robots/user_robot.dart';
import 'robots/user_robot_channel_list_asserts.dart';
import 'robots/user_robot_message_list_asserts.dart';
import 'support/step.dart';
import 'support/stream_test_case.dart';

void main() {
  const sampleText = 'Test';

  streamTestWithEnv(
    allureId: '12835',
    description: 'unread separator is shown when the participant sends messages while the user is away',
    skip: 'https://linear.app/stream/issue/FLU-1098',
    body: (env) async {
      const unreadCount = 2;

      step('GIVEN the user opens a channel and sends a message');
      await env.userRobot.login().openChannel().sendMessage(sampleText);

      step('AND the message is delivered');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.sent);

      step('AND the user moves back to the channel list');
      await env.userRobot.tapBackButton();

      step('WHEN the participant sends new messages');
      await env.participantRobot.sendMultipleMessages('New', count: unreadCount);

      step('AND the channel preview shows the unread count');
      await env.userRobot.assertChannelUnreadCount(unreadCount);

      step('AND the user reopens the channel');
      await env.userRobot.openChannel();

      step('THEN the unread separator is shown with the unread count');
      await env.userRobot.assertUnreadSeparator(unreadCount: unreadCount);
    },
  );

  streamTestWithEnv(
    allureId: '12836',
    description: 'user scrolls to the first unread message',
    skip: 'https://linear.app/stream/issue/FLU-1098',
    body: (env) async {
      const unreadCount = 25;

      step('GIVEN the user opens a channel and sends a message');
      await env.userRobot.login().openChannel().sendMessage(sampleText);

      step('AND the message is delivered');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.sent);

      step('AND the user moves back to the channel list');
      await env.userRobot.tapBackButton();

      step('AND the participant sends new messages');
      await env.participantRobot.sendMultipleMessages('New', count: unreadCount);

      step('AND the channel preview shows the unread count');
      await env.userRobot.assertChannelUnreadCount(unreadCount);

      step('WHEN the user reopens the channel');
      await env.userRobot.openChannel();

      step('THEN the jump to unread button is shown with the unread count');
      await env.userRobot.assertJumpToUnreadButton(unreadCount: unreadCount);

      step('WHEN the user taps the jump to unread button');
      await env.userRobot.tapOnJumpToUnreadButton();

      step('THEN the list scrolls to the unread separator');
      await env.userRobot.assertUnreadSeparator(unreadCount: unreadCount);
    },
  );

  streamTestWithEnv(
    allureId: '12837',
    description: 'user marks a message as unread',
    body: (env) async {
      const unreadCount = 2;

      step('GIVEN the user opens a channel and sends a message');
      await env.userRobot.login().openChannel().sendMessage(sampleText);

      step('AND the message is delivered');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.sent);

      step('AND the participant sends messages');
      await env.participantRobot.sendMultipleMessages('New', count: unreadCount);
      await env.userRobot.assertMessage('New-$unreadCount');

      step('WHEN the user marks the first participant message as unread');
      await env.userRobot.markMessageAsUnread('New-1');

      step('THEN the unread separator is shown with the unread count');
      await env.userRobot.assertUnreadSeparator(unreadCount: unreadCount);

      step('AND the channel preview shows the unread count');
      await env.userRobot.tapBackButton().assertChannelUnreadCount(unreadCount);
    },
  );

  streamTestWithEnv(
    allureId: '12838',
    description: 'jump to unread button shows the unread count when the user marks a message as unread',
    body: (env) async {
      const unreadCount = 25;

      step('GIVEN the user opens a channel and sends a message');
      await env.userRobot.login().openChannel().sendMessage(sampleText);

      step('AND the message is delivered');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.sent);

      step('AND the participant sends more messages than fit on the screen');
      await env.participantRobot.sendMultipleMessages('New', count: unreadCount);
      await env.userRobot.assertMessage('New-$unreadCount');

      step('WHEN the user marks the first participant message as unread');
      await env.userRobot.scrollMessageListUpUntilVisible('New-1').markMessageAsUnread('New-1');

      step('AND the user scrolls back to the bottom');
      await env.userRobot.scrollMessageListDownUntilVisible('New-$unreadCount');

      step('THEN the jump to unread button shows the unread count');
      await env.userRobot.assertJumpToUnreadButton(unreadCount: unreadCount);
    },
  );

  streamTestWithEnv(
    allureId: '12839',
    description: 'user dismisses the unread indicator',
    body: (env) async {
      const unreadCount = 25;

      step('GIVEN the user opens a channel and sends a message');
      await env.userRobot.login().openChannel().sendMessage(sampleText);

      step('AND the message is delivered');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.sent);

      step('AND the user moves back to the channel list');
      await env.userRobot.tapBackButton();

      step('AND the participant sends new messages');
      await env.participantRobot.sendMultipleMessages('New', count: unreadCount);

      step('AND the user reopens the channel');
      await env.userRobot.assertChannelUnreadCount(unreadCount).openChannel();

      step('WHEN the user dismisses the unread indicator');
      await env.userRobot.assertJumpToUnreadButton().dismissUnreadIndicator();

      step('THEN the jump to unread button is hidden');
      await env.userRobot.assertJumpToUnreadButton(isDisplayed: false);
    },
  );

  streamTestWithEnv(
    allureId: '12840',
    description: 'channel unread count is reset when the user reads the channel',
    body: (env) async {
      const unreadCount = 2;

      step('GIVEN the user opens a channel and sends a message');
      await env.userRobot.login().openChannel().sendMessage(sampleText);

      step('AND the message is delivered');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.sent);

      step('AND the user moves back to the channel list');
      await env.userRobot.tapBackButton();

      step('AND the participant sends new messages');
      await env.participantRobot.sendMultipleMessages('New', count: unreadCount);

      step('AND the channel preview shows the unread count');
      await env.userRobot.assertChannelUnreadCount(unreadCount);

      step('WHEN the user reads the channel');
      await env.userRobot.openChannel().assertMessage('New-$unreadCount');

      step('AND the user moves back to the channel list');
      await env.userRobot.tapBackButton();

      step('THEN the channel preview has no unread count');
      await env.userRobot.assertChannelUnreadCount(0);
    },
  );
}
