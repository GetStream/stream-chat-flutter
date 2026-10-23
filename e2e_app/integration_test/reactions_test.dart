import 'mock_server/data_types.dart';
import 'robots/participant_robot.dart';
import 'robots/user_robot.dart';
import 'robots/user_robot_message_list_asserts.dart';
import 'support/step.dart';
import 'support/stream_test_case.dart';

void main() {
  const sampleText = 'Test';

  streamTestWithEnv(
    allureId: '11293',
    description: 'user adds a reaction to their own message',
    body: (env) async {
      step('GIVEN user opens the channel');
      await env.userRobot.login().openChannel();

      step('WHEN user sends the message');
      await env.userRobot.sendMessage(sampleText);

      step('AND user adds the reaction');
      await env.userRobot.addReaction(ReactionType.like);

      step('THEN the reaction is added');
      await env.userRobot.assertReaction(type: ReactionType.like, isDisplayed: true);
    },
  );

  streamTestWithEnv(
    allureId: '11288',
    description: 'user deletes a reaction from their own message',
    body: (env) async {
      step('GIVEN user opens the channel');
      await env.userRobot.login().openChannel();

      step('WHEN user sends the message');
      await env.userRobot.sendMessage(sampleText);

      step('AND user adds the reaction');
      await env.userRobot.addReaction(ReactionType.wow).assertReaction(type: ReactionType.wow, isDisplayed: true);

      step('AND user removes the reaction');
      await env.userRobot.deleteReaction(ReactionType.wow);

      step('THEN the reaction is removed');
      await env.userRobot.assertReaction(type: ReactionType.wow, isDisplayed: false);
    },
  );

  streamTestWithEnv(
    allureId: '11292',
    description: 'user adds a reaction to the participant message',
    body: (env) async {
      step('GIVEN user opens the channel');
      await env.userRobot.login().openChannel();

      step('WHEN participant sends the message');
      await env.participantRobot.sendMessage(sampleText);

      step('AND user adds the reaction');
      await env.userRobot.addReaction(ReactionType.love);

      step('THEN the reaction is added');
      await env.userRobot.assertReaction(type: ReactionType.love, isDisplayed: true);
    },
  );

  streamTestWithEnv(
    allureId: '11290',
    description: 'user removes a reaction from the participant message',
    body: (env) async {
      step('GIVEN user opens the channel');
      await env.userRobot.login().openChannel();

      step('WHEN participant sends the message');
      await env.participantRobot.sendMessage(sampleText);

      step('AND user adds the reaction');
      await env.userRobot.addReaction(ReactionType.lol).assertReaction(type: ReactionType.lol, isDisplayed: true);

      step('AND user removes the reaction');
      await env.userRobot.deleteReaction(ReactionType.lol);

      step('THEN the reaction is removed');
      await env.userRobot.assertReaction(type: ReactionType.lol, isDisplayed: false);
    },
  );

  streamTestWithEnv(
    allureId: '11294',
    description: 'participant adds a reaction to the user message',
    body: (env) async {
      step('GIVEN user opens the channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.userRobot.login().openChannel();

      step('AND participant adds the reaction to the user message');
      await env.participantRobot.readMessage().addReaction(ReactionType.like);

      step('THEN the reaction is added');
      await env.userRobot.assertReaction(type: ReactionType.like, isDisplayed: true);
    },
  );

  streamTestWithEnv(
    allureId: '11296',
    description: 'participant removes a reaction from the user message',
    body: (env) async {
      step('GIVEN user opens the channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.userRobot.login().openChannel();

      step('AND participant adds the reaction to the user message');
      await env.participantRobot.readMessage().addReaction(ReactionType.lol);
      await env.userRobot.assertReaction(type: ReactionType.lol, isDisplayed: true);

      step('AND participant removes the reaction');
      await env.participantRobot.deleteReaction(ReactionType.lol);

      step('THEN the reaction is removed');
      await env.userRobot.assertReaction(type: ReactionType.lol, isDisplayed: false);
    },
  );

  streamTestWithEnv(
    allureId: '11291',
    description: 'participant adds a reaction to their own message',
    body: (env) async {
      step('GIVEN user opens the channel');
      await env.userRobot.login().openChannel();

      step('WHEN participant sends the message');
      await env.participantRobot.sendMessage(sampleText);

      step('AND participant adds the reaction');
      await env.participantRobot.addReaction(ReactionType.wow);

      step('THEN the reaction is added');
      await env.userRobot.assertReaction(type: ReactionType.wow, isDisplayed: true);
    },
  );

  streamTestWithEnv(
    allureId: '11295',
    description: 'participant removes a reaction from their own message',
    body: (env) async {
      step('GIVEN user opens the channel');
      await env.userRobot.login().openChannel();

      step('WHEN participant sends the message');
      await env.participantRobot.sendMessage(sampleText);

      step('AND participant adds the reaction');
      await env.participantRobot.addReaction(ReactionType.sad);
      await env.userRobot.assertReaction(type: ReactionType.sad, isDisplayed: true);

      step('AND participant removes the reaction');
      await env.participantRobot.deleteReaction(ReactionType.sad);

      step('THEN the reaction is removed');
      await env.userRobot.assertReaction(type: ReactionType.sad, isDisplayed: false);
    },
  );

  streamTestWithEnv(
    allureId: '11287',
    description: 'user adds a reaction while offline',
    skip: 'https://linear.app/stream/issue/FLU-506',
    body: (env) async {
      step('GIVEN user opens the channel');
      await env.userRobot.login().openChannel();

      step('AND user sends a message');
      await env.userRobot.sendMessage(sampleText);

      step('AND user becomes offline');
      await env.goOffline();

      step('WHEN user adds a reaction');
      await env.userRobot.addReaction(ReactionType.like);

      step('THEN the reaction is displayed');
      await env.userRobot.assertReaction(type: ReactionType.like, isDisplayed: true);

      step('WHEN user becomes online');
      await env.goOnline();

      step('THEN the reaction is still displayed');
      await env.userRobot.assertReaction(type: ReactionType.like, isDisplayed: true);
    },
  );

  streamTestWithEnv(
    allureId: '11289',
    description: 'participant adds a reaction while the user is offline',
    body: (env) async {
      step('GIVEN user opens the channel');
      await env.userRobot.login().openChannel();

      step('AND user sends a message');
      await env.userRobot.sendMessage(sampleText);

      step('AND user becomes offline');
      await env.goOffline();

      step('WHEN participant adds a reaction');
      await env.participantRobot.addReaction(ReactionType.like);

      step('AND user becomes online');
      await env.goOnline();

      step('THEN the reaction is displayed');
      await env.userRobot.assertReaction(type: ReactionType.like, isDisplayed: true);
    },
  );

  // MARK: Extended reactions

  streamTestWithEnv(
    description: 'user adds a reaction using the extended reactions picker',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the participant sends a message');
      await env.participantRobot.sendMessage('Test');
      await env.userRobot.assertMessage('Test');

      step('AND the user adds a reaction using the extended reactions picker');
      await env.userRobot.toggleReactionUsingExtendedPicker(ReactionType.lol);

      step('THEN the reaction is added');
      await env.userRobot.assertReaction(type: ReactionType.lol, isDisplayed: true);
    },
  );

  streamTestWithEnv(
    description: 'user removes a reaction using the extended reactions picker',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a message');
      await env.participantRobot.sendMessage('Test');
      await env.userRobot.assertMessage('Test');

      step('AND the user adds a reaction using the extended reactions picker');
      await env.userRobot
          .toggleReactionUsingExtendedPicker(ReactionType.lol)
          .assertReaction(type: ReactionType.lol, isDisplayed: true);

      step('WHEN the user removes the reaction using the extended reactions picker');
      await env.userRobot.toggleReactionUsingExtendedPicker(ReactionType.lol);

      step('THEN the reaction is removed');
      await env.userRobot.assertReaction(type: ReactionType.lol, isDisplayed: false);
    },
  );

  streamTestWithEnv(
    description: 'reaction authors sheet is shown when the user taps on a reaction',
    body: (env) async {
      const message = 'test message';

      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a message');
      await env.participantRobot.sendMessage(message);
      await env.userRobot.assertMessage(message);

      step('AND the user adds a reaction');
      await env.userRobot.addReaction(ReactionType.wow).assertReaction(type: ReactionType.wow, isDisplayed: true);

      step('AND the participant adds a reaction');
      await env.participantRobot.addReaction(ReactionType.love);
      await env.userRobot.assertReaction(type: ReactionType.love, isDisplayed: true);

      step('WHEN the user taps on the message reactions');
      await env.userRobot.tapOnMessageReactions(ReactionType.love);

      step('THEN the reaction authors sheet shows the participant and the user');
      // The sheet lists the authors of one reaction type at a time.
      await env.userRobot
          .assertReactionAuthor(ParticipantRobot.name)
          .selectReactionInAuthors(ReactionType.wow)
          .assertOwnReactionInAuthors();

      step('WHEN the participant removes the reaction');
      await env.userRobot.closeReactionAuthors();
      await env.participantRobot.deleteReaction(ReactionType.love);
      await env.userRobot.assertReaction(type: ReactionType.love, isDisplayed: false);

      step('AND the user taps on the message reactions');
      await env.userRobot.tapOnMessageReactions(ReactionType.wow);

      step('THEN the reaction authors sheet shows only the user');
      await env.userRobot.assertOwnReactionInAuthors().assertReactionAuthor(ParticipantRobot.name, isDisplayed: false);
    },
  );

  streamTestWithEnv(
    description: 'participant adds a reaction to a thread reply',
    body: (env) async {
      const message = 'message';
      const threadReply = 'thread reply';

      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a message');
      await env.participantRobot.sendMessage(message);
      await env.userRobot.assertMessage(message);

      step('AND the user replies to the message in a thread');
      await env.userRobot.openThread().sendMessageInThread(threadReply).assertThreadReply(threadReply);

      step('WHEN the participant adds a reaction to the thread reply');
      await env.participantRobot.addReaction(ReactionType.wow);

      step('THEN the user observes the reaction on the thread reply');
      await env.userRobot.assertReaction(type: ReactionType.wow, isDisplayed: true);
    },
  );
}
