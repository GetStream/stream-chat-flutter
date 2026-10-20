import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../fakes.dart';
import '../../mocks.dart';

void main() {
  setUpAll(() => registerFallbackValue(FakeAttachmentFile()));

  test('deleting a bounced message emits a hard-deleted message.deleted', () async {
    final channel = _channel();
    final bounced = Message(
      id: 'bounced',
      text: 'bad word',
      type: MessageType.error,
      moderation: const Moderation(action: ModerationAction.bounce, originalText: 'bad word'),
    );
    channel.state!.addNewMessage(bounced);
    final deleted = channel.on(EventType.messageDeleted).first;

    await channel.deleteMessage(bounced);

    expect(
      await deleted,
      isA<Event>()
          .having((it) => it.hardDelete, 'hardDelete', isTrue)
          .having((it) => it.message?.id, 'message id', 'bounced'),
    );
  });

  test('deleting an unsent message emits message.deleted', () async {
    final channel = _channel();
    final unsent = Message(id: 'unsent', text: 'Hello', state: MessageState.sending);
    channel.state!.addNewMessage(unsent);
    final deleted = channel.on(EventType.messageDeleted).first;

    await channel.deleteMessage(unsent);

    expect(await deleted, isA<Event>().having((it) => it.message?.id, 'message id', 'unsent'));
  });

  test('deleting an unsent message removes it from the state', () async {
    final channel = _channel();
    final unsent = Message(id: 'unsent', text: 'Hello', state: MessageState.sending);
    channel.state!.addNewMessage(unsent);

    await channel.deleteMessage(unsent);
    await pumpEventQueue();

    expect(channel.state!.messages, isEmpty);
  });

  test('deleting a message while its attachment uploads keeps it deleted', () async {
    final channel = _channel(imageUpload: Completer<SendImageResponse>().future);
    final sending = channel.sendMessage(_withUploadingImage('uploading')).then<void>((_) {}, onError: (_) {});
    await pumpEventQueue();

    await channel.deleteMessage(channel.state!.messages.single);
    await sending;
    await pumpEventQueue();

    expect(channel.state!.messages, isEmpty);
  });

  test('a send superseded by a newer one leaves the newer one sending', () async {
    final channel = _channel(imageUpload: Completer<SendImageResponse>().future);
    final message = _withUploadingImage('resent');
    final first = channel.sendMessage(message).then<void>((_) {}, onError: (_) {});
    await pumpEventQueue();

    channel.sendMessage(message).ignore();
    await first;
    await pumpEventQueue();

    expect(channel.state!.messages.single.state, MessageState.sending);
  });
}

// A message whose image is still to be uploaded.
Message _withUploadingImage(String id) {
  return Message(
    id: id,
    attachments: [
      Attachment(
        id: 'image',
        type: AttachmentType.image,
        file: AttachmentFile(size: 1, path: 'image.png'),
      ),
    ],
  );
}

// A client that delivers the events the SDK raises, as the real one does.
class _DeliveringClient extends MockStreamChatClient {
  @override
  void handleEvent(Event event) => addEvent(event);
}

// A channel created from a state, on a [_DeliveringClient] whose image
// uploads finish with [imageUpload].
Channel _channel({Future<SendImageResponse>? imageUpload}) {
  final client = _DeliveringClient();
  when(
    () => client.detachedLogger(any()),
  ).thenAnswer((invocation) => Logger.detached(invocation.positionalArguments.first as String));
  when(() => client.logger).thenReturn(Logger.detached('client'));
  if (imageUpload != null) {
    when(
      () => client.sendImage(
        any(),
        any(),
        any(),
        onSendProgress: any(named: 'onSendProgress'),
        cancelToken: any(named: 'cancelToken'),
        extraData: any(named: 'extraData'),
      ),
    ).thenAnswer((_) => imageUpload);
  }
  when(() => client.state).thenReturn(FakeClientState());
  when(() => client.channelDeliveryReporter.submitForDelivery(any())).thenAnswer((_) async {});
  when(() => client.retryPolicy).thenReturn(
    RetryPolicy(shouldRetry: (_, __, ___) => false, delayFactor: Duration.zero),
  );
  final channel = Channel.fromState(
    client,
    ChannelState(
      channel: ChannelModel(type: 'messaging', id: 'local-delete'),
    ),
  );
  addTearDown(channel.dispose);
  return channel;
}
