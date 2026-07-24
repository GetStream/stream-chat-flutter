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
}
