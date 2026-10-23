import 'robots/participant_robot.dart';
import 'robots/user_robot.dart';
import 'robots/user_robot_channel_list_asserts.dart';
import 'robots/user_robot_message_list_asserts.dart';
import 'support/step.dart';
import 'support/stream_test_case.dart';

void main() {
  const sampleText = 'Test';
  // Seeded messages alternate authors starting with the user, so with two
  // seeded messages the one with text "2" belongs to the participant.
  const participantMessageText = '2';
  const groupChannelName = '1';

  streamTestWithEnv(
    allureId: '12784',
    description: 'user flags a message',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step('WHEN the user taps the flag option of the message');
      await env.userRobot.flagMessage(sampleText);

      step('THEN the flag confirmation is shown');
      await env.userRobot.assertFlagMessageDialog(isDisplayed: true);

      step('WHEN the user confirms flagging the message');
      await env.userRobot.confirmFlagMessage();

      step('THEN the confirmation is dismissed and the message stays in the message list');
      await env.userRobot.assertFlagMessageDialog(isDisplayed: false).assertMessage(sampleText);
    },
  );

  streamTestWithEnv(
    allureId: '12785',
    description: 'user mutes the message author',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step('WHEN the user mutes the message author');
      await env.userRobot.muteMessageAuthor(sampleText);

      step('THEN the message actions offer to unmute the author');
      await env.userRobot.assertMuteMessageAuthorOption(sampleText, isAuthorMuted: true);
    },
  );

  streamTestWithEnv(
    allureId: '12786',
    description: 'user unmutes the message author',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step('AND the user mutes the message author');
      await env.userRobot.muteMessageAuthor(sampleText).assertMuteMessageAuthorOption(sampleText, isAuthorMuted: true);

      step('WHEN the user unmutes the message author');
      await env.userRobot.unmuteMessageAuthor(sampleText);

      step('THEN the message actions offer to mute the author again');
      await env.userRobot.assertMuteMessageAuthorOption(sampleText, isAuthorMuted: false);
    },
  );

  streamTestWithEnv(
    allureId: '12787',
    description: 'muted author stays muted when the user reopens the channel',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step('AND the user mutes the message author');
      await env.userRobot.muteMessageAuthor(sampleText).assertMuteMessageAuthorOption(sampleText, isAuthorMuted: true);

      step('WHEN the user reopens the channel');
      await env.userRobot.tapBackButton().openChannel();

      step('THEN the message actions still offer to unmute the author');
      await env.userRobot.assertMuteMessageAuthorOption(sampleText, isAuthorMuted: true);
    },
  );

  streamTestWithEnv(
    allureId: '12788',
    description: 'user blocks the message author',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step('WHEN the user blocks the message author');
      await env.userRobot.blockMessageAuthor(sampleText);

      step('THEN the message actions offer to unblock the author');
      await env.userRobot.assertBlockMessageAuthorOption(sampleText, isAuthorBlocked: true);
    },
  );

  streamTestWithEnv(
    allureId: '12789',
    description: 'user unblocks the message author',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step('AND the user blocks the message author');
      await env.userRobot
          .blockMessageAuthor(sampleText)
          .assertBlockMessageAuthorOption(sampleText, isAuthorBlocked: true);

      step('WHEN the user unblocks the message author');
      await env.userRobot.unblockMessageAuthor(sampleText);

      step('THEN the message actions offer to block the author again');
      await env.userRobot.assertBlockMessageAuthorOption(sampleText, isAuthorBlocked: false);
    },
  );

  streamTestWithEnv(
    allureId: '12790',
    description: 'blocked author stays blocked when the user reopens the channel',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step('AND the user blocks the message author');
      await env.userRobot
          .blockMessageAuthor(sampleText)
          .assertBlockMessageAuthorOption(sampleText, isAuthorBlocked: true);

      step('WHEN the user reopens the channel');
      await env.userRobot.tapBackButton().openChannel();

      step('THEN the message actions still offer to unblock the author');
      await env.userRobot.assertBlockMessageAuthorOption(sampleText, isAuthorBlocked: true);
    },
  );

  streamTestWithEnv(
    allureId: '12791',
    description: 'user blocks the participant in a direct message channel',
    skip: 'https://linear.app/stream/issue/FLU-1085',
    body: (env) async {
      step('GIVEN a direct message channel with the participant exists');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 2, withDirectMessageChannel: true);

      step('AND the user opens the direct message channel');
      await env.userRobot.login().openChannelNamed(ParticipantRobot.name);

      step('WHEN the user blocks the participant');
      await env.userRobot.blockMessageAuthor(participantMessageText);

      step('THEN the message actions offer to unblock the participant');
      await env.userRobot.assertBlockMessageAuthorOption(participantMessageText, isAuthorBlocked: true);
    },
  );

  streamTestWithEnv(
    allureId: '12792',
    description: 'direct message channel disappears when the user blocks the participant',
    skip: 'https://linear.app/stream/issue/FLU-1085',
    body: (env) async {
      step('GIVEN a direct message channel with the participant exists');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 2, withDirectMessageChannel: true);

      step('AND the user sees it in the channel list');
      await env.userRobot.login().assertChannelCount(2).assertChannelWithName(ParticipantRobot.name);

      step('WHEN the user blocks the participant in the direct message channel');
      await env.userRobot.openChannelNamed(ParticipantRobot.name).blockMessageAuthor(participantMessageText);
      await env.userRobot.tapBackButton();

      step('THEN the direct message channel disappears from the channel list');
      await env.userRobot.assertChannelCount(1).assertChannelWithName(ParticipantRobot.name, isDisplayed: false);

      step('WHEN the user unblocks the participant from the group channel');
      await env.userRobot.openChannelNamed(groupChannelName).unblockMessageAuthor(participantMessageText);
      await env.userRobot.tapBackButton();

      step('THEN the direct message channel is shown in the channel list again');
      await env.userRobot.assertChannelCount(2).assertChannelWithName(ParticipantRobot.name);
    },
  );
}
