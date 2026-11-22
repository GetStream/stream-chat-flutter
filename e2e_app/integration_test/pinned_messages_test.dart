import 'mock_server/data_types.dart';
import 'robots/participant_robot.dart';
import 'robots/user_robot.dart';
import 'robots/user_robot_message_list_asserts.dart';
import 'support/step.dart';
import 'support/stream_test_case.dart';

void main() {
  const sampleText = 'Test';

  streamTestWithEnv(
    allureId: '12793',
    description: 'user pins a message',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the participant sends a message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step('AND the user pins the message');
      await env.userRobot.pinMessage();

      step('THEN the message shows the pinned by you label');
      await env.userRobot.assertMessagePinnedLabel();
    },
  );

  streamTestWithEnv(
    allureId: '12794',
    description: 'user unpins a message',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step('AND the user pins the message');
      await env.userRobot.pinMessage().assertMessagePinnedLabel();

      step('WHEN the user unpins the message');
      await env.userRobot.unpinMessage();

      step('THEN the message shows no pinned label');
      await env.userRobot.assertMessagePinnedLabel(isDisplayed: false);
    },
  );

  streamTestWithEnv(
    allureId: '12795',
    description: 'participant pins a message',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user sends a message');
      await env.userRobot.sendMessage(sampleText).assertMessageDeliveryStatus(MessageDeliveryStatus.sent);

      step('AND the participant pins the message');
      await env.participantRobot.pinMessage();

      step('THEN the message shows the pinned by participant label');
      await env.userRobot.assertMessagePinnedLabel(pinnedBy: ParticipantRobot.name);
    },
  );

  streamTestWithEnv(
    allureId: '12796',
    description: 'participant unpins a message',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the user sends a message');
      await env.userRobot.sendMessage(sampleText).assertMessageDeliveryStatus(MessageDeliveryStatus.sent);

      step('AND the participant pins the message');
      await env.participantRobot.pinMessage();
      await env.userRobot.assertMessagePinnedLabel(pinnedBy: ParticipantRobot.name);

      step('WHEN the participant unpins the message');
      await env.participantRobot.unpinMessage();

      step('THEN the message shows no pinned label');
      await env.userRobot.assertMessagePinnedLabel(pinnedBy: ParticipantRobot.name, isDisplayed: false);
    },
  );

  streamTestWithEnv(
    allureId: '12797',
    description: 'pinned message is shown on the pinned messages screen',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step('AND the user pins the message');
      await env.userRobot.pinMessage().assertMessagePinnedLabel();

      step('WHEN the user opens the pinned messages screen');
      await env.userRobot.tapBackButton().openChannelMenu().tapOnViewChannelInfo().tapOnPinnedMessagesOption();

      step('THEN the pinned message is shown');
      await env.userRobot.assertPinnedMessagesScreen().assertMessageInPinnedMessages(sampleText);
    },
  );

  streamTestWithEnv(
    allureId: '12798',
    description: 'unpinned message is not shown on the pinned messages screen',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step('AND the user pins the message');
      await env.userRobot.pinMessage().assertMessagePinnedLabel();

      step('WHEN the user unpins the message');
      await env.userRobot.unpinMessage().assertMessagePinnedLabel(isDisplayed: false);

      step('AND the user opens the pinned messages screen');
      await env.userRobot.tapBackButton().openChannelMenu().tapOnViewChannelInfo().tapOnPinnedMessagesOption();

      step('THEN no pinned message is shown');
      await env.userRobot.assertPinnedMessagesScreen().assertPinnedMessagesAreEmpty();
    },
  );
}
