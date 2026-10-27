import 'mock_server/data_types.dart';
import 'robots/participant_robot.dart';
import 'robots/user_robot.dart';
import 'robots/user_robot_message_list_asserts.dart';
import 'support/step.dart';
import 'support/stream_test_case.dart';

void main() {
  const sampleText = 'Test';
  // A message long enough to wrap across several lines, so editing to/from it
  // produces a real change in cell height (single newlines collapse in markdown).
  const longText =
      'This is a much longer message that will certainly wrap across several lines '
      'inside the chat bubble, making the message cell noticeably taller than a short one.';

  // MARK: Message sending

  streamTestWithEnv(
    allureId: '11188',
    description: 'message list updates when the user sends a message',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user sends a message');
      await env.userRobot.sendMessage(sampleText);

      step('THEN the message is displayed');
      await env.userRobot.assertMessage(sampleText);
    },
  );

  streamTestWithEnv(
    allureId: '11346',
    description: 'message list updates when the participant sends a message',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the participant sends a message');
      await env.participantRobot.sendMessage(sampleText);

      step('THEN the message is displayed');
      await env.userRobot.assertMessage(sampleText);
    },
  );

  streamTestWithEnv(
    allureId: '11336',
    description: 'user sends a message with one emoji',
    body: (env) async {
      const message = '🍏';

      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user sends the emoji: $message');
      await env.userRobot.sendMessage(message);

      step('THEN the message is delivered');
      await env.userRobot.assertMessage(message);
    },
  );

  streamTestWithEnv(
    allureId: '11347',
    description: 'user sends a message with multiple emojis',
    body: (env) async {
      const message = '🍏🙂👍';

      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user sends a message with multiple emojis: $message');
      await env.userRobot.sendMessage(message);

      step('THEN the message is delivered');
      await env.userRobot.assertMessage(message);
    },
  );

  streamTestWithEnv(
    allureId: '11339',
    description: 'user receives a message with an emoji',
    body: (env) async {
      const message = '🚢';

      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the participant sends the emoji: $message');
      await env.participantRobot.sendMessage(message);

      step('THEN the message is delivered');
      await env.userRobot.assertMessage(message);
    },
  );

  streamTestWithEnv(
    allureId: '11345',
    description: 'user sends a message with multiple lines',
    body: (env) async {
      const message = 'alpha\nbeta\ngamma';

      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user sends a message with multiple lines');
      await env.userRobot.sendMessage(message);

      step('THEN each line of the message is displayed');
      // The markdown renderer collapses single newlines, so assert on the
      // individual line tokens rather than the literal multi-line string.
      await env.userRobot.assertMessageContains('alpha').assertMessageContains('gamma');
    },
  );

  // MARK: Message editing

  streamTestWithEnv(
    allureId: '11337',
    description: 'user edits a message',
    body: (env) async {
      const editedMessage = 'hello';

      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user sends the message');
      await env.userRobot.sendMessage(sampleText).assertMessage(sampleText);

      step('AND the user edits the message');
      await env.userRobot.editMessage(editedMessage);

      step('THEN the message is edited');
      await env.userRobot.assertEditedMessage(editedMessage);
    },
  );

  streamTestWithEnv(
    allureId: '11341',
    description: 'user sees a message edited by the participant',
    body: (env) async {
      const editedMessage = 'hello';

      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the participant sends the message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step('AND the participant edits the message');
      await env.participantRobot.editMessage(editedMessage);

      step('THEN the message is edited');
      await env.userRobot.assertEditedMessage(editedMessage);
    },
  );

  // MARK: Typing indicator

  streamTestWithEnv(
    allureId: '11343',
    description: 'user observes the typing indicator',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.userRobot.login().openChannel();

      step('WHEN the participant starts typing');
      await env.participantRobot.startTyping();

      step('THEN the typing indicator is shown');
      await env.userRobot.assertTypingIndicator(isDisplayed: true);

      step('WHEN the participant stops typing');
      await env.participantRobot.stopTyping();

      step('THEN the typing indicator disappears');
      await env.userRobot.assertTypingIndicator(isDisplayed: false);
    },
  );

  // MARK: Offline

  streamTestWithEnv(
    allureId: '11338',
    description: 'user sees the participant message received while offline',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the user becomes offline');
      await env.goOffline();

      step('WHEN the participant sends a new message');
      await env.participantRobot.sendMessage(sampleText);

      step('AND the user becomes online');
      await env.goOnline();

      step('THEN the user observes the new message from the participant');
      await env.userRobot.assertMessage(sampleText);
    },
  );

  // Both offline cases run with persistence on, mirroring the native
  // `setIsLocalStorageEnabled(to: .on)`.
  streamTestWithEnv(
    allureId: '11527',
    description: 'user adds a message while offline',
    persistence: true,
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the user becomes offline');
      await env.goOffline();

      step('WHEN the user sends a new message');
      await env.userRobot.sendMessage(sampleText);

      step('THEN the message is shown as failed to be sent');
      // The send is optimistic, so the text shows up right away; the SDK marks
      // the message failed once its retries are exhausted.
      await env.userRobot.assertMessage(sampleText).assertMessageFailedToBeSent();
      // The composer reports the failed send through FlutterError, which the
      // failed bubble asserted above already covers.
      await env.takeExpectedError();

      step('WHEN the user becomes online');
      await env.goOnline();

      step('THEN the message is delivered');
      // The channel's retry queue replays failed messages on
      // `connection.recovered`, which flips the status to sent.
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.sent);
    },
  );

  streamTestWithEnv(
    allureId: '11526',
    description: 'user recovers a message received while in the background',
    persistence: true,
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the user goes to the background');
      await env.moveToBackground();

      step('WHEN the participant sends a new message');
      // Nothing is pumped between here and the foregrounding — see
      // `StreamTestEnv.moveToBackground`.
      await env.participantRobot.sendMessage(sampleText);

      step('AND the user comes back to the foreground');
      await env.moveToForeground();

      step('THEN the new message is delivered');
      await env.userRobot.assertMessage(sampleText);
    },
  );

  // MARK: Thread replies

  streamTestWithEnv(
    allureId: '11350',
    description: 'thread reply appears in the thread when the participant adds it',
    body: (env) async {
      const threadReply = 'thread reply';

      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.userRobot.login().openChannel();

      step('WHEN the participant adds a thread reply');
      await env.participantRobot.sendMessageInThread(threadReply);

      step('AND the user opens the thread');
      await env.userRobot.openThread();

      step('THEN the user observes the thread reply in the thread');
      await env.userRobot.assertThreadReply(threadReply);
    },
  );

  streamTestWithEnv(
    allureId: '11492',
    description: 'thread reply also sent to the channel appears in both places',
    body: (env) async {
      const threadReply = 'thread reply';

      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.userRobot.login().openChannel();

      step('WHEN the participant adds a thread reply and also sends it to the channel');
      await env.participantRobot.sendMessageInThread(threadReply, alsoSendInChannel: true);

      step('THEN the user observes the thread reply in the channel');
      await env.userRobot.assertMessage(threadReply);

      step('AND the user observes the thread reply in the thread');
      // The in-channel copy is the newest message and has no 'Thread Reply'
      // action, so the thread is opened from the parent's replies footer.
      await env.userRobot.openThreadFromReplies().assertThreadReply(threadReply);
    },
  );

  streamTestWithEnv(
    allureId: '11329',
    description: 'thread typing indicator hides when the participant stops typing',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.userRobot.login().openChannel();

      step('AND the user opens the thread');
      await env.userRobot.openThread();

      step('WHEN the participant starts typing in the thread');
      await env.participantRobot.startTypingInThread();

      step('THEN the typing indicator is shown');
      await env.userRobot.assertTypingIndicator(isDisplayed: true);

      step('WHEN the participant stops typing in the thread');
      await env.participantRobot.stopTypingInThread();

      step('THEN the typing indicator disappears');
      await env.userRobot.assertTypingIndicator(isDisplayed: false);
    },
  );

  streamTestWithEnv(
    allureId: '12755',
    description: 'thread reply also sent to the channel by the user appears in both places',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.userRobot.login().openChannel();

      step('WHEN the user adds a thread reply and also sends it to the channel');
      await env.userRobot.openThread().sendMessageInThread(sampleText, alsoSendInChannel: true);

      step('THEN the user observes the thread reply in the thread');
      await env.userRobot.assertThreadReply(sampleText).assertAlsoInTheChannelLabel(inThread: true);

      step('AND the user observes the thread reply in the channel');
      await env.userRobot.tapBackButton().assertMessage(sampleText).assertAlsoInTheChannelLabel(inThread: false);
    },
  );

  // MARK: Deleted messages

  streamTestWithEnv(
    allureId: '11332',
    description: 'user deletes a message',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user sends the message');
      await env.userRobot.sendMessage(sampleText).assertMessage(sampleText);

      step('AND the user deletes the message');
      await env.userRobot.deleteMessage();

      step('THEN the message is deleted');
      await env.userRobot.assertDeletedMessage();
    },
  );

  streamTestWithEnv(
    allureId: '11333',
    description: 'user sees a message deleted by the participant',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the participant sends the message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step('AND the participant deletes the message');
      await env.participantRobot.deleteMessage();

      step('THEN the message is deleted');
      await env.userRobot.assertDeletedMessage();
    },
  );

  streamTestWithEnv(
    allureId: '11335',
    description: 'user sees a message hard-deleted by the participant',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the participant sends the message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step('AND the participant hard-deletes the message');
      await env.participantRobot.deleteMessage(hard: true);

      step('THEN the message is hard-deleted');
      await env.userRobot.assertHardDeletedMessage(sampleText);
    },
  );

  streamTestWithEnv(
    allureId: '12756',
    description: 'thread reply is removed everywhere when the participant removes it from the channel',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.userRobot.login().openChannel();

      step('AND the participant adds a thread reply and also sends it to the channel');
      await env.participantRobot.sendMessageInThread(sampleText, alsoSendInChannel: true);
      await env.userRobot.assertMessage(sampleText);

      step('WHEN the participant removes the thread reply');
      await env.participantRobot.deleteMessage();

      step('THEN the user observes the thread reply removed in the channel');
      await env.userRobot.assertDeletedMessage().assertAlsoInTheChannelLabel(inThread: false);

      step('AND the user observes the thread reply removed in the thread');
      await env.userRobot.openThreadFromReplies().assertDeletedMessage().assertAlsoInTheChannelLabel(inThread: true);
    },
  );

  streamTestWithEnv(
    allureId: '12757',
    description: 'thread reply is removed everywhere when the user removes it from the channel',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.userRobot.login().openChannel();

      step('AND the user adds a thread reply and also sends it to the channel');
      await env.userRobot.openThread().sendMessageInThread(sampleText, alsoSendInChannel: true);
      await env.userRobot.assertThreadReply(sampleText);

      step('WHEN the user removes the thread reply from the channel');
      await env.userRobot.tapBackButton().assertMessage(sampleText).deleteMessage();

      step('THEN the user observes the thread reply removed in the channel');
      await env.userRobot.assertDeletedMessage().assertAlsoInTheChannelLabel(inThread: false);

      step('AND the user observes the thread reply removed in the thread');
      await env.userRobot.openThreadFromReplies().assertDeletedMessage().assertAlsoInTheChannelLabel(inThread: true);
    },
  );

  streamTestWithEnv(
    allureId: '12758',
    description: 'thread reply is removed everywhere when the user removes it from the thread',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.userRobot.login().openChannel();

      step('AND the user adds a thread reply and also sends it to the channel');
      await env.userRobot.openThread().sendMessageInThread(sampleText, alsoSendInChannel: true);
      await env.userRobot.assertThreadReply(sampleText);

      step('WHEN the user removes the thread reply from the thread');
      await env.userRobot.deleteMessage();

      step('THEN the user observes the thread reply removed in the thread');
      await env.userRobot.assertDeletedMessage().assertAlsoInTheChannelLabel(inThread: true);

      step('AND the user observes the thread reply removed in the channel');
      await env.userRobot.tapBackButton().assertDeletedMessage().assertAlsoInTheChannelLabel(inThread: false);
    },
  );

  streamTestWithEnv(
    allureId: '12759',
    description: 'participant removes a thread reply',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.userRobot.login().openChannel();

      step('AND the participant adds a thread reply');
      await env.participantRobot.sendMessageInThread(sampleText);
      await env.userRobot.assertThreadReplyLabel(replies: 1);

      step('WHEN the participant removes the thread reply');
      await env.participantRobot.deleteMessage();

      step('THEN the user observes the thread reply removed in the thread');
      await env.userRobot
          .assertThreadReplyLabel(replies: 1)
          .assertThreadReplyLabelAvatars(count: 1)
          .openThreadFromReplies()
          .assertDeletedMessage();
    },
  );

  streamTestWithEnv(
    allureId: '12760',
    description: 'user removes a thread reply',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.userRobot.login().openChannel();

      step('AND the user adds a thread reply');
      await env.userRobot.openThread().sendMessageInThread(sampleText);
      await env.userRobot.assertThreadReply(sampleText);

      step('WHEN the user removes the thread reply');
      await env.userRobot.deleteMessage();

      step('THEN the user observes the thread reply removed in the thread');
      await env.userRobot.assertDeletedMessage();

      step('AND the user observes the thread reply count on the parent message');
      await env.userRobot.tapBackButton().assertThreadReplyLabel(replies: 1).assertThreadReplyLabelAvatars(count: 1);
    },
  );

  streamTestWithEnv(
    allureId: '12761',
    description: 'thread is not locked after the user deletes the parent message',
    skip: 'https://linear.app/stream/issue/FLU-1092',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.userRobot.login().openChannel();

      step('AND the participant adds a thread reply');
      await env.participantRobot.sendMessageInThread(sampleText);
      await env.userRobot.assertThreadReplyLabel(replies: 1);

      step('WHEN the user deletes the parent message');
      await env.userRobot.deleteMessage();

      step('THEN the thread is not locked');
      await env.userRobot.openThreadFromReplies().assertThreadReply(sampleText);
    },
  );

  streamTestWithEnv(
    allureId: '12762',
    description: 'thread is not locked after the participant deletes the parent message',
    skip: 'https://linear.app/stream/issue/FLU-1092',
    body: (env) async {
      const threadReply = 'thread reply';

      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step('AND the user sends a message in the thread');
      await env.userRobot.openThread().sendMessageInThread(threadReply).assertThreadReply(threadReply).tapBackButton();

      step('WHEN the participant deletes the parent message');
      await env.participantRobot.deleteMessage();
      await env.userRobot.assertDeletedMessage();

      step('THEN the thread is not locked');
      await env.userRobot.openThreadFromReplies().assertThreadReply(threadReply);
    },
  );

  streamTestWithEnv(
    allureId: '12763',
    description: 'user hard-deletes a message',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user sends a message');
      await env.userRobot.sendMessage(sampleText).assertMessage(sampleText);

      step('AND the user hard-deletes the message');
      await env.userRobot.deleteMessage(hard: true);

      step('THEN the message is hard-deleted');
      await env.userRobot.assertHardDeletedMessage(sampleText);
    },
  );

  streamTestWithEnv(
    allureId: '12764',
    description: 'user hard-deletes a message in a channel with history',
    body: (env) async {
      const message = 'test message';

      step('GIVEN the user opens a channel with a message');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.userRobot.login().openChannel();

      step('WHEN the user sends a message');
      await env.userRobot.sendMessage(message).assertMessage(message);

      step('AND the user hard-deletes the message');
      await env.userRobot.deleteMessage(hard: true);

      step('THEN the message is hard-deleted');
      await env.userRobot.assertHardDeletedMessage(message);
    },
  );

  // MARK: Mentions

  streamTestWithEnv(
    allureId: '11349',
    description: 'user sees the mentions overlay when typing @',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user types @');
      await env.userRobot.typeText('@');

      step('THEN the mentions overlay appears');
      await env.userRobot.assertMentionsOverlay(isDisplayed: true);

      step('WHEN the user removes @');
      await env.userRobot.clearComposer();

      step('THEN the mentions overlay disappears');
      await env.userRobot.assertMentionsOverlay(isDisplayed: false);
    },
  );

  streamTestWithEnv(
    allureId: '12765',
    description: 'user fills the composer by mentioning the participant through the mentions overlay',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step("WHEN the user taps on the participant's name");
      await env.userRobot.mentionParticipant(send: false);

      step("THEN the composer fills in the participant's name");
      await env.userRobot.assertMentionWasApplied();
    },
  );

  // MARK: Commands

  streamTestWithEnv(
    allureId: '12766',
    description: 'selecting a command hides the attachments button',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the user observes the attachments button');
      await env.userRobot.assertComposerAttachmentsButton(isDisplayed: true);

      step('WHEN the user selects the giphy command from the suggestions');
      await env.userRobot.openComposerCommands().assertComposerCommands(isDisplayed: true).selectCommand('giphy');

      step('THEN the attachments button disappears');
      await env.userRobot.assertComposerAttachmentsButton(isDisplayed: false);
    },
  );

  streamTestWithEnv(
    allureId: '12767',
    description: 'command suggestions disappear when the user taps on the message list',
    skip: 'https://linear.app/stream/issue/FLU-1093',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 30);
      await env.userRobot.login().openChannel();

      step('AND the user opens the command suggestions');
      await env.userRobot.openComposerCommands().assertComposerCommands(isDisplayed: true);

      step('WHEN the user taps on the message list');
      await env.userRobot.tapOnMessageList();

      step('THEN the command suggestions disappear');
      await env.userRobot.assertComposerCommands(isDisplayed: false);
    },
  );

  // MARK: Scroll to bottom

  streamTestWithEnv(
    allureId: '11334',
    description: 'message list scrolls down when the user receives a new message at the bottom',
    body: (env) async {
      const newMessage = 'New message';

      step('GIVEN the user opens a channel with history');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 30);
      await env.userRobot.login().openChannel();

      step('WHEN the participant sends a message');
      await env.participantRobot.sendMessage(newMessage);

      step('THEN the new message is visible');
      await env.userRobot.assertMessage(newMessage);
    },
  );

  streamTestWithEnv(
    allureId: '11348',
    description: 'message list does not scroll down when scrolled up and the user receives a message',
    body: (env) async {
      const newMessage = 'New message';

      step('GIVEN the user opens a channel with history');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 30);
      await env.userRobot.login().openChannel();

      step('WHEN the user scrolls up');
      await env.userRobot.scrollMessageListUp();

      step('AND the participant sends a message');
      await env.participantRobot.sendMessage(newMessage);

      step('THEN the new message is not visible');
      await env.userRobot.assertMessage(newMessage, isDisplayed: false);
    },
  );

  streamTestWithEnv(
    allureId: '12768',
    description: 'message list scrolls down when scrolled up and the user sends a message',
    body: (env) async {
      step('GIVEN the user opens a channel with history');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 30);
      await env.userRobot.login().openChannel();

      step('WHEN the user scrolls up');
      await env.userRobot.scrollMessageListUp().assertScrollToBottomButton(isDisplayed: true);

      step('AND the user sends a new message');
      await env.userRobot.sendMessage(sampleText);

      step('THEN the message list is scrolled down');
      await env.userRobot.assertScrollToBottomButton(isDisplayed: false).assertMessageOnScreen(sampleText);
    },
  );

  streamTestWithEnv(
    allureId: '12769',
    description: 'message list scrolls down when the user taps the scroll to bottom button',
    body: (env) async {
      const newMessage = 'New message';

      step('GIVEN the user opens a channel with history');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 30);
      await env.userRobot.login().openChannel();

      step('AND the user sends a new message');
      await env.userRobot.sendMessage(newMessage).assertMessage(newMessage);

      step('WHEN the user scrolls up');
      await env.userRobot.scrollMessageListUp().assertScrollToBottomButton(isDisplayed: true);

      step('AND the user taps the scroll to bottom button');
      await env.userRobot.tapOnScrollToBottomButton();

      step('THEN the message list is scrolled down');
      await env.userRobot.assertMessageOnScreen(newMessage).assertScrollToBottomButton(isDisplayed: false);
    },
  );

  streamTestWithEnv(
    allureId: '12770',
    description: 'skipped messages are reloaded when the user scrolls to the bottom',
    body: (env) async {
      step('GIVEN the user opens a channel with history');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 30);
      await env.userRobot.login().openChannel();

      step('AND the user scrolls up');
      await env.userRobot.scrollMessageListUp().assertScrollToBottomButton(isDisplayed: true);

      step('AND the participant sends some messages');
      await env.participantRobot.sendMultipleMessages('Some message', count: 16);

      step('WHEN the user scrolls to the bottom');
      await env.userRobot.tapOnScrollToBottomButton();

      step('THEN the skipped messages are reloaded');
      await env.userRobot.assertMessageOnScreen('Some message-16').assertScrollToBottomButton(isDisplayed: false);
    },
  );

  streamTestWithEnv(
    allureId: '12771',
    description: 'scroll to bottom button shows the unread count',
    body: (env) async {
      const newMessage = 'New message';

      step('GIVEN the user opens a channel with history');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 30);
      await env.userRobot.login().openChannel();

      step('WHEN the user scrolls up');
      await env.userRobot.scrollMessageListUp().assertScrollToBottomButton(isDisplayed: true);

      step('AND the participant sends a message');
      await env.participantRobot.sendMessage(newMessage);

      step('THEN the message list is not scrolled down');
      await env.userRobot
          .assertMessageOnScreen(newMessage, isDisplayed: false)
          .assertScrollToBottomButton(isDisplayed: true, unreadCount: 1);

      step('WHEN the user taps the scroll to bottom button');
      await env.userRobot.tapOnScrollToBottomButton().assertMessageOnScreen(newMessage);

      step('AND the user scrolls up');
      await env.userRobot.scrollMessageListUp();

      step('THEN the unread count is not displayed');
      await env.userRobot.assertScrollToBottomButton(isDisplayed: true, unreadCount: 0);
    },
  );

  // MARK: Pagination

  streamTestWithEnv(
    allureId: '11331',
    description: 'user paginates the message list',
    body: (env) async {
      const messagesCount = 60;

      step('GIVEN the user opens a channel with a long history');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: messagesCount);
      await env.userRobot.login().openChannel();

      step('THEN the whole history can be paged through');
      await env.userRobot.assertMessageListPagination(messagesCount: messagesCount);
    },
  );

  streamTestWithEnv(
    allureId: '12772',
    description: 'user paginates a thread',
    body: (env) async {
      const repliesCount = 60;

      step('GIVEN the user opens a channel with a long thread');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1, repliesCount: repliesCount);
      await env.userRobot.login().openChannel();

      step('WHEN the user opens the thread');
      await env.userRobot.openThreadFromReplies();

      step('THEN the whole thread history can be paged through');
      await env.userRobot.assertMessageListPagination(messagesCount: repliesCount + 1);
    },
  );

  // MARK: Link previews

  // Link previews are asserted on a participant-sent YouTube message: the
  // composer suppresses enrichment on the user's own outgoing link, and the
  // mock server only serves a canned OG response for YouTube URLs.
  streamTestWithEnv(
    allureId: '11340',
    description: 'user sees a link preview for a YouTube link',
    body: (env) async {
      const link = 'https://youtube.com/watch?v=xOX7MsrbaPY';

      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the participant sends a message with a YouTube link');
      await env.participantRobot.sendMessage(link);

      step('THEN a link preview is displayed');
      await env.userRobot.assertLinkPreview();
    },
  );

  // Mirrors the native test_messageWithLinkOpensSafari: the browser is stood in
  // for by a fake `UrlLauncherPlatform`, so the tap is verified without the real
  // browser taking over the device (which suspends the app and hangs the run).
  streamTestWithEnv(
    allureId: '11493',
    description: 'message with a link opens the browser',
    body: (env) async {
      const link = 'https://youtube.com/watch?v=xOX7MsrbaPY';
      // Tapping the preview opens the attachment's asset URL, which comes from
      // the mock server's canned OG payload — the canonical (`www.`) form of the
      // link, not the text the participant typed.
      const openedLink = 'https://www.youtube.com/watch?v=xOX7MsrbaPY';

      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the participant sends a message with a YouTube link');
      await env.participantRobot.sendMessage(link);
      await env.userRobot.assertLinkPreview();

      step('AND the user taps the link preview');
      await env.userRobot.tapLinkPreview();

      step('THEN the browser opens the link');
      await env.assertBrowserOpened(url: openedLink);
    },
  );

  streamTestWithEnv(
    allureId: '12773',
    description: 'user sees a link preview for their own YouTube link',
    body: (env) async {
      const link = 'https://youtube.com/watch?v=xOX7MsrbaPY';

      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user sends a message with a YouTube link');
      await env.userRobot.sendMessage(link);

      step('THEN a link preview is displayed');
      await env.userRobot.assertLinkPreview();
    },
  );

  streamTestWithEnv(
    allureId: '12774',
    description: 'user sees a link preview for their own Unsplash link',
    skip: 'https://linear.app/stream/issue/FLU-1088',
    body: (env) async {
      const link = 'https://unsplash.com/photos/1_2d3MRbI9c';

      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user sends a message with an Unsplash link');
      await env.userRobot.sendMessage(link);

      step('THEN a link preview is displayed');
      await env.userRobot.assertLinkPreview();
    },
  );

  streamTestWithEnv(
    allureId: '12775',
    description: 'user sees a link preview for an Unsplash link',
    skip: 'https://linear.app/stream/issue/FLU-1088',
    body: (env) async {
      const link = 'https://unsplash.com/photos/1_2d3MRbI9c';

      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the participant sends a message with an Unsplash link');
      await env.participantRobot.sendMessage(link);

      step('THEN a link preview is displayed');
      await env.userRobot.assertLinkPreview();
    },
  );

  streamTestWithEnv(
    allureId: '12776',
    description: 'message with a link without a scheme opens the browser',
    body: (env) async {
      const link = 'youtube.com';

      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user sends a message with a link without https://');
      await env.userRobot.sendMessage('Some link: $link');

      step('AND the user taps the link');
      await env.userRobot.tapOnLinkText(link);

      step('THEN the browser opens the link');
      await env.assertBrowserOpened();
    },
  );

  // MARK: Message grouping & size

  streamTestWithEnv(
    allureId: '11330',
    description: 'message cell grows when the user edits it to a longer message',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the user sends a short message');
      await env.userRobot.sendMessage(sampleText).assertMessage(sampleText);

      step('THEN the message cell grows after editing to a longer message');
      await env.userRobot.assertMessageSizeChangesAfterEditing(longText, increased: true);
    },
  );

  streamTestWithEnv(
    allureId: '11344',
    description: 'message cell shrinks when the user edits it to a shorter message',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the user sends a long message');
      await env.userRobot.sendMessage(longText).assertMessage(longText);

      step('THEN the message cell shrinks after editing to a shorter message');
      await env.userRobot.assertMessageSizeChangesAfterEditing(sampleText, increased: false);
    },
  );

  streamTestWithEnv(
    allureId: '11342',
    description: 'composer does not grow beyond its line limit',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('THEN the composer grows with input but stops at its cap');
      await env.userRobot.assertComposerGrowsWithinLimit();
    },
  );

  streamTestWithEnv(
    allureId: '12777',
    description: 'message ends its group when followed by an error message',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the user sends the 1st message');
      await env.userRobot.sendMessage(sampleText).assertMessage(sampleText);

      step('AND the timestamp is shown under the 1st message');
      await env.userRobot.assertMessageTimestamps(1);

      step('WHEN the user sends a message that does not pass moderation');
      await env.userRobot.sendMessage(forbiddenWord);

      step('THEN the messages are not grouped and the 1st message shows the timestamp');
      await env.userRobot.assertMessageTimestamps(1);
    },
  );

  streamTestWithEnv(
    allureId: '12778',
    description: 'message renders its timestamp again when the last message of its group is hard-deleted',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends 3 grouped messages');
      await env.participantRobot.sendMessage('1').sendMessage('2').sendMessage('3');
      await env.userRobot.assertMessage('3').assertMessageTimestamps(1);

      step('WHEN the participant hard-deletes the last message');
      await env.participantRobot.deleteMessage(hard: true);
      await env.userRobot.assertMessage('3', isDisplayed: false);

      step('THEN the previous message renders the timestamp again');
      await env.userRobot.assertMessageTimestamps(1);
    },
  );

  streamTestWithEnv(
    allureId: '12779',
    description: 'message renders its timestamp again when the last message of its group is soft-deleted',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends 3 grouped messages');
      await env.participantRobot.sendMessage('1').sendMessage('2').sendMessage('3');
      await env.userRobot.assertMessage('3').assertMessageTimestamps(1);

      step('WHEN the participant soft-deletes the last message');
      await env.participantRobot.deleteMessage();
      await env.userRobot.assertDeletedMessage();

      step('THEN the previous message renders the timestamp again');
      await env.userRobot.assertMessageTimestamps(1);
    },
  );

  // MARK: Thread reply editing

  streamTestWithEnv(
    allureId: '12780',
    description: 'user edits a thread reply',
    body: (env) async {
      const threadReply = 'thread reply';
      const editedThreadReply = 'edited thread reply';

      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step('AND the user replies to the message in a thread');
      await env.userRobot.openThread().sendMessageInThread(threadReply).assertThreadReply(threadReply);

      step('WHEN the user edits the thread reply');
      await env.userRobot.editMessage(editedThreadReply);

      step('THEN the thread reply is edited and marked as edited');
      await env.userRobot.assertEditedMessage(editedThreadReply);
    },
  );

  streamTestWithEnv(
    allureId: '12781',
    description: 'participant edits a thread reply',
    body: (env) async {
      const threadReply = 'thread reply';
      const editedThreadReply = 'edited thread reply';

      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the user sends a message');
      await env.userRobot.sendMessage(sampleText).assertMessage(sampleText);

      step('AND the participant replies to the message in a thread');
      await env.participantRobot.sendMessageInThread(threadReply);

      step('AND the user opens the thread');
      await env.userRobot.openThreadFromReplies().assertThreadReply(threadReply);

      step('WHEN the participant edits the thread reply');
      await env.participantRobot.editMessageInThread(editedThreadReply);

      step('THEN the thread reply is edited and marked as edited');
      await env.userRobot.assertEditedMessage(editedThreadReply);
    },
  );

  streamTestWithEnv(
    allureId: '12782',
    description: 'thread reply also sent to the channel is edited everywhere when the participant edits it',
    body: (env) async {
      const threadReply = 'thread reply';
      const editedThreadReply = 'edited thread reply';

      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the user sends a message');
      await env.userRobot.sendMessage(sampleText).assertMessage(sampleText);

      step('AND the participant replies in a thread and also sends it to the channel');
      await env.participantRobot.sendMessageInThread(threadReply, alsoSendInChannel: true);
      await env.userRobot.assertMessage(threadReply);

      step('WHEN the participant edits the thread reply');
      await env.participantRobot.editMessageInThread(editedThreadReply, alsoSendInChannel: true);

      step('THEN the thread reply is edited in the channel');
      await env.userRobot.assertEditedMessage(editedThreadReply);

      step('AND the thread reply is edited in the thread');
      await env.userRobot.openThreadFromReplies().assertEditedMessage(editedThreadReply);
    },
  );

  streamTestWithEnv(
    allureId: '12783',
    description: 'thread reply is removed everywhere when the participant removes it from the thread',
    body: (env) async {
      const threadReply = 'thread reply';

      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the user sends a message');
      await env.userRobot.sendMessage(sampleText).assertMessage(sampleText);

      step('WHEN the participant replies in a thread and also sends it to the channel');
      await env.participantRobot.sendMessageInThread(threadReply, alsoSendInChannel: true);

      step('AND the user opens the thread');
      await env.userRobot.openThreadFromReplies().assertThreadReply(threadReply);

      step('AND the participant removes the thread reply');
      await env.participantRobot.deleteMessage();

      step('THEN the message is deleted from the thread');
      await env.userRobot.assertDeletedMessage();

      step('AND the message is deleted from the channel');
      await env.userRobot.tapBackButton().assertDeletedMessage();
    },
  );
}
