import 'robots/user_robot.dart';
import 'robots/user_robot_message_list_asserts.dart';
import 'support/step.dart';
import 'support/stream_test_case.dart';

void main() {
  // Long enough that the cooldown cannot run out between sending and asserting
  // on a slow CI device; no test waits for it to end.
  const cooldownDuration = 60;
  const message = 'message';
  const replyMessage = 'reply message';
  const editedMessage = 'edited message';

  streamTestWithEnv(
    allureId: '12821',
    description: 'cooldown is shown when a new message is sent',
    body: (env) async {
      step('GIVEN slow mode is enabled on the channel');
      await env.backendRobot.setCooldown(enabled: true, duration: cooldownDuration);

      step('AND the user opens the channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user sends a new message');
      await env.userRobot.sendMessage(message);

      step('THEN slow mode is active and the cooldown is shown');
      await env.userRobot.assertCooldown(isDisplayed: true);
    },
  );

  streamTestWithEnv(
    allureId: '12822',
    description: 'composer is disabled while slow mode is active',
    body: (env) async {
      step('GIVEN slow mode is enabled on the channel');
      await env.backendRobot.setCooldown(enabled: true, duration: cooldownDuration);

      step('AND the user opens the channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user sends a new message');
      await env.userRobot.sendMessage(message);

      step('THEN the cooldown is shown and the composer is locked');
      await env.userRobot.assertComposerIsDisabledInSlowMode();
    },
  );

  streamTestWithEnv(
    allureId: '12823',
    description: 'cooldown is shown when the user replies to a message',
    body: (env) async {
      step('GIVEN slow mode is enabled on the channel');
      await env.backendRobot.setCooldown(enabled: true, duration: cooldownDuration);

      step('AND the user opens the channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a new message');
      await env.participantRobot.sendMessage(message);
      await env.userRobot.assertMessage(message);

      step('WHEN the user replies to the message');
      await env.userRobot.quoteMessage(replyMessage);

      step('THEN slow mode is active and the cooldown is shown');
      await env.userRobot.assertCooldown(isDisplayed: true);

      step('AND the reply is sent');
      await env.userRobot.assertQuotedMessage(text: replyMessage, quote: message);
    },
  );

  streamTestWithEnv(
    allureId: '12824',
    description: 'message cannot be replied to while the cooldown is shown',
    body: (env) async {
      step('GIVEN slow mode is enabled on the channel');
      await env.backendRobot.setCooldown(enabled: true, duration: cooldownDuration);

      step('AND the user opens the channel');
      await env.userRobot.login().openChannel();

      step('AND the user sends a new message');
      await env.userRobot.sendMessage(message).assertMessage(message);

      step('WHEN the user selects reply from the message actions');
      await env.userRobot.selectReplyFromContextMenu();

      step('THEN the cooldown is shown and the composer is locked');
      await env.userRobot.assertComposerIsDisabledInSlowMode();
    },
  );

  streamTestWithEnv(
    allureId: '12825',
    description: 'cooldown carries over into a thread',
    body: (env) async {
      step('GIVEN slow mode is enabled on the channel');
      await env.backendRobot.setCooldown(enabled: true, duration: cooldownDuration);

      step('AND the user opens the channel');
      await env.userRobot.login().openChannel();

      step('AND the user sends a new message');
      await env.userRobot.sendMessage(message).assertMessage(message);

      step('WHEN the user opens the thread of the message');
      await env.userRobot.openThread();

      step('THEN the cooldown is shown and the composer is locked in the thread');
      await env.userRobot.assertComposerIsDisabledInSlowMode();
    },
  );

  streamTestWithEnv(
    allureId: '12826',
    description: 'cooldown is not shown when a message is edited',
    body: (env) async {
      step('GIVEN slow mode is enabled on a channel with a message');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.backendRobot.setCooldown(enabled: true, duration: cooldownDuration);

      step('AND the user opens the channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user edits the message');
      await env.userRobot.editMessage(editedMessage).assertEditedMessage(editedMessage);

      step('THEN slow mode is not active and the cooldown is not shown');
      await env.userRobot.assertCooldown(isDisplayed: false);
    },
  );
}
