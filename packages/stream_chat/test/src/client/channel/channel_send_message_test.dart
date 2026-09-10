import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

ChannelState Function(ChannelState) _seedChannel() {
  return (_) => createDefaultChannelState(
    channel: createDefaultChannelModel(
      cid: _channelCid,
      config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
      ownCapabilities: const [ChannelCapability.readEvents],
    ),
  );
}

void main() {
  group('`.sendMessage`', () {
    channelTest(
      'should work fine',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final message = Message(
          id: 'test-message-id',
          text: 'Hello world!',
          user: tester.currentUser,
        );

        tester.mockApi(
          (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
          result: createDefaultSendMessageResponse(message: message.copyWith(state: MessageState.sent)),
        );

        final messagesEmission = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.sending),
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.sent),
                matchMessageState: true,
              ),
            ],
          ]),
        );

        final res = await tester.channel.sendMessage(message);

        expect(res, isNotNull);
        expect(res.message.id, message.id);

        tester.verifyApi(
          (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
        );

        await messagesEmission;
      },
    );

    channelTest(
      'should handle StreamChatNetworkError by adding message to retry queue with skipPush: true, skipEnrichUrl: false',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final message = Message(
          id: 'test-message-id',
          text: 'Hello world!',
          user: tester.currentUser,
        );

        // The retriable failure arms the live retry queue; its immediate
        // retry attempt succeeds, so the queue drains without waiting on
        // backoff timers.
        tester.mockApiFailureOnce(
          (api) => api.message.sendMessage(
            _channelId,
            _channelType,
            any(that: isSameMessageAs(message)),
            skipPush: true,
          ),
          error: createDefaultNetworkError(errorCode: ChatErrorCode.notAllowed, retriable: true),
          result: createDefaultSendMessageResponse(message: message.copyWith(state: MessageState.sent)),
        );

        final messagesEmission = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.sending),
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.sendingFailed(
                    skipPush: true,
                    skipEnrichUrl: false,
                  ),
                ),
                matchMessageState: true,
              ),
            ],
            // The retry queue re-sends the queued message with the same flags.
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.sending),
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.sent),
                matchMessageState: true,
              ),
            ],
          ]),
        );

        try {
          await tester.channel.sendMessage(
            message,
            skipPush: true,
          );
        } catch (e) {
          expect(e, isA<StreamChatNetworkError>());

          final networkError = e as StreamChatNetworkError;
          expect(networkError.code, equals(ChatErrorCode.notAllowed.code));
        }

        await messagesEmission;

        // Initial attempt + the retry-queue retry, both with the same flags.
        tester.verifyApiCalled(
          (api) => api.message.sendMessage(
            _channelId,
            _channelType,
            any(that: isSameMessageAs(message)),
            skipPush: true,
          ),
          times: 2,
        );
      },
    );

    channelTest(
      'should handle StreamChatNetworkError by adding message to retry queue with skipPush: true, skipEnrichUrl: true',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final message = Message(
          id: 'test-message-id-2',
          text: 'Hello world!',
          user: tester.currentUser,
        );

        // The retriable failure arms the live retry queue; its immediate
        // retry attempt succeeds, so the queue drains without waiting on
        // backoff timers.
        tester.mockApiFailureOnce(
          (api) => api.message.sendMessage(
            _channelId,
            _channelType,
            any(that: isSameMessageAs(message)),
            skipPush: true,
            skipEnrichUrl: true,
          ),
          error: createDefaultNetworkError(errorCode: ChatErrorCode.notAllowed, retriable: true),
          result: createDefaultSendMessageResponse(message: message.copyWith(state: MessageState.sent)),
        );

        final messagesEmission = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.sending),
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.sendingFailed(
                    skipPush: true,
                    skipEnrichUrl: true,
                  ),
                ),
                matchMessageState: true,
              ),
            ],
            // The retry queue re-sends the queued message with the same flags.
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.sending),
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.sent),
                matchMessageState: true,
              ),
            ],
          ]),
        );

        try {
          await tester.channel.sendMessage(
            message,
            skipPush: true,
            skipEnrichUrl: true,
          );
        } catch (e) {
          expect(e, isA<StreamChatNetworkError>());

          final networkError = e as StreamChatNetworkError;
          expect(networkError.code, equals(ChatErrorCode.notAllowed.code));
        }

        await messagesEmission;

        // Initial attempt + the retry-queue retry, both with the same flags.
        tester.verifyApiCalled(
          (api) => api.message.sendMessage(
            _channelId,
            _channelType,
            any(that: isSameMessageAs(message)),
            skipPush: true,
            skipEnrichUrl: true,
          ),
          times: 2,
        );
      },
    );

    channelTest(
      'should handle StreamChatNetworkError by adding message to retry queue with skipPush: false, skipEnrichUrl: true',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final message = Message(
          id: 'test-message-id-3',
          text: 'Hello world!',
          user: tester.currentUser,
        );

        // The retriable failure arms the live retry queue; its immediate
        // retry attempt succeeds, so the queue drains without waiting on
        // backoff timers.
        tester.mockApiFailureOnce(
          (api) => api.message.sendMessage(
            _channelId,
            _channelType,
            any(that: isSameMessageAs(message)),
            skipEnrichUrl: true,
          ),
          error: createDefaultNetworkError(errorCode: ChatErrorCode.notAllowed, retriable: true),
          result: createDefaultSendMessageResponse(message: message.copyWith(state: MessageState.sent)),
        );

        final messagesEmission = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.sending),
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.sendingFailed(
                    skipPush: false,
                    skipEnrichUrl: true,
                  ),
                ),
                matchMessageState: true,
              ),
            ],
            // The retry queue re-sends the queued message with the same flags.
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.sending),
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.sent),
                matchMessageState: true,
              ),
            ],
          ]),
        );

        try {
          await tester.channel.sendMessage(
            message,
            skipEnrichUrl: true,
          );
        } catch (e) {
          expect(e, isA<StreamChatNetworkError>());

          final networkError = e as StreamChatNetworkError;
          expect(networkError.code, equals(ChatErrorCode.notAllowed.code));
        }

        await messagesEmission;

        // Initial attempt + the retry-queue retry, both with the same flags.
        tester.verifyApiCalled(
          (api) => api.message.sendMessage(
            _channelId,
            _channelType,
            any(that: isSameMessageAs(message)),
            skipEnrichUrl: true,
          ),
          times: 2,
        );
      },
    );

    channelTest(
      'should handle StreamChatNetworkError by adding message to retry queue with skipPush: false, skipEnrichUrl: false',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final message = Message(
          id: 'test-message-id-4',
          text: 'Hello world!',
          user: tester.currentUser,
        );

        // The retriable failure arms the live retry queue; its immediate
        // retry attempt succeeds, so the queue drains without waiting on
        // backoff timers.
        tester.mockApiFailureOnce(
          (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
          error: createDefaultNetworkError(errorCode: ChatErrorCode.notAllowed, retriable: true),
          result: createDefaultSendMessageResponse(message: message.copyWith(state: MessageState.sent)),
        );

        final messagesEmission = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.sending),
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.sendingFailed(
                    skipPush: false,
                    skipEnrichUrl: false,
                  ),
                ),
                matchMessageState: true,
              ),
            ],
            // The retry queue re-sends the queued message with the same flags.
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.sending),
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.sent),
                matchMessageState: true,
              ),
            ],
          ]),
        );

        try {
          await tester.channel.sendMessage(
            message,
          );
        } catch (e) {
          expect(e, isA<StreamChatNetworkError>());

          final networkError = e as StreamChatNetworkError;
          expect(networkError.code, equals(ChatErrorCode.notAllowed.code));
        }

        await messagesEmission;

        // Initial attempt + the retry-queue retry, both with the same flags.
        tester.verifyApiCalled(
          (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
          times: 2,
        );
      },
    );

    channelTest(
      'should update message state even when non-retriable error occurs',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final message = Message(
          id: 'test-message-id',
          text: 'Hello world!',
          user: tester.currentUser,
        );

        tester.mockApiFailure(
          (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
          error: createDefaultNetworkError(errorCode: ChatErrorCode.inputError, statusCode: 400),
        );

        final messagesEmission = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.sending),
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.sendingFailed(
                    skipPush: false,
                    skipEnrichUrl: false,
                  ),
                ),
                matchMessageState: true,
              ),
            ],
          ]),
        );

        try {
          await tester.channel.sendMessage(message);
        } catch (e) {
          expect(e, isA<StreamChatNetworkError>());
        }

        await messagesEmission;
      },
    );

    channelTest(
      'with attachments should work just fine',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final attachments = List.generate(
          3,
          (index) => Attachment(
            id: 'test-attachment-id-$index',
            type: index.isEven ? 'image' : 'file',
            file: AttachmentFile(size: index * 33, path: 'test-file-path'),
          ),
        );

        final message = Message(
          id: 'test-message-id',
          attachments: attachments,
        );

        tester
          ..mockApi(
            (api) => api.fileUploader.sendImage(
              any(),
              _channelId,
              _channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
              extraData: any(named: 'extraData'),
            ),
            result: SendImageResponse()..file = 'test-image-url',
          )
          ..mockApi(
            (api) => api.fileUploader.sendFile(
              any(),
              _channelId,
              _channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
              extraData: any(named: 'extraData'),
            ),
            result: SendFileResponse()..file = 'test-file-url',
          )
          ..mockApi(
            (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
            result: createDefaultSendMessageResponse(
              message: message.copyWith(
                attachments: attachments
                    .map((it) => it.copyWith(uploadState: const UploadState.success()))
                    .toList(growable: false),
                state: MessageState.sent,
              ),
            ),
          );

        final messagesEmission = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
          emitsInOrder(
            [
              // preparing attachments to upload
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sending,
                    attachments: [...attachments.map((it) => it.copyWith(uploadState: const UploadState.preparing()))],
                  ),
                  matchMessageState: true,
                  matchAttachments: true,
                  matchAttachmentsUploadState: true,
                ),
              ],
              // 0th attachment is successfully uploaded
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sending,
                    attachments: [...attachments]
                      ..[0] = attachments[0].copyWith(
                        uploadState: const UploadState.success(),
                      ),
                  ),
                  matchMessageState: true,
                  matchAttachments: true,
                  matchAttachmentsUploadState: true,
                ),
              ],
              // 0th and 1st attachment is successfully uploaded
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sending,
                    attachments: [...attachments]
                      ..[0] = attachments[0].copyWith(
                        uploadState: const UploadState.success(),
                      )
                      ..[1] = attachments[1].copyWith(
                        uploadState: const UploadState.success(),
                      ),
                  ),
                  matchMessageState: true,
                  matchAttachments: true,
                  matchAttachmentsUploadState: true,
                ),
              ],
              // all the attachments are successfully uploaded
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sending,
                    attachments: [...attachments.map((it) => it.copyWith(uploadState: const UploadState.success()))],
                  ),
                  matchMessageState: true,
                  matchAttachments: true,
                  matchAttachmentsUploadState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sent,
                    attachments: [...attachments.map((it) => it.copyWith(uploadState: const UploadState.success()))],
                  ),
                  matchMessageState: true,
                  matchAttachments: true,
                  matchAttachmentsUploadState: true,
                ),
              ],
            ],
          ),
        );

        final res = await tester.channel.sendMessage(message);

        expect(res, isNotNull);
        expect(res.message.id, message.id);
        expect(res.message.attachments.length, message.attachments.length);
        expect(
          res.message.attachments.every(
            (it) => it.uploadState == const UploadState.success(),
          ),
          isTrue,
        );

        tester
          ..verifyApiCalled(
            (api) => api.fileUploader.sendImage(
              any(),
              _channelId,
              _channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
              extraData: any(named: 'extraData'),
            ),
            times: 2,
          )
          ..verifyApi(
            (api) => api.fileUploader.sendFile(
              any(),
              _channelId,
              _channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
              extraData: any(named: 'extraData'),
            ),
          )
          ..verifyApi(
            (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
          );

        await messagesEmission;
      },
    );

    channelTest(
      'should not send if the message is invalid',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final message = Message(id: 'test-message-id');

        await expectLater(
          () => tester.channel.sendMessage(message),
          throwsA(isA<StreamChatError>()),
        );

        tester.verifyNeverCalled(
          (api) => api.message.sendMessage(_channelId, _channelType, any()),
        );
      },
    );

    channelTest(
      'should not send empty message when all attachments are cancelled',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final attachment = Attachment(
          id: 'test-attachment-id',
          type: 'image',
          file: AttachmentFile(size: 100, path: 'test-file-path'),
        );

        final message = Message(
          id: 'test-message-id',
          attachments: [attachment],
        );

        tester.mockApiFailure(
          (api) => api.fileUploader.sendImage(
            any(),
            _channelId,
            _channelType,
            onSendProgress: any(named: 'onSendProgress'),
            cancelToken: any(named: 'cancelToken'),
            extraData: any(named: 'extraData'),
          ),
          error: StreamChatNetworkError.raw(
            code: 0,
            message: 'Request cancelled',
            type: StreamChatNetworkErrorType.cancel,
          ),
        );

        await expectLater(
          () => tester.channel.sendMessage(message),
          throwsA(isA<StreamChatError>()),
        );

        tester
          ..verifyApi(
            (api) => api.fileUploader.sendImage(
              any(),
              _channelId,
              _channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
              extraData: any(named: 'extraData'),
            ),
          )
          ..verifyNeverCalled(
            (api) => api.message.sendMessage(_channelId, _channelType, any()),
          );
      },
    );

    channelTest(
      'should send message when attachment is cancelled but text exists',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final attachment = Attachment(
          id: 'test-attachment-id',
          type: 'image',
          file: AttachmentFile(size: 100, path: 'test-file-path'),
        );

        final message = Message(
          id: 'test-message-id',
          text: 'Hello world!',
          attachments: [attachment],
        );

        tester
          ..mockApiFailure(
            (api) => api.fileUploader.sendImage(
              any(),
              _channelId,
              _channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
              extraData: any(named: 'extraData'),
            ),
            error: StreamChatNetworkError.raw(
              code: 0,
              message: 'Request cancelled',
              type: StreamChatNetworkErrorType.cancel,
            ),
          )
          ..mockApi(
            (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
            result: createDefaultSendMessageResponse(
              message: message.copyWith(
                attachments: [],
                state: MessageState.sent,
              ),
            ),
          );

        final res = await tester.channel.sendMessage(message);

        expect(res, isNotNull);
        expect(res.message.text, 'Hello world!');

        tester
          ..verifyApi(
            (api) => api.fileUploader.sendImage(
              any(),
              _channelId,
              _channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
              extraData: any(named: 'extraData'),
            ),
          )
          ..verifyApi(
            (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
          );
      },
    );

    channelTest(
      'should send message when attachment is cancelled but quoted message exists',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final attachment = Attachment(
          id: 'test-attachment-id',
          type: 'image',
          file: AttachmentFile(size: 100, path: 'test-file-path'),
        );

        final quotedMessage = Message(
          id: 'quoted-123',
          text: 'Original message',
        );

        final message = Message(
          id: 'test-message-id',
          attachments: [attachment],
          quotedMessageId: quotedMessage.id,
        );

        tester
          ..mockApiFailure(
            (api) => api.fileUploader.sendImage(
              any(),
              _channelId,
              _channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
              extraData: any(named: 'extraData'),
            ),
            error: StreamChatNetworkError.raw(
              code: 0,
              message: 'Request cancelled',
              type: StreamChatNetworkErrorType.cancel,
            ),
          )
          ..mockApi(
            (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
            result: createDefaultSendMessageResponse(
              message: message.copyWith(
                attachments: [],
                state: MessageState.sent,
              ),
            ),
          );

        final res = await tester.channel.sendMessage(message);

        expect(res, isNotNull);
        expect(res.message.quotedMessageId, quotedMessage.id);

        tester
          ..verifyApi(
            (api) => api.fileUploader.sendImage(
              any(),
              _channelId,
              _channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
              extraData: any(named: 'extraData'),
            ),
          )
          ..verifyApi(
            (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
          );
      },
    );

    channelTest(
      'should send message when attachment is cancelled but poll exists',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final attachment = Attachment(
          id: 'test-attachment-id',
          type: 'image',
          file: AttachmentFile(size: 100, path: 'test-file-path'),
        );

        final message = Message(
          id: 'test-message-id',
          attachments: [attachment],
          pollId: 'poll-123',
        );

        tester
          ..mockApiFailure(
            (api) => api.fileUploader.sendImage(
              any(),
              _channelId,
              _channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
              extraData: any(named: 'extraData'),
            ),
            error: StreamChatNetworkError.raw(
              code: 0,
              message: 'Request cancelled',
              type: StreamChatNetworkErrorType.cancel,
            ),
          )
          ..mockApi(
            (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
            result: createDefaultSendMessageResponse(
              message: message.copyWith(
                attachments: [],
                state: MessageState.sent,
              ),
            ),
          );

        final res = await tester.channel.sendMessage(message);

        expect(res, isNotNull);
        expect(res.message.pollId, 'poll-123');

        tester
          ..verifyApi(
            (api) => api.fileUploader.sendImage(
              any(),
              _channelId,
              _channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
              extraData: any(named: 'extraData'),
            ),
          )
          ..verifyApi(
            (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
          );
      },
    );
  });
}
