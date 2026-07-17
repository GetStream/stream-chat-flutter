import 'mock_server/data_types.dart';
import 'robots/participant_robot.dart';
import 'robots/user_robot.dart';
import 'robots/user_robot_message_list_asserts.dart';
import 'support/step.dart';
import 'support/stream_test_case.dart';

void main() {
  const sampleText = 'Test';

  streamTestWithEnv(
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

  // EXPECTED TO FAIL on Flutter: unlike iOS/Android, the Dart SDK does not
  // queue offline reactions — `channel.sendReaction` rolls back its optimistic
  // update when the HTTP request fails (channel.dart), and the reaction is
  // never replayed on reconnect (the RetryQueue is messages-only). Kept as a
  // faithful port of the native case so the gap stays visible; it will pass
  // once the SDK gives reactions the same offline-queue treatment as messages.
  streamTestWithEnv(
    description: 'user adds a reaction while offline',
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
