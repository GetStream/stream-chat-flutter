import 'mock_server/data_types.dart';
import 'robots/user_robot.dart';
import 'robots/user_robot_message_list_asserts.dart';
import 'support/step.dart';
import 'support/stream_test_case.dart';

void main() {
  // MARK: User uploads

  streamTestWithEnv(
    allureId: '12653',
    description: 'user uploads an image',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user attaches an image');
      await env.userRobot.attachFile(AttachmentType.image);

      step('THEN the image is displayed in the composer');
      await env.userRobot.assertAttachmentsInComposer(AttachmentType.image);

      step('WHEN the user sends the image');
      await env.userRobot.tapOnSendButton();

      step('THEN the user can see the uploaded image');
      await env.userRobot.assertImage(isDisplayed: true);
    },
  );

  streamTestWithEnv(
    allureId: '12654',
    description: 'user uploads multiple images',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user attaches multiple images');
      await env.userRobot.attachFile(AttachmentType.image, count: 2);

      step('THEN the images are displayed in the composer');
      await env.userRobot.assertAttachmentsInComposer(AttachmentType.image, count: 2);

      step('WHEN the user sends the images');
      await env.userRobot.tapOnSendButton();

      step('THEN the user can see the uploaded images');
      await env.userRobot.assertImage(isDisplayed: true, count: 2);
    },
  );

  streamTestWithEnv(
    allureId: '12655',
    description: 'user deletes an image',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user sends an image');
      await env.userRobot.attachFile(AttachmentType.image).tapOnSendButton().assertImage(isDisplayed: true);

      step('AND the user deletes the image');
      await env.userRobot.deleteMessage();

      step('THEN the user can see the deleted message');
      await env.userRobot.assertImage(isDisplayed: false).assertDeletedMessage();
    },
  );

  streamTestWithEnv(
    allureId: '12656',
    description: 'user uploads a file',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user attaches a file');
      await env.userRobot.attachFile(AttachmentType.file);

      step('THEN the file is displayed in the composer');
      await env.userRobot.assertAttachmentsInComposer(AttachmentType.file);

      step('WHEN the user sends the file');
      await env.userRobot.tapOnSendButton();

      step('THEN the user can see the uploaded file');
      await env.userRobot.assertFile(isDisplayed: true);
    },
  );

  streamTestWithEnv(
    allureId: '12657',
    description: 'user uploads multiple files',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user attaches multiple files');
      await env.userRobot.attachFile(AttachmentType.file, count: 2);

      step('THEN the files are displayed in the composer');
      await env.userRobot.assertAttachmentsInComposer(AttachmentType.file, count: 2);

      step('WHEN the user sends the files');
      await env.userRobot.tapOnSendButton();

      step('THEN the user can see the uploaded files');
      await env.userRobot.assertFile(isDisplayed: true, count: 2);
    },
  );

  streamTestWithEnv(
    allureId: '12658',
    description: 'user deletes a file',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user sends a file');
      await env.userRobot.attachFile(AttachmentType.file).tapOnSendButton().assertFile(isDisplayed: true);

      step('AND the user deletes the file');
      await env.userRobot.deleteMessage();

      step('THEN the user can see the deleted message');
      await env.userRobot.assertFile(isDisplayed: false).assertDeletedMessage();
    },
  );

  streamTestWithEnv(
    allureId: '12659',
    description: 'user uploads a video',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user sends a video');
      await env.userRobot.attachFile(AttachmentType.video).tapOnSendButton();

      step('THEN the user can see the uploaded video');
      await env.userRobot.assertVideo(isDisplayed: true);
    },
  );

  streamTestWithEnv(
    allureId: '12660',
    description: 'image upload recovers when the user comes back online',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the user goes offline');
      await env.goOffline();

      step('WHEN the user sends an image while offline');
      await env.userRobot.attachFile(AttachmentType.image).tapOnSendButton();
      // The composer reports the failed send through FlutterError.
      await env.takeExpectedError();

      step('AND the user comes back online');
      await env.goOnline();

      step('THEN the image is uploaded');
      await env.userRobot.assertImage(isDisplayed: true).assertMessageDeliveryStatus(MessageDeliveryStatus.sent);
    },
  );

  // MARK: Participant uploads

  streamTestWithEnv(
    allureId: '12661',
    description: 'participant uploads an image',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the participant uploads an image');
      await env.participantRobot.uploadAttachment(AttachmentType.image);

      step('THEN the user can see the uploaded image');
      await env.userRobot.assertImage(isDisplayed: true);
    },
  );

  streamTestWithEnv(
    allureId: '12662',
    description: 'participant uploads multiple images',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the participant uploads multiple images');
      await env.participantRobot.uploadAttachment(AttachmentType.image, count: 2);

      step('THEN the user can see the images in one message');
      await env.userRobot.assertImage(isDisplayed: true, count: 2);
    },
  );

  streamTestWithEnv(
    allureId: '12663',
    description: 'participant uploads a video',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the participant uploads a video');
      await env.participantRobot.uploadAttachment(AttachmentType.video);

      step('THEN the user can see the uploaded video');
      await env.userRobot.assertVideo(isDisplayed: true);
    },
  );

  streamTestWithEnv(
    allureId: '12664',
    description: 'participant uploads a file',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the participant uploads a file');
      await env.participantRobot.uploadAttachment(AttachmentType.file);

      step('THEN the user can see the uploaded file');
      await env.userRobot.assertFile(isDisplayed: true);
    },
  );

  streamTestWithEnv(
    allureId: '12665',
    description: 'user swipes between images in the gallery',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant uploads multiple images');
      await env.participantRobot.uploadAttachment(AttachmentType.image, count: 2);

      step('WHEN the user opens the first image');
      await env.userRobot.assertImage(isDisplayed: true, count: 2).openImageInGallery();

      step('THEN the gallery shows the first image');
      await env.userRobot.assertGalleryPosition(1, total: 2);

      step('WHEN the user swipes to the next image');
      await env.userRobot.swipeToNextImageInGallery();

      step('THEN the gallery shows the second image');
      await env.userRobot.assertGalleryPosition(2, total: 2);
    },
  );
}
