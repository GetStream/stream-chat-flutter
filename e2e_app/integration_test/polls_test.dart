import 'mock_server/data_types.dart';
import 'robots/participant_robot.dart';
import 'robots/user_robot.dart';
import 'robots/user_robot_message_list_asserts.dart';
import 'support/step.dart';
import 'support/stream_test_case.dart';

void main() {
  const question = 'Best color?';
  const firstOption = 'Red';
  const secondOption = 'Blue';
  const options = [firstOption, secondOption];

  streamTestWithEnv(
    allureId: '12799',
    description: 'poll message is shown when the user creates a poll',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user creates a poll from the attachment picker');
      await env.userRobot.createPoll(question, options);

      step('THEN the poll message shows the question and the options');
      await env.userRobot.assertPollMessage(question).assertPollOption(firstOption).assertPollOption(secondOption);
    },
  );

  streamTestWithEnv(
    allureId: '12800',
    description: 'option is checked when the user votes in a poll',
    body: (env) async {
      step('GIVEN the user creates a poll');
      await env.userRobot.login().openChannel().createPoll(question, options);

      step('WHEN the user votes for an option');
      await env.userRobot.castPollVote(firstOption);

      step('THEN the option is checked');
      await env.userRobot.assertPollOption(firstOption, isChecked: true);
    },
  );

  streamTestWithEnv(
    allureId: '12801',
    description: 'option is unchecked when the user removes the poll vote',
    body: (env) async {
      step('GIVEN the user creates a poll and votes');
      await env.userRobot
          .login()
          .openChannel()
          .createPoll(question, options)
          .castPollVote(firstOption)
          .assertPollOption(firstOption, isChecked: true);

      step('WHEN the user taps the voted option again');
      await env.userRobot.removePollVote(firstOption);

      step('THEN the option is unchecked');
      await env.userRobot.assertPollOption(firstOption, isChecked: false);
    },
  );

  streamTestWithEnv(
    allureId: '12802',
    description: 'participant vote is shown in the poll results',
    body: (env) async {
      step('GIVEN the user creates a poll');
      await env.userRobot.login().openChannel().createPoll(question, options);

      step('AND the participant votes for an option');
      // A vote arriving before the poll message is delivered is rejected.
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.sent);
      await env.participantRobot.castPollVote(firstOption);

      step('WHEN the user opens the poll results');
      await env.userRobot.assertPollOptionVoteCount(firstOption, count: 1).openPollResults();

      step('THEN the participant vote is shown');
      await env.userRobot.assertPollResults(voterName: ParticipantRobot.name);
    },
  );

  streamTestWithEnv(
    allureId: '12803',
    description: 'poll is closed when the user ends it',
    body: (env) async {
      step('GIVEN the user creates a poll');
      await env.userRobot.login().openChannel().createPoll(question, options);

      step('WHEN the user ends the poll');
      await env.userRobot.endPoll();

      step('THEN the poll is shown as ended');
      await env.userRobot.assertPollClosed();
    },
  );

  streamTestWithEnv(
    allureId: '12804',
    description: 'user votes for several options when the poll allows multiple votes',
    body: (env) async {
      step('GIVEN the user creates a poll that allows multiple votes');
      await env.userRobot.login().openChannel().createPoll(question, options, multipleAnswers: true);

      step('WHEN the user votes for both options');
      await env.userRobot
          .castPollVote(firstOption)
          .assertPollOption(firstOption, isChecked: true)
          .castPollVote(secondOption);

      step('THEN both options are checked');
      await env.userRobot
          .assertPollOption(secondOption, isChecked: true)
          .assertPollOption(firstOption, isChecked: true);
    },
  );
}
