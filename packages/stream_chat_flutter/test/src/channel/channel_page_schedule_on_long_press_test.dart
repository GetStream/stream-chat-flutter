import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';
import 'channel_page_harness.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(Message());
    registerFallbackValue(DateTime(2026));
  });

  void stubSchedule(MockChannel channel, Future<ScheduleMessageResponse> Function() answer) {
    when(
      () => channel.scheduleMessage(any(), scheduledAt: any(named: 'scheduledAt')),
    ).thenAnswer((_) => answer());
  }

  testWidgets('schedules the message for the picked time on a long press of send, then clears it', (tester) async {
    final channel = await pumpChannelPage(tester);
    stubSchedule(channel, () async => ScheduleMessageResponse()..message = Message());
    await _type(tester, 'Hello');
    final controller = composerController(tester);

    await _scheduleWithPreset(tester);

    final [scheduled, _] = verify(
      () => channel.scheduleMessage(captureAny(), scheduledAt: captureAny(named: 'scheduledAt')),
    ).captured;
    expect((scheduled as Message).text, 'Hello');
    expect(controller.text, isEmpty);
  });

  testWidgets('keeps the composer clear when scheduling fails in a way that can be retried', (tester) async {
    final channel = await pumpChannelPage(tester);
    stubSchedule(channel, () async => throw const StreamNetworkException(message: 'Offline'));
    await _type(tester, 'Hello');

    await _scheduleWithPreset(tester);

    expect(composerController(tester).text, isEmpty);
  });

  testWidgets('says so when an attachment fails to upload', (tester) async {
    final channel = await pumpChannelPage(tester);
    final clientState = channel.client.state;
    when(() => channel.scheduleMessage(any(), scheduledAt: any(named: 'scheduledAt'))).thenAnswer((invocation) async {
      final message = invocation.positionalArguments.first as Message;
      final image = Attachment(
        type: AttachmentType.image,
        uploadState: const .failed(error: 'Offline'),
      );
      final failed = ScheduledMessage(
        id: message.id,
        cid: 'test-channel-type:test-channel-id',
        user: User(id: 'user-id'),
        message: message.copyWith(attachments: [image]),
        scheduledAt: DateTime(2026, 10, 23, 9),
        status: ScheduledMessageStatus.failed,
        failure: const ScheduledMessageFailure.schedulingFailed(),
      );
      when(() => clientState.scheduledMessages).thenReturn([failed]);
      throw const StreamClientException(message: 'Failed to upload one or more attachments');
    });
    await _type(tester, 'Hello');

    await _scheduleWithPreset(tester);

    final text = DefaultTranslations.instance.scheduledMessageAttachmentUploadFailedText;
    expect(find.text(text), findsOneWidget);
  });

  testWidgets('says nothing when the message is deleted while its attachments upload', (tester) async {
    final channel = await pumpChannelPage(tester);
    stubSchedule(
      channel,
      () async =>
          throw const StreamNetworkException(message: 'The attachment uploads were canceled', isCancelled: true),
    );
    await _type(tester, 'Hello');

    await _scheduleWithPreset(tester);

    expect(find.byType(StreamSnackbar), findsNothing);
  });

  testWidgets('schedules a message whose attachment is not uploaded yet', (tester) async {
    final channel = await pumpChannelPage(tester);
    stubSchedule(channel, () async => ScheduleMessageResponse()..message = Message());
    await _type(tester, 'Hello');
    final attachment = Attachment(
      id: 'image',
      type: AttachmentType.image,
      file: AttachmentFile(size: 1, path: 'image.png'),
    );
    composerController(tester).addAttachment(attachment);
    await tester.pumpAndSettle();

    await _scheduleWithPreset(tester);

    final scheduled =
        verify(
              () => channel.scheduleMessage(captureAny(), scheduledAt: any(named: 'scheduledAt')),
            ).captured.single
            as Message;
    expect(scheduled.attachments.single.id, 'image');
  });

  testWidgets('keeps the text and the mentions in the composer when scheduling is refused', (tester) async {
    final channel = await pumpChannelPage(tester);
    stubSchedule(channel, () async => throw const ScheduledMessageRefusedError(.scheduledMessageIsCommand, 'Refused'));
    final maya = User(id: 'maya', name: 'Maya');
    await _type(tester, 'Hi @Maya');
    final controller = composerController(tester)..addMentionedUser(maya);
    await tester.pumpAndSettle();

    await _scheduleWithPreset(tester);

    expect(controller.text, 'Hi @Maya');
    expect(controller.mentionedUsers, [maya]);
    expect(find.text(DefaultTranslations.instance.scheduleCommandRefusedError), findsOneWidget);
  });

  testWidgets('says the quoted message was deleted when scheduling is refused for it', (tester) async {
    final channel = await pumpChannelPage(tester);
    stubSchedule(
      channel,
      () async => throw const ScheduledMessageRefusedError(.scheduledMessageQuoteDeleted, 'Refused'),
    );
    await _type(tester, 'Hello');

    await _scheduleWithPreset(tester);

    expect(find.text(DefaultTranslations.instance.scheduleQuotedMessageDeletedError), findsOneWidget);
  });

  testWidgets("says the message can't be scheduled when trying again won't help", (tester) async {
    final channel = await pumpChannelPage(tester);
    stubSchedule(
      channel,
      () async => throw const ScheduledMessageRefusedError(.scheduledMessageNotEditable, 'Refused'),
    );
    await _type(tester, 'Hello');

    await _scheduleWithPreset(tester);

    expect(find.text(DefaultTranslations.instance.scheduleMessageRefusedError), findsOneWidget);
  });

  testWidgets("says the message can't be scheduled when the server refuses it without a reason", (tester) async {
    final channel = await pumpChannelPage(tester);
    const refused = StreamApiException(message: 'Refused', statusCode: 400, code: StreamErrorCode.inputError);
    stubSchedule(channel, () async => throw refused);
    await _type(tester, 'Hello');

    await _scheduleWithPreset(tester);

    expect(find.text(DefaultTranslations.instance.scheduleMessageRefusedError), findsOneWidget);
  });

  testWidgets('says why the server refused to schedule the message', (tester) async {
    final channel = await pumpChannelPage(tester);
    when(() => channel.config).thenReturn(ChannelConfig(scheduledMessagesMaxPerUser: 100));
    const limitReached = StreamApiException(
      message: 'Too many scheduled messages',
      statusCode: 400,
      code: StreamErrorCode(118),
    );
    stubSchedule(channel, () async => throw limitReached);
    await _type(tester, 'Hello');

    await _scheduleWithPreset(tester);

    expect(find.text(DefaultTranslations.instance.scheduleUserLimitReachedError(limit: 100)), findsOneWidget);
    expect(composerController(tester).text, 'Hello');
  });

  testWidgets('keeps text typed while the message is scheduled, as a new message', (tester) async {
    final channel = await pumpChannelPage(tester);
    final answer = Completer<ScheduleMessageResponse>();
    stubSchedule(channel, () => answer.future);
    await _type(tester, 'First');
    final controller = composerController(tester);
    final scheduledId = controller.value.id;

    await _scheduleWithPreset(tester);
    controller.text = 'Second';
    answer.complete(ScheduleMessageResponse()..message = Message(id: scheduledId));
    await tester.pumpAndSettle();

    expect(controller.text, 'Second');
    expect(controller.value.id, isNot(scheduledId));
  });

  testWidgets("offers no long press of send where the user can't schedule", (tester) async {
    await pumpChannelPage(tester, canSchedule: false);
    await _type(tester, 'Hello');

    expect(_sendButton(tester).props.onLongPress, isNull);
  });

  testWidgets('offers neither the long press nor the banner when scheduled messages are turned off', (tester) async {
    await pumpChannelPage(
      tester,
      scheduledMessages: [scheduledMessage()],
      configData: StreamChatConfigurationData(scheduledMessagesEnabled: false),
    );
    await _type(tester, 'Hello');

    expect(_sendButton(tester).props.onLongPress, isNull);
    expect(find.byType(StreamScheduledMessagesBanner), findsNothing);
  });

  testWidgets('schedules on the channel the page is swapped to', (tester) async {
    final swap = ValueNotifier<MockChannel?>(null);
    addTearDown(swap.dispose);
    final first = await pumpChannelPage(tester, canSchedule: false, channelSwap: swap);
    final second = stubPageChannel(first.client as MockClient);
    stubSchedule(second, () async => ScheduleMessageResponse()..message = Message());

    swap.value = second;
    await tester.pumpAndSettle();
    await _type(tester, 'Hello');
    await _scheduleWithPreset(tester);

    verify(() => second.scheduleMessage(any(), scheduledAt: any(named: 'scheduledAt'))).called(1);
  });

  testWidgets('clears the composer once a time is picked', (tester) async {
    final channel = await pumpChannelPage(tester);
    stubSchedule(channel, () => Completer<ScheduleMessageResponse>().future);
    await _type(tester, 'Hello');

    await _scheduleWithPreset(tester);

    expect(composerController(tester).text, isEmpty);
  });

  testWidgets('puts a refused message back in the composer', (tester) async {
    final channel = await pumpChannelPage(tester);
    stubSchedule(channel, () async => throw const ScheduledMessageRefusedError(.scheduledMessageIsCommand, 'Refused'));
    await _type(tester, 'Hello');

    await _scheduleWithPreset(tester);

    expect(composerController(tester).text, 'Hello');
  });

  testWidgets("doesn't put a refused message back over text typed meanwhile", (tester) async {
    final channel = await pumpChannelPage(tester);
    final answer = Completer<ScheduleMessageResponse>();
    stubSchedule(channel, () => answer.future);
    await _type(tester, 'Hello');

    await _scheduleWithPreset(tester);
    await _type(tester, 'Something else');
    answer.completeError(const ScheduledMessageRefusedError(.scheduledMessageIsCommand, 'Refused'));
    await tester.pumpAndSettle();

    expect(composerController(tester).text, 'Something else');
  });

  for (final (name, error) in [
    ('the server is unreachable', const StreamNetworkException(message: 'No connection')),
    (
      'it was already sent',
      const StreamApiException(message: 'Already sent', statusCode: 400, code: StreamErrorCode(123)),
    ),
  ]) {
    testWidgets('keeps the composer cleared when $name', (tester) async {
      final channel = await pumpChannelPage(tester);
      stubSchedule(channel, () async => throw error);
      await _type(tester, 'Hello');

      await _scheduleWithPreset(tester);

      expect(composerController(tester).text, isEmpty);
      expect(find.byType(StreamSnackbar), findsNothing);
    });
  }

  testWidgets('clears the attachments and the quote once scheduled', (tester) async {
    final channel = await pumpChannelPage(tester);
    stubSchedule(channel, () async => ScheduleMessageResponse()..message = Message());
    await _type(tester, 'Hello');
    final controller = composerController(tester)
      ..attachments = [
        Attachment(type: AttachmentType.image, imageUrl: 'https://example.com/a.png', uploadState: const .success()),
      ]
      ..quotedMessage = Message(id: 'quoted-id', text: 'Earlier');
    await tester.pumpAndSettle();

    await _scheduleWithPreset(tester);

    expect(controller.attachments, isEmpty);
    expect(controller.message.quotedMessage, isNull);
  });

  testWidgets('offers the long press once the user can schedule', (tester) async {
    // Broadcast, as the page and its composer each follow the capabilities.
    final capabilities = StreamController<List<ChannelCapability>>.broadcast();
    addTearDown(capabilities.close);
    await pumpChannelPage(tester, canSchedule: false, capabilitiesUpdates: capabilities.stream);
    await _type(tester, 'Hello');
    expect(_sendButton(tester).props.onLongPress, isNull);

    capabilities.add([ChannelCapability.sendMessage, ChannelCapability.scheduleMessage]);
    await tester.pumpAndSettle();

    expect(_sendButton(tester).props.onLongPress, isNotNull);
  });
}

Future<void> _type(WidgetTester tester, String text) async {
  await tester.enterText(find.byType(EditableText), text);
  await tester.pumpAndSettle();
}

StreamButton _sendButton(WidgetTester tester) {
  return tester.widget<StreamButton>(find.byKey(const ValueKey('send_key')));
}

// Long-presses send, and picks the first preset of the schedule sheet.
Future<void> _scheduleWithPreset(WidgetTester tester) async {
  _sendButton(tester).props.onLongPress!();
  await tester.pumpAndSettle();

  await tester.tap(find.textContaining('Tomorrow').first);
  await tester.pumpAndSettle();
}
