import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../fakes.dart';
import '../../mocks.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(FakeAttachmentFile());
    registerFallbackValue(FakeMessage());
  });

  test('canceling an attachment upload sends the message without the attachment', () async {
    final channel = _channel(imageUpload: _uploadUntilCanceled);
    final sending = channel.sendMessage(_withImage(text: 'Hello'));
    await pumpEventQueue();

    channel.cancelAttachmentUpload('image');
    await sending;

    final sent =
        verify(
              () => channel.client.sendMessage(
                captureAny(),
                any(),
                any(),
                skipPush: any(named: 'skipPush'),
                skipEnrichUrl: any(named: 'skipEnrichUrl'),
              ),
            ).captured.single
            as Message;
    expect(sent.attachments, isEmpty);
  });

  test('retrying a failed attachment upload marks the attachment as uploaded', () async {
    var attempt = 0;
    final channel = _channel(
      imageUpload: (_) async {
        attempt += 1;
        if (attempt == 1) throw StreamChatNetworkError(ChatErrorCode.internalSystemError);
        return SendImageResponse()..file = 'https://example.com/image.png';
      },
    );
    await _ignoringFailure(channel.sendMessage(_withImage(text: 'Hello')));

    await channel.retryAttachmentUpload('message', 'image');

    final attachment = channel.state!.messages.single.attachments.single;
    expect(attachment.uploadState, const UploadState.success());
    expect(attachment.imageUrl, 'https://example.com/image.png');
  });

  test('sending a message with an attachment that has no file fails it', () async {
    final channel = _channel(imageUpload: (_) async => SendImageResponse());
    final message = Message(
      id: 'message',
      text: 'Hello',
      attachments: [Attachment(id: 'custom', type: 'custom')],
    );

    await expectLater(channel.sendMessage(message), throwsA(isA<StreamChatError>()));
  });

  test('retrying an uploaded attachment does not send a message whose other attachment uploads', () async {
    final channel = _channel(
      imageUpload: (invocation) {
        final file = invocation.positionalArguments.first as AttachmentFile;
        if (file.path == 'first.png') return Future.value(SendImageResponse()..file = 'https://example.com/1.png');
        return Completer<SendImageResponse>().future;
      },
    );
    channel.sendMessage(_withImages(['first', 'second'])).ignore();
    await pumpEventQueue();

    await channel.retryAttachmentUpload('message', 'first');
    await pumpEventQueue();

    verifyNever(
      () => channel.client.sendMessage(
        any(),
        any(),
        any(),
        skipPush: any(named: 'skipPush'),
        skipEnrichUrl: any(named: 'skipEnrichUrl'),
      ),
    );
  });

  test('deleting a message cancels the upload of its attachment', () async {
    final cancelTokens = <CancelToken>[];
    final channel = _channel(
      imageUpload: (invocation) {
        cancelTokens.add(invocation.namedArguments[#cancelToken] as CancelToken);
        return _uploadUntilCanceled(invocation);
      },
    );
    final sending = _ignoringFailure(channel.sendMessage(_withImage(text: 'Hello')));
    await pumpEventQueue();

    await channel.deleteMessage(channel.state!.messages.single);
    await sending;

    expect(cancelTokens.single.isCancelled, isTrue);
  });

  test('deleting a message while its attachment uploads makes its sending throw', () async {
    final channel = _channel(imageUpload: _uploadUntilCanceled);
    final sending = expectLater(
      channel.sendMessage(_withImage(text: 'Hello')),
      throwsA(isA<StreamChatError>().having((it) => it.message, 'message', 'Message deleted')),
    );
    await pumpEventQueue();

    await channel.deleteMessage(channel.state!.messages.single);

    await sending;
  });

  test('sending a message again while its attachment uploads makes the first sending throw', () async {
    final channel = _channel(imageUpload: _uploadUntilCanceled);
    final first = expectLater(
      channel.sendMessage(_withImage(text: 'Hello')),
      throwsA(isA<StreamChatError>().having((it) => it.message, 'message', 'Message cancelled')),
    );
    await pumpEventQueue();

    channel.sendMessage(_withImage(text: 'Hello')).ignore();

    await first;
  });

  test('sending a message again while its attachment uploads cancels the first upload', () async {
    final cancelTokens = <CancelToken>[];
    final channel = _channel(
      imageUpload: (invocation) {
        cancelTokens.add(invocation.namedArguments[#cancelToken] as CancelToken);
        return _uploadUntilCanceled(invocation);
      },
    );
    final first = _ignoringFailure(channel.sendMessage(_withImage(text: 'Hello')));
    await pumpEventQueue();

    channel.sendMessage(_withImage(text: 'Hello')).ignore();
    await first;

    expect(cancelTokens.first.isCancelled, isTrue);
  });

  test('deleting a message whose attachment finished uploading does not send it', () async {
    final upload = Completer<SendImageResponse>();
    final channel = _channel(imageUpload: (_) => upload.future);
    final sending = _ignoringFailure(channel.sendMessage(_withImage(text: 'Hello')));
    await pumpEventQueue();
    final message = channel.state!.messages.single;

    upload.complete(SendImageResponse()..file = 'https://example.com/image.png');
    channel.deleteMessage(message).ignore();
    await sending;

    verifyNever(
      () => channel.client.sendMessage(
        any(),
        any(),
        any(),
        skipPush: any(named: 'skipPush'),
        skipEnrichUrl: any(named: 'skipEnrichUrl'),
      ),
    );
  });

  test('sending a message uploads at most three of its attachments at a time', () async {
    var uploads = 0;
    final channel = _channel(
      imageUpload: (_) {
        uploads += 1;
        return Completer<SendImageResponse>().future;
      },
    );

    channel.sendMessage(_withImages(['1', '2', '3', '4', '5'])).ignore();
    await pumpEventQueue();

    expect(uploads, 3);
  });

  test('sending a message uploads its next attachment once one finishes', () async {
    final uploaded = <String?>[];
    final first = Completer<SendImageResponse>();
    final channel = _channel(
      imageUpload: (invocation) {
        final file = invocation.positionalArguments.first as AttachmentFile;
        uploaded.add(file.path);
        if (file.path == '1.png') return first.future;
        return Completer<SendImageResponse>().future;
      },
    );
    channel.sendMessage(_withImages(['1', '2', '3', '4'])).ignore();
    await pumpEventQueue();

    first.complete(SendImageResponse()..file = 'https://example.com/1.png');
    await pumpEventQueue();

    expect(uploaded.last, '4.png');
  });

  test('canceling an attachment waiting for its turn sends the message without it', () async {
    final channel = _channel(
      imageUpload: (invocation) async {
        final file = invocation.positionalArguments.first as AttachmentFile;
        return SendImageResponse()..file = 'https://example.com/${file.path}';
      },
    );
    final sending = channel.sendMessage(_withImages(['1', '2', '3', '4']));

    channel.cancelAttachmentUpload('4');
    await sending;

    final sent =
        verify(
              () => channel.client.sendMessage(
                captureAny(),
                any(),
                any(),
                skipPush: any(named: 'skipPush'),
                skipEnrichUrl: any(named: 'skipEnrichUrl'),
              ),
            ).captured.single
            as Message;
    expect(sent.attachments.map((it) => it.id), ['1', '2', '3']);
  });

  test('deleting a message whose attachment finished uploading makes its sending throw', () async {
    final upload = Completer<SendImageResponse>();
    final channel = _channel(imageUpload: (_) => upload.future);
    final sending = expectLater(
      channel.sendMessage(_withImage(text: 'Hello')),
      throwsA(isA<StreamChatError>().having((it) => it.message, 'message', 'Message deleted')),
    );
    await pumpEventQueue();
    final message = channel.state!.messages.single;

    upload.complete(SendImageResponse()..file = 'https://example.com/image.png');
    channel.deleteMessage(message).ignore();

    await sending;
  });

  test('retrying an attachment while the message uploads does not upload it again', () async {
    var uploads = 0;
    final channel = _channel(
      imageUpload: (_) {
        uploads += 1;
        return Completer<SendImageResponse>().future;
      },
    );
    channel.sendMessage(_withImage(text: 'Hello')).ignore();
    await pumpEventQueue();

    await channel.retryAttachmentUpload('message', 'image');

    expect(uploads, 1);
  });
}

// A message with [text] and an image still to be uploaded.
Message _withImage({required String text}) {
  return Message(
    id: 'message',
    text: text,
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
    text: 'Hello',
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

// An upload that answers only once it is canceled, the way a canceled
// request does.
Future<SendImageResponse> _uploadUntilCanceled(Invocation invocation) async {
  final cancelToken = invocation.namedArguments[#cancelToken] as CancelToken;
  await cancelToken.whenCancel;
  throw StreamChatNetworkError.raw(
    code: 0,
    message: 'Request canceled',
    type: StreamChatNetworkErrorType.cancel,
  );
}

// Waits for [future], which fails in the setup of a test.
Future<void> _ignoringFailure(Future<Object?> future) {
  return future.then<void>((_) {}, onError: (_) {});
}

// An image upload on [client], with any arguments.
Future<SendImageResponse> _sendImage(StreamChatClient client) {
  return client.sendImage(
    any(),
    any(),
    any(),
    onSendProgress: any(named: 'onSendProgress'),
    cancelToken: any(named: 'cancelToken'),
    extraData: any(named: 'extraData'),
  );
}

// A channel created from a state, whose image uploads are answered by
// [imageUpload] and whose messages are sent as they are.
Channel _channel({required Future<SendImageResponse> Function(Invocation) imageUpload}) {
  final client = MockStreamChatClient();
  when(
    () => client.detachedLogger(any()),
  ).thenAnswer((invocation) => Logger.detached(invocation.positionalArguments.first as String));
  when(() => client.logger).thenReturn(Logger.detached('client'));
  when(() => _sendImage(client)).thenAnswer(imageUpload);
  when(
    () => client.sendMessage(
      any(),
      any(),
      any(),
      skipPush: any(named: 'skipPush'),
      skipEnrichUrl: any(named: 'skipEnrichUrl'),
    ),
  ).thenAnswer(
    (invocation) async => SendMessageResponse()..message = invocation.positionalArguments.first as Message,
  );
  when(() => client.state).thenReturn(FakeClientState());
  when(() => client.channelDeliveryReporter.submitForDelivery(any())).thenAnswer((_) async {});
  when(() => client.retryPolicy).thenReturn(
    RetryPolicy(shouldRetry: (_, __, ___) => false, delayFactor: Duration.zero),
  );
  final channel = Channel.fromState(
    client,
    ChannelState(
      channel: ChannelModel(type: 'messaging', id: 'attachment-upload'),
    ),
  );
  addTearDown(channel.dispose);
  return channel;
}
