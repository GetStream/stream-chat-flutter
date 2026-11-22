import 'robots/user_robot.dart';
import 'robots/user_robot_message_list_asserts.dart';
import 'support/step.dart';
import 'support/stream_test_case.dart';

void main() {
  const sampleText = 'Test';
  const oneHourInSeconds = 3600;

  streamTestWithEnv(
    allureId: '12814',
    description: 'reminders screen is empty when the user has no reminders',
    body: (env) async {
      step('GIVEN the user logs in');
      await env.userRobot.login().waitForChannelListToLoad();

      step('WHEN the user opens the reminders screen');
      await env.userRobot.openReminders();

      step('THEN no reminder is shown');
      await env.userRobot.assertRemindersScreen().assertRemindersAreEmpty();
    },
  );

  streamTestWithEnv(
    allureId: '12815',
    description: 'reminder saved for later is shown on the reminders screen',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step('AND the message is saved for later');
      await env.backendRobot.createReminder();

      step('WHEN the user opens the reminders screen');
      await env.userRobot.tapBackButton().openReminders();

      step('THEN the message is shown as saved for later');
      await env.userRobot.assertRemindersScreen().assertReminder(sampleText, savedForLater: true);
    },
  );

  streamTestWithEnv(
    allureId: '12816',
    description: 'scheduled reminder is shown on the reminders screen',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step('AND a reminder for the message is due in one hour');
      await env.backendRobot.createReminder(remindAtSeconds: oneHourInSeconds);

      step('WHEN the user opens the reminders screen');
      await env.userRobot.tapBackButton().openReminders();

      step('THEN the message is shown on the reminders screen');
      await env.userRobot.assertRemindersScreen().assertReminder(sampleText);
    },
  );

  streamTestWithEnv(
    allureId: '12817',
    description: 'reminder saved for later is shown on the message',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step('AND the message is saved for later');
      await env.backendRobot.createReminder();

      step('WHEN the user reopens the channel');
      await env.userRobot.tapBackButton().openChannel();

      step('THEN the message is shown as saved for later');
      await env.userRobot.assertMessageReminder(remindAtIsSet: false);
    },
  );

  streamTestWithEnv(
    allureId: '12818',
    description: 'scheduled reminder is shown on the message',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step('AND a reminder for the message is due in one hour');
      await env.backendRobot.createReminder(remindAtSeconds: oneHourInSeconds);

      step('WHEN the user reopens the channel');
      await env.userRobot.tapBackButton().openChannel();

      step('THEN the message shows when the reminder is due');
      await env.userRobot.assertMessageReminder(remindAtIsSet: true);
    },
  );
}
