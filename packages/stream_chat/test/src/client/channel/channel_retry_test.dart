import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

ChannelState Function(ChannelState) _seedChannel() {
  return (_) => createDefaultChannelState(
    channel: createDefaultChannelModel(cid: _channelCid),
  );
}

void main() {
  group('Retry functionality with parameter preservation', () {
    group('retryMessage method', () {
      channelTest(
        'should call sendMessage with preserved skipPush and skipEnrichUrl parameters',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id',
            text: 'Hello, World!',
            state: MessageState.sendingFailed(
              skipPush: true,
              skipEnrichUrl: true,
            ),
          );

          tester.mockApi(
            (api) => api.message.sendMessage(
              _channelId,
              _channelType,
              any(that: isSameMessageAs(message)),
              skipPush: true,
              skipEnrichUrl: true,
            ),
            result: createDefaultSendMessageResponse(message: message.copyWith(state: MessageState.sent)),
          );

          final result = await tester.channel.retryMessage(message);

          expect(result, isNotNull);
          expect(result, isA<SendMessageResponse>());

          tester.verifyApi(
            (api) => api.message.sendMessage(
              _channelId,
              _channelType,
              any(that: isSameMessageAs(message)),
              skipPush: true,
              skipEnrichUrl: true,
            ),
          );
        },
      );

      channelTest(
        'should call sendMessage with preserved skipPush parameter',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id',
            text: 'Hello, World!',
            state: MessageState.sendingFailed(
              skipPush: true,
              skipEnrichUrl: false,
            ),
          );

          tester.mockApi(
            (api) => api.message.sendMessage(
              _channelId,
              _channelType,
              any(that: isSameMessageAs(message)),
              skipPush: true,
            ),
            result: createDefaultSendMessageResponse(message: message.copyWith(state: MessageState.sent)),
          );

          final result = await tester.channel.retryMessage(message);

          expect(result, isNotNull);
          expect(result, isA<SendMessageResponse>());

          tester.verifyApi(
            (api) => api.message.sendMessage(
              _channelId,
              _channelType,
              any(that: isSameMessageAs(message)),
              skipPush: true,
            ),
          );
        },
      );

      channelTest(
        'should call sendMessage with preserved skipEnrichUrl parameter',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id',
            text: 'Hello, World!',
            state: MessageState.sendingFailed(
              skipPush: false,
              skipEnrichUrl: true,
            ),
          );

          tester.mockApi(
            (api) => api.message.sendMessage(
              _channelId,
              _channelType,
              any(that: isSameMessageAs(message)),
              skipEnrichUrl: true,
            ),
            result: createDefaultSendMessageResponse(message: message.copyWith(state: MessageState.sent)),
          );

          final result = await tester.channel.retryMessage(message);

          expect(result, isNotNull);
          expect(result, isA<SendMessageResponse>());

          tester.verifyApi(
            (api) => api.message.sendMessage(
              _channelId,
              _channelType,
              any(that: isSameMessageAs(message)),
              skipEnrichUrl: true,
            ),
          );
        },
      );

      channelTest(
        'should call sendMessage with preserved false skipPush and skipEnrichUrl parameters',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id',
            text: 'Hello, World!',
            state: MessageState.sendingFailed(
              skipPush: false,
              skipEnrichUrl: false,
            ),
          );

          tester.mockApi(
            (api) => api.message.sendMessage(
              _channelId,
              _channelType,
              any(that: isSameMessageAs(message)),
            ),
            result: createDefaultSendMessageResponse(message: message.copyWith(state: MessageState.sent)),
          );

          final result = await tester.channel.retryMessage(message);

          expect(result, isNotNull);
          expect(result, isA<SendMessageResponse>());

          tester.verifyApi(
            (api) => api.message.sendMessage(
              _channelId,
              _channelType,
              any(that: isSameMessageAs(message)),
            ),
          );
        },
      );

      channelTest(
        'should call updateMessage with preserved skipPush, skipEnrichUrl parameter',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id',
            text: 'Hello, World!',
            state: MessageState.updatingFailed(
              skipPush: true,
              skipEnrichUrl: true,
            ),
          );

          tester.mockApi(
            (api) => api.message.updateMessage(
              any(that: isSameMessageAs(message)),
              skipPush: true,
              skipEnrichUrl: true,
            ),
            result: createDefaultUpdateMessageResponse(message: message.copyWith(state: MessageState.updated)),
          );

          final result = await tester.channel.retryMessage(message);

          expect(result, isNotNull);
          expect(result, isA<UpdateMessageResponse>());

          tester.verifyApi(
            (api) => api.message.updateMessage(
              any(that: isSameMessageAs(message)),
              skipPush: true,
              skipEnrichUrl: true,
            ),
          );
        },
      );

      channelTest(
        'should call updateMessage with preserved false skipPush, skipEnrichUrl parameter',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id',
            state: MessageState.updatingFailed(
              skipPush: false,
              skipEnrichUrl: false,
            ),
          );

          tester.mockApi(
            (api) => api.message.updateMessage(
              any(that: isSameMessageAs(message)),
            ),
            result: createDefaultUpdateMessageResponse(message: message.copyWith(state: MessageState.updated)),
          );

          final result = await tester.channel.retryMessage(message);

          expect(result, isNotNull);
          expect(result, isA<UpdateMessageResponse>());

          tester.verifyApi(
            (api) => api.message.updateMessage(
              any(that: isSameMessageAs(message)),
            ),
          );
        },
      );

      channelTest(
        'should call deleteMessage with preserved hard parameter',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id',
            createdAt: DateTime.utc(2021, 3),
            state: MessageState.hardDeletingFailed,
          );

          tester.mockApi(
            (api) => api.message.deleteMessage(message.id, hard: true),
            result: createDefaultEmptyResponse(),
          );

          final result = await tester.channel.retryMessage(message);

          expect(result, isNotNull);
          expect(result, isA<EmptyResponse>());

          tester.verifyApi(
            (api) => api.message.deleteMessage(message.id, hard: true),
          );
        },
      );

      channelTest(
        'should call deleteMessage with preserved false hard parameter',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id',
            createdAt: DateTime.utc(2021, 3),
            state: MessageState.softDeletingFailed,
          );

          tester.mockApi(
            (api) => api.message.deleteMessage(message.id, hard: false),
            result: createDefaultEmptyResponse(),
          );

          final result = await tester.channel.retryMessage(message);

          expect(result, isNotNull);
          expect(result, isA<EmptyResponse>());

          tester.verifyApi(
            (api) => api.message.deleteMessage(message.id, hard: false),
          );
        },
      );

      channelTest(
        'should call deleteMessageForMe for deletingForMeFailed state',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id',
            createdAt: DateTime.utc(2021, 3),
            state: MessageState.deletingForMeFailed,
          );

          tester.mockApi(
            (api) => api.message.deleteMessage(message.id, deleteForMe: true),
            result: createDefaultEmptyResponse(),
          );

          final result = await tester.channel.retryMessage(message);

          expect(result, isNotNull);
          expect(result, isA<EmptyResponse>());

          tester.verifyApi(
            (api) => api.message.deleteMessage(message.id, deleteForMe: true),
          );
        },
      );

      channelTest(
        'should throw AssertionError when message state is not failed',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id',
            state: MessageState.sent,
          );

          expect(() => tester.channel.retryMessage(message), throwsA(isA<AssertionError>()));
        },
      );
    });
  });
}
