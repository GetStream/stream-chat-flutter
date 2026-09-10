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
      ownCapabilities: [ChannelCapability.readEvents],
    ),
  );
}

void main() {
  group('`.updateMessage`', () {
    channelTest(
      'should work fine',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final message = Message(
          id: 'test-message-id',
          state: MessageState.sent,
        );

        tester.mockApi(
          (api) => api.message.updateMessage(any(that: isSameMessageAs(message))),
          result: createDefaultUpdateMessageResponse(message: message),
        );

        final messagesEmits = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.updating),
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.updated),
                matchMessageState: true,
              ),
            ],
          ]),
        );

        final res = await tester.channel.updateMessage(message);

        expect(res, isNotNull);
        expect(res.message.id, message.id);

        await messagesEmits;

        tester.verifyApi(
          (api) => api.message.updateMessage(any(that: isSameMessageAs(message))),
        );
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
            (api) => api.message.updateMessage(any(that: isSameMessageAs(message))),
            result: createDefaultUpdateMessageResponse(
              message: message.copyWith(
                state: MessageState.sent,
                attachments: attachments
                    .map((it) => it.copyWith(uploadState: const UploadState.success()))
                    .toList(growable: false),
              ),
            ),
          );

        final messagesEmits = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
          emitsInOrder(
            [
              // preparing attachments to upload
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.updating,
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
                    state: MessageState.updating,
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
                    state: MessageState.updating,
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
                    state: MessageState.updating,
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
                    state: MessageState.updated,
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

        final res = await tester.channel.updateMessage(message);

        expect(res, isNotNull);
        expect(res.message.id, message.id);
        expect(res.message.attachments.length, message.attachments.length);
        expect(
          res.message.attachments.every(
            (it) => it.uploadState == const UploadState.success(),
          ),
          isTrue,
        );

        await messagesEmits;

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
            (api) => api.message.updateMessage(any(that: isSameMessageAs(message))),
          );
      },
    );

    channelTest(
      'should update message state even when error is not StreamChatNetworkError',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final message = Message(
          id: 'test-message-id-error-1',
          state: MessageState.sent,
        );

        tester.mockApiFailure(
          (api) => api.message.updateMessage(
            any(that: isSameMessageAs(message)),
            skipEnrichUrl: true,
          ),
          error: ArgumentError('Invalid argument'),
        );

        final messagesEmits = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.updating),
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.updatingFailed(
                    skipPush: false,
                    skipEnrichUrl: true,
                  ),
                ),
                matchMessageState: true,
              ),
            ],
          ]),
        );

        try {
          await tester.channel.updateMessage(message, skipEnrichUrl: true);
        } catch (e) {
          expect(e, isA<ArgumentError>());
        }

        await messagesEmits;
      },
    );

    channelTest(
      'should add message to retry queue when retriable StreamChatNetworkError occurs with skipPush: false, skipEnrichUrl: true',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final message = Message(
          id: 'test-message-id-retry-1',
          state: MessageState.sent,
        );

        // Create a retriable error (data == null). The retriable failure arms
        // the live retry queue; its immediate retry attempt succeeds, so the
        // queue drains without waiting on backoff timers.
        tester.mockApiFailureOnce(
          (api) => api.message.updateMessage(
            any(that: isSameMessageAs(message)),
            skipEnrichUrl: true,
          ),
          error: createDefaultNetworkError(errorCode: ChatErrorCode.requestTimeout, retriable: true),
          result: createDefaultUpdateMessageResponse(message: message),
        );

        final messagesEmits = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.updating),
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.updatingFailed(
                    skipPush: false,
                    skipEnrichUrl: true,
                  ),
                ),
                matchMessageState: true,
              ),
            ],
            // The retry queue retries the queued update with the same flags.
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.updating),
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.updated),
                matchMessageState: true,
              ),
            ],
          ]),
        );

        try {
          await tester.channel.updateMessage(message, skipEnrichUrl: true);
        } catch (e) {
          expect(e, isA<StreamChatNetworkError>());

          final networkError = e as StreamChatNetworkError;
          expect(networkError.code, equals(ChatErrorCode.requestTimeout.code));
          expect(networkError.isRetriable, isTrue);
        }

        await messagesEmits;

        // Initial attempt + the retry-queue retry, both with the same flags.
        tester.verifyApiCalled(
          (api) => api.message.updateMessage(
            any(that: isSameMessageAs(message)),
            skipEnrichUrl: true,
          ),
          times: 2,
        );
      },
    );

    channelTest(
      'should add message to retry queue when retriable StreamChatNetworkError occurs with skipPush: true, skipEnrichUrl: false',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final message = Message(
          id: 'test-message-id-retry-2',
          state: MessageState.sent,
        );

        // Create a retriable error (data == null). The retriable failure arms
        // the live retry queue; its immediate retry attempt succeeds, so the
        // queue drains without waiting on backoff timers.
        tester.mockApiFailureOnce(
          (api) => api.message.updateMessage(
            any(that: isSameMessageAs(message)),
            skipPush: true,
          ),
          error: createDefaultNetworkError(errorCode: ChatErrorCode.internalSystemError, retriable: true),
          result: createDefaultUpdateMessageResponse(message: message),
        );

        final messagesEmits = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.updating),
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.updatingFailed(
                    skipPush: true,
                    skipEnrichUrl: false,
                  ),
                ),
                matchMessageState: true,
              ),
            ],
            // The retry queue retries the queued update with the same flags.
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.updating),
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.updated),
                matchMessageState: true,
              ),
            ],
          ]),
        );

        try {
          await tester.channel.updateMessage(message, skipPush: true);
        } catch (e) {
          expect(e, isA<StreamChatNetworkError>());

          final networkError = e as StreamChatNetworkError;
          expect(networkError.code, equals(ChatErrorCode.internalSystemError.code));
          expect(networkError.isRetriable, isTrue);
        }

        await messagesEmits;

        // Initial attempt + the retry-queue retry, both with the same flags.
        tester.verifyApiCalled(
          (api) => api.message.updateMessage(
            any(that: isSameMessageAs(message)),
            skipPush: true,
          ),
          times: 2,
        );
      },
    );

    channelTest(
      'should handle non-retriable StreamChatNetworkError with skipPush: true, skipEnrichUrl: true',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final message = Message(
          id: 'test-message-id-error-2',
          state: MessageState.sent,
        );

        tester.mockApiFailure(
          (api) => api.message.updateMessage(
            any(that: isSameMessageAs(message)),
            skipPush: true,
            skipEnrichUrl: true,
          ),
          error: createDefaultNetworkError(errorCode: ChatErrorCode.notAllowed),
        );

        final messagesEmits = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.updating),
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.updatingFailed(
                    skipPush: true,
                    skipEnrichUrl: true,
                  ),
                ),
                matchMessageState: true,
              ),
            ],
          ]),
        );

        try {
          await tester.channel.updateMessage(
            message,
            skipPush: true,
            skipEnrichUrl: true,
          );
        } catch (e) {
          expect(e, isA<StreamChatNetworkError>());

          final networkError = e as StreamChatNetworkError;
          expect(networkError.code, equals(ChatErrorCode.notAllowed.code));
        }

        await messagesEmits;
      },
    );

    channelTest(
      'should handle non-retriable StreamChatNetworkError with skipPush: false, skipEnrichUrl: false',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final message = Message(
          id: 'test-message-id-error-3',
          state: MessageState.sent,
        );

        tester.mockApiFailure(
          (api) => api.message.updateMessage(
            any(that: isSameMessageAs(message)),
          ),
          error: createDefaultNetworkError(errorCode: ChatErrorCode.notAllowed),
        );

        final messagesEmits = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.updating),
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.updatingFailed(
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
          await tester.channel.updateMessage(message);
        } catch (e) {
          expect(e, isA<StreamChatNetworkError>());

          final networkError = e as StreamChatNetworkError;
          expect(networkError.code, equals(ChatErrorCode.notAllowed.code));
        }

        await messagesEmits;
      },
    );
  });

  group('`ChannelClientState.updateMessage`', () {
    channelTest(
      'upsert: true (default) adds an unknown message',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final message = Message(
          id: 'unknown-message',
          user: tester.currentUser,
          text: 'hello',
          createdAt: DateTime.utc(2026),
        );

        expect(tester.channelState!.messages, isEmpty);

        tester.channelState!.updateMessage(message);

        expect(tester.channelState!.messages.map((m) => m.id), ['unknown-message']);
      },
    );

    channelTest(
      'upsert: false does NOT add an unknown message',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final message = Message(
          id: 'unknown-message',
          user: tester.currentUser,
          text: 'hello',
          createdAt: DateTime.utc(2026),
        );

        expect(tester.channelState!.messages, isEmpty);

        tester.channelState!.updateMessage(message, upsert: false);

        expect(tester.channelState!.messages, isEmpty);
      },
    );

    channelTest(
      'upsert: false updates a message already in the window',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        const messageId = 'known-message';
        final seeded = Message(
          id: messageId,
          user: tester.currentUser,
          text: 'old',
          createdAt: DateTime.utc(2026),
        );
        tester.channelState!.updateChannelState(
          tester.channelState!.channelState.copyWith(messages: [seeded]),
        );

        tester.channelState!.updateMessage(
          seeded.copyWith(text: 'new'),
          upsert: false,
        );

        final stored = tester.channelState!.messages.single;
        expect(stored.id, equals(messageId));
        expect(stored.text, equals('new'));
      },
    );
  });

  channelTest(
    '`.partialUpdateMessage`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
    body: (tester) async {
      final message = Message(
        id: 'test-message-id',
        state: MessageState.sent,
      );

      const set = {'text': 'Update Message text'};
      const unset = ['pinExpires'];

      final updateMessageResponse = createDefaultUpdateMessageResponse(
        message: message.copyWith(text: set['text'], pinExpires: null),
      );

      tester.mockApi(
        (api) => api.message.partialUpdateMessage(message.id, set: set, unset: unset),
        result: updateMessageResponse,
      );

      final messagesEmits = expectLater(
        // skipping first seed message list -> [] messages
        tester.channelState?.messagesStream.skip(1),
        emitsInOrder([
          [
            isSameMessageAs(
              message.copyWith(
                state: MessageState.updating,
              ),
              matchText: true,
              matchMessageState: true,
            ),
          ],
          [
            isSameMessageAs(
              updateMessageResponse.message.copyWith(
                state: MessageState.updated,
              ),
              matchText: true,
              matchMessageState: true,
            ),
          ],
        ]),
      );

      final res = await tester.channel.partialUpdateMessage(
        message,
        set: set,
        unset: unset,
      );

      expect(res, isNotNull);
      expect(res.message.id, message.id);
      expect(res.message.id, message.id);
      expect(res.message.text, set['text']);
      expect(res.message.pinExpires, isNull);

      await messagesEmits;

      tester.verifyApi(
        (api) => api.message.partialUpdateMessage(message.id, set: set, unset: unset),
      );
    },
  );

  group('`.partialUpdateMessage` error handling', () {
    channelTest(
      'should update message state even when error is not StreamChatNetworkError',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final message = Message(
          id: 'test-message-id-error-partial-1',
          state: MessageState.sent,
        );

        // Add message to channel state first
        tester.channelState?.updateMessage(message);

        const set = {'text': 'Update Message text'};
        const unset = ['pinExpires'];

        tester.mockApiFailure(
          (api) => api.message.partialUpdateMessage(
            message.id,
            set: set,
            unset: unset,
          ),
          error: ArgumentError('Invalid argument'),
        );

        final messagesEmits = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.updating,
                ),
                matchText: true,
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.partialUpdatingFailed(
                    set: set,
                    unset: unset,
                    skipEnrichUrl: false,
                  ),
                ),
                matchText: true,
                matchMessageState: true,
              ),
            ],
          ]),
        );

        try {
          await tester.channel.partialUpdateMessage(
            message,
            set: set,
            unset: unset,
          );
        } catch (e) {
          expect(e, isA<ArgumentError>());
        }

        await messagesEmits;
      },
    );

    channelTest(
      'should add message to retry queue when retriable StreamChatNetworkError occurs with skipEnrichUrl: true',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final message = Message(
          id: 'test-message-id-retry-partial-1',
          state: MessageState.sent,
        );

        // Add message to channel state first
        tester.channelState?.updateMessage(message);

        const set = {'text': 'Update Message text'};
        const unset = ['pinExpires'];

        // Create a retriable error (data == null). The retriable failure arms
        // the live retry queue; its immediate retry attempt succeeds, so the
        // queue drains without waiting on backoff timers.
        tester.mockApiFailureOnce(
          (api) => api.message.partialUpdateMessage(
            message.id,
            set: set,
            unset: unset,
            skipEnrichUrl: true,
          ),
          error: createDefaultNetworkError(errorCode: ChatErrorCode.requestTimeout, retriable: true),
          result: createDefaultUpdateMessageResponse(message: message),
        );

        final messagesEmits = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.updating,
                ),
                matchText: true,
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.partialUpdatingFailed(
                    set: set,
                    unset: unset,
                    skipEnrichUrl: true,
                  ),
                ),
                matchText: true,
                matchMessageState: true,
              ),
            ],
            // The retry queue retries the queued partial update with the same
            // set/unset and flags.
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.updating),
                matchText: true,
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.updated),
                matchText: true,
                matchMessageState: true,
              ),
            ],
          ]),
        );

        try {
          await tester.channel.partialUpdateMessage(
            message,
            set: set,
            unset: unset,
            skipEnrichUrl: true,
          );
        } catch (e) {
          expect(e, isA<StreamChatNetworkError>());

          final networkError = e as StreamChatNetworkError;
          expect(networkError.code, equals(ChatErrorCode.requestTimeout.code));
          expect(networkError.isRetriable, isTrue);
        }

        await messagesEmits;

        // Initial attempt + the retry-queue retry, both with the same
        // set/unset and flags.
        tester.verifyApiCalled(
          (api) => api.message.partialUpdateMessage(
            message.id,
            set: set,
            unset: unset,
            skipEnrichUrl: true,
          ),
          times: 2,
        );
      },
    );

    channelTest(
      'should add message to retry queue when retriable StreamChatNetworkError occurs with skipEnrichUrl: false',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final message = Message(
          id: 'test-message-id-retry-partial-2',
          state: MessageState.sent,
        );

        // Add message to channel state first
        tester.channelState?.updateMessage(message);

        const set = {'text': 'Update Message text'};
        const unset = ['pinExpires'];

        // Create a retriable error (data == null). The retriable failure arms
        // the live retry queue; its immediate retry attempt succeeds, so the
        // queue drains without waiting on backoff timers.
        tester.mockApiFailureOnce(
          (api) => api.message.partialUpdateMessage(
            message.id,
            set: set,
            unset: unset,
          ),
          error: createDefaultNetworkError(errorCode: ChatErrorCode.internalSystemError, retriable: true),
          result: createDefaultUpdateMessageResponse(message: message),
        );

        final messagesEmits = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.updating,
                ),
                matchText: true,
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.partialUpdatingFailed(
                    set: set,
                    unset: unset,
                    skipEnrichUrl: false,
                  ),
                ),
                matchText: true,
                matchMessageState: true,
              ),
            ],
            // The retry queue retries the queued partial update with the same
            // set/unset and flags.
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.updating),
                matchText: true,
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.updated),
                matchText: true,
                matchMessageState: true,
              ),
            ],
          ]),
        );

        try {
          await tester.channel.partialUpdateMessage(
            message,
            set: set,
            unset: unset,
          );
        } catch (e) {
          expect(e, isA<StreamChatNetworkError>());

          final networkError = e as StreamChatNetworkError;
          expect(networkError.code, equals(ChatErrorCode.internalSystemError.code));
          expect(networkError.isRetriable, isTrue);
        }

        await messagesEmits;

        // Initial attempt + the retry-queue retry, both with the same
        // set/unset and flags.
        tester.verifyApiCalled(
          (api) => api.message.partialUpdateMessage(
            message.id,
            set: set,
            unset: unset,
          ),
          times: 2,
        );
      },
    );

    channelTest(
      'should handle non-retriable StreamChatNetworkError with skipEnrichUrl: true',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final message = Message(
          id: 'test-message-id-error-partial-2',
          state: MessageState.sent,
        );

        // Add message to channel state first
        tester.channelState?.updateMessage(message);

        const set = {'text': 'Update Message text'};
        const unset = ['pinExpires'];

        tester.mockApiFailure(
          (api) => api.message.partialUpdateMessage(
            message.id,
            set: set,
            unset: unset,
            skipEnrichUrl: true,
          ),
          error: createDefaultNetworkError(errorCode: ChatErrorCode.notAllowed),
        );

        final messagesEmits = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.updating,
                ),
                matchText: true,
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.partialUpdatingFailed(
                    set: set,
                    unset: unset,
                    skipEnrichUrl: true,
                  ),
                ),
                matchText: true,
                matchMessageState: true,
              ),
            ],
          ]),
        );

        try {
          await tester.channel.partialUpdateMessage(
            message,
            set: set,
            unset: unset,
            skipEnrichUrl: true,
          );
        } catch (e) {
          expect(e, isA<StreamChatNetworkError>());

          final networkError = e as StreamChatNetworkError;
          expect(networkError.code, equals(ChatErrorCode.notAllowed.code));
        }

        await messagesEmits;
      },
    );

    channelTest(
      'should handle non-retriable StreamChatNetworkError with skipEnrichUrl: false',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final message = Message(
          id: 'test-message-id-error-partial-3',
          state: MessageState.sent,
        );

        // Add message to channel state first
        tester.channelState?.updateMessage(message);

        const set = {'text': 'Update Message text'};
        const unset = ['pinExpires'];

        tester.mockApiFailure(
          (api) => api.message.partialUpdateMessage(
            message.id,
            set: set,
            unset: unset,
          ),
          error: createDefaultNetworkError(errorCode: ChatErrorCode.notAllowed),
        );

        final messagesEmits = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.updating,
                ),
                matchText: true,
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.partialUpdatingFailed(
                    set: set,
                    unset: unset,
                    skipEnrichUrl: false,
                  ),
                ),
                matchText: true,
                matchMessageState: true,
              ),
            ],
          ]),
        );

        try {
          await tester.channel.partialUpdateMessage(
            message,
            set: set,
            unset: unset,
          );
        } catch (e) {
          expect(e, isA<StreamChatNetworkError>());

          final networkError = e as StreamChatNetworkError;
          expect(networkError.code, equals(ChatErrorCode.notAllowed.code));
        }

        await messagesEmits;
      },
    );
  });
}
