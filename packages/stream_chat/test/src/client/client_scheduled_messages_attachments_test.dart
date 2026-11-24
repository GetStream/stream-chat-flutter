import 'dart:async';

import 'package:clock/clock.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import 'scheduled_messages_harness.dart';

void main() {
  final harness = useScheduledMessageClient();
  setUpAll(() => registerFallbackValue(FakeAttachmentFile()));

  final now = DateTime.utc(2026, 10, 30, 12);
  final scheduledAt = now.add(const Duration(days: 1));
  const imageUrl = 'https://example.com/image.png';
  final uploadError = StreamChatNetworkError(ChatErrorCode.internalSystemError);

  Future<ScheduleMessageResponse> schedule(Message message) {
    return _schedule(harness, message, now: now, scheduledAt: scheduledAt);
  }

  test('scheduleMessage lists its attachment as preparing while it uploads', () async {
    _stubImageUpload(harness, (_) => Completer<SendImageResponse>().future);

    schedule(_withImage()).ignore();
    await settle();

    final [listed] = harness.client.state.scheduledMessages;
    expect(listed.message.attachments.single.uploadState, const UploadState.preparing());
  });

  test('scheduleMessage lists the upload progress of its attachment against the size of its file', () async {
    _stubImageUpload(harness, (invocation) {
      // The request is larger than the file, as it also sends the framing.
      final onSendProgress = invocation.namedArguments[#onSendProgress] as ProgressCallback;
      onSendProgress(60, 120);
      return Completer<SendImageResponse>().future;
    });
    final message = Message(
      id: 'message',
      attachments: [
        Attachment(
          id: 'image',
          type: AttachmentType.image,
          file: AttachmentFile(size: 100, path: 'image.png'),
        ),
      ],
    );

    schedule(message).ignore();
    await settle();

    final [listed] = harness.client.state.scheduledMessages;
    expect(listed.message.attachments.single.uploadState, const UploadState.inProgress(uploaded: 50, total: 100));
  });

  test('scheduleMessage schedules the message with its attachment uploaded', () async {
    _stubImageUpload(harness, (_) async => SendImageResponse()..file = imageUrl);
    _stubSchedule(harness);

    await schedule(_withImage());

    final sent = _verifyScheduled(harness).captured.single as Message;
    expect(sent.attachments.single.imageUrl, imageUrl);
  });

  test('scheduleMessage throws when an attachment fails to upload', () async {
    _stubImageUpload(harness, (_) async => throw uploadError);

    await expectLater(schedule(_withImage()), throwsA(isA<StreamChatError>()));
  });

  test('scheduleMessage leaves one whose attachment failed to upload listed as failed', () async {
    _stubImageUpload(harness, (_) async => throw uploadError);

    await _ignoringFailure(schedule(_withImage()));
    await settle();

    final [failed] = harness.client.state.scheduledMessages;
    expect(failed.failureReason, ScheduledMessageFailureReason.attachmentUploadFailed);
  });

  test('scheduleMessage marks an attachment that failed to upload as failed', () async {
    _stubImageUpload(harness, (_) async => throw uploadError);

    await _ignoringFailure(schedule(_withImage()));
    await settle();

    final [failed] = harness.client.state.scheduledMessages;
    expect(failed.message.attachments.single.uploadState.isFailed, isTrue);
  });

  test('scheduleMessage does not schedule one whose attachment failed to upload', () async {
    _stubImageUpload(harness, (_) async => throw uploadError);

    await _ignoringFailure(schedule(_withImage()));

    _verifyNeverScheduled(harness);
  });

  test('scheduleMessage does not schedule one whose user disconnected while it uploaded', () async {
    final upload = Completer<SendImageResponse>();
    _stubImageUpload(harness, (_) => upload.future);
    _stubSchedule(harness);
    final scheduling = _ignoringFailure(schedule(_withImage()));
    await settle();

    await harness.client.disconnectUser();
    upload.complete(SendImageResponse()..file = imageUrl);
    await scheduling;

    _verifyNeverScheduled(harness);
  });

  test('resendScheduledMessage uploads a failed attachment again', () async {
    var attempt = 0;
    _stubImageUpload(harness, (_) async {
      attempt += 1;
      if (attempt == 1) throw uploadError;
      return SendImageResponse()..file = imageUrl;
    });
    _stubSchedule(harness);
    await _ignoringFailure(schedule(_withImage()));
    await settle();

    await harness.client.resendScheduledMessage(harness.client.state.scheduledMessages.single.id);

    final sent = _verifyScheduled(harness).captured.single as Message;
    expect(sent.attachments.single.imageUrl, imageUrl);
  });

  test('resendScheduledMessage does not upload an attachment that was uploaded', () async {
    final uploads = <String?>[];
    var failSecond = true;
    _stubImageUpload(harness, (invocation) async {
      final file = invocation.positionalArguments.first as AttachmentFile;
      uploads.add(file.path);
      if (file.path == 'second.png' && failSecond) throw uploadError;
      return SendImageResponse()..file = imageUrl;
    });
    _stubSchedule(harness);
    await _ignoringFailure(schedule(_withImages(['first', 'second'])));
    await settle();
    failSecond = false;

    await harness.client.resendScheduledMessage(harness.client.state.scheduledMessages.single.id);

    expect(uploads.where((it) => it == 'first.png'), hasLength(1));
  });

  test('deleteScheduledMessage cancels the upload of its attachment', () async {
    final cancelTokens = <CancelToken>[];
    _stubImageUpload(harness, (invocation) async {
      cancelTokens.add(invocation.namedArguments[#cancelToken] as CancelToken);
      return _uploadUntilCanceled(invocation);
    });
    final scheduling = _ignoringFailure(schedule(_withImage()));
    await settle();

    await harness.client.deleteScheduledMessage(harness.client.state.scheduledMessages.single.id);
    await scheduling;

    expect(cancelTokens.single.isCancelled, isTrue);
  });

  test('deleteScheduledMessage makes the scheduleMessage of one still uploading throw', () async {
    _stubImageUpload(harness, _uploadUntilCanceled);
    final scheduling = expectLater(schedule(_withImage()), throwsA(isA<StreamChatError>()));
    await settle();

    await harness.client.deleteScheduledMessage(harness.client.state.scheduledMessages.single.id);

    await scheduling;
  });

  test('deleteScheduledMessage removes one still uploading', () async {
    _stubImageUpload(harness, _uploadUntilCanceled);
    final scheduling = _ignoringFailure(schedule(_withImage()));
    await settle();

    await harness.client.deleteScheduledMessage(harness.client.state.scheduledMessages.single.id);
    await scheduling;
    await settle();

    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('deleteScheduledMessage makes no request for one still uploading', () async {
    _stubImageUpload(harness, _uploadUntilCanceled);
    final scheduling = _ignoringFailure(schedule(_withImage()));
    await settle();

    await harness.client.deleteScheduledMessage(harness.client.state.scheduledMessages.single.id);
    await scheduling;

    verifyNever(() => harness.api.scheduledMessages.deleteScheduledMessage(any()));
  });

  test('deleteScheduledMessage does not schedule one still uploading', () async {
    _stubImageUpload(harness, _uploadUntilCanceled);
    final scheduling = _ignoringFailure(schedule(_withImage()));
    await settle();

    await harness.client.deleteScheduledMessage(harness.client.state.scheduledMessages.single.id);
    await scheduling;

    _verifyNeverScheduled(harness);
  });

  test('deleteScheduledMessage makes no request for one whose attachment failed to upload', () async {
    _stubImageUpload(harness, (_) async => throw uploadError);
    await _ignoringFailure(schedule(_withImage()));
    await settle();

    await harness.client.deleteScheduledMessage(harness.client.state.scheduledMessages.single.id);

    verifyNever(() => harness.api.scheduledMessages.deleteScheduledMessage(any()));
  });

  test('deleteScheduledMessage removes one whose attachment failed to upload', () async {
    _stubImageUpload(harness, (_) async => throw uploadError);
    when(
      () => harness.api.scheduledMessages.deleteScheduledMessage(any()),
    ).thenAnswer((_) async => throw missingError);
    await _ignoringFailure(schedule(_withImage()));
    await settle();

    await harness.client.deleteScheduledMessage(harness.client.state.scheduledMessages.single.id);
    await settle();

    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('updateScheduledMessage uploads the new attachment first', () async {
    final scheduledMessage = fakeScheduledMessage('a');
    await harness.hold([scheduledMessage]);
    _stubImageUpload(harness, (_) async => SendImageResponse()..file = imageUrl);
    _stubUpdate(harness, scheduledMessage);

    await harness.client.updateScheduledMessage(scheduledMessage.id, _withImage(id: 'a'));

    final sent = _verifyUpdated(harness).captured.single as Message;
    expect(sent.attachments.single.imageUrl, imageUrl);
  });

  test('deleteScheduledMessage makes the updateScheduledMessage still uploading its attachment throw', () async {
    final scheduledMessage = fakeScheduledMessage('a');
    await harness.hold([scheduledMessage]);
    _stubUploadUntilCanceled(harness);
    _stubDelete(harness, scheduledMessage);
    final editing = expectLater(
      harness.client.updateScheduledMessage(scheduledMessage.id, _withImage(id: 'a')),
      throwsA(isA<StreamChatError>()),
    );
    await settle();

    await harness.client.deleteScheduledMessage(scheduledMessage.id);

    await editing;
  });

  test('deleteScheduledMessage sends the delete request for one being edited', () async {
    final scheduledMessage = fakeScheduledMessage('a');
    await harness.hold([scheduledMessage]);
    _stubUploadUntilCanceled(harness);
    _stubDelete(harness, scheduledMessage);
    final editing = _ignoringFailure(harness.client.updateScheduledMessage(scheduledMessage.id, _withImage(id: 'a')));
    await settle();

    await harness.client.deleteScheduledMessage(scheduledMessage.id);
    await editing;

    verify(() => harness.api.scheduledMessages.deleteScheduledMessage('a')).called(1);
  });

  test('scheduleMessage again for the same message cancels its earlier attachment upload', () async {
    final cancelTokens = _stubUploadUntilCanceled(harness);
    final first = _ignoringFailure(schedule(_withImages(['first'])));
    await settle();

    final second = _ignoringFailure(schedule(_withImages(['second'])));
    await settle();

    expect(cancelTokens.first.isCancelled, isTrue);
    await harness.client.deleteScheduledMessage(harness.client.state.scheduledMessages.single.id);
    await Future.wait([first, second]);
  });

  test('updateScheduledMessage sends nothing when the new attachment fails to upload', () async {
    final scheduledMessage = fakeScheduledMessage('a');
    await harness.hold([scheduledMessage]);
    _stubImageUpload(harness, (_) async => throw uploadError);

    await _ignoringFailure(harness.client.updateScheduledMessage(scheduledMessage.id, _withImage(id: 'a')));

    _verifyNeverUpdated(harness);
  });

  test('updateScheduledMessage refuses one still uploading to be scheduled', () async {
    _stubUploadUntilCanceled(harness);
    final scheduling = _ignoringFailure(schedule(_withImage()));
    await settle();
    final listed = harness.client.state.scheduledMessages.single;

    await expectLater(harness.client.updateScheduledMessage(listed.id, _edited(listed)), throwsStateError);

    await harness.client.deleteScheduledMessage(listed.id);
    await scheduling;
  });

  test('updateScheduledMessage keeps uploading the attachment of one still being scheduled', () async {
    final cancelTokens = _stubUploadUntilCanceled(harness);
    final scheduling = _ignoringFailure(schedule(_withImage()));
    await settle();
    final listed = harness.client.state.scheduledMessages.single;

    await _ignoringFailure(harness.client.updateScheduledMessage(listed.id, _edited(listed)));

    expect(cancelTokens.single.isCancelled, isFalse);
    await harness.client.deleteScheduledMessage(listed.id);
    await scheduling;
  });

  test('rescheduleMessage refuses one still uploading to be scheduled', () async {
    _stubUploadUntilCanceled(harness);
    final scheduling = _ignoringFailure(schedule(_withImage()));
    await settle();
    final listed = harness.client.state.scheduledMessages.single;

    await expectLater(harness.client.rescheduleMessage(listed.id, scheduledAt: scheduledAt), throwsStateError);

    await harness.client.deleteScheduledMessage(listed.id);
    await scheduling;
  });

  test('sendScheduledMessageNow refuses one still uploading to be scheduled', () async {
    _stubUploadUntilCanceled(harness);
    final scheduling = _ignoringFailure(schedule(_withImage()));
    await settle();
    final listed = harness.client.state.scheduledMessages.single;

    await expectLater(harness.client.sendScheduledMessageNow(listed.id), throwsStateError);

    await harness.client.deleteScheduledMessage(listed.id);
    await scheduling;
  });

  test('deleteScheduledMessage lists an edit stopped while it uploads as failed when the request fails', () async {
    final scheduledMessage = fakeScheduledMessage('a');
    await harness.hold([scheduledMessage]);
    _stubUploadUntilCanceled(harness);
    final error = StreamChatNetworkError(ChatErrorCode.internalSystemError);
    when(
      () => harness.api.scheduledMessages.deleteScheduledMessage(any()),
    ).thenAnswer((_) async => throw error);
    final editing = _ignoringFailure(harness.client.updateScheduledMessage(scheduledMessage.id, _withImage(id: 'a')));
    await settle();

    await _ignoringFailure(harness.client.deleteScheduledMessage(scheduledMessage.id));
    await editing;
    await settle();

    final [listed] = harness.client.state.scheduledMessages;
    expect(listed.failureReason, ScheduledMessageFailureReason.updateFailed);
  });

  test('sendScheduledMessageNow refuses one whose edit is uploading', () async {
    final scheduledMessage = fakeScheduledMessage('a');
    await harness.hold([scheduledMessage]);
    _stubUploadUntilCanceled(harness);
    _stubDelete(harness, scheduledMessage);
    final editing = _ignoringFailure(harness.client.updateScheduledMessage(scheduledMessage.id, _withImage(id: 'a')));
    await settle();

    await expectLater(harness.client.sendScheduledMessageNow(scheduledMessage.id), throwsStateError);

    await harness.client.deleteScheduledMessage(scheduledMessage.id);
    await editing;
  });

  test('updateScheduledMessage refuses one whose edit is uploading', () async {
    final scheduledMessage = fakeScheduledMessage('a');
    await harness.hold([scheduledMessage]);
    _stubUploadUntilCanceled(harness);
    _stubDelete(harness, scheduledMessage);
    final editing = _ignoringFailure(harness.client.updateScheduledMessage(scheduledMessage.id, _withImage(id: 'a')));
    await settle();

    await expectLater(
      harness.client.updateScheduledMessage(scheduledMessage.id, _edited(scheduledMessage)),
      throwsStateError,
    );

    await harness.client.deleteScheduledMessage(scheduledMessage.id);
    await editing;
  });

  test('disconnecting cancels the attachment upload of one being scheduled', () async {
    final cancelTokens = _stubUploadUntilCanceled(harness);
    final scheduling = _ignoringFailure(schedule(_withImage()));
    await settle();

    await harness.client.disconnectUser();
    await scheduling;

    expect(cancelTokens.single.isCancelled, isTrue);
  });

  test('deleteScheduledMessage of one whose attachment finished uploading does not schedule it', () async {
    final upload = Completer<SendImageResponse>();
    _stubImageUpload(harness, (_) => upload.future);
    _stubSchedule(harness);
    final scheduling = _ignoringFailure(schedule(_withImage()));
    await settle();
    final listed = harness.client.state.scheduledMessages.single;

    upload.complete(SendImageResponse()..file = imageUrl);
    harness.client.deleteScheduledMessage(listed.id).ignore();
    await scheduling;

    _verifyNeverScheduled(harness);
  });

  test('updateScheduledMessage refuses an attachment not uploaded yet for one not listed', () async {
    await expectLater(
      harness.client.updateScheduledMessage('a', _withImage(id: 'a')),
      throwsArgumentError,
    );

    _verifyNeverUpdated(harness);
  });
}

// A message with an image still to be uploaded.
Message _withImage({String id = 'message'}) {
  return Message(
    id: id,
    text: 'Good morning',
    attachments: [
      Attachment(
        id: 'image',
        type: AttachmentType.image,
        file: AttachmentFile(size: 1, path: 'image.png'),
      ),
    ],
  );
}

// A message with an image still to be uploaded for each of [ids], each at
// `<id>.png`.
Message _withImages(List<String> ids) {
  return Message(
    id: 'message',
    text: 'Good morning',
    attachments: [
      for (final id in ids)
        Attachment(
          id: id,
          type: AttachmentType.image,
          file: AttachmentFile(size: 1, path: '$id.png'),
        ),
    ],
  );
}

// Schedules [message] on [harness]'s client in `messaging:general` at
// [scheduledAt], with the clock fixed at [now].
Future<ScheduleMessageResponse> _schedule(
  ScheduledMessageHarness harness,
  Message message, {
  required DateTime now,
  required DateTime scheduledAt,
}) {
  return withClock(
    Clock.fixed(now),
    () => harness.client.scheduleMessage(message, 'general', 'messaging', scheduledAt: scheduledAt),
  );
}

// Waits for [future], which fails in the setup of a test.
Future<void> _ignoringFailure(Future<Object?> future) {
  return future.then<void>((_) {}, onError: (_) {});
}

// An upload that answers only once it is canceled, the way a canceled
// request does.
Future<SendImageResponse> _uploadUntilCanceled(Invocation invocation) async {
  final cancelToken = invocation.namedArguments[#cancelToken] as CancelToken;
  await cancelToken.whenCancel;
  throw StreamChatNetworkError.raw(code: 0, message: 'Request canceled', type: .cancel);
}

// Answers every image upload with [answer].
void _stubImageUpload(
  ScheduledMessageHarness harness,
  Future<SendImageResponse> Function(Invocation) answer,
) {
  when(
    () => harness.api.fileUploader.sendImage(
      any(),
      any(),
      any(),
      onSendProgress: any(named: 'onSendProgress'),
      cancelToken: any(named: 'cancelToken'),
      extraData: any(named: 'extraData'),
    ),
  ).thenAnswer(answer);
}

// Answers every schedule request with the message as scheduled.
void _stubSchedule(ScheduledMessageHarness harness) {
  when(
    () => harness.api.scheduledMessages.scheduleMessage(
      any(),
      any(),
      any(),
      any(),
      skipPush: any(named: 'skipPush'),
      skipEnrichUrl: any(named: 'skipEnrichUrl'),
    ),
  ).thenAnswer((invocation) async {
    final message = invocation.positionalArguments[2] as Message;
    return ScheduleMessageResponse()
      ..message = message
      ..scheduledMessage = fakeScheduledMessage(message.id);
  });
}

// The schedule requests made, with their messages captured.
VerificationResult _verifyScheduled(ScheduledMessageHarness harness) {
  return verify(
    () => harness.api.scheduledMessages.scheduleMessage(
      any(),
      any(),
      captureAny(),
      any(),
      skipPush: any(named: 'skipPush'),
      skipEnrichUrl: any(named: 'skipEnrichUrl'),
    ),
  );
}

// Checks that nothing was scheduled.
void _verifyNeverScheduled(ScheduledMessageHarness harness) {
  verifyNever(
    () => harness.api.scheduledMessages.scheduleMessage(
      any(),
      any(),
      any(),
      any(),
      skipPush: any(named: 'skipPush'),
      skipEnrichUrl: any(named: 'skipEnrichUrl'),
    ),
  );
}

// Answers every update request with [scheduledMessage].
void _stubUpdate(ScheduledMessageHarness harness, ScheduledMessage scheduledMessage) {
  when(
    () => harness.api.scheduledMessages.updateScheduledMessage(
      any(),
      message: any(named: 'message'),
      scheduledAt: any(named: 'scheduledAt'),
    ),
  ).thenAnswer((_) async => fakeUpdate(scheduledMessage));
}

// The update requests made, with their messages captured.
VerificationResult _verifyUpdated(ScheduledMessageHarness harness) {
  return verify(
    () => harness.api.scheduledMessages.updateScheduledMessage(
      any(),
      message: captureAny(named: 'message'),
      scheduledAt: any(named: 'scheduledAt'),
    ),
  );
}

// Checks that nothing was updated.
void _verifyNeverUpdated(ScheduledMessageHarness harness) {
  verifyNever(
    () => harness.api.scheduledMessages.updateScheduledMessage(
      any(),
      message: any(named: 'message'),
      scheduledAt: any(named: 'scheduledAt'),
    ),
  );
}

// Answers every image upload only once it is canceled, and returns the cancel
// tokens of the uploads made.
List<CancelToken> _stubUploadUntilCanceled(ScheduledMessageHarness harness) {
  final cancelTokens = <CancelToken>[];
  _stubImageUpload(harness, (invocation) {
    cancelTokens.add(invocation.namedArguments[#cancelToken] as CancelToken);
    return _uploadUntilCanceled(invocation);
  });

  return cancelTokens;
}

// [scheduledMessage]'s message with new text.
Message _edited(ScheduledMessage scheduledMessage) {
  return Message(id: scheduledMessage.id, text: 'Good evening');
}

// Answers every delete request with [scheduledMessage] as canceled.
void _stubDelete(ScheduledMessageHarness harness, ScheduledMessage scheduledMessage) {
  final canceled = fakeScheduledMessage(scheduledMessage.id, status: ScheduledMessageStatus.canceled);
  when(
    () => harness.api.scheduledMessages.deleteScheduledMessage(any()),
  ).thenAnswer((_) async => fakeDelete(canceled));
}
