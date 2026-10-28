import 'robots/user_robot.dart';
import 'robots/user_robot_message_list_asserts.dart';
import 'support/step.dart';
import 'support/stream_test_case.dart';

void main() {
  // The mock server serves a canned OG response for each of these hosts.
  const unsplashLink = 'https://unsplash.com/photos/1_2d3MRbI9c';
  const youtubeLink = 'https://youtube.com/watch?v=xOX7MsrbaPY';
  const giphyLink = 'https://giphy.com/gifs/test-gw3IWyGkC0rsazTi';

  // Dismissing the composer's preview doesn't send `skip_enrich_url`.
  const enrichedAfterDismissal = 'https://linear.app/stream/issue/FLU-1089';

  streamTestWithEnv(
    allureId: '12706',
    description: 'user sends a Unsplash link with a preview',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user types a Unsplash url');
      await env.userRobot.typeText('Look at $unsplashLink');

      step('THEN the user observes a link preview in the composer');
      await env.userRobot.assertLinkPreviewInComposer(isDisplayed: true);

      step('WHEN the user taps on the send button');
      await env.userRobot.tapOnSendButton();

      step('THEN the user observes the message with a link preview');
      await env.userRobot
          .assertMessageWithLink('Look at $unsplashLink', link: unsplashLink)
          .assertLinkPreviewInMessageList(isDisplayed: true);
    },
  );

  streamTestWithEnv(
    allureId: '12707',
    description: 'user sends a Unsplash link without a preview',
    skip: enrichedAfterDismissal,
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user types a Unsplash url');
      await env.userRobot.typeText('Look at $unsplashLink').assertLinkPreviewInComposer(isDisplayed: true);

      step('AND the user cancels the link preview');
      await env.userRobot.tapOnLinkPreviewCancelButton();

      step('THEN the link preview disappears');
      await env.userRobot.assertLinkPreviewInComposer(isDisplayed: false);

      step('WHEN the user taps on the send button');
      await env.userRobot.tapOnSendButton();

      step('THEN the user observes the message without a link preview');
      await env.userRobot
          .assertMessageWithLink('Look at $unsplashLink', link: unsplashLink)
          .assertLinkPreviewInMessageList(isDisplayed: false);
    },
  );

  streamTestWithEnv(
    allureId: '12708',
    description: 'participant sends a Unsplash link',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the participant sends a Unsplash url');
      await env.participantRobot.sendMessage('Look at $unsplashLink');

      step('THEN the user observes the message with a link preview');
      await env.userRobot
          .assertMessageWithLink('Look at $unsplashLink', link: unsplashLink)
          .assertLinkPreviewInMessageList(isDisplayed: true);
    },
  );

  streamTestWithEnv(
    allureId: '12709',
    description: 'user sends a YouTube link with a preview',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user types a YouTube url');
      await env.userRobot.typeText('Look at $youtubeLink');

      step('THEN the user observes a link preview in the composer');
      await env.userRobot.assertLinkPreviewInComposer(isDisplayed: true);

      step('WHEN the user taps on the send button');
      await env.userRobot.tapOnSendButton();

      step('THEN the user observes the message with a link preview');
      await env.userRobot
          .assertMessageWithLink('Look at $youtubeLink', link: youtubeLink)
          .assertLinkPreviewInMessageList(isDisplayed: true);
    },
  );

  streamTestWithEnv(
    allureId: '12710',
    description: 'user sends a YouTube link without a preview',
    skip: enrichedAfterDismissal,
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user types a YouTube url');
      await env.userRobot.typeText('Look at $youtubeLink').assertLinkPreviewInComposer(isDisplayed: true);

      step('AND the user cancels the link preview');
      await env.userRobot.tapOnLinkPreviewCancelButton();

      step('THEN the link preview disappears');
      await env.userRobot.assertLinkPreviewInComposer(isDisplayed: false);

      step('WHEN the user taps on the send button');
      await env.userRobot.tapOnSendButton();

      step('THEN the user observes the message without a link preview');
      await env.userRobot
          .assertMessageWithLink('Look at $youtubeLink', link: youtubeLink)
          .assertLinkPreviewInMessageList(isDisplayed: false);
    },
  );

  streamTestWithEnv(
    allureId: '12711',
    description: 'participant sends a YouTube link',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the participant sends a YouTube url');
      await env.participantRobot.sendMessage('Look at $youtubeLink');

      step('THEN the user observes the message with a link preview');
      await env.userRobot
          .assertMessageWithLink('Look at $youtubeLink', link: youtubeLink)
          .assertLinkPreviewInMessageList(isDisplayed: true);
    },
  );

  streamTestWithEnv(
    allureId: '12712',
    description: 'user sends a Giphy link with a preview',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user types a Giphy url');
      await env.userRobot.typeText('Look at $giphyLink');

      step('THEN the user observes a link preview in the composer');
      await env.userRobot.assertLinkPreviewInComposer(isDisplayed: true);

      step('WHEN the user taps on the send button');
      await env.userRobot.tapOnSendButton();

      step('THEN the user observes the message with a link preview');
      await env.userRobot
          .assertMessageWithLink('Look at $giphyLink', link: giphyLink)
          .assertLinkPreviewInMessageList(isDisplayed: true);
    },
  );

  streamTestWithEnv(
    allureId: '12713',
    description: 'user sends a Giphy link without a preview',
    skip: enrichedAfterDismissal,
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user types a Giphy url');
      await env.userRobot.typeText('Look at $giphyLink').assertLinkPreviewInComposer(isDisplayed: true);

      step('AND the user cancels the link preview');
      await env.userRobot.tapOnLinkPreviewCancelButton();

      step('THEN the link preview disappears');
      await env.userRobot.assertLinkPreviewInComposer(isDisplayed: false);

      step('WHEN the user taps on the send button');
      await env.userRobot.tapOnSendButton();

      step('THEN the user observes the message without a link preview');
      await env.userRobot
          .assertMessageWithLink('Look at $giphyLink', link: giphyLink)
          .assertLinkPreviewInMessageList(isDisplayed: false);
    },
  );

  streamTestWithEnv(
    allureId: '12714',
    description: 'participant sends a Giphy link',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the participant sends a Giphy url');
      await env.participantRobot.sendMessage('Look at $giphyLink');

      step('THEN the user observes the message with a link preview');
      await env.userRobot
          .assertMessageWithLink('Look at $giphyLink', link: giphyLink)
          .assertLinkPreviewInMessageList(isDisplayed: true);
    },
  );
}
