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
