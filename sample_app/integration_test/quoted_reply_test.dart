import 'mock_server/data_types.dart';
import 'robots/user_robot.dart';
import 'robots/user_robot_message_list_asserts.dart';
import 'support/step.dart';
import 'support/stream_test_case.dart';

// TODO(allure): fill in each test's `allureId` from Allure TestOps project 135
// once this suite has run in a launch — TestOps auto-creates a case per new
// `fullName`, so the mapping is read back from the API afterwards.
void main() {
  const sampleText = 'Test message';
  const quoteReply = 'Alright';
  const invalidCommand = 'invalid command';
  const messagesCount = 30;
  // The thread parent needs a text of its own: threads are opened by naming the
  // parent, and the mock server otherwise names both the parent and its replies
  // by index.
  const parentText = 'Parent message';

  // MARK: In the channel

  streamTestWithEnv(
    description: 'swiping a message starts a quoted reply',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1, messagesText: sampleText);
      await env.userRobot.login().openChannel();

      step('WHEN the user swipes a message');
      await env.userRobot.swipeMessage();

      step('AND the user sends a message');
      await env.userRobot.sendMessage(quoteReply);

      step('THEN a quoted reply is sent');
      await env.userRobot.assertQuotedMessage(text: quoteReply, quote: sampleText);
    },
  );

  streamTestWithEnv(
    description: 'user adds a quoted reply to a message in the list',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step("WHEN the user adds a quoted reply to the participant's message");
      await env.userRobot.quoteMessage(quoteReply);

      step('THEN the user observes the quoted reply in the message list');
      await env.userRobot
          .assertQuotedMessage(text: quoteReply, quote: sampleText)
          .assertScrollToBottomButton(isDisplayed: false);
    },
  );

  streamTestWithEnv(
    description: 'participant adds a quoted reply to a message in the list',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.userRobot.login().openChannel();

      step("WHEN the participant adds a quoted reply to the user's message");
      await env.participantRobot.quoteMessage(quoteReply);

      step('THEN the user observes the quoted reply in the message list');
      await env.userRobot
          .assertQuotedMessage(text: quoteReply, quote: '1')
          .assertScrollToBottomButton(isDisplayed: false);
    },
  );

  streamTestWithEnv(
    description: 'user adds a quoted reply to a message that is not in the list',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: messagesCount);
      await env.userRobot.login().openChannel().waitForMessageListToLoad();

      step('WHEN the user adds a quoted reply to the oldest message');
      // Quoting the oldest message is what puts the quote far from the reply,
      // which is the point of the test; `quoteMessage` scrolls up to reach it.
      await env.userRobot.quoteMessage(quoteReply, quotedText: '1');

      step('THEN the user observes the quoted reply in the message list');
      await env.userRobot
          .assertQuotedMessage(text: quoteReply, quote: '1')
          .assertScrollToBottomButton(isDisplayed: false);

      step('WHEN the user taps the quoted message');
      await env.userRobot.tapQuotedMessage();

      step('THEN the user is scrolled up to the quote');
      await env.userRobot
          .assertQuotedMessage(text: quoteReply, isDisplayed: false)
          .assertScrollToBottomButton(isDisplayed: true);
    },
  );

  streamTestWithEnv(
    description: 'participant adds a quoted reply to a message that is not in the list',
    body: (env) async {
      const firstMessage = '1';

      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: messagesCount);
      await env.userRobot.login().openChannel();

      step("WHEN the participant adds a quoted reply to the user's oldest message");
      await env.participantRobot.quoteMessage(quoteReply, last: false);

      step('THEN the user observes the quoted reply in the message list');
      await env.userRobot
          .assertQuotedMessage(text: quoteReply, quote: firstMessage)
          .assertScrollToBottomButton(isDisplayed: false);

      step('WHEN the user taps the quoted message');
      await env.userRobot.tapQuotedMessage();

      step('THEN the user is scrolled up to the quote');
      await env.userRobot
          .assertQuotedMessage(text: quoteReply, isDisplayed: false)
          .assertScrollToBottomButton(isDisplayed: true);
    },
  );

  streamTestWithEnv(
    description: 'participant adds a quoted reply with a file to a message that is not in the list',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: messagesCount);
      await env.userRobot.login().openChannel();

      step("WHEN the participant adds a quoted reply with a file to the user's oldest message");
      await env.participantRobot.quoteMessageWithAttachment(AttachmentType.file, last: false);

      step('THEN the user observes the quoted reply in the message list');
      await env.userRobot.assertQuotedMessage(quote: '1');

      step('WHEN the user taps the quoted message');
      await env.userRobot.tapQuotedMessage();

      step('THEN the user is scrolled up to the quote');
      await env.userRobot.assertScrollToBottomButton(isDisplayed: true);
    },
  );

  streamTestWithEnv(
    description: 'participant adds a quoted reply with a giphy to a message that is not in the list',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: messagesCount);
      await env.userRobot.login().openChannel();

      step("WHEN the participant adds a quoted reply with a giphy to the user's oldest message");
      await env.participantRobot.quoteMessageWithGiphy(last: false);

      step('THEN the user observes the quoted reply in the message list');
      await env.userRobot.assertGiphy(isDisplayed: true);
    },
  );

  streamTestWithEnv(
    description: 'quoted reply deleted by the participant shows the deleted message',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.userRobot.login().openChannel();

      step('AND the participant adds a quoted reply');
      await env.participantRobot.quoteMessage(quoteReply);
      await env.userRobot.assertQuotedMessage(text: quoteReply, quote: '1');

      step('WHEN the participant deletes the quoted reply');
      await env.participantRobot.deleteMessage();

      step('THEN the user observes the deleted message');
      await env.userRobot.assertDeletedMessage().assertMessage(quoteReply, isDisplayed: false);
    },
  );

  streamTestWithEnv(
    description: 'original message deleted by the participant shows as deleted in the quote',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step('AND the user adds a quoted reply');
      await env.userRobot.quoteMessage(quoteReply);

      step('WHEN the participant deletes the original message');
      await env.participantRobot.deleteMessage();

      step('THEN the deleted message is shown in the quoted reply bubble');
      // The quote bubble previews the deleted message with the SDK's own
      // `messageDeletedLabel`, the same as the channel list does.
      await env.userRobot.assertQuotedMessage(text: quoteReply, quote: 'Message deleted');
    },
  );

  streamTestWithEnv(
    description: 'quoted reply deleted by the user shows the deleted message',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.userRobot.login().openChannel();

      step('AND the user adds a quoted reply');
      await env.userRobot.quoteMessage(quoteReply);
      await env.userRobot.assertQuotedMessage(text: quoteReply, quote: '1');

      step('WHEN the user deletes the quoted reply');
      await env.userRobot.deleteMessage(text: quoteReply);

      step('THEN the user observes the deleted message');
      await env.userRobot.assertDeletedMessage().assertMessage(quoteReply, isDisplayed: false);
    },
  );

  streamTestWithEnv(
    description: 'original message deleted by the user shows as deleted in the quote',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1, messagesText: sampleText);
      await env.userRobot.login().openChannel();

      step('AND the user adds a quoted reply');
      await env.userRobot.quoteMessage(quoteReply);
      await env.userRobot.assertQuotedMessage(text: quoteReply, quote: sampleText);

      step('WHEN the user deletes the original message');
      await env.userRobot.deleteMessage(text: sampleText);

      step('THEN the deleted message is shown in the quoted reply bubble');
      await env.userRobot.assertQuotedMessage(text: quoteReply, quote: 'Message deleted');
    },
  );

  streamTestWithEnv(
    description: 'user adds a quoted reply with an invalid command',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.userRobot.login().openChannel();

      step('WHEN the user quotes a message with an invalid command');
      await env.userRobot.quoteMessage('/$invalidCommand');

      step('THEN the user observes the invalid command message');
      await env.userRobot
          .assertInvalidCommandMessage(invalidCommand)
          .assertQuotedMessage(text: quoteReply, isDisplayed: false);
    },
  );

  // MARK: In a thread

  streamTestWithEnv(
    description: 'user adds a quoted reply in a thread',
    body: (env) async {
      step('GIVEN the user opens a channel with a thread');
      await env.backendRobot.generateChannels(
        channelsCount: 1,
        messagesCount: 1,
        messagesText: parentText,
        repliesCount: 1,
        repliesText: sampleText,
      );
      await env.userRobot.login().openChannel();

      step('WHEN the user adds a quoted reply to a message in the thread');
      await env.userRobot.openThread(parentText: parentText).quoteMessage(quoteReply);

      step('THEN the user observes the quoted reply in the thread');
      await env.userRobot
          .assertQuotedMessage(text: quoteReply, quote: sampleText)
          .assertScrollToBottomButton(isDisplayed: false);
    },
  );

  streamTestWithEnv(
    description: 'participant adds a quoted reply in a thread',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.userRobot.login().openChannel();

      step('AND the user sends a message in the thread');
      await env.userRobot.openThread().sendMessage(sampleText).assertMessage(sampleText);

      step("WHEN the participant adds a quoted reply to the user's message in the thread");
      await env.participantRobot.quoteMessageInThread(quoteReply);

      step('THEN the user observes the quoted reply in the thread');
      await env.userRobot
          .assertQuotedMessage(text: quoteReply, quote: sampleText)
          .assertScrollToBottomButton(isDisplayed: false);
    },
  );

  streamTestWithEnv(
    description: 'user adds a quoted reply in a thread to a message that is not in the list',
    // TODO(FLU-605): jumping to a quote inside a thread does not surface the scroll-to-bottom button (Android ignores this case on AND-76).
    skip: 'https://linear.app/stream/issue/FLU-605',
    body: (env) async {
      step('GIVEN the user opens a channel with a long thread');
      await env.backendRobot.generateChannels(
        channelsCount: 1,
        messagesCount: 1,
        messagesText: sampleText,
        repliesCount: messagesCount,
      );
      await env.userRobot.login().openChannel().waitForMessageListToLoad();

      step('WHEN the user adds a quoted reply to the oldest reply in the thread');
      // Quoting the oldest reply is what puts the quote far from the reply,
      // which is the point of the test; `quoteMessage` scrolls up to reach it.
      await env.userRobot.openThread(parentText: sampleText).quoteMessage(quoteReply, quotedText: '1');

      step('THEN the user observes the quoted reply in the thread');
      await env.userRobot
          .assertQuotedMessage(text: quoteReply, quote: '1')
          .assertScrollToBottomButton(isDisplayed: false);

      step('WHEN the user taps the quoted message');
      await env.userRobot.tapQuotedMessage();

      step('THEN the user is scrolled up to the quote');
      await env.userRobot
          .assertQuotedMessage(text: quoteReply, isDisplayed: false)
          .assertScrollToBottomButton(isDisplayed: true);
    },
  );

  streamTestWithEnv(
    description: 'participant adds a quoted reply in a thread to a message that is not in the list',
    // TODO(FLU-605): tapping a quote inside a thread does not scroll the reply out of view (Android ignores this case on AND-960).
    skip: 'https://linear.app/stream/issue/FLU-605',
    body: (env) async {
      step('GIVEN the user opens a channel with a long thread');
      await env.backendRobot.generateChannels(
        channelsCount: 1,
        messagesCount: 1,
        messagesText: sampleText,
        repliesCount: messagesCount,
      );
      await env.userRobot.login().openChannel();

      step("WHEN the participant adds a quoted reply to the user's oldest reply");
      await env.participantRobot.quoteMessageInThread(quoteReply, last: false);

      step('THEN the user observes the quoted reply in the thread');
      await env.userRobot
          .openThreadFromReplies()
          .assertQuotedMessage(text: quoteReply, quote: '1')
          .assertScrollToBottomButton(isDisplayed: false);

      step('WHEN the user taps the quoted message');
      await env.userRobot.tapQuotedMessage();

      step('THEN the user is scrolled up to the quote');
      await env.userRobot
          .assertQuotedMessage(text: quoteReply, isDisplayed: false)
          .assertScrollToBottomButton(isDisplayed: true);
    },
  );

  streamTestWithEnv(
    description: 'participant adds a quoted reply with a file in a thread',
    body: (env) async {
      step('GIVEN the user opens a channel with a long thread');
      await env.backendRobot.generateChannels(
        channelsCount: 1,
        messagesCount: 1,
        messagesText: sampleText,
        repliesCount: messagesCount,
      );
      await env.userRobot.login().openChannel();

      step("WHEN the participant adds a quoted reply with a file to the user's oldest reply");
      await env.participantRobot.quoteMessageWithAttachmentInThread(AttachmentType.file, last: false);

      step('THEN the user observes the quoted reply in the thread');
      await env.userRobot.openThreadFromReplies().assertQuotedMessage(quote: '1');
    },
  );

  streamTestWithEnv(
    description: 'participant adds a quoted reply with a giphy in a thread',
    body: (env) async {
      step('GIVEN the user opens a channel with a long thread');
      await env.backendRobot.generateChannels(
        channelsCount: 1,
        messagesCount: 1,
        messagesText: sampleText,
        repliesCount: messagesCount,
      );
      await env.userRobot.login().openChannel();

      step("WHEN the participant adds a quoted reply with a giphy to the user's oldest reply");
      await env.participantRobot.quoteMessageWithGiphyInThread(last: false);

      step('THEN the user observes the giphy in the thread');
      await env.userRobot.openThreadFromReplies().assertGiphy(isDisplayed: true);
    },
  );

  streamTestWithEnv(
    description: 'user adds a quoted reply with an invalid command in a thread',
    body: (env) async {
      step('GIVEN the user opens a channel with a thread');
      await env.backendRobot.generateChannels(
        channelsCount: 1,
        messagesCount: 1,
        messagesText: parentText,
        repliesCount: 1,
      );
      await env.userRobot.login().openChannel();

      step('WHEN the user quotes a message with an invalid command in the thread');
      await env.userRobot.openThread(parentText: parentText).quoteMessage('/$invalidCommand');

      step('THEN the user observes the invalid command message');
      await env.userRobot
          .assertInvalidCommandMessage(invalidCommand)
          .assertQuotedMessage(text: quoteReply, isDisplayed: false);
    },
  );

  // MARK: Thread reply count

  streamTestWithEnv(
    description: 'thread reply count shows one reply',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.userRobot.login().openChannel();

      step('WHEN the participant sends one thread reply');
      await env.participantRobot.sendMessageInThread(sampleText);

      step('THEN the user observes the thread reply count in the channel');
      // The channel footer hardcodes "N replies", so a single reply reads
      // "1 replies" — see `assertThreadReplyLabel`.
      await env.userRobot.assertThreadReplyLabel(replies: 1).assertThreadReplyLabelAvatars(count: 1);

      step('WHEN the user opens the thread');
      await env.userRobot.openThreadFromReplies();

      step('THEN the user observes one reply in the thread');
      await env.userRobot.assertThreadReplyLabel(replies: 1, inThread: true);
    },
  );

  streamTestWithEnv(
    description: 'thread reply count shows multiple replies',
    body: (env) async {
      const replies = 5;

      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.userRobot.login().openChannel();

      step('WHEN the participant sends multiple thread replies');
      for (var i = 0; i < replies; i++) {
        await env.participantRobot.sendMessageInThread(sampleText);
      }

      step('THEN the user observes the thread reply count in the channel');
      await env.userRobot.assertThreadReplyLabel(replies: replies).assertThreadReplyLabelAvatars(count: 1);

      step('WHEN the user opens the thread');
      await env.userRobot.openThreadFromReplies();

      step('THEN the user observes all the replies in the thread');
      await env.userRobot.assertThreadReplyLabel(replies: replies, inThread: true);
    },
  );

  // MARK: Thread reply also sent to the channel

  streamTestWithEnv(
    description: 'quoted reply in a thread is also shown in the channel when also sent there',
    body: (env) async {
      const quotedText = '$messagesCount';

      step('GIVEN the user opens a channel with a long thread');
      await env.backendRobot.generateChannels(
        channelsCount: 1,
        messagesCount: 1,
        messagesText: sampleText,
        repliesCount: messagesCount,
      );
      // Awaits the channel being fully loaded before the participant acts. The
      // parent itself is off screen (oldest message, 30 replies below it), so
      // this waits on the list rather than on the parent's text.
      await env.userRobot.login().openChannel().waitForMessageListToLoad();

      step('WHEN the participant adds a quoted reply in the thread and also in the channel');
      await env.participantRobot.quoteMessageInThread(quoteReply, alsoSendInChannel: true);

      step('THEN the user observes the quoted reply in the channel');
      await env.userRobot
          .assertQuotedMessage(text: quoteReply, quote: quotedText)
          .assertScrollToBottomButton(isDisplayed: false);

      step('AND the user observes the quoted reply in the thread as well');
      await env.userRobot
          .openThreadFromReplies()
          .assertQuotedMessage(text: quoteReply, quote: quotedText)
          .assertScrollToBottomButton(isDisplayed: false);
    },
  );

  // MARK: Deletions in a thread

  streamTestWithEnv(
    description: 'quoted reply deleted by the participant shows the deleted message in a thread',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.userRobot.login().openChannel();

      step('AND the participant adds a quoted reply in the thread');
      await env.participantRobot.quoteMessageInThread(quoteReply);

      step('WHEN the participant deletes the quoted reply');
      await env.participantRobot.deleteMessage();

      step('THEN the user observes the deleted message in the thread');
      await env.userRobot.openThreadFromReplies().assertDeletedMessage();
    },
  );

  streamTestWithEnv(
    description: 'original message deleted by the participant shows as deleted in the quote in a thread',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.userRobot.login().openChannel();

      step('AND the participant sends a message in the thread');
      await env.participantRobot.sendMessageInThread(sampleText);

      step('AND the user adds a quoted reply in the thread');
      await env.userRobot.openThreadFromReplies().quoteMessage(quoteReply);

      step('WHEN the participant deletes the original message');
      await env.participantRobot.deleteMessage();

      step('THEN the deleted message is shown in the quoted reply bubble');
      await env.userRobot.assertQuotedMessage(text: quoteReply, quote: 'Message deleted');
    },
  );

  streamTestWithEnv(
    description: 'quoted reply deleted by the user shows the deleted message in a thread',
    body: (env) async {
      step('GIVEN the user opens a channel with a thread');
      await env.backendRobot.generateChannels(
        channelsCount: 1,
        messagesCount: 1,
        messagesText: parentText,
        repliesCount: 1,
        repliesText: sampleText,
      );
      await env.userRobot.login().openChannel();

      step('AND the user adds a quoted reply in the thread');
      await env.userRobot.openThread(parentText: parentText).quoteMessage(quoteReply);
      await env.userRobot.assertQuotedMessage(text: quoteReply, quote: sampleText);

      step('WHEN the user deletes the quoted reply');
      await env.userRobot.deleteMessage(text: quoteReply);

      step('THEN the user observes the deleted message');
      await env.userRobot.assertDeletedMessage().assertMessage(quoteReply, isDisplayed: false);
    },
  );

  streamTestWithEnv(
    description: 'original message deleted by the user shows as deleted in the quote in a thread',
    body: (env) async {
      step('GIVEN the user opens a channel with a thread');
      await env.backendRobot.generateChannels(
        channelsCount: 1,
        messagesCount: 1,
        messagesText: parentText,
        repliesCount: 1,
        repliesText: sampleText,
      );
      await env.userRobot.login().openChannel();

      step('AND the user adds a quoted reply in the thread');
      await env.userRobot.openThread(parentText: parentText).quoteMessage(quoteReply);

      step('WHEN the user deletes the original message');
      await env.userRobot.deleteMessage(text: sampleText);

      step('THEN the deleted message is shown in the quoted reply bubble');
      await env.userRobot.assertQuotedMessage(text: quoteReply, quote: 'Message deleted');
    },
  );

  // MARK: Thread root message

  streamTestWithEnv(
    description: 'thread root message is only visible on the last page of the thread',
    // TODO(FLU-605): the thread renders its root message twice once an older page is paged in.
    skip: 'https://linear.app/stream/issue/FLU-605',
    body: (env) async {
      step('GIVEN the user opens a channel with a long thread');
      await env.backendRobot.generateChannels(
        channelsCount: 1,
        messagesCount: 1,
        messagesText: sampleText,
        repliesCount: messagesCount,
      );
      await env.userRobot.login().openChannel();

      step('WHEN the user opens the thread');
      await env.userRobot.openThreadFromReplies();

      step('THEN the parent message is not loaded');
      await env.userRobot.assertMessages(text: sampleText, count: 0);

      step('WHEN the user scrolls up to load one more page');
      await env.userRobot.scrollMessageListUp(times: 8);

      step('THEN the parent message is loaded');
      await env.userRobot.assertMessages(text: sampleText, count: 1);
    },
  );

  streamTestWithEnv(
    description: 'user quotes the thread root message when it is not in the list',
    // TODO(FLU-605): same as the two cases above — jumping to a quote inside a
    // thread does not surface the scroll-to-bottom button.
    skip: 'https://linear.app/stream/issue/FLU-605',
    body: (env) async {
      step('GIVEN the user opens a long thread');
      await env.backendRobot.generateChannels(
        channelsCount: 1,
        messagesCount: 1,
        messagesText: sampleText,
        repliesCount: messagesCount,
      );
      await env.userRobot.login().openChannel().openThreadFromReplies();

      step('WHEN the user quotes the root message');
      await env.userRobot.scrollMessageListUp(times: 5).quoteMessage(quoteReply, quotedText: sampleText);

      step('AND the user re-enters the thread');
      await env.userRobot.tapBackButton().openThreadFromReplies();

      step('AND the user jumps to the root message');
      await env.userRobot.tapQuotedMessage();

      step('THEN the root message is loaded');
      await env.userRobot
          .assertQuotedMessage(text: quoteReply, isDisplayed: false)
          .assertScrollToBottomButton(isDisplayed: true);
    },
  );
}
