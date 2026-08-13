import 'mock_server/data_types.dart';
import 'robots/participant_robot.dart';
import 'robots/user_robot.dart';
import 'robots/user_robot_channel_list_asserts.dart';
import 'robots/user_robot_message_list_asserts.dart';
import 'support/step.dart';
import 'support/stream_test_case.dart';

void main() {
  const sampleText = 'Test';

  // MARK: Channel preview

  streamTestWithEnv(
    allureId: '11637',
    description: 'channel preview updates when the participant sends a message',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the participant sends a message');
      await env.participantRobot.sendMessage(sampleText);

      step('AND the user goes back to the channel list');
      await env.userRobot.tapBackButton();

      step('THEN the user observes the new message in the preview');
      await env.userRobot
          .assertMessageInChannelPreview(sampleText, fromCurrentUser: false)
          .assertMessagePreviewDeliveryStatus(MessageDeliveryStatus.nil)
          .assertChannelAvatar();
    },
  );

  streamTestWithEnv(
    allureId: '11634',
    description: 'channel preview updates when the user sends a message',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user sends a message');
      await env.userRobot.sendMessage(sampleText).assertMessage(sampleText);

      step('AND the user goes back to the channel list');
      await env.userRobot.tapBackButton();

      step('THEN the user observes the new message in the preview');
      await env.userRobot
          .assertMessageInChannelPreview(sampleText, fromCurrentUser: true)
          .assertMessagePreviewDeliveryStatus(MessageDeliveryStatus.sent)
          .assertChannelAvatar();

      step('WHEN the participant reads the message');
      await env.participantRobot.readMessage();

      step('THEN the message is shown as read in the preview');
      await env.userRobot.assertMessagePreviewDeliveryStatus(MessageDeliveryStatus.read);
    },
  );

  streamTestWithEnv(
    allureId: '11643',
    description: 'channel preview updates when the participant sends a message while the user is offline',
    body: (env) async {
      step('GIVEN the user opens the channel list');
      await env.userRobot.login().waitForChannelListToLoad();

      step('AND the user becomes offline');
      await env.goOffline();

      step('WHEN the participant sends a message');
      // The participant robot drives the mock server from the test process, not
      // from the device, so it can send while the app is offline — the native
      // suites have to schedule the message with a delay before going offline.
      await env.participantRobot.sendMessage(sampleText);

      step('AND the user becomes online');
      await env.goOnline();

      step('THEN the user observes the new message in the preview');
      await env.userRobot.assertMessageInChannelPreview(sampleText, fromCurrentUser: false);
    },
  );

  streamTestWithEnv(
    allureId: '11638',
    description: 'error message is not shown in the channel preview',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step('WHEN the user sends a message with an invalid command');
      // The mock server answers an unknown command with an error-type message.
      // Asserted here so the preview check below cannot pass on a run where the
      // error message never arrived. The mock strips the leading slash.
      await env.userRobot.sendMessage('/test').assertInvalidCommandMessage('test');

      step('AND the user goes back to the channel list');
      await env.userRobot.tapBackButton();

      step('THEN the error message is not shown in the preview');
      await env.userRobot
          .assertMessageInChannelPreview(sampleText, fromCurrentUser: false)
          .assertMessagePreviewTimestamp();
    },
  );

  streamTestWithEnv(
    allureId: '11635',
    description: 'channel preview shows no messages when the channel is empty',
    body: (env) async {
      step('WHEN the user opens the channel list');
      await env.userRobot.login().waitForChannelListToLoad();

      step('AND the channel has no messages');
      // Nothing to do — the mock server's default channel is empty.

      step('THEN the channel preview shows that there are no messages');
      // The SDK's own placeholder (`emptyMessagesText`), shown without a sender
      // prefix because there is no message to attribute it to.
      await env.userRobot.assertMessageInChannelPreview('No messages yet');

      step('AND the message timestamp is hidden');
      await env.userRobot.assertMessagePreviewTimestamp(isDisplayed: false);
    },
  );

  streamTestWithEnv(
    allureId: '11644',
    description: 'channel preview shows the deleted message when the only message in the channel is deleted',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step('AND the participant deletes the message');
      await env.participantRobot.deleteMessage();

      step('WHEN the user goes back to the channel list');
      await env.userRobot.tapBackButton();

      step('THEN the channel preview shows the deleted message');
      await env.userRobot.assertMessageInChannelPreview('Message deleted', fromCurrentUser: false);

      step('AND the message timestamp is shown');
      await env.userRobot.assertMessagePreviewTimestamp();
    },
  );

  streamTestWithEnv(
    allureId: '11641',
    description: 'channel preview shows the deleted message when the last message is deleted',
    body: (env) async {
      const oldMessage = 'Old';
      const newMessage = 'New';

      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends 2 messages');
      await env.participantRobot.sendMessage(oldMessage).sendMessage(newMessage);
      await env.userRobot.assertMessage(newMessage);

      step('AND the participant deletes the last message');
      await env.participantRobot.deleteMessage();

      step('WHEN the user goes back to the channel list');
      await env.userRobot.tapBackButton();

      step('THEN the channel preview shows the deleted message');
      await env.userRobot.assertMessageInChannelPreview('Message deleted', fromCurrentUser: false);

      step('AND the message timestamp is shown');
      await env.userRobot.assertMessagePreviewTimestamp();
    },
  );

  streamTestWithEnv(
    allureId: '11640',
    description: 'channel preview is not updated when a thread reply is sent',
    body: (env) async {
      const channelMessage = 'Channel message';
      const threadReply = 'Thread reply';

      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a message');
      await env.participantRobot.sendMessage(channelMessage);
      await env.userRobot.assertMessage(channelMessage);

      step('AND the participant adds a thread reply to that message');
      await env.participantRobot.sendMessageInThread(threadReply);

      step('WHEN the user goes back to the channel list');
      await env.userRobot.tapBackButton();

      step('THEN the channel preview still shows the channel message');
      await env.userRobot
          .assertMessageInChannelPreview(channelMessage, fromCurrentUser: false)
          .assertMessagePreviewTimestamp();
    },
  );

  streamTestWithEnv(
    allureId: '11639',
    description: 'channel preview is updated when a thread reply is also sent to the channel',
    // The skeleton overflow only reproduces on Android; iOS passes consistently.
    skip: 'https://linear.app/stream/issue/FLU-670',
    skipPlatforms: {E2ePlatform.android},
    body: (env) async {
      const channelMessage = 'Channel message';
      const threadReply = 'Thread reply';

      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the user sends a message');
      await env.userRobot.sendMessage(channelMessage).assertMessage(channelMessage);

      step('AND the user adds a thread reply to it, also sending it to the channel');
      await env.userRobot.openThread().sendMessageInThread(threadReply, alsoSendInChannel: true);

      step('WHEN the user goes back to the channel list');
      await env.userRobot.moveToChannelListFromThread();

      step('THEN the channel preview shows the thread reply');
      await env.userRobot
          .assertMessageInChannelPreview(threadReply, fromCurrentUser: true)
          .assertMessagePreviewTimestamp();
    },
  );

  streamTestWithEnv(
    allureId: '11642',
    description: 'channel preview is updated when the preview message is edited',
    body: (env) async {
      const editedMessage = 'edited message';

      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step('WHEN the participant edits the message');
      await env.participantRobot.editMessage(editedMessage);

      step('AND the user goes back to the channel list');
      await env.userRobot.tapBackButton();

      step('THEN the channel preview shows the edited message');
      await env.userRobot
          .assertMessageInChannelPreview(editedMessage, fromCurrentUser: false)
          .assertMessagePreviewTimestamp();
    },
  );

  // MARK: Truncate channel

  streamTestWithEnv(
    allureId: '11645',
    description: 'message list and channel preview are updated when the channel is truncated with a message',
    body: (env) async {
      const systemMessage = 'Channel truncated';

      step('GIVEN the user opens a channel with messages');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 42);
      await env.userRobot.login().openChannel();

      step('WHEN the channel is truncated with a system message');
      await env.truncateChannel(withSystemMessage: systemMessage);

      step('THEN the user observes only the system message');
      await env.userRobot
          .assertMessage(systemMessage)
          .assertMessageCount(1)
          .assertScrollToBottomButton(isDisplayed: false);

      step('WHEN the user goes back to the channel list');
      await env.userRobot.tapBackButton();

      step('THEN the channel preview shows the system message');
      // The mock server attributes the truncation to whoever asked for it, so
      // the system message is the current user's and the preview carries the
      // "You: " prefix — which the visual formatter applies even to a system
      // message, unlike the a11y label.
      await env.userRobot.assertMessageInChannelPreview(systemMessage, fromCurrentUser: true);

      step('AND the message timestamp is shown');
      await env.userRobot.assertMessagePreviewTimestamp();
    },
  );

  streamTestWithEnv(
    allureId: '11633',
    description: 'message list and channel preview are updated when the channel is truncated without a message',
    body: (env) async {
      step('GIVEN the user opens a channel with messages');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 42);
      await env.userRobot.login().openChannel();

      step('WHEN the channel is truncated without a system message');
      await env.truncateChannel();

      step('THEN the user observes an empty message list');
      await env.userRobot.assertMessageCount(0).assertScrollToBottomButton(isDisplayed: false);

      step('WHEN the user goes back to the channel list');
      await env.userRobot.tapBackButton();

      step('THEN the channel preview is empty');
      await env.userRobot.assertMessageInChannelPreview('No messages yet');

      step('AND the message timestamp is not shown');
      await env.userRobot.assertMessagePreviewTimestamp(isDisplayed: false);
    },
  );

  // MARK: Pagination

  streamTestWithEnv(
    allureId: '11636',
    description: 'user paginates the channel list',
    body: (env) async {
      const channelsCount = 30;

      step('WHEN the user opens the channel list');
      await env.backendRobot.generateChannels(channelsCount: channelsCount);
      await env.userRobot.login().waitForChannelListToLoad();

      step('THEN the user makes sure that all the channels are loaded');
      // Mirrors the native scenario, whose channel count also fits in a single
      // page: the app queries 30 channels at a time and the mock server only
      // pages the list when it holds more than the requested limit. So this
      // covers scrolling the whole list, not network paging.
      await env.userRobot.assertChannelListPagination(channelsCount: channelsCount);
    },
  );
}
