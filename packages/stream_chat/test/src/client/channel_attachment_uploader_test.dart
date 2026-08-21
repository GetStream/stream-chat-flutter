import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/client/channel_attachment_uploader.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../mocks.dart';

void main() {
  const channelId = 'test-channel-id';
  const channelType = 'test-channel-type';
  const messageId = 'test-message-id';

  late final client = MockStreamChatClient();
  late Channel channel;
  late ChannelAttachmentUploader uploader;

  setUpAll(() {
    registerFallbackValue(FakeAttachmentFile());

    when(() => client.detachedLogger(any())).thenAnswer((invocation) {
      final name = invocation.positionalArguments.first;
      return Logger.detached(name);
    });
    when(() => client.logger).thenReturn(Logger.detached('mock-client-logger'));
    when(() => client.state).thenReturn(FakeClientState());
    when(() => client.retryPolicy).thenReturn(
      RetryPolicy(
        shouldRetry: (_, __, ___) => false,
        delayFactor: Duration.zero,
      ),
    );
  });

  setUp(() {
    final channelState = ChannelState(
      channel: ChannelModel(id: channelId, type: channelType),
    );
    channel = Channel.fromState(client, channelState);
    uploader = ChannelAttachmentUploader(channel: channel);
  });

  tearDown(() {
    channel.dispose();
    clearInteractions(client);
  });

  Attachment imageAttachment(String id, {UploadState uploadState = const UploadState.preparing()}) {
    return Attachment(
      id: id,
      type: AttachmentType.image,
      file: AttachmentFile(size: 33, path: 'test-image-path'),
      uploadState: uploadState,
    );
  }

  Attachment fileAttachment(String id, {UploadState uploadState = const UploadState.preparing()}) {
    return Attachment(
      id: id,
      type: AttachmentType.file,
      file: AttachmentFile(size: 33, path: 'test-file-path'),
      uploadState: uploadState,
    );
  }

  Message seedMessage(List<Attachment> attachments) {
    final message = Message(id: messageId, attachments: attachments);
    channel.state!.updateMessage(message);
    return message;
  }

  void stubSendImage(Future<SendImageResponse> Function() response) {
    when(
      () => client.sendImage(
        any(),
        channelId,
        channelType,
        onSendProgress: any(named: 'onSendProgress'),
        cancelToken: any(named: 'cancelToken'),
        extraData: any(named: 'extraData'),
      ),
    ).thenAnswer((_) => response());
  }

  void stubSendFile(Future<SendFileResponse> Function() response) {
    when(
      () => client.sendFile(
        any(),
        channelId,
        channelType,
        onSendProgress: any(named: 'onSendProgress'),
        cancelToken: any(named: 'cancelToken'),
        extraData: any(named: 'extraData'),
      ),
    ).thenAnswer((_) => response());
  }

  group('cancelAttachmentUpload', () {
    test('throws when no upload request has started for the attachment', () {
      expect(
        () => uploader.cancelAttachmentUpload('unknown-attachment'),
        throwsA(isA<StreamChatError>()),
      );
    });

    test('cancels the in-flight upload request and removes the attachment', () async {
      seedMessage([imageAttachment('a1')]);
      final responseCompleter = Completer<SendImageResponse>();
      stubSendImage(() => responseCompleter.future);

      final upload = uploader.uploadAttachments(messageId, ['a1']);

      final cancelToken =
          verify(
                () => client.sendImage(
                  any(),
                  channelId,
                  channelType,
                  onSendProgress: any(named: 'onSendProgress'),
                  cancelToken: captureAny(named: 'cancelToken'),
                  extraData: any(named: 'extraData'),
                ),
              ).captured.single
              as CancelToken?;

      uploader.cancelAttachmentUpload('a1', reason: 'user cancelled');
      expect(cancelToken?.isCancelled, isTrue);

      // Simulate the http client surfacing the cancellation.
      responseCompleter.completeError(
        StreamChatNetworkError.raw(
          code: -1,
          message: 'cancelled',
          type: StreamChatNetworkErrorType.cancel,
        ),
      );
      await upload;

      expect(channel.state!.messages.single.attachments, isEmpty);
    });

    test('throws when the upload request is already cancelled', () {
      seedMessage([imageAttachment('a1')]);
      stubSendImage(() => Completer<SendImageResponse>().future);

      uploader
        ..uploadAttachments(messageId, ['a1'])
        ..cancelAttachmentUpload('a1');

      expect(
        () => uploader.cancelAttachmentUpload('a1'),
        throwsA(isA<StreamChatError>()),
      );
    });
  });

  group('uploadAttachments', () {
    test('throws when the message is not found in the channel state', () {
      expect(
        () => uploader.uploadAttachments('unknown-message', ['a1']),
        throwsA(isA<StreamChatError>()),
      );
    });

    test('uploads an image and stores the url with a success state', () async {
      seedMessage([imageAttachment('a1')]);
      stubSendImage(() async => SendImageResponse()..file = 'test-image-url');

      await uploader.uploadAttachments(messageId, ['a1']);

      final attachment = channel.state!.messages.single.attachments.single;
      expect(attachment.imageUrl, 'test-image-url');
      expect(attachment.uploadState.isSuccess, isTrue);
    });

    test('uploads a file and stores the asset and thumb urls with a success state', () async {
      seedMessage([fileAttachment('a1')]);
      stubSendFile(
        () async => SendFileResponse()
          ..file = 'test-file-url'
          ..thumbUrl = 'test-thumb-url',
      );

      await uploader.uploadAttachments(messageId, ['a1']);

      final attachment = channel.state!.messages.single.attachments.single;
      expect(attachment.assetUrl, 'test-file-url');
      expect(attachment.thumbUrl, 'test-thumb-url');
      expect(attachment.uploadState.isSuccess, isTrue);
    });

    test('marks the attachment as failed when the upload errors', () async {
      seedMessage([fileAttachment('a1')]);
      stubSendFile(() async => throw StateError('upload failed'));

      await uploader.uploadAttachments(messageId, ['a1']);

      final attachment = channel.state!.messages.single.attachments.single;
      expect(attachment.uploadState.isFailed, isTrue);
    });

    test('skips attachments that are already uploaded', () async {
      seedMessage([
        imageAttachment('a1', uploadState: const UploadState.success()),
        fileAttachment('a2'),
      ]);
      stubSendFile(() async => SendFileResponse()..file = 'test-file-url');

      await uploader.uploadAttachments(messageId, ['a1', 'a2']);

      verifyNever(
        () => client.sendImage(
          any(),
          any(),
          any(),
          onSendProgress: any(named: 'onSendProgress'),
          cancelToken: any(named: 'cancelToken'),
          extraData: any(named: 'extraData'),
        ),
      );
    });
  });

  group('uploadMessageAttachments', () {
    test('completes with the latest message once all uploads settle', () async {
      final message = seedMessage([
        imageAttachment('a1'),
        fileAttachment('a2'),
      ]);
      stubSendImage(() async => SendImageResponse()..file = 'test-image-url');
      stubSendFile(() async => throw StateError('upload failed'));

      final result = await uploader.uploadMessageAttachments(message);

      final image = result.attachments.singleWhere((it) => it.id == 'a1');
      final file = result.attachments.singleWhere((it) => it.id == 'a2');
      expect(image.uploadState.isSuccess, isTrue);
      expect(file.uploadState.isFailed, isTrue);
    });

    test('completes immediately when every attachment is already uploaded', () async {
      final message = seedMessage([
        imageAttachment('a1', uploadState: const UploadState.success()),
      ]);

      final result = await uploader.uploadMessageAttachments(message);

      expect(result.id, messageId);
      verifyNever(
        () => client.sendImage(
          any(),
          any(),
          any(),
          onSendProgress: any(named: 'onSendProgress'),
          cancelToken: any(named: 'cancelToken'),
          extraData: any(named: 'extraData'),
        ),
      );
    });
  });

  group('abortPendingUpload', () {
    test('fails the pending wait with the given reason', () async {
      final message = seedMessage([imageAttachment('a1')]);
      stubSendImage(() => Completer<SendImageResponse>().future);

      final pending = uploader.uploadMessageAttachments(message);
      uploader.abortPendingUpload(messageId, reason: 'Message deleted');

      await expectLater(
        pending,
        throwsA(
          isA<StreamChatError>().having((it) => it.message, 'message', 'Message deleted'),
        ),
      );
    });

    test('is a no-op when no upload wait is pending', () {
      expect(
        () => uploader.abortPendingUpload(messageId, reason: 'Message cancelled'),
        returnsNormally,
      );
    });
  });
}
