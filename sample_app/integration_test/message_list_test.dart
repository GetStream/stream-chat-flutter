import 'robots/user_robot.dart';
import 'robots/user_robot_message_list_asserts.dart';
import 'support/step.dart';
import 'support/stream_test_case.dart';

// Ported from the native MessageList suites (`MessageList_Tests.swift` /
// `MessageListTests.kt`), adapted to the in-process integration_test setup.
// A few native cases can't run under this binding (offline writes throw, the
// lifecycle reconnect hangs, url_launcher opens the real browser on-device) and
// are kept as documented `skip:`s.
//
// TODO(allure): fill each test's `allureId` from Allure TestOps project 135.
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

  streamTestWithEnv(
    description: 'user adds a message while offline',
    skip:
        'Offline channel.sendMessage throws an unhandled async StreamChatNetworkError '
        'that the integration_test binding surfaces (and poisons the bundle with). '
        'The message is still optimistically queued; the throw is the harness limitation.',
    body: (env) async {
      // Placeholder mirroring native test_addMessageWhileOffline. See skip reason.
    },
  );

  streamTestWithEnv(
    description: 'user recovers a message received while in the background',
    skip:
        'Lifecycle-driven reconnect (moveToForeground → client.maybeReconnect) spins '
        'indefinitely under the in-process integration_test binding and hangs the run.',
    body: (env) async {
      // Placeholder mirroring native test_offlineRecoveryWithinSession. See skip reason.
    },
  );

  // MARK: Thread replies

  streamTestWithEnv(
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
    description: 'thread reply also sent to the channel appears in both places',
    skip:
        "The in-channel copy of a thread reply doesn't expose a 'Thread Reply' action, "
        'so openThread() must target the parent message reliably first (needs a stable selector).',
    body: (env) async {
      // Placeholder; the channel-side assertion works, opening the thread from
      // the in-channel reply does not. See skip reason.
    },
  );

  streamTestWithEnv(
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

  // MARK: Deleted messages

  streamTestWithEnv(
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

  // MARK: Mentions

  streamTestWithEnv(
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

  // MARK: Scroll to bottom

  streamTestWithEnv(
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

  // MARK: Pagination

  streamTestWithEnv(
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

  // MARK: Link previews

  // Link previews are asserted on a participant-sent YouTube message: the
  // composer suppresses enrichment on the user's own outgoing link, and the
  // mock server only serves a canned OG response for YouTube URLs.
  streamTestWithEnv(
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

  streamTestWithEnv(
    description: 'message with a link opens the browser',
    skip:
        'On-device, url_launcher opens the real browser (the plugin uses its own '
        'Pigeon channel, not the mocked plugins.flutter.io/url_launcher). Verifying '
        'in-process would require overriding UrlLauncherPlatform.instance (extra dep).',
    body: (env) async {
      // Placeholder mirroring native test_messageWithLinkOpensSafari. See skip reason.
    },
  );

  // MARK: Message grouping & size

  streamTestWithEnv(
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
    description: 'composer does not grow beyond its line limit',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('THEN the composer grows with input but stops at its cap');
      await env.userRobot.assertComposerGrowsWithinLimit();
    },
  );
}
