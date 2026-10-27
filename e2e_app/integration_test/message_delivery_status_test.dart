import 'package:flutter_test/flutter_test.dart';

import 'mock_server/data_types.dart';
import 'pages/message_list_page.dart';
import 'robots/participant_robot.dart';
import 'robots/user_robot.dart';
import 'robots/user_robot_channel_list_asserts.dart';
import 'robots/user_robot_message_list_asserts.dart';
import 'support/step.dart';
import 'support/stream_test_case.dart';

void main() {
  const sampleText = 'Test';
  const threadReply = 'thread reply';
  const newParticipantId = 'leia_organa';

  // MARK: Message list

  streamTestWithEnv(
    allureId: '12716',
    description: 'single checkmark is shown when a message is sent',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user sends a new message');
      await env.userRobot.sendMessage(sampleText);

      step('THEN the user spots a single checkmark below the message');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.sent);
    },
  );

  streamTestWithEnv(
    allureId: '12717',
    description: 'delivery status shows clocks when a message is pending',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user sends a new message that is held by the server');
      // The mock server's `freeze_messages` answers 408 at once, which Flutter
      // treats as a failed send; holding the response keeps it pending instead.
      await env.backendRobot.delayNewMessages();
      await env.userRobot.sendMessage('pending message');

      step('THEN the message delivery status shows clocks');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.pending);
      // Let the held send complete, so it can't land in the next test.
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.sent);
    },
  );

  streamTestWithEnv(
    allureId: '12718',
    description: 'error indicator is shown when a message fails to be sent',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user sends a new message that is going to fail');
      await env.backendRobot.failNewMessages();
      await env.userRobot.sendMessage('failed message');
      await env.takeExpectedError();

      step('THEN an error indicator is shown for the message');
      await env.userRobot.assertMessageFailedToBeSent();
    },
  );

  streamTestWithEnv(
    allureId: '12719',
    description: 'double checkmark is shown when the participant reads a message',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the user successfully sends a new message');
      await env.userRobot.sendMessage(sampleText).assertMessageDeliveryStatus(MessageDeliveryStatus.sent);

      step("WHEN the participant reads the user's message");
      await env.participantRobot.readMessage();

      step('THEN the user spots a double checkmark below the message');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.read);
    },
  );

  streamTestWithEnv(
    allureId: '12720',
    description: 'delivered checkmark turns read when the participant reads the message',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the user successfully sends a new message');
      await env.userRobot.sendMessage(sampleText).assertMessageDeliveryStatus(MessageDeliveryStatus.sent);

      step('AND the message is delivered to the participant but not read');
      await env.participantRobot.markAsDelivered();

      step('THEN the message delivery status shows it as delivered');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.delivered);

      step('WHEN the participant reads the message');
      await env.participantRobot.readMessage();

      step('THEN the message delivery status shows it as read');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.read);
    },
  );

  streamTestWithEnv(
    allureId: '12721',
    description: 'delivery status is shown for the last message in a group',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the user successfully sends a new message');
      await env.userRobot.sendMessage(sampleText).assertMessageDeliveryStatus(MessageDeliveryStatus.sent, count: 1);

      step('WHEN the user sends another message');
      await env.userRobot.sendMessage('$sampleText 2').assertMessage('$sampleText 2');

      step('THEN the delivery status of the previous message is hidden');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.sent, count: 1);
    },
  );

  streamTestWithEnv(
    // The native suites disagree: Android and UIKit hide the status of a deleted
    // message, SwiftUI keeps it (`test_deliveryStatusShown_whenMessageIsDeleted`).
    allureId: '12722',
    description: 'delivery status is shown when a message is deleted',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the user successfully sends a new message');
      await env.userRobot.sendMessage(sampleText).assertMessageDeliveryStatus(MessageDeliveryStatus.sent);

      step('WHEN the user deletes the message');
      await env.userRobot.deleteMessage().assertDeletedMessage();

      step('THEN the delivery status is still shown');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.sent);
    },
  );

  streamTestWithEnv(
    allureId: '12723',
    description: 'delivery status is shown for the previous message when an error message is shown',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the user successfully sends a new message');
      await env.userRobot.sendMessage(sampleText).assertMessageDeliveryStatus(MessageDeliveryStatus.sent);

      step('WHEN the user sends a message with an invalid command');
      await env.userRobot.sendMessage('/command').assertInvalidCommandMessage('command');

      step('THEN the delivery status is shown for the first message');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.sent, count: 1);
    },
  );

  streamTestWithEnv(
    allureId: '12724',
    description: 'delivery status is shown for the previous message when a new message fails to be sent',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the user successfully sends a new message');
      await env.userRobot.sendMessage(sampleText).assertMessageDeliveryStatus(MessageDeliveryStatus.sent);

      step('WHEN the user sends a message that is going to fail');
      await env.backendRobot.failNewMessages();
      await env.userRobot.sendMessage('failed message');
      await env.takeExpectedError();

      step('THEN an error indicator is shown for the failed message');
      await env.userRobot.assertMessageFailedToBeSent();

      step('AND the delivery status is shown for the previous message');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.sent, messageIndex: 1);
    },
  );

  streamTestWithEnv(
    allureId: '12725',
    description: 'message that failed to be sent cannot be previewed in a thread',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the user becomes offline');
      await env.goOffline();

      step('WHEN the user sends a new message');
      await env.userRobot.sendMessage('failed message');
      await env.takeExpectedError();

      step('THEN an error indicator is shown for the message');
      await env.userRobot.assertMessageFailedToBeSent().assertMessageDeliveryStatus(MessageDeliveryStatus.nil);

      step('AND the user cannot preview the message in a thread');
      expect(await env.userRobot.hasMessageAction(MessageListPage.actions.threadReply), isFalse);

      await env.goOnline();
    },
  );

  streamTestWithEnv(
    allureId: '12726',
    description: 'double checkmark is still shown when a new participant is added',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the user successfully sends a new message');
      await env.userRobot.sendMessage(sampleText).assertMessageDeliveryStatus(MessageDeliveryStatus.sent);

      step('AND the participant reads the message');
      await env.participantRobot.readMessage();
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.read);

      step('WHEN a new participant is added to the channel');
      await env.backendRobot.addMember(newParticipantId);

      step('THEN the user still spots a double checkmark below the message');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.read);
    },
  );

  streamTestWithEnv(
    allureId: '12727',
    description: 'read status is dropped when the participant is removed',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the user successfully sends a new message');
      await env.userRobot.sendMessage(sampleText).assertMessageDeliveryStatus(MessageDeliveryStatus.sent);

      step('AND the participant reads the message');
      await env.participantRobot.readMessage();
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.read);

      step('WHEN the participant is removed from the channel');
      await env.backendRobot.removeMember(ParticipantRobot.id);

      step('THEN the user observes a single checkmark below the message');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.sent);
    },
  );

  // MARK: Threads

  streamTestWithEnv(
    allureId: '12728',
    description: 'single checkmark is shown when a message is sent and previewed in a thread',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the user successfully sends a new message');
      await env.userRobot.sendMessage(sampleText).assertMessageDeliveryStatus(MessageDeliveryStatus.sent);

      step('WHEN the user previews the thread of the message');
      await env.userRobot.openThread();

      step('THEN the user spots a single checkmark below the message');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.sent);

      step('WHEN the participant reads the message');
      await env.participantRobot.readMessage();

      step('THEN the user spots a double checkmark below the message');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.read);
    },
  );

  streamTestWithEnv(
    allureId: '12729',
    description: 'single checkmark is shown when a thread reply is sent',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the participant sends a new message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step('AND the user replies to the message in a thread');
      await env.userRobot.openThread().sendMessageInThread(threadReply);

      step('THEN the user spots a single checkmark below the thread reply');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.sent);
    },
  );

  streamTestWithEnv(
    allureId: '12730',
    description: 'error indicator is shown when a thread reply fails to be sent',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.userRobot.login().openChannel();

      step('WHEN the user sends a thread reply that is going to fail');
      await env.backendRobot.failNewMessages();
      await env.userRobot.openThread().sendMessageInThread(sampleText);
      await env.takeExpectedError();

      step('THEN an error indicator is shown for the thread reply');
      await env.userRobot.assertMessageFailedToBeSent();
    },
  );

  streamTestWithEnv(
    allureId: '12731',
    description: 'double checkmark is shown when the participant reads a thread reply',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.userRobot.login().openChannel();

      step('WHEN the user replies to the message in a thread');
      await env.userRobot.openThread().sendMessageInThread(sampleText);

      step('AND the thread reply is delivered');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.sent);

      step("AND the participant reads the user's thread reply");
      await env.participantRobot.readMessage();

      step('THEN the user spots a double checkmark below the thread reply');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.read);
    },
  );

  streamTestWithEnv(
    allureId: '12732',
    description: 'double checkmark is shown when the participant reads a thread reply also sent to the channel',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a new message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step('AND the user sends a thread reply also to the channel');
      await env.userRobot.openThread().sendMessageInThread(threadReply, alsoSendInChannel: true);

      step('AND the thread reply delivery status shows a single checkmark');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.sent);

      step('WHEN the participant reads the thread reply');
      await env.participantRobot.readMessage();

      step('THEN the thread reply delivery status shows a double checkmark');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.read);

      step('AND the thread reply delivery status shows a double checkmark in the channel');
      await env.userRobot.tapBackButton().assertMessageDeliveryStatus(MessageDeliveryStatus.read);
    },
  );

  streamTestWithEnv(
    allureId: '12733',
    description: 'delivery status is shown for the last thread reply in a group',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.userRobot.login().openChannel();

      step('WHEN the user replies to the message in a thread');
      await env.userRobot.openThread().sendMessageInThread(sampleText);

      step('AND the delivery status shows a single checkmark');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.sent, count: 2);

      step('AND the user sends another thread reply');
      await env.userRobot.sendMessageInThread('$sampleText 2').assertMessage('$sampleText 2');

      step('THEN the delivery status of the previous thread reply is hidden');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.sent, count: 2);
    },
  );

  streamTestWithEnv(
    // SwiftUI's `test_deliveryStatusShown_whenThreadReplyIsDeleted`; see the
    // deleted message case above.
    allureId: '12734',
    description: 'delivery status is shown when a thread reply is deleted',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.userRobot.login().openChannel();

      step('AND the user successfully sends a thread reply');
      await env.userRobot.openThread().sendMessageInThread(sampleText);
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.sent, count: 2);

      step('WHEN the user deletes the thread reply');
      await env.userRobot.deleteMessage().assertDeletedMessage();

      step('THEN the delivery status is still shown for the thread reply');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.sent, count: 2);
    },
  );

  streamTestWithEnv(
    allureId: '12735',
    description: 'thread reply has no double checkmark when a new participant is added',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a new message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step('AND the user replies to the message in a thread');
      await env.userRobot.openThread().sendMessageInThread(threadReply);

      step('WHEN a new participant is added to the channel');
      await env.backendRobot.addMember(newParticipantId);

      step('THEN the user spots a single checkmark below the thread reply');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.sent);
    },
  );

  streamTestWithEnv(
    allureId: '12736',
    description: 'read status of a thread reply is dropped when the participant is removed',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.backendRobot.generateChannels(channelsCount: 1, messagesCount: 1);
      await env.userRobot.login().openChannel();

      step('AND the user replies to the message in a thread');
      await env.userRobot.openThread().sendMessageInThread(sampleText);
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.sent);

      step('AND the participant reads the thread reply');
      await env.participantRobot.readMessage();
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.read);

      step('WHEN the participant is removed from the channel');
      await env.backendRobot.removeMember(ParticipantRobot.id);

      step('THEN the user observes a single checkmark below the thread reply');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.sent);
    },
  );

  // MARK: Channel preview

  streamTestWithEnv(
    allureId: '12737',
    description: 'channel preview shows clocks when the last message is pending',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user sends a new message that is held by the server');
      // The mock server's `freeze_messages` answers 408 at once, which Flutter
      // treats as a failed send; holding the response keeps it pending instead.
      await env.backendRobot.delayNewMessages();
      await env.userRobot.sendMessage(sampleText);

      step('AND the user returns to the channel list');
      await env.userRobot.tapBackButton();

      step('THEN the channel preview shows clocks');
      await env.userRobot.assertMessagePreviewDeliveryStatus(MessageDeliveryStatus.pending);
      // Let the held send complete, so it can't land in the next test.
      await env.userRobot.assertMessagePreviewDeliveryStatus(MessageDeliveryStatus.sent);
    },
  );

  streamTestWithEnv(
    allureId: '12738',
    description: 'channel preview shows a single checkmark when the last message is sent',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the user sends a new message');
      await env.userRobot.sendMessage(sampleText).assertMessageDeliveryStatus(MessageDeliveryStatus.sent);

      step('WHEN the user returns to the channel list');
      await env.userRobot.tapBackButton();

      step('THEN the channel preview shows a single checkmark');
      await env.userRobot.assertMessagePreviewDeliveryStatus(MessageDeliveryStatus.sent);
    },
  );

  streamTestWithEnv(
    allureId: '12739',
    description: 'channel preview shows an error indicator when the message fails to be sent',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the user sends a new message that is going to fail');
      await env.backendRobot.failNewMessages();
      await env.userRobot.sendMessage(sampleText);
      await env.takeExpectedError();

      step('AND the user returns to the channel list');
      await env.userRobot.tapBackButton();

      step('THEN the channel preview shows an error indicator');
      await env.userRobot.assertMessagePreviewDeliveryStatus(MessageDeliveryStatus.failed);
    },
  );

  streamTestWithEnv(
    allureId: '12740',
    description: 'channel preview shows a double checkmark when the participant reads the message',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the user sends a new message');
      await env.userRobot.sendMessage(sampleText).assertMessageDeliveryStatus(MessageDeliveryStatus.sent);

      step('WHEN the user returns to the channel list');
      await env.userRobot.tapBackButton();

      step('AND the participant reads the message');
      await env.participantRobot.readMessage();

      step('THEN the channel preview shows a double checkmark');
      await env.userRobot.assertMessagePreviewDeliveryStatus(MessageDeliveryStatus.read);
    },
  );

  streamTestWithEnv(
    allureId: '12741',
    description: 'channel preview shows no delivery status when the participant sends the message',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('WHEN the participant sends a new message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step('AND the user returns to the channel list');
      await env.userRobot.tapBackButton();

      step('THEN the delivery status is hidden');
      await env.userRobot
          .assertMessageInChannelPreview(sampleText, fromCurrentUser: false)
          .assertMessagePreviewDeliveryStatus(MessageDeliveryStatus.nil);
    },
  );

  streamTestWithEnv(
    allureId: '12742',
    description: 'channel preview shows no delivery status when the user sends a thread reply',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a new message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step('AND the user replies to the message in a thread');
      await env.userRobot.openThread().sendMessageInThread(threadReply).assertThreadReply(threadReply);

      step('WHEN the user returns to the channel list');
      await env.userRobot.moveToChannelListFromThread();

      step('THEN the delivery status is hidden');
      await env.userRobot
          .assertMessageInChannelPreview(sampleText, fromCurrentUser: false)
          .assertMessagePreviewDeliveryStatus(MessageDeliveryStatus.nil);
    },
  );

  streamTestWithEnv(
    allureId: '12743',
    description: 'channel preview shows a single checkmark when a thread reply is pending',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the user sends a new message');
      await env.userRobot.sendMessage('1').assertMessageDeliveryStatus(MessageDeliveryStatus.sent);

      step('AND the user sends a thread reply that is held by the server');
      await env.userRobot.openThread();
      // The mock server's `freeze_messages` answers 408 at once, which Flutter
      // treats as a failed send; holding the response keeps it pending instead.
      await env.backendRobot.delayNewMessages();
      await env.userRobot.sendMessageInThread('2');

      step('WHEN the user returns to the channel list');
      await env.userRobot.moveToChannelListFromThread();

      step('THEN the channel preview shows a single checkmark');
      await env.userRobot.assertMessagePreviewDeliveryStatus(MessageDeliveryStatus.sent);
      // Let the held thread reply complete, so it can't land in the next test.
      await env.userRobot.openChannel().openThreadFromReplies().assertMessageDeliveryStatus(MessageDeliveryStatus.sent);
    },
  );

  streamTestWithEnv(
    allureId: '12744',
    description: 'channel preview shows no delivery status when the participant reads a thread reply',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a new message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step('AND the user replies to the message in a thread');
      await env.userRobot.openThread().sendMessageInThread(threadReply).assertThreadReply(threadReply);

      step("AND the participant reads the user's thread reply");
      await env.participantRobot.readMessage();

      step('WHEN the user returns to the channel list');
      await env.userRobot.moveToChannelListFromThread();

      step('THEN the delivery status is hidden');
      await env.userRobot.assertMessagePreviewDeliveryStatus(MessageDeliveryStatus.nil);
    },
  );

  streamTestWithEnv(
    allureId: '12745',
    description: 'channel preview shows no delivery status when the participant sends a thread reply',
    body: (env) async {
      step('GIVEN the user opens a channel');
      await env.userRobot.login().openChannel();

      step('AND the participant sends a new message');
      await env.participantRobot.sendMessage(sampleText);
      await env.userRobot.assertMessage(sampleText);

      step('AND the participant replies to the message in a thread');
      await env.participantRobot.sendMessageInThread(threadReply);
      await env.userRobot.assertThreadReplyLabel(replies: 1);

      step('WHEN the user returns to the channel list');
      await env.userRobot.tapBackButton();

      step('THEN the delivery status is hidden');
      await env.userRobot.assertMessagePreviewDeliveryStatus(MessageDeliveryStatus.nil);
    },
  );

  // MARK: Read events disabled

  streamTestWithEnv(
    allureId: '12746',
    description: 'delivery status is hidden when a message is sent and read events are disabled',
    skip: 'https://linear.app/stream/issue/FLU-1091',
    body: (env) async {
      step('GIVEN read events are disabled and the user opens a channel');
      await env.backendRobot.setReadEvents(enabled: false);
      await env.userRobot.login().openChannel();

      step('WHEN the user sends a new message');
      await env.userRobot.sendMessage(sampleText).assertMessage(sampleText);

      step('THEN the delivery status is hidden');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.nil);
    },
  );

  streamTestWithEnv(
    allureId: '12747',
    description: 'delivery status shows clocks when a message is pending and read events are disabled',
    body: (env) async {
      step('GIVEN read events are disabled and the user opens a channel');
      await env.backendRobot.setReadEvents(enabled: false);
      await env.userRobot.login().openChannel();

      step('WHEN the user sends a new message that is held by the server');
      // The mock server's `freeze_messages` answers 408 at once, which Flutter
      // treats as a failed send; holding the response keeps it pending instead.
      await env.backendRobot.delayNewMessages();
      await env.userRobot.sendMessage('pending message');

      step('THEN the message delivery status shows clocks');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.pending);
      // Let the held send complete, so it can't land in the next test.
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.sent);
    },
  );

  streamTestWithEnv(
    allureId: '12748',
    description: 'error indicator is shown when a message fails to be sent and read events are disabled',
    body: (env) async {
      step('GIVEN read events are disabled and the user opens a channel');
      await env.backendRobot.setReadEvents(enabled: false);
      await env.userRobot.login().openChannel();

      step('WHEN the user sends a new message that is going to fail');
      await env.backendRobot.failNewMessages();
      await env.userRobot.sendMessage('failed message');
      await env.takeExpectedError();

      step('THEN an error indicator is shown for the message');
      await env.userRobot.assertMessageFailedToBeSent();
    },
  );

  streamTestWithEnv(
    allureId: '12749',
    description: 'delivery status is hidden when the participant reads a message and read events are disabled',
    skip: 'https://linear.app/stream/issue/FLU-1091',
    body: (env) async {
      step('GIVEN read events are disabled and the user opens a channel');
      await env.backendRobot.setReadEvents(enabled: false);
      await env.userRobot.login().openChannel();

      step('AND the user sends a new message');
      await env.userRobot.sendMessage(sampleText).assertMessage(sampleText);

      step('WHEN the participant reads the message');
      await env.participantRobot.readMessage();

      step('THEN the delivery status is hidden');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.nil);
    },
  );

  streamTestWithEnv(
    allureId: '12750',
    description: 'delivery status is hidden when a new participant is added and read events are disabled',
    skip: 'https://linear.app/stream/issue/FLU-1091',
    body: (env) async {
      step('GIVEN read events are disabled and the user opens a channel');
      await env.backendRobot.setReadEvents(enabled: false);
      await env.userRobot.login().openChannel();

      step('AND the user sends a new message');
      await env.userRobot.sendMessage(sampleText).assertMessage(sampleText);

      step('AND the participant reads the message');
      await env.participantRobot.readMessage();

      step('WHEN a new participant is added to the channel');
      await env.backendRobot.addMember(newParticipantId);

      step('THEN the delivery status is hidden');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.nil);
    },
  );

  streamTestWithEnv(
    allureId: '12751',
    description: 'delivery status is hidden when the participant is removed and read events are disabled',
    skip: 'https://linear.app/stream/issue/FLU-1091',
    body: (env) async {
      step('GIVEN read events are disabled and the user opens a channel');
      await env.backendRobot.setReadEvents(enabled: false);
      await env.userRobot.login().openChannel();

      step('AND the user sends a new message');
      await env.userRobot.sendMessage(sampleText).assertMessage(sampleText);

      step('AND the participant reads the message');
      await env.participantRobot.readMessage();

      step('WHEN the participant is removed from the channel');
      await env.backendRobot.removeMember(ParticipantRobot.id);

      step('THEN the delivery status is hidden');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.nil);
    },
  );

  streamTestWithEnv(
    allureId: '12752',
    description: 'delivery status is hidden for grouped messages when read events are disabled',
    skip: 'https://linear.app/stream/issue/FLU-1091',
    body: (env) async {
      step('GIVEN read events are disabled and the user opens a channel');
      await env.backendRobot.setReadEvents(enabled: false);
      await env.userRobot.login().openChannel();

      step('AND the user sends a new message');
      await env.userRobot.sendMessage(sampleText).assertMessage(sampleText);

      step('WHEN the user sends another message');
      await env.userRobot.sendMessage('second message').assertMessage('second message');

      step('THEN the delivery status is hidden for all messages');
      await env.userRobot
          .assertMessageDeliveryStatus(MessageDeliveryStatus.nil)
          .assertMessageDeliveryStatus(MessageDeliveryStatus.nil, messageIndex: 1);
    },
  );

  streamTestWithEnv(
    allureId: '12753',
    description: 'delivery status is hidden when a message is deleted and read events are disabled',
    skip: 'https://linear.app/stream/issue/FLU-1091',
    body: (env) async {
      step('GIVEN read events are disabled and the user opens a channel');
      await env.backendRobot.setReadEvents(enabled: false);
      await env.userRobot.login().openChannel();

      step('AND the user sends a new message');
      await env.userRobot.sendMessage(sampleText).assertMessage(sampleText);

      step('AND the delivery status is hidden');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.nil);

      step('WHEN the user deletes the message');
      await env.userRobot.deleteMessage().assertDeletedMessage();

      step('THEN the delivery status stays hidden');
      await env.userRobot.assertMessageDeliveryStatus(MessageDeliveryStatus.nil);
    },
  );

  streamTestWithEnv(
    allureId: '12754',
    description: 'channel preview shows no delivery status when read events are disabled',
    skip: 'https://linear.app/stream/issue/FLU-1091',
    body: (env) async {
      step('GIVEN read events are disabled and the user opens a channel');
      await env.backendRobot.setReadEvents(enabled: false);
      await env.userRobot.login().openChannel();

      step('AND the user sends a new message');
      await env.userRobot.sendMessage(sampleText).assertMessage(sampleText);

      step('WHEN the user returns to the channel list');
      await env.userRobot.tapBackButton();

      step('THEN the delivery status is hidden in the channel preview');
      await env.userRobot
          .assertMessageInChannelPreview(sampleText, fromCurrentUser: true)
          .assertMessagePreviewDeliveryStatus(MessageDeliveryStatus.nil);
    },
  );
}
